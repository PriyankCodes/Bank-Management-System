package com.bank.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.bank.config.Db;

public class AnalysisDao {

    public double getMonthlyIncome(long customerId) throws SQLException {
        String sql = """
            SELECT COALESCE(SUM(t.amount),0) AS income
            FROM transactions t
            JOIN accounts a ON t.account_id = a.id
            JOIN customers c ON a.customer_id = c.id
            WHERE c.id = ? AND t.txn_type = 'CREDIT' AND MONTH(t.created_at) = MONTH(CURDATE()) AND YEAR(t.created_at) = YEAR(CURDATE())
            """;
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("income").doubleValue();
                }
            }
        }
        return 0.0;
    }

    public double getMonthlySpending(long customerId) throws SQLException {
        String sql = """
            SELECT COALESCE(SUM(t.amount),0) AS spending
            FROM transactions t
            JOIN accounts a ON t.account_id = a.id
            JOIN customers c ON a.customer_id = c.id
            WHERE c.id = ? AND t.txn_type = 'DEBIT' AND MONTH(t.created_at) = MONTH(CURDATE()) AND YEAR(t.created_at) = YEAR(CURDATE())
            """;
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("spending").doubleValue();
                }
            }
        }
        return 0.0;
    }
}
