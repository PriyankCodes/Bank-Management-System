package com.bank.webApp;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bank.dao.CustomerDao;
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
            resp.sendRedirect(req.getContextPath() + "/AuthServlet");
            return;
        }

        try {
            Customer customer = customerDao.findByUserId(userId);
            if (customer == null) {
                req.setAttribute("error", "Customer profile not found.");
                req.getRequestDispatcher("/customer/dashboard.jsp").forward(req, resp);
                return;
            }

            List accounts = accountService.getAccountsByCustomerId(customer.getId());
            boolean hasSaving = accounts.stream().anyMatch(a -> "SAVINGS".equalsIgnoreCase(((com.bank.model.Account) a).getType()));
            boolean hasCurrent = accounts.stream().anyMatch(a -> "CURRENT".equalsIgnoreCase(((com.bank.model.Account) a).getType()));

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
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Long userId = (session != null) ? (Long) session.getAttribute("userId") : null;

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/AuthServlet");
            return;
        }

        String showForm = req.getParameter("showForm");
        String formType = req.getParameter("formType");
        String action = req.getParameter("action");
        String accountNumber = req.getParameter("accountNumber");
        String amountStr = req.getParameter("amount");

        // If this is a request to show the form (clicked deposit/withdraw button)
        if (showForm != null && formType != null && accountNumber == null && amountStr == null && action == null) {
            // Just forward to GET to redisplay dashboard with form open
            doGet(req, resp);
            return;
        }

        // Otherwise, this should be a form submission with amount and action
        if (accountNumber == null || action == null || amountStr == null) {
            session.setAttribute("flash_error", "Invalid form submission.");
            resp.sendRedirect(req.getContextPath() + "/customer/dashboard");
            return;
        }

        BigDecimal amount;
        try {
            amount = new BigDecimal(amountStr);
            if (amount.compareTo(BigDecimal.ONE) < 0) {
                session.setAttribute("flash_error", "Amount must be at least ₹1.");
                resp.sendRedirect(req.getContextPath() + "/customer/dashboard");
                return;
            }
        } catch (Exception e) {
            session.setAttribute("flash_error", "Invalid amount.");
            resp.sendRedirect(req.getContextPath() + "/customer/dashboard");
            return;
        }

        try {
            AccountService accountService = new AccountService();
            if ("deposit".equals(action)) {
                boolean success = accountService.deposit(userId, accountNumber, amount);
                if (success) {
                    session.setAttribute("flash_success", "Deposit successful!");
                } else {
                    session.setAttribute("flash_error", "Deposit failed.");
                }
            } else if ("withdraw".equals(action)) {
                BigDecimal balance = accountService.getBalanceByAccountNumber(accountNumber);
                BigDecimal minBalance = new BigDecimal("1000");
                if (balance == null || balance.compareTo(amount) < 0) {
                    session.setAttribute("flash_error", "Insufficient balance.");
                } else if (balance.subtract(amount).compareTo(minBalance) < 0) {
                    session.setAttribute("flash_error", "Account must retain minimum ₹1000 after withdrawal.");
                } else {
                    boolean success = accountService.withdraw(userId, accountNumber, amount);
                    if (success) {
                        session.setAttribute("flash_success", "Withdrawal successful!");
                    } else {
                        session.setAttribute("flash_error", "Withdrawal failed.");
                    }
                }
            } else {
                session.setAttribute("flash_error", "Unknown action.");
            }
        } catch (Exception ex) {
            session.setAttribute("flash_error", "Server error during operation.");
        }

        resp.sendRedirect(req.getContextPath() + "/customer/dashboard");
    }

}
