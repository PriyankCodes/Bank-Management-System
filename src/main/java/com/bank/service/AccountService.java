package com.bank.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

import com.bank.dao.AccountDao;
import com.bank.dao.TransactionDao;
import com.bank.model.Account;
import com.bank.util.Util;

public class AccountService {

	private final AccountDao accountDao = new AccountDao();
	private final TransactionDao transactionDao = new TransactionDao();

	public boolean canCreateAccount(long customerId, String type) throws SQLException {
		if (type == null)
			return false;
		String t = type.trim().toUpperCase();
		return accountDao.countByCustomerAndType(customerId, t) == 0;
	}

	public long createAccount(long customerId, String type, BigDecimal initialDeposit) throws SQLException {
		if (!Util.isValidInitialDeposit(initialDeposit)) {
			throw new IllegalArgumentException("Initial deposit must be at least ₹1000.");
		}
		if (!canCreateAccount(customerId, type)) {
			throw new IllegalStateException("You already have a " + type + " account.");
		}
		Account account = new Account();
		account.setCustomerId(customerId);
		account.setType(type.trim().toUpperCase());
		account.setBalance(initialDeposit);
		account.setStatus("PENDING");
		return accountDao.insert(account);
	}

	public List<Account> getAccountsByCustomerId(long customerId) throws SQLException {
		return accountDao.findByCustomerId(customerId);
	}
	
	public long findCustomerIdByUserId(long userId) throws SQLException {
	    return accountDao.findIdByUserId(userId);
	}


	public boolean hasPendingAccount(long customerId) {
		try {
			return accountDao.hasPendingAccount(customerId);
		} catch (SQLException e) {
			e.printStackTrace();
			// Treat exception as no pending (or optionally throw runtime)
			return false;
		}
	}

	public long findAccountIdByAccountNumber(String accountNumber) throws SQLException {
		return accountDao.findIdByAccountNumber(accountNumber);
	}

	public String getAccountNumberById(long accountId) throws SQLException {
		return accountDao.getAccountNumberById(accountId);
	}

	public boolean deposit(long customerId, String accountNumber, BigDecimal amount) throws SQLException {
		long accountId = accountDao.findIdByAccountNumber(accountNumber);
		// You can add ownership validation if required here

		String status = accountDao.getAccountStatus(accountId);
		if (status == null || status.equalsIgnoreCase("PENDING") || status.equalsIgnoreCase("SUSPENDED")
				|| status.equalsIgnoreCase("CLOSED")) {
			return false; // Do not allow operation on these statuses
		}
		accountDao.credit(accountId, amount);

		String ref = "DEP" + System.currentTimeMillis();
		transactionDao.addTransaction(accountId, "CREDIT", amount, ref);

		return true;
	}

	public boolean withdraw(long customerId, String accountNumber, BigDecimal amount) throws SQLException {
		long accountId = accountDao.findIdByAccountNumber(accountNumber);

		BigDecimal balance = accountDao.getBalance(accountId);
		if (balance == null || balance.compareTo(amount) < 0) {
			return false; // insufficient balance
		}
		BigDecimal minBalance = new BigDecimal("1000");
		if (balance.subtract(amount).compareTo(minBalance) < 0) {
			return false; // minimum balance rule
		}
		String status = accountDao.getAccountStatus(accountId);
		if (status == null || status.equalsIgnoreCase("PENDING") || status.equalsIgnoreCase("SUSPENDED")
				|| status.equalsIgnoreCase("CLOSED")) {
			return false; // Do not allow operation on these statuses
		}
		accountDao.debit(accountId, amount);

		String ref = "WDR" + System.currentTimeMillis();
		transactionDao.addTransaction(accountId, "DEBIT", amount, ref);

		return true;
	}

	public BigDecimal getBalanceByAccountNumber(String accountNumber) throws SQLException {
		long accountId = accountDao.findIdByAccountNumber(accountNumber);
		return accountDao.getBalance(accountId);
	}
	
	public boolean hasNonActiveAccountOfType(long customerId, String type) {
	    try {
	        return accountDao.hasNonActiveAccountOfType(customerId, type);
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false; // safe fallback, assumes no non-active account
	    }
	}


}
