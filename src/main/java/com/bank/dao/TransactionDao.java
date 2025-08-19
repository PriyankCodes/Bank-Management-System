package com.bank.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.bank.config.Db;
import com.bank.model.Transaction;

public class TransactionDao {

    public List<Transaction> findByAccountAndDateRange(long accountId, LocalDate from, LocalDate to) throws SQLException {
        String sql = "SELECT created_at, txn_type, amount, reference_no FROM transactions " +
                     "WHERE account_id=? AND DATE(created_at) BETWEEN ? AND ? ORDER BY created_at DESC";
        List<Transaction> list = new ArrayList<>();
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            ps.setDate(2, Date.valueOf(from));
            ps.setDate(3, Date.valueOf(to));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Transaction t = new Transaction();
                    t.setCreatedAt(rs.getTimestamp("created_at"));
                    t.setTxnType(rs.getString("txn_type"));
                    t.setAmount(rs.getBigDecimal("amount"));
                    t.setReferenceNo(rs.getString("reference_no"));
                    list.add(t);
                }
            }
        }
        return list;
    }

    public void addTransaction(long accountId, String txnType, BigDecimal amount, String referenceNo) throws SQLException {
        String sql = "INSERT INTO transactions (account_id, txn_type, amount, reference_no, created_at) VALUES (?, ?, ?, ?, NOW())";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            ps.setString(2, txnType);
            ps.setBigDecimal(3, amount);
            ps.setString(4, referenceNo);
            ps.executeUpdate();
        }
    }
    

    public List<Transaction> findByAccount(long accountId) throws SQLException {
        String sql = "SELECT * FROM transactions WHERE account_id = ? ORDER BY created_at DESC";
        List<Transaction> list = new ArrayList<>();
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Transaction txn = new Transaction();
                    txn.setId(rs.getLong("id"));
                    txn.setAccountId(rs.getLong("account_id"));
                    txn.setTxnType(rs.getString("txn_type"));
                    txn.setAmount(rs.getBigDecimal("amount"));
                    txn.setReferenceNo(rs.getString("reference_no"));
                    txn.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(txn);
                }
            }
        }
        return list;
    }
    
    public List<Transaction> findByCustomerAccounts(long customerId) throws SQLException {
        String sql = "SELECT t.* , a.account_number FROM transactions t " +
                     "JOIN accounts a ON t.account_id = a.id " +
                     "WHERE a.customer_id = ? ORDER BY t.created_at DESC";

        List<Transaction> list = new ArrayList<>();
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Transaction txn = new Transaction();
                    txn.setId(rs.getLong("id"));
                    txn.setAccountId(rs.getLong("account_id"));
                    txn.setTxnType(rs.getString("txn_type"));
                    txn.setAmount(rs.getBigDecimal("amount"));
                    txn.setReferenceNo(rs.getString("reference_no"));
                    txn.setCreatedAt(rs.getTimestamp("created_at"));
                    txn.setAccountNumber(rs.getString("account_number")); // add this field in Transaction model
                    list.add(txn);
                }
            }
        }
        return list;
    }
    

}
