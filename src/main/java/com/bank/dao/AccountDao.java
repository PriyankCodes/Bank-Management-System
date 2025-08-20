package com.bank.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.bank.config.Db;
import com.bank.model.Account;

public class AccountDao {

    // Find accounts of a customer
    public List<Account> findByCustomerId(long customerId) throws SQLException {
        String sql = "SELECT * FROM accounts WHERE customer_id=? AND status <> 'CLOSED' ORDER BY opened_at DESC";
        List<Account> accounts = new ArrayList<>();
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Account a = new Account();
                    a.setId(rs.getLong("id"));
                    a.setAccountNumber(rs.getString("account_number"));
                    a.setCustomerId(rs.getLong("customer_id"));
                    a.setType(rs.getString("type"));
                    a.setStatus(rs.getString("status"));
                    a.setBalance(rs.getBigDecimal("balance"));
                    a.setOpenedAt(rs.getTimestamp("opened_at"));
                    accounts.add(a);
                }
            }
        }
        return accounts;
    }

    // Count accounts of a certain type belonging to a customer
    public int countByCustomerAndType(long customerId, String type) throws SQLException {
        String sql = "SELECT COUNT(*) FROM accounts WHERE customer_id=? AND type=? AND status='ACTIVE'";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, customerId);
            ps.setString(2, type);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    // Insert a new account; returns generated ID
    public long insert(Account account) throws SQLException {
        String sql = "INSERT INTO accounts (account_number, customer_id, type, status, balance, opened_at) VALUES (?, ?, ?, ?, ?, NOW())";
        String prefix = "SAVINGS".equalsIgnoreCase(account.getType()) ? "SB" : "CU";
        String acctNum = prefix + System.currentTimeMillis();

        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, acctNum);
            ps.setLong(2, account.getCustomerId());
            ps.setString(3, account.getType().toUpperCase());
            ps.setString(4, account.getStatus() != null ? account.getStatus() : "PENDING");
            ps.setBigDecimal(5, account.getBalance());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        }
        throw new SQLException("Failed to insert account");
    }
    public Long findIdByAccountNumber(String accountNumber) throws SQLException {
        String sql = "SELECT id FROM accounts WHERE account_number = ?";
        try (Connection conn = Db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, accountNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getLong("id");
            }
        }
        return null; // not found (external beneficiary)
    }

    public boolean isAccountOwnedByUser(long accountId, long userId) throws SQLException {
        String sql = "SELECT 1 FROM accounts a JOIN customers c ON a.customer_id=c.id WHERE a.id=? AND c.user_id=?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            ps.setLong(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // Checks if account has sufficient balance
    public boolean hasSufficientBalance(long accountId, BigDecimal amount) throws SQLException {
        String sql = "SELECT balance FROM accounts WHERE id=?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return false;
                return rs.getBigDecimal("balance").compareTo(amount) >= 0;
            }
        }
    }

    // Debit amount from account balance
    public void debit(long accountId, BigDecimal amount) throws SQLException {
        String sql = "UPDATE accounts SET balance = balance - ? WHERE id=?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBigDecimal(1, amount);
            ps.setLong(2, accountId);
            ps.executeUpdate();
        }
    }

    // Credit amount to account balance
    public void credit(long accountId, BigDecimal amount) throws SQLException {
        String sql = "UPDATE accounts SET balance = balance + ? WHERE id=?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBigDecimal(1, amount);
            ps.setLong(2, accountId);
            ps.executeUpdate();
        }
    }

    public boolean hasPendingAccount(long customerId) throws SQLException {
        String sql = "SELECT 1 FROM accounts WHERE customer_id = ? AND status = 'PENDING' LIMIT 1";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // true if any row found
            }
        }
    }
    
    public BigDecimal getBalance(long accountId) throws SQLException {
        String sql = "SELECT balance FROM accounts WHERE id = ?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("balance");
                }
            }
        }
        return null; // account not found
    }

    public String getAccountNumberById(long accountId) throws SQLException {
        String sql = "SELECT account_number FROM accounts WHERE id = ?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("account_number");
                }
            }
        }
        return null; // not found
    }


}
