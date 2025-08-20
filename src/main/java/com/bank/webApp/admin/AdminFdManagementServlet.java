package com.bank.webApp.admin;

import com.bank.model.FixedDeposit;
import com.bank.service.AdminService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/fixed_deposits")
public class AdminFdManagementServlet extends HttpServlet {

    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<FixedDeposit> fds = adminService.getAllFixedDeposits();
            req.setAttribute("fixedDeposits", fds);
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to load fixed deposits.");
        }
        req.getRequestDispatcher("/admin/fixed_deposits.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            if ("updateStatus".equals(action)) {
                long fdId = Long.parseLong(req.getParameter("fdId"));
                String newStatus = req.getParameter("newStatus");
                boolean success = adminService.updateFixedDepositStatus(fdId, newStatus);
                setFlashMessage(req, success, "FD status updated.", "Failed to update FD status.");
            } else if ("updateInterestRate".equals(action)) {
                BigDecimal newRate = new BigDecimal(req.getParameter("newRate"));
                boolean success = adminService.updateAllFdInterestRate(newRate);
                setFlashMessage(req, success, "FD interest rates updated for all fixed deposits.", "Failed to update FD rates.");
            } else {
                req.getSession().setAttribute("flash_error", "Invalid action.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "Server error occurred.");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/fixed_deposits");
    }

    private void setFlashMessage(HttpServletRequest req, boolean success, String successMessage, String errorMessage) {
        if (success) {
            req.getSession().setAttribute("flash_success", successMessage);
        } else {
            req.getSession().setAttribute("flash_error", errorMessage);
        }
    }
}
