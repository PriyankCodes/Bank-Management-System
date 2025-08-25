package com.bank.admin;

import com.bank.model.Account;
import com.bank.service.AdminService;
import com.bank.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/accounts")
public class AdminAccountsServlet extends HttpServlet {

    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/AuthServlet");
            return;
        }

        try {
            List<Account> accounts = adminService.getAllAccountsWithCustomer();
            req.setAttribute("accounts", accounts);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Unable to load accounts.");
        }

        req.getRequestDispatcher("/admin/accounts.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/AuthServlet");
            return;
        }

        String accountIdStr = req.getParameter("accountId");
        String action = req.getParameter("action");

        if (!ValidationUtil.isRequired(accountIdStr) || !ValidationUtil.isPositiveInteger(accountIdStr)) {
            req.getSession().setAttribute("flash_error", "Invalid account ID.");
            resp.sendRedirect(req.getContextPath() + "/admin/accounts");
            return;
        }


        try {
            long accountId = Long.parseLong(accountIdStr);
            boolean success = adminService.updateAccountStatus(accountId, action);
            if (success) {
                req.getSession().setAttribute("flash_success", "Account status updated successfully.");
            } else {
                req.getSession().setAttribute("flash_error", "Failed to update account status.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "Server error occurred.");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/accounts");
    }
}
