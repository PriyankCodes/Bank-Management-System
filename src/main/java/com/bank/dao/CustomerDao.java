package com.bank.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.bank.config.Db;
import com.bank.model.Customer;

public class CustomerDao {

    public long insertCustomer(Customer c) throws SQLException {
        String sql = "INSERT INTO customers (user_id, first_name, last_name, dob, city, state) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = Db.getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, c.getUserId());
            ps.setString(2, c.getFirstName());
            ps.setString(3, c.getLastName());
            ps.setDate(4, Date.valueOf(c.getDob()));
            ps.setString(5, c.getCity());
            ps.setString(6, c.getState());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getLong(1);
            }
        }
        throw new SQLException("Customer insert failed");
    }

    public Customer findByUserId(long userId) throws SQLException {
        String sql = "SELECT * FROM customers WHERE user_id=?";
        try (Connection con = Db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer c = new Customer();
                    c.setId(rs.getLong("id"));
                    c.setUserId(rs.getLong("user_id"));
                    c.setFirstName(rs.getString("first_name"));
                    c.setLastName(rs.getString("last_name"));
                    c.setDob(rs.getDate("dob").toLocalDate());
                    c.setCity(rs.getString("city"));
                    c.setState(rs.getString("state"));
                    return c;
                }
            }
        }
        return null;
    }
}
