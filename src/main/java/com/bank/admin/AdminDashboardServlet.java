package com.bank.admin;

import com.bank.model.Customer;
import com.bank.service.AdminService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/AuthServlet");
            return;
        }

        try {
            int pendingAccounts = adminService.countPendingAccounts();
            int activeCustomers = adminService.countActiveCustomers();
            int softDeletedCustomers = adminService.countSoftDeletedCustomers();
            BigDecimal avgInterestRate = adminService.getAverageInterestRate();
            List<Customer> recentCustomers = adminService.getRecentCustomerRegistrations(10);

            req.setAttribute("pendingAccounts", pendingAccounts);
            req.setAttribute("activeCustomers", activeCustomers);
            req.setAttribute("softDeletedCustomers", softDeletedCustomers);
            req.setAttribute("avgInterestRate", avgInterestRate);
            req.setAttribute("recentCustomers", recentCustomers);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Unable to load dashboard data.");
        }

        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
    }
}
