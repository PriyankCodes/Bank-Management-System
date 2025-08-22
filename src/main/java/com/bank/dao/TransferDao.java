package com.bank.dao;

import com.bank.config.Db;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TransferDao {

    public void create(long fromAccountId, long beneficiaryId, BigDecimal amount, String referenceNo) throws SQLException {
        String sql = "INSERT INTO transfers (from_account_id, beneficiary_id, amount, status, reference_no, created_at) VALUES (?, ?, ?, 'PENDING', ?, NOW())";
        try (Connection con = Db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, fromAccountId);
            ps.setLong(2, beneficiaryId);
            ps.setBigDecimal(3, amount);
            ps.setString(4, referenceNo);
            ps.executeUpdate();
        }
    }

    public List<Map<String, Object>> recentForUser(long userId) throws SQLException {
        // Fetch recent transfers initiated by user based on from_account_id -> customer_id via accounts join
        String sql = "SELECT t.id, t.amount, t.status, t.reference_no, t.created_at, " +
                "a.account_number AS fromAccountNumber, " +
                "b.name AS beneficiaryName " +
                //"b.account_number AS accountNumber"+
                "FROM transfers t " +
                "JOIN accounts a ON t.from_account_id = a.id " +
                "JOIN beneficiaries b ON t.beneficiary_id = b.id " +
                "WHERE a.customer_id = ? " +
                "ORDER BY t.created_at DESC ";

        List<Map<String, Object>> results = new ArrayList<>();
        try (Connection con = Db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("id", rs.getLong("id"));
                    row.put("amount", rs.getBigDecimal("amount"));
                    row.put("status", rs.getString("status"));
                    row.put("referenceNo", rs.getString("reference_no"));
                    row.put("createdAt", rs.getTimestamp("created_at"));
                    row.put("fromAccountNumber", rs.getString("fromAccountNumber"));
                    row.put("beneficiaryName", rs.getString("beneficiaryName"));
                   // row.put("accountNumber", rs.getString("accountNumber"));

                    results.add(row);
                }
            }
        }
        return results;
    }

    public void markSuccess(String referenceNo) throws SQLException {
        String sql = "UPDATE transfers SET status='SUCCESS' WHERE reference_no=?";
        try (Connection con = Db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, referenceNo);
            ps.executeUpdate();
        }
    }
    
    public void deleteTransfersByBeneficiaryId(long beneficiaryId) throws SQLException {
        String sql = "DELETE FROM transfers WHERE beneficiary_id = ?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, beneficiaryId);
            ps.executeUpdate();
        }
    }

}
