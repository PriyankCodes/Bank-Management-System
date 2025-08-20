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
import com.bank.model.FixedDeposit;

public class FixedDepositDao {

	
	public BigDecimal getCurrentFdInterestRate() throws SQLException {
	    String sql = "SELECT rate_percent FROM fd_interest_rate WHERE id = 1";  // assuming single row with ID=1
	    try (Connection con = Db.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getBigDecimal("rate_percent");
	        }
	    }
	    // default if not found
	    return BigDecimal.valueOf(5.00);
	}

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
                    fd.setFdNumber(rs.getString("fd_number"));  // <-- Add this line

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
        String sql = "INSERT INTO fixed_deposits\r\n"
        		+ "(customer_id, linked_account_id, fd_number, principal,  tenure_months, start_date, maturity_date, status)\r\n"
        		+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?)\r\n"
        		+ "";

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
        	ps.setString(8, "ACTIVE");  // Make sure this is position 9 and correct value


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

    public List<FixedDeposit> findAllFixedDeposits() throws SQLException {
        String sql = "SELECT fd.*, c.first_name, c.last_name FROM fixed_deposits fd " +
                     "JOIN customers c ON fd.customer_id = c.id ORDER BY fd.start_date DESC";

        List<FixedDeposit> fds = new ArrayList<>();
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

        	while (rs.next()) {
        	    FixedDeposit fd = new FixedDeposit();
        	    fd.setId(rs.getLong("id"));
        	    fd.setCustomerId(rs.getLong("customer_id"));
        	    fd.setFdNumber(rs.getString("fd_number"));

        	    fd.setPrincipal(rs.getBigDecimal("principal"));
        	    fd.setTenureMonths(rs.getInt("tenure_months"));
        	    fd.setStatus(rs.getString("status"));

        	    // Convert SQL Date to String using toString or custom format
        	    java.sql.Date startDate = rs.getDate("start_date");
        	    if (startDate != null) {
        	        fd.setStartDate(startDate.toString()); // yyyy-MM-dd format
        	    } else {
        	        fd.setStartDate(null);
        	    }

        	    // maturityDate is Timestamp, so use getTimestamp directly
        	    fd.setMaturityDate(rs.getTimestamp("maturity_date"));

        	    fd.setInterestRate(rs.getBigDecimal("rate_percent"));
        	    fd.setAccountId(rs.getLong("linked_account_id"));

        	    // For customer name string concatenation
        	    String firstName = rs.getString("first_name");
        	    String lastName = rs.getString("last_name");
        	    fd.setCustomerName((firstName != null ? firstName : "") + " " + (lastName != null ? lastName : ""));

        	    fds.add(fd);
        	}

        }
        return fds;
    }

    public boolean updateFixedDepositStatus(long fdId, String newStatus) throws SQLException {
        String sql = "UPDATE fixed_deposits SET status = ? WHERE id = ?";
        try (Connection con = Db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setLong(2, fdId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean updateAllFixedDepositsRate(BigDecimal newRate) throws SQLException {
        String sql = "UPDATE fixed_deposits SET rate_percent = ?";
        try (Connection con = Db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBigDecimal(1, newRate);
            ps.executeUpdate();
            return true;
        }
    }

}
