package com.bank.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.bank.config.Db;
import com.bank.model.Account;
import com.bank.model.Customer;
import com.bank.model.FixedDepositRate;

public class AdminDao {

    public int countPendingAccounts() throws SQLException {
        String sql = "SELECT COUNT(*) FROM accounts WHERE status = 'PENDING'";
        try (Connection con = Db.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    public int countActiveCustomers() throws SQLException {
        // Since customers table has no 'status', count all customers
        String sql = "SELECT COUNT(*) FROM customers";
        try (Connection con = Db.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    public int countSoftDeletedCustomers() throws SQLException {
        // You may implement soft delete with an 'is_deleted' boolean column, otherwise return 0
        String sql = "SELECT COUNT(*) FROM customers WHERE is_deleted = TRUE";
        try (Connection con = Db.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            // If column doesn't exist, return 0 or log
            return 0;
        }
        return 0;
    }

    public BigDecimal getAverageInterestRate() throws SQLException {
        String sql = "SELECT AVG(rate_percent) FROM fixed_deposits WHERE status = 'ACTIVE'";
        try (Connection con = Db.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                BigDecimal avg = rs.getBigDecimal(1);
                return (avg != null) ? avg : BigDecimal.ZERO;
            }
        }
        return BigDecimal.ZERO;
    }

    public List<Customer> findRecentCustomerRegistrations(int limit) throws SQLException {
        String sql = "SELECT c.id, c.first_name, c.last_name, u.email, u.created_at AS registered_on, u.status\r\n"
        		+ "FROM customers c\r\n"
        		+ "JOIN users u ON c.user_id = u.id\r\n"
        		+ "ORDER BY u.created_at DESC LIMIT ?\r\n"
        		+ "";

        List<Customer> customers = new ArrayList<>();
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Customer c = new Customer();
                    c.setId(rs.getLong("id"));
                    c.setFirstName(rs.getString("first_name"));
                    c.setLastName(rs.getString("last_name"));
                    c.setEmail(rs.getString("email"));
                    c.setStatus(rs.getString("status"));  // Confirm column label "status"
                    c.setRegisteredOn(rs.getTimestamp("registered_on"));
                    customers.add(c);
                }
            }
        }
        return customers;
    }
    

