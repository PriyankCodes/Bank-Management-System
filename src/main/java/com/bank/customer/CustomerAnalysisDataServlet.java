package com.bank.customer;

import com.bank.service.AnalysisService;
import com.bank.model.Customer;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/customer/customer-analysis/data")
public class CustomerAnalysisDataServlet extends HttpServlet {

    private final AnalysisService analysisService = new AnalysisService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long userId = (Long) req.getSession().getAttribute("userId");
        if (userId == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        resp.setContentType("application/json");
        try (PrintWriter out = resp.getWriter()) {
            Customer customer = analysisService.findCustomerByUserId(userId);
            if (customer == null) {
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }
            // Compute monthly income and spending
            double monthlyIncome = analysisService.getMonthlyIncome(customer.getId());
            double monthlySpending = analysisService.getMonthlySpending(customer.getId());

            String json = String.format("{\"monthlyIncome\": %.2f, \"monthlySpending\": %.2f}", monthlyIncome, monthlySpending);
            out.print(json);
        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            e.printStackTrace();
        }
    }
}
