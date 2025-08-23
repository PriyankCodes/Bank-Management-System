
package com.bank.dao;

import com.bank.config.Db;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TransferDao {

	public void create(long fromAccountId, Long beneficiaryId, String beneficiaryAccountNumber, BigDecimal amount,
			String referenceNo) throws SQLException {
		String sql = "INSERT INTO transfers (from_account_id, beneficiary_id, beneficiary_account_number, amount, status, reference_no, created_at) "
				+ "VALUES (?, ?, ?, ?, 'PENDING', ?, NOW())";
		try (Connection con = Db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setLong(1, fromAccountId);

			if (beneficiaryId != null && beneficiaryId > 0) {
				ps.setLong(2, beneficiaryId);
			} else {
				ps.setNull(2, Types.BIGINT);
			}

			ps.setString(3, beneficiaryAccountNumber);
			ps.setBigDecimal(4, amount);
			ps.setString(5, referenceNo);
			ps.executeUpdate();
		}
	}

	public List<Map<String, Object>> recentForUser(long userId) throws SQLException {
	    String sql = "SELECT t.id, t.amount, t.status, t.reference_no, t.created_at, " +
	            "a.account_number AS fromAccountNumber, " +
	            "COALESCE(b.name, t.beneficiary_account_number) AS beneficiaryDisplay " +
	            "FROM transfers t " +
	            "JOIN accounts a ON t.from_account_id = a.id " +
	            "LEFT JOIN beneficiaries b ON t.beneficiary_id = b.id " +
	            "WHERE a.customer_id = ? " +
	            "ORDER BY t.created_at DESC";

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
	                row.put("beneficiaryDisplay", rs.getString("beneficiaryDisplay"));
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
		try (Connection con = Db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setLong(1, beneficiaryId);
			ps.executeUpdate();
		}
	}

}

