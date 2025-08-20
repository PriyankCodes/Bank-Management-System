package com.bank.service;

import com.bank.dao.AccountDao;
import com.bank.dao.TransactionDao;
import com.bank.dao.TransferDao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class TransferService {
	private final TransferDao transferDao = new TransferDao();
	private final AccountDao accountDao = new AccountDao();
	private final TransactionDao transactionDao = new TransactionDao();

	public List<Map<String, Object>> recentForUser(long userId) throws SQLException {
		return transferDao.recentForUser(userId);
	}

	// Transfer funds: debit source, add transfer record, credit beneficiary (if
	// internal), etc.
	public String transfer(long userId, long fromAccountId, long beneficiaryId, BigDecimal amount) throws SQLException {
		if (amount == null || amount.compareTo(BigDecimal.ONE) < 0)
			return null;

		// Check ownership and sufficient balance
		if (!accountDao.isAccountOwnedByUser(fromAccountId, userId))
			return null;

		// Get current balance
		BigDecimal currentBalance = accountDao.getBalance(fromAccountId);
		if (currentBalance == null)
			return null;

		BigDecimal minimumBalance = new BigDecimal("1000");
		BigDecimal balanceAfterTransfer = currentBalance.subtract(amount);

		// Enforce minimum balance of ₹1000 after transfer
		if (balanceAfterTransfer.compareTo(minimumBalance) < 0) {
			return null; // insufficient funds respecting minimum balance limit
		}

		// Proceed with transfer
		String ref = "TR" + System.currentTimeMillis();

		transferDao.create(fromAccountId, beneficiaryId, amount, ref);

		transactionDao.addTransaction(fromAccountId, "DEBIT", amount, ref);
		accountDao.debit(fromAccountId, amount);

		// Credit beneficiary if internal account exists
		if (beneficiaryId > 0 && beneficiaryId != fromAccountId) {
			transactionDao.addTransaction(beneficiaryId, "CREDIT", amount, ref);
			accountDao.credit(beneficiaryId, amount);
		}

		transferDao.markSuccess(ref);
		return ref;
	}

}
