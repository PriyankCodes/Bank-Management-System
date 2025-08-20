package com.bank.webApp;

import com.bank.service.AccountService;
import com.bank.service.CustomerService;
import com.bank.service.TransferService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/customer/transfers")
public class TransferServlet extends HttpServlet {
    private final AccountService accountService = new AccountService();
    private final CustomerService customerService = new CustomerService();
    private final TransferService transferService = new TransferService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long userId = (Long) req.getSession().getAttribute("userId");
        String role = (String) req.getSession().getAttribute("role");
        if (userId == null || !"CUSTOMER".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/AuthServlet");
            return;
        }
        try {
            req.setAttribute("accounts", accountService.getAccountsByCustomerId(userId)); // assumes customer id = userId; adjust if necessary
            req.setAttribute("beneficiaries", customerService.listBeneficiaries(userId)); // implement this in CustomerService
            req.setAttribute("transfers", transferService.recentForUser(userId));
        } catch (Exception e) {
            req.setAttribute("error", "Unable to load transfers data.");
        }
        req.getRequestDispatcher("/customer/transfers.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long userId = (Long) req.getSession().getAttribute("userId");
        String role = (String) req.getSession().getAttribute("role");
        if (userId == null || !"CUSTOMER".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/AuthServlet");
            return;
        }
        try {
            long fromAccountId = Long.parseLong(req.getParameter("fromAccountId"));
            long beneficiaryId = Long.parseLong(req.getParameter("beneficiaryId"));
            BigDecimal amount = new BigDecimal(req.getParameter("amount"));

            // Fetch account numbers from database
            String fromAccNumber = accountService.getAccountNumberById(fromAccountId);
            String beneficiaryAccNumber = null;
            if (beneficiaryId > 0) {
                beneficiaryAccNumber = accountService.getAccountNumberById(beneficiaryId);
            }
            System.out.println(fromAccNumber);
            System.out.println(beneficiaryAccNumber);

            // Check if account numbers are the same
            if (fromAccNumber != null && fromAccNumber.equals(beneficiaryAccNumber)) {
                req.setAttribute("error", "Source and destination account numbers cannot be the same.");
                doGet(req, resp);
                return;
            }

            String ref = transferService.transfer(userId, fromAccountId, beneficiaryId, amount);
            if (ref != null) {
                req.getSession().setAttribute("flash_success", "Transfer successful. Reference: " + ref);
                resp.sendRedirect(req.getContextPath() + "/customer/transfers");
            } else {
                req.setAttribute("error", "Transfer failed: check balance, ownership, or input values.");
                doGet(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", "Transfer failed due to server error.");
            doGet(req, resp);
        }
    }

}
