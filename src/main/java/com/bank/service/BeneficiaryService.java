package com.bank.service;

import java.sql.SQLException;

import com.bank.dao.AccountDao;
import com.bank.dao.BeneficiaryDao;
import com.bank.dao.TransferDao;
import com.bank.model.Beneficiary;
import com.bank.util.Util;

public class BeneficiaryService {

    private final BeneficiaryDao beneficiaryDao = new BeneficiaryDao();
    private final AccountDao accountDao = new AccountDao();
    private final TransferDao transferDao = new TransferDao();


    public boolean isAccountExists(String accountNumber) throws SQLException {
        return accountDao.findIdByAccountNumber(accountNumber) != null;
    }

    public boolean addBeneficiary(long customerId, String name, String accountNumber, String bankName) throws SQLException {
        if (!Util.isValidBeneficiaryName(name)) {
            throw new IllegalArgumentException("Invalid beneficiary name.");
        }
        if (!Util.isValidAccountNumber(accountNumber)) {
            throw new IllegalArgumentException("Invalid account number.");
        }
        if (!Util.isValidBankName(bankName)) {
            throw new IllegalArgumentException("Invalid bank name.");
        }

        // Check if account exists internally—throw exception or handle as needed
        if (!isAccountExists(accountNumber)) {
            throw new IllegalArgumentException("Beneficiary account number does not exist in the bank.");
        }

        Beneficiary b = new Beneficiary();
        b.setCustomerId(customerId);
        b.setName(name.trim());
        b.setAccountNumber(accountNumber.trim());
        b.setBankName(bankName.trim());
        beneficiaryDao.insert(b);
        return true;
    }

    public java.util.List<Beneficiary> listBeneficiaries(long userId) throws SQLException {
        return beneficiaryDao.findActiveByCustomerUserId(userId);
    }
    public boolean deleteBeneficiary(long userId, long beneficiaryId) throws SQLException {
        // Check beneficiary belongs to customer user (via customerService or beneficiaryDao)
        if (!beneficiaryDao.belongsToUser(beneficiaryId, userId)) {
            return false;
        }
        transferDao.deleteTransfersByBeneficiaryId(beneficiaryId);

        return beneficiaryDao.deleteById(beneficiaryId);
    }

    public void updateBeneficiary(long userId, long beneficiaryId, String name, String accountNumber, String bankName) throws SQLException {
        // Fetch existing beneficiary
        Beneficiary b = beneficiaryDao.findById(beneficiaryId);
        if (b == null) {
            throw new IllegalArgumentException("Beneficiary not found");
        }

        // Verify ownership: beneficiary must belong to the current user's customer profile
      
        // Validate inputs (reuse your validation or add here)
        if (name == null || name.trim().length() < 2) {
            throw new IllegalArgumentException("Invalid beneficiary name");
        }
        if (accountNumber == null || !accountNumber.matches("[A-Za-z0-9]+")) {
            throw new IllegalArgumentException("Invalid account number");
        }
        if (bankName == null || bankName.trim().length() < 2) {
            throw new IllegalArgumentException("Invalid bank name");
        }
        if (!isAccountExists(accountNumber)) {
            throw new IllegalArgumentException("Beneficiary account number does not exist in the bank.");
        }

        // Update fields
        b.setName(name.trim());
        b.setAccountNumber(accountNumber.trim());
        b.setBankName(bankName.trim());

        // Save update
        beneficiaryDao.update(b);
    }

    public Beneficiary getBeneficiaryById(long beneficiaryId) throws SQLException {
        return beneficiaryDao.findById(beneficiaryId);
    }

    public boolean isBeneficiaryOwnedByUser(long beneficiaryId, long userId) throws SQLException {
        return beneficiaryDao.belongsToUser(beneficiaryId, userId);
    }

    
    

}
