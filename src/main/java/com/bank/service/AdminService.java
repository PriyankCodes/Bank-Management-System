package com.bank.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.bank.dao.AdminDao;
import com.bank.dao.FixedDepositDao;
import com.bank.model.Account;
import com.bank.model.Customer;
import com.bank.model.FixedDeposit;
import com.bank.model.FixedDepositRate;

public class AdminService {

    private final AdminDao adminDao = new AdminDao();
    FixedDepositService fdService = new FixedDepositService();


    public int countPendingAccounts() throws SQLException {
        return adminDao.countPendingAccounts();
    }

    public int countActiveCustomers() throws SQLException {
        return adminDao.countActiveCustomers();
    }

    public int countSoftDeletedCustomers() throws SQLException {
        return adminDao.countSoftDeletedCustomers();
    }

    public BigDecimal getAverageInterestRate() throws SQLException {
        return adminDao.getAverageInterestRate();
    }

    public List<Customer> getRecentCustomerRegistrations(int limit) throws SQLException {
        return adminDao.findRecentCustomerRegistrations(limit);
    }
    
    public List<Account> getAllAccountsWithCustomer() throws SQLException {
        return adminDao.findAllAccountsWithCustomer();
    }

    public boolean updateAccountStatus(long accountId, String newStatus) throws SQLException {
        return adminDao.updateAccountStatus(accountId, newStatus);
    }
    public List<Customer> getAllCustomers() throws SQLException {
        return adminDao.findAllCustomers();
    }

    public boolean softDeleteCustomer(long userId) throws SQLException {
        return adminDao.softDeleteCustomer(userId);
    }

    public boolean updateCustomer(Customer customer) throws SQLException {
        return adminDao.updateCustomer(customer);
    }
    public Customer getCustomerById(long customerId) throws SQLException {
        return adminDao.findCustomerById(customerId);
    }
    public boolean toggleCustomerStatus(long userId) throws SQLException {
        return adminDao.toggleUserStatus(userId);
    }

    public List<FixedDepositRate> getAllFixedDepositRates() throws SQLException {
        return adminDao.findAllFixedDepositRates();
    }

    public boolean addFixedDepositRate(FixedDepositRate rate) throws SQLException {
        return adminDao.addFixedDepositRate(rate);
    }

    public boolean updateFixedDepositRate(FixedDepositRate rate) throws SQLException {
        return adminDao.updateFixedDepositRate(rate);
    }

    public boolean deleteFixedDepositRate(long id) throws SQLException {
        return adminDao.deleteFixedDepositRate(id);
    }
    private final FixedDepositDao fdDao = new FixedDepositDao();

    public List<FixedDeposit> getAllFixedDeposits() throws SQLException {
        return fdDao.findAllFixedDeposits();
    }

    public boolean updateFixedDepositStatus(long fdId, String status) throws SQLException {
        if ("CLOSED".equalsIgnoreCase(status)) {
            try {
                fdService.closeFixedDeposit(fdId);
                return true;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        } else {
            return fdDao.updateFixedDepositStatus(fdId, status);
        }
    }


    public boolean updateAllFdInterestRate(BigDecimal newRate) throws SQLException {
        return fdDao.updateAllFixedDepositsRate(newRate);
    }
    

    public Map<String, Integer> getDashboardMetrics() throws SQLException {
        Map<String, Integer> metrics = new HashMap<>();
        metrics.put("activeCustomers", adminDao.countActiveCustomers());
        metrics.put("openSupportTickets", adminDao.countOpenSupportTickets());
        metrics.put("activeFixedDeposits", adminDao.countActiveFixedDeposits());
        metrics.put("savingsAccounts", adminDao.countSavingsAccounts());
        metrics.put("currentAccounts", adminDao.countCurrentAccounts());
        return metrics;
    }

}
