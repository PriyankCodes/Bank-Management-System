package com.bank.service;

import com.bank.dao.AccountDao;
import com.bank.model.Account;
import com.bank.util.Util;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public class AccountService {

	private final AccountDao accountDao = new AccountDao();

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

	
	
}
