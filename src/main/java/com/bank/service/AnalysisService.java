package com.bank.service;

import com.bank.dao.AnalysisDao;
import com.bank.model.Customer;

import java.sql.SQLException;

public class AnalysisService {

    private final AnalysisDao analysisDao = new AnalysisDao();
    private final CustomerService customerService = new CustomerService();

    public Customer findCustomerByUserId(long userId) throws SQLException {
        return customerService.findByUserId(userId);
    }

    public double getMonthlyIncome(long customerId) throws SQLException {
        return analysisDao.getMonthlyIncome(customerId);
    }

    public double getMonthlySpending(long customerId) throws SQLException {
        return analysisDao.getMonthlySpending(customerId);
    }
}
