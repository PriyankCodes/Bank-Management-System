package com.bank.webApp;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bank.dao.CustomerDao;
import com.bank.model.Account;
import com.bank.model.Customer;
import com.bank.service.AccountService;

@WebServlet("/customer/dashboard")
public class CustomerDashboardServlet extends HttpServlet {

    private final CustomerDao customerDao = new CustomerDao();
    private final AccountService accountService = new AccountService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Long userId = (session != null) ? (Long) session.getAttribute("userId") : null;
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }

        try {
            Customer customer = customerDao.findByUserId(userId);
            if (customer == null) {
                req.setAttribute("error", "Customer profile not found.");
                req.getRequestDispatcher("/customer/dashboard.jsp").forward(req, resp);
                return;
            }

            List<Account> accounts = accountService.getAccountsByCustomerId(customer.getId());
            boolean hasSaving = accounts.stream().anyMatch(a -> "SAVINGS".equalsIgnoreCase(a.getType()));
            boolean hasCurrent = accounts.stream().anyMatch(a -> "CURRENT".equalsIgnoreCase(a.getType()));

            req.setAttribute("customer", customer);
            req.setAttribute("accounts", accounts);
            req.setAttribute("hasSaving", hasSaving);
            req.setAttribute("hasCurrent", hasCurrent);

            req.getRequestDispatcher("/customer/dashboard.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to load dashboard data.");
            req.getRequestDispatcher("/customer/dashboard.jsp").forward(req, resp);
        }
    }
}
