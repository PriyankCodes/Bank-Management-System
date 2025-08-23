
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
	public String transfer(long userId, long fromAccountId, Long beneficiaryId, String beneficiaryAccountNumber,
			BigDecimal amount) throws SQLException {
		if (amount == null || amount.compareTo(BigDecimal.ONE) < 0)
			return null;

		if (!accountDao.isAccountOwnedByUser(fromAccountId, userId))
			return null;

		BigDecimal currentBalance = accountDao.getBalance(fromAccountId);
		if (currentBalance == null)
			return null;

		BigDecimal minimumBalance = new BigDecimal("1000");
		BigDecimal balanceAfterTransfer = currentBalance.subtract(amount);
		if (balanceAfterTransfer.compareTo(minimumBalance) < 0)
			return null;

		String ref = "TR" + System.currentTimeMillis();

		transferDao.create(fromAccountId, beneficiaryId, beneficiaryAccountNumber, amount, ref);

		transactionDao.addTransaction(fromAccountId, "DEBIT", amount, ref);
		accountDao.debit(fromAccountId, amount);

// Credit only if internal account
		Long beneficiaryAccountId = accountDao.findIdByAccountNumber(beneficiaryAccountNumber);
		if (beneficiaryAccountId != null) {
		    // Internal account: credit it
		    transactionDao.addTransaction(beneficiaryAccountId, "CREDIT", amount, ref);
		    accountDao.credit(beneficiaryAccountId, amount);
		}

		

		transferDao.markSuccess(ref);
		return ref;
	}

}

