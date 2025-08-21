
package com.bank.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import com.bank.config.Db;
import com.bank.dao.AccountDao;
import com.bank.dao.FixedDepositDao;
import com.bank.dao.TransactionDao;
import com.bank.model.FixedDeposit;

public class FixedDepositService {

	private final FixedDepositDao fdDao = new FixedDepositDao();
	private final AccountDao accountDao = new AccountDao();
	private final TransactionDao transactionDao = new TransactionDao();

	public List<FixedDeposit> getFixedDeposits(long customerId) throws SQLException {
		return fdDao.findByCustomerId(customerId);
	}

	public long createFixedDeposit(long customerId, long accountId, BigDecimal principal, int tenureMonths)
			throws SQLException {
		BigDecimal balance = accountDao.getBalance(accountId);
		if (balance == null || balance.compareTo(principal) < 0) {
			throw new IllegalArgumentException("Insufficient balance in linked account.");
		}
		BigDecimal minimumBalance = BigDecimal.valueOf(1000);
		if (balance.subtract(principal).compareTo(minimumBalance) < 0) {
		    throw new IllegalArgumentException("Linked account must maintain a minimum balance of ₹1000 after FD.");
		}
		if (principal == null || principal.compareTo(BigDecimal.valueOf(1000)) < 0) {
			throw new IllegalArgumentException("Minimum principal amount is ₹1000.");
		}
		if (tenureMonths <= 0) {
			throw new IllegalArgumentException("Tenure must be positive.");
		}

		Connection con = null;
		try {
			con = Db.getConnection();
			con.setAutoCommit(false);

			// Debit the linked account
			accountDao.debit(accountId, principal);

			// Add transaction record for debit
			transactionDao.addTransaction(accountId, "DEBIT", principal, "FD Opening");

			// Insert FD record
			FixedDeposit fd = new FixedDeposit();
			fd.setCustomerId(customerId);
			fd.setAccountId(accountId);
			fd.setPrincipal(principal);
			fd.setTenureMonths(tenureMonths);
			fd.setStatus("PENDING");
			fd.setInterestRate(null);

			long fdId = fdDao.insert(fd);

			// ✅ Commit only after all operations succeed
			con.commit();
			return fdId;

		} catch (Exception e) {
			if (con != null)
				con.rollback();
			throw e;
		} finally {
			if (con != null) {
				con.setAutoCommit(true);
				con.close();
			}
		}
	}

	public void closeFixedDeposit(long fdId) throws SQLException {
		Connection con = null;
		try {
			con = Db.getConnection();
			con.setAutoCommit(false); // start transaction

			// Fetch FD inside this connection
			FixedDeposit fd = fdDao.findById(fdId);
			if (fd == null) {
				throw new IllegalArgumentException("Fixed Deposit not found.");
			}
			if (!"ACTIVE".equalsIgnoreCase(fd.getStatus())) {
				throw new IllegalStateException("FD is not active and cannot be closed.");
			}

			BigDecimal principal = fd.getPrincipal();
			BigDecimal interest = calculateInterest(fd); // or pass current date if needed
			BigDecimal totalAmount = principal.add(interest);
			long accountId = fd.getAccountId();

			// Credit back principal + interest
			// Note: Here DAO methods open and close connections independently,
			// so autoCommit on this connection does not control them.
			accountDao.credit(accountId, totalAmount);

			// Add transaction record
			transactionDao.addTransaction(accountId, "CREDIT", totalAmount, "FD maturity close");

			// Update FD status
			fdDao.updateFixedDepositStatus(fdId, "CLOSED");

			con.commit(); // commit transaction on this connection (mostly no effect)
		} catch (Exception e) {
			if (con != null)
				con.rollback();
			throw e;
		} finally {
			if (con != null) {
				con.setAutoCommit(true);
				con.close();
			}
		}
	}

	private BigDecimal calculateInterest(FixedDeposit fd) {
		String closeDateStr = java.time.LocalDate.now().toString();
		BigDecimal principal = fd.getPrincipal();
		BigDecimal annualRate = fd.getInterestRate() != null ? fd.getInterestRate() : BigDecimal.ZERO;

		String startDateStr = fd.getStartDate();
		if (startDateStr == null || closeDateStr == null)
			return BigDecimal.ZERO;

		java.time.LocalDate startDate = java.time.LocalDate.parse(startDateStr);
		java.time.LocalDate closeDate = java.time.LocalDate.parse(closeDateStr);

		java.time.Period period = java.time.Period.between(startDate, closeDate);
		int actualMonths = period.getYears() * 12 + period.getMonths();
		if (actualMonths <= 0)
			actualMonths = 1;

		BigDecimal monthsInYear = new BigDecimal("12");

		return principal.multiply(annualRate).multiply(BigDecimal.valueOf(actualMonths))
				.divide(monthsInYear.multiply(new BigDecimal("100")), 2, RoundingMode.HALF_UP);

	}

}
