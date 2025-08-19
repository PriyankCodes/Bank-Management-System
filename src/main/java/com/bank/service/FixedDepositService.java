package com.bank.service;

import com.bank.dao.FixedDepositDao;
import com.bank.model.FixedDeposit;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public class FixedDepositService {

	private final FixedDepositDao fdDao = new FixedDepositDao();

	public List<FixedDeposit> getFixedDeposits(long customerId) throws SQLException {
		return fdDao.findByCustomerId(customerId);
	}

	public long createFixedDeposit(long customerId, long accountId, BigDecimal principal, int tenureMonths)
			throws SQLException {
		if (principal == null || principal.compareTo(BigDecimal.valueOf(1000)) < 0) {
			throw new IllegalArgumentException("Minimum principal amount is ₹1000.");
		}
		if (tenureMonths <= 0) {
			throw new IllegalArgumentException("Tenure must be positive.");
		}
		FixedDeposit fd = new FixedDeposit();
		fd.setCustomerId(customerId);
		fd.setAccountId(accountId);
		fd.setPrincipal(principal);
		fd.setTenureMonths(tenureMonths);
		fd.setStatus("PENDING");
		fd.setInterestRate(null); 
		return fdDao.insert(fd);
	}

}