    public List<Account> findAllAccountsWithCustomer() throws SQLException {
        String sql = "SELECT a.id, a.account_number, a.type, a.status, a.balance, a.opened_at, " +
                     "c.first_name, c.last_name " +
                     "FROM accounts a JOIN customers c ON a.customer_id = c.id " +
                     "ORDER BY a.opened_at DESC";

        List<Account> accounts = new ArrayList<>();
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Account a = new Account();
                a.setId(rs.getLong("id"));
                a.setAccountNumber(rs.getString("account_number"));
                a.setType(rs.getString("type"));
                a.setStatus(rs.getString("status"));
                a.setBalance(rs.getBigDecimal("balance"));
                a.setOpenedAt(rs.getTimestamp("opened_at"));
                a.setCustomerName(rs.getString("first_name") + " " + rs.getString("last_name"));
                accounts.add(a);
            }
        }
        return accounts;
    }

    public boolean updateAccountStatus(long accountId, String newStatus) throws SQLException {
        String sql = "UPDATE accounts SET status = ? WHERE id = ?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setLong(2, accountId);
            return ps.executeUpdate() == 1;
        }
    }
    

    // Fetch all customers with associated user email and registration date
    public List<Customer> findAllCustomers() throws SQLException {
        String sql = "SELECT c.id, c.user_id, c.first_name, c.last_name, c.dob, c.city, c.state,\r\n"
        		+ "       u.email, u.phone, u.created_at AS registered_on, u.status\r\n"
        		+ "FROM customers c\r\n"
        		+ "JOIN users u ON c.user_id = u.id\r\n"
        		+ "ORDER BY u.created_at DESC\r\n"
        		+ "";

        List<Customer> customers = new ArrayList<>();
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Customer cust = new Customer();
                cust.setId(rs.getLong("id"));
                cust.setUserId(rs.getLong("user_id"));
                cust.setFirstName(rs.getString("first_name"));
                cust.setLastName(rs.getString("last_name"));
                cust.setDob(rs.getDate("dob").toLocalDate());
                cust.setCity(rs.getString("city"));
                cust.setState(rs.getString("state"));
                cust.setEmail(rs.getString("email"));
                cust.setPhone(rs.getString("phone"));

                cust.setRegisteredOn(rs.getTimestamp("registered_on"));
                cust.setStatus(rs.getString("status"));
                customers.add(cust);
            }
        }
        return customers;
    }

  
   
    public Customer findCustomerById(long id) throws SQLException {
    	String sql = "SELECT c.id, c.user_id, c.first_name, c.last_name, c.dob, c.city, c.state, " +
                "u.email, u.phone, u.created_at AS registered_on, u.status " +
                "FROM customers c " +
                "JOIN users u ON c.user_id = u.id " +
                "WHERE c.id = ?";   // <<<<<< Corrected: add WHERE clause filtering by customer id


        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer cust = new Customer();
                    cust.setId(rs.getLong("id"));
                    cust.setUserId(rs.getLong("user_id"));
                    cust.setFirstName(rs.getString("first_name"));
                    cust.setLastName(rs.getString("last_name"));

                    Date sqlDate = rs.getDate("dob");
                    if (sqlDate != null) {
                        cust.setDob(sqlDate.toLocalDate());
                    } else {
                        cust.setDob(null);
                    }

                    cust.setCity(rs.getString("city"));
                    cust.setState(rs.getString("state"));
                    cust.setEmail(rs.getString("email"));
                    cust.setPhone(rs.getString("phone"));

                    cust.setRegisteredOn(rs.getTimestamp("registered_on"));
                    cust.setStatus(rs.getString("status"));
                    return cust;
                } else {
                    return null;
                }
            }
        }
    }

    public boolean updateCustomer(Customer customer) throws SQLException {
        String sqlCustomers = "UPDATE customers SET first_name = ?, last_name = ?, dob = ?, city = ?, state = ? WHERE id = ?";
        String sqlUsers = "UPDATE users SET email = ?, phone = ? WHERE id = ?";
        Connection con = null;
        try {
            con = Db.getConnection();
            con.setAutoCommit(false);

            try (PreparedStatement psCust = con.prepareStatement(sqlCustomers)) {
                psCust.setString(1, customer.getFirstName());
                psCust.setString(2, customer.getLastName());
                psCust.setDate(3, customer.getDob() != null ? java.sql.Date.valueOf(customer.getDob()) : null);
                psCust.setString(4, customer.getCity());
                psCust.setString(5, customer.getState());
                psCust.setLong(6, customer.getId());
                psCust.executeUpdate();
            }

            try (PreparedStatement psUser = con.prepareStatement(sqlUsers)) {
                psUser.setString(1, customer.getEmail());
                psUser.setString(2, customer.getPhone());  // set phone
                psUser.setLong(3, customer.getUserId());
                psUser.executeUpdate();
            }

            con.commit();
            return true;
        } catch (SQLException e) {
            if (con != null) con.rollback();
            throw e;
        } finally {
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
    }

    public boolean softDeleteCustomer(long userId) throws SQLException {
        String sql = "UPDATE users SET status = 'DISABLED' WHERE id = ?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            return ps.executeUpdate() == 1;
        }
    }
    
 // Toggle user status between ACTIVE and DISABLED
    public boolean toggleUserStatus(long userId) throws SQLException {
        String fetchStatusSql = "SELECT status FROM users WHERE id = ?";
        String updateUserSql = "UPDATE users SET status = ? WHERE id = ?";
        try (Connection con = Db.getConnection();
             PreparedStatement fetchPs = con.prepareStatement(fetchStatusSql)) {
            fetchPs.setLong(1, userId);
            try (ResultSet rs = fetchPs.executeQuery()) {
                if (rs.next()) {
                    String currentStatus = rs.getString("status");
                    String newStatus = "ACTIVE".equals(currentStatus) ? "DISABLED" : "ACTIVE";

                    // Update user status
                    try (PreparedStatement updatePs = con.prepareStatement(updateUserSql)) {
                        updatePs.setString(1, newStatus);
                        updatePs.setLong(2, userId);
                        int updatedRows = updatePs.executeUpdate();
                        if (updatedRows == 1) {
                            // Update all customer accounts accordingly
                            updateAccountsStatusByUser(userId, newStatus);
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    }

    // Helper: Update accounts status for all accounts of a customer linked to the given userId
    private void updateAccountsStatusByUser(long userId, String userStatus) throws SQLException {
        String getCustomerIdSql = "SELECT id FROM customers WHERE user_id = ?";
        String updateAccountsSql;

        if ("DISABLED".equals(userStatus)) {
            updateAccountsSql = "UPDATE accounts SET status = 'CLOSED' WHERE customer_id = ?";
        } else if ("ACTIVE".equals(userStatus)) {
            updateAccountsSql = "UPDATE accounts SET status = 'ACTIVE' WHERE customer_id = ?";
        } else {
            return; // no action for other statuses
        }

        try (Connection con = Db.getConnection();
             PreparedStatement getCustPs = con.prepareStatement(getCustomerIdSql)) {
            getCustPs.setLong(1, userId);
            try (ResultSet rs = getCustPs.executeQuery()) {
                if (rs.next()) {
                    long customerId = rs.getLong("id");
                    try (PreparedStatement updateAccPs = con.prepareStatement(updateAccountsSql)) {
                        updateAccPs.setLong(1, customerId);
                        updateAccPs.executeUpdate();
                    }
                }
            }
        }
    }

    public List<FixedDepositRate> findAllFixedDepositRates() throws SQLException {
        String sql = "SELECT id, account_type, rate_percent, status FROM fixed_deposits ORDER BY account_type";
        List<FixedDepositRate> rates = new ArrayList<>();
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                FixedDepositRate rate = new FixedDepositRate();
                rate.setId(rs.getLong("id"));
                rate.setAccountType(rs.getString("account_type"));
                rate.setRatePercent(rs.getBigDecimal("rate_percent"));
                rate.setStatus(rs.getString("status"));
                rates.add(rate);
            }
        }
        return rates;
    }

    public boolean addFixedDepositRate(FixedDepositRate rate) throws SQLException {
        String sql = "INSERT INTO fixed_deposits (account_type, rate_percent, status) VALUES (?, ?, ?)";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, rate.getAccountType());
            ps.setBigDecimal(2, rate.getRatePercent());
            ps.setString(3, rate.getStatus());
            return ps.executeUpdate() == 1;
        }
    }

    public boolean updateFixedDepositRate(FixedDepositRate rate) throws SQLException {
        String sql = "UPDATE fixed_deposits SET account_type = ?, rate_percent = ?, status = ? WHERE id = ?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, rate.getAccountType());
            ps.setBigDecimal(2, rate.getRatePercent());
            ps.setString(3, rate.getStatus());
            ps.setLong(4, rate.getId());
            return ps.executeUpdate() == 1;
        }
    }

    public boolean deleteFixedDepositRate(long id) throws SQLException {
        String sql = "DELETE FROM fixed_deposits WHERE id = ?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() == 1;
        }
    }


}
