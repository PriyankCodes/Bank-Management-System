package com.bank.dao;

import com.bank.config.Db;
import com.bank.model.FixedDeposit;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FixedDepositDao {

    public List<FixedDeposit> findByCustomerId(long customerId) throws SQLException {
    	String sql = "SELECT * FROM fixed_deposits WHERE customer_id = ?";
    	List<FixedDeposit> fds = new ArrayList<>();
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FixedDeposit fd = new FixedDeposit();
                    fd.setId(rs.getLong("id"));
                    fd.setCustomerId(rs.getLong("customer_id"));
                    fd.setPrincipal(rs.getBigDecimal("principal"));
                    fd.setTenureMonths(rs.getInt("tenure_months"));
                    fd.setStatus(rs.getString("status"));
                    fd.setStartDate(rs.getString("start_date"));
                    fd.setMaturityDate(rs.getTimestamp("maturity_date"));
                    fd.setInterestRate(rs.getBigDecimal("rate_percent"));
                    fd.setAccountId(rs.getLong("linked_account_id"));
                    fds.add(fd);
                }
            }
        }
        return fds;
    }

    	public long insert(FixedDeposit fd) throws SQLException {
    	    String sql = "INSERT INTO fixed_deposits " +
    	                 "(customer_id, linked_account_id, fd_number, principal, tenure_months, start_date, maturity_date, payout_frequency, status) " +
    	                 "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

    	    String fdNumber = "FD" + System.currentTimeMillis();
    	    java.sql.Date startDate = new java.sql.Date(System.currentTimeMillis());
    	    java.sql.Date maturityDate = calculateMaturityDate(startDate, fd.getTenureMonths());

    	    try (Connection con = Db.getConnection();
    	         PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

    	        ps.setLong(1, fd.getCustomerId());
    	        ps.setLong(2, fd.getAccountId());
    	        ps.setString(3, fdNumber);
    	        ps.setBigDecimal(4, fd.getPrincipal());
    	        ps.setInt(5, fd.getTenureMonths());
    	        ps.setDate(6, startDate);
    	        ps.setDate(7, maturityDate);
    	        ps.setString(8, "ON_MATURITY");  // Example payout frequency
    	        ps.setString(9, "ACTIVE");       // Initial status

    	        ps.executeUpdate();

    	        try (ResultSet rs = ps.getGeneratedKeys()) {
    	            if (rs.next()) return rs.getLong(1);
    	        }
    	    }
    	    throw new SQLException("FD insert failed");
    	}


    // Helper method to calculate maturity date
    private java.sql.Date calculateMaturityDate(java.sql.Date startDate, int tenureMonths) {
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.setTime(startDate);
        cal.add(java.util.Calendar.MONTH, tenureMonths);
        return new java.sql.Date(cal.getTimeInMillis());
    }


}
