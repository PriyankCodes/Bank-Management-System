package com.bank.service;

import java.sql.SQLException;
import java.time.LocalDate;

import com.bank.dao.CustomerDao;
import com.bank.dao.UserDao;
import com.bank.model.Customer;
import com.bank.model.User;

public class AuthService {
    private final UserDao userDao = new UserDao();
    private final CustomerDao customerDao = new CustomerDao();

    public User login(String email, String password) throws SQLException {
        if (!userDao.verifyLogin(email, password)) return null;
        return userDao.findByEmail(email);
    }

    public boolean register(String email, String phone, String password,
                           String firstName, String lastName, LocalDate dob, String city, String state)
            throws SQLException {
        if (userDao.emailExists(email)) return false;
        User user = new User();
        user.setEmail(email);
        user.setPhone(phone);
        user.setPassword(password); // hash in prod!
        user.setRole("CUSTOMER");
        user.setStatus("ACTIVE"); // If you want email verification, set 'PENDING'
        long userId = userDao.insertUser(user);
        Customer c = new Customer();
        c.setUserId(userId);
        c.setFirstName(firstName);
        c.setLastName(lastName);
        c.setDob(dob);
        c.setCity(city);
        c.setState(state);
        customerDao.insertCustomer(c);
        return true;
    }
}
