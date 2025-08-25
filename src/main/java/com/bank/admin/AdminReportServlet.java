package com.bank.admin;

import java.io.IOException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bank.service.AdminService;

@WebServlet("/admin/reports")
public class AdminReportServlet extends HttpServlet {

    private final AdminService adminDashboardService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            Map<String, Integer> metrics = adminDashboardService.getDashboardMetrics();
            req.setAttribute("metrics", metrics);
            req.getRequestDispatcher("/admin/reports.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to load dashboard data.");
            req.getRequestDispatcher("/admin/reports.jsp").forward(req, resp);
        }
    }
}
