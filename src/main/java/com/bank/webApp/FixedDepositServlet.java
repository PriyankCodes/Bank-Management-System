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

import com.bank.model.Account;
import com.bank.model.Customer;
import com.bank.model.FixedDeposit;
import com.bank.service.AccountService;
import com.bank.service.CustomerService;
import com.bank.service.FixedDepositService;

@WebServlet("/customer/fixed_deposits")
public class FixedDepositServlet extends HttpServlet {

    private final FixedDepositService fdService = new FixedDepositService();
    private final CustomerService customerService = new CustomerService();
    private final AccountService accountService = new AccountService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long userId = (Long) req.getSession().getAttribute("userId");
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }
        try {
            Customer customer = customerService.findByUserId(userId);
            if (customer == null) {
                req.setAttribute("error", "Customer profile not found.");
                req.getRequestDispatcher("/customer/fixed_deposits.jsp").forward(req, resp);
                return;
            }

            List<Account> accounts = accountService.getAccountsByCustomerId(customer.getId());
            req.setAttribute("accounts", accounts);

            List<FixedDeposit> fds = fdService.getFixedDeposits(customer.getId());
            req.setAttribute("fixedDeposits", fds);
        } catch (Exception e) {
            e.printStackTrace(); // Log full stack trace
            req.setAttribute("error", "Unable to load fixed deposits: " + e.getMessage());
        }
        req.getRequestDispatcher("/customer/fixed_deposits.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long userId = (Long) req.getSession().getAttribute("userId");
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }
        try {
            String principalStr = req.getParameter("principal");
            String tenureStr = req.getParameter("tenureMonths");
            String accountIdStr = req.getParameter("accountId");

            BigDecimal principal = new BigDecimal(principalStr);
            int tenureMonths = Integer.parseInt(tenureStr);
            long accountId = Long.parseLong(accountIdStr);

            Customer customer = customerService.findByUserId(userId);
            if (customer == null) {
                req.setAttribute("error", "Customer profile not found.");
                doGet(req, resp);
                return;
            }

            fdService.createFixedDeposit(customer.getId(), accountId, principal, tenureMonths);
            req.getSession().setAttribute("flash_success", "Fixed deposit application submitted successfully.");
            resp.sendRedirect(req.getContextPath() + "/customer/fixed_deposits");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            req.setAttribute("error", "Invalid number format: " + e.getMessage());
            doGet(req, resp);
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to create fixed deposit: " + e.getMessage());
            doGet(req, resp);
        }
    }



}
