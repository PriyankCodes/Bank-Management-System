package com.bank.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.bank.config.Db;
import com.bank.model.SupportTicket;

public class SupportTicketDao {

    public void insertTicket(long customerId, String subject, String description) throws Exception {
        String sql = "INSERT INTO support_tickets (customer_id, subject, description, status, priority, created_at) " +
                     "VALUES (?, ?, ?, 'OPEN', 'MEDIUM', NOW())";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, customerId);
            ps.setString(2, subject);
            ps.setString(3, description);
            ps.executeUpdate();
        }
    }
    
    public List<SupportTicket> findTicketsFiltered(String status, String priority) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT st.*, c.first_name, c.last_name FROM support_tickets st " +
            "JOIN customers c ON st.customer_id = c.id WHERE 1=1 ");

        if (status != null && !status.isEmpty()) {
            sql.append(" AND st.status = ? ");
        }
        if (priority != null && !priority.isEmpty()) {
            sql.append(" AND st.priority = ? ");
        }
        sql.append(" ORDER BY st.created_at DESC");

        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int index = 1;
            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }
            if (priority != null && !priority.isEmpty()) {
                ps.setString(index++, priority);
            }

            try (ResultSet rs = ps.executeQuery()) {
                List<SupportTicket> tickets = new ArrayList<>();
                while (rs.next()) {
                    SupportTicket st = new SupportTicket();
                    st.setId(rs.getLong("id"));
                    st.setCustomerId(rs.getLong("customer_id"));
                    st.setSubject(rs.getString("subject"));
                    st.setDescription(rs.getString("description"));
                    st.setStatus(rs.getString("status"));
                    st.setPriority(rs.getString("priority"));
                    st.setCreatedAt(rs.getTimestamp("created_at"));

                    String firstName = rs.getString("first_name");
                    String lastName = rs.getString("last_name");
                    st.setCustomerName(firstName + " " + lastName);

                    tickets.add(st);
                }
                return tickets;
            }
        }
    }

    public boolean updateStatus(long ticketId, String newStatus) throws SQLException {
        String sql = "UPDATE support_tickets SET status = ? WHERE id = ?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setLong(2, ticketId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean updatePriority(long ticketId, String newPriority) throws SQLException {
        String sql = "UPDATE support_tickets SET priority = ? WHERE id = ?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newPriority);
            ps.setLong(2, ticketId);
            return ps.executeUpdate() == 1;
        }
    }
    
    // Get tickets created by customer
    public List<SupportTicket> findTicketsByCustomer(long customerId) throws SQLException {
        String sql = "SELECT * FROM support_tickets WHERE customer_id = ? ORDER BY created_at DESC";
        List<SupportTicket> tickets = new ArrayList<>();
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SupportTicket st = new SupportTicket();
                    st.setId(rs.getLong("id"));
                    st.setCustomerId(rs.getLong("customer_id"));
                    st.setSubject(rs.getString("subject"));
                    st.setDescription(rs.getString("description"));
                    st.setStatus(rs.getString("status"));
                    st.setPriority(rs.getString("priority"));
                    st.setCreatedAt(rs.getTimestamp("created_at"));
                    tickets.add(st);
                }
            }
        }
        return tickets;
    }
    
    public SupportTicket findById(long ticketId) throws SQLException {
        String sql = "SELECT st.*, c.first_name, c.last_name FROM support_tickets st " +
                     "JOIN customers c ON st.customer_id = c.id WHERE st.id = ?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, ticketId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SupportTicket st = new SupportTicket();
                    st.setId(rs.getLong("id"));
                    st.setCustomerId(rs.getLong("customer_id"));
                    st.setSubject(rs.getString("subject"));
                    st.setDescription(rs.getString("description"));
                    st.setStatus(rs.getString("status"));
                    st.setPriority(rs.getString("priority"));
                    st.setCreatedAt(rs.getTimestamp("created_at"));

                    String firstName = rs.getString("first_name");
                    String lastName = rs.getString("last_name");
                    st.setCustomerName(firstName + " " + lastName);

                    return st;
                }
            }
        }
        return null; // not found
    }

}
