package com.bank.service;

import java.sql.SQLException;
import java.util.List;

import com.bank.dao.BeneficiaryDao;
import com.bank.dao.CustomerDao;
import com.bank.model.Beneficiary;
import com.bank.model.Customer;

public class CustomerService {

    private final CustomerDao customerDao = new CustomerDao();
    private final BeneficiaryDao beneficiaryDao = new BeneficiaryDao();


    // Fetch customer profile by user ID
    public Customer findByUserId(long userId) throws SQLException {
        return customerDao.findByUserId(userId);
    }

    public List<Beneficiary> listBeneficiaries(long userId) throws SQLException {
        return beneficiaryDao.findActiveByCustomerUserId(userId);
    }
    
    public String getBeneficiaryAccountNumberById(long beneficiaryId) throws SQLException {
        return beneficiaryDao.findAccountNumberById(beneficiaryId);
    }
    


    

    
    // Additional customer-related methods can be added here as needed

}
