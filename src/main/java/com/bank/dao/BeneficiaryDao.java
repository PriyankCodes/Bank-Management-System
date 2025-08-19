package com.bank.dao;

import com.bank.config.Db;
import com.bank.model.Beneficiary;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BeneficiaryDao {

  
    // Find beneficiary by account number and customer id (validate ownership)
    public Beneficiary findByAccountNumberAndCustomerId(String accountNumber, long customerId) throws SQLException {
        String sql = "SELECT * FROM beneficiaries WHERE account_number = ? AND customer_id = ?";
        try (Connection con = Db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, accountNumber);
            ps.setLong(2, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Beneficiary b = new Beneficiary();
                    b.setId(rs.getLong("id"));
                    b.setCustomerId(rs.getLong("customer_id"));
                    b.setName(rs.getString("name"));
                    b.setAccountNumber(rs.getString("account_number"));
                    b.setBankName(rs.getString("bank_name"));
                    b.setAddedAt(rs.getTimestamp("added_at"));
                    return b;
                }
            }
        }
        return null;
    }

    public long insert(Beneficiary b) throws SQLException {
        String sql = "INSERT INTO beneficiaries (customer_id, name, account_number, bank_name, added_at) VALUES (?, ?, ?, ?, NOW())";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, b.getCustomerId());
            ps.setString(2, b.getName());
            ps.setString(3, b.getAccountNumber());
            ps.setString(4, b.getBankName());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getLong(1);
            }
        }
        throw new SQLException("Failed to insert beneficiary");
    }

    public List<Beneficiary> findActiveByCustomerUserId(long userId) throws SQLException {
        String sql = "SELECT b.* FROM beneficiaries b JOIN customers c ON b.customer_id = c.id " +
                "WHERE c.user_id = ? ORDER BY b.added_at DESC";
        List<Beneficiary> list = new ArrayList<>();
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Beneficiary b = new Beneficiary();
                    b.setId(rs.getLong("id"));
                    b.setCustomerId(rs.getLong("customer_id"));
                    b.setName(rs.getString("name"));
                    b.setAccountNumber(rs.getString("account_number"));
                    b.setBankName(rs.getString("bank_name"));
                    b.setAddedAt(rs.getTimestamp("added_at"));
                    list.add(b);
                }
            }
        }
        return list;
    }
    
    public String findAccountNumberById(long beneficiaryId) throws SQLException {
        String sql = "SELECT account_number FROM beneficiaries WHERE id = ?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, beneficiaryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("account_number");
                }
            }
        }
        return null;
    }

    public boolean belongsToUser(long beneficiaryId, long userId) throws SQLException {
        String sql = "SELECT 1 FROM beneficiaries b JOIN customers c ON b.customer_id = c.id WHERE b.id = ? AND c.user_id = ?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, beneficiaryId);
            ps.setLong(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean deleteById(long beneficiaryId) throws SQLException {
        String sql = "DELETE FROM beneficiaries WHERE id = ?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, beneficiaryId);
            return ps.executeUpdate() > 0;
        }
    }
    public Beneficiary findById(long beneficiaryId) throws SQLException {
        String sql = "SELECT * FROM beneficiaries WHERE id = ?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, beneficiaryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Beneficiary b = new Beneficiary();
                    b.setId(rs.getLong("id"));
                    b.setCustomerId(rs.getLong("customer_id"));
                    b.setName(rs.getString("name"));
                    b.setAccountNumber(rs.getString("account_number"));
                    b.setBankName(rs.getString("bank_name"));
                    b.setAddedAt(rs.getTimestamp("added_at"));
                    return b;
                }
            }
        }
        return null;
    }


    public void update(Beneficiary b) throws SQLException {
        String sql = "UPDATE beneficiaries SET name = ?, account_number = ?, bank_name = ? WHERE id = ?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, b.getName());
            ps.setString(2, b.getAccountNumber());
            ps.setString(3, b.getBankName());
            ps.setLong(4, b.getId());
            ps.executeUpdate();
        }
    }


}
