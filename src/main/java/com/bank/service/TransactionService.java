package com.bank.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.bank.dao.TransactionDao;
import com.bank.model.Transaction;

public class TransactionService {

	private final TransactionDao transactionDao = new TransactionDao();

	public List<Transaction> getTransactionsForAccount(long accountId) throws SQLException {
		return transactionDao.findByAccount(accountId);
	}

	public List<Transaction> getTransactionsForCustomer(long customerId) throws SQLException {
		return transactionDao.findByCustomerAccounts(customerId);
	}

}
