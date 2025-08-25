package com.bank.webApp;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bank.model.Customer;
import com.bank.model.SupportTicket;
import com.bank.service.CustomerService;
import com.bank.service.SupportTicketService;

@WebServlet("/customer/support-ticket")
public class SupportTicketServlet extends HttpServlet {

    private final SupportTicketService supportTicketService = new SupportTicketService();
    private final CustomerService customerService = new CustomerService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Long userId = session != null ? (Long) session.getAttribute("userId") : null;

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/AuthServlet");
            return;
        }

        try {
            Customer customer = customerService.findByUserId(userId);
            if (customer == null) {
                req.setAttribute("error", "Customer profile not found.");
                req.getRequestDispatcher("/customer/support-ticket.jsp").forward(req, resp);
                return;
            }

            List<SupportTicket> tickets = supportTicketService.getTicketsForCustomer(customer.getId());
            req.setAttribute("tickets", tickets);
            req.setAttribute("customer", customer);
            req.getRequestDispatcher("/customer/support-ticket.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to load support tickets.");
            req.getRequestDispatcher("/customer/support-ticket.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Long userId = session != null ? (Long) session.getAttribute("userId") : null;

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/AuthServlet");
            return;
        }

        String subject = req.getParameter("subject");
        String description = req.getParameter("description");

        if (subject == null || subject.trim().isEmpty() || description == null || description.trim().isEmpty()) {
            session.setAttribute("flash_error", "All fields are required.");
            resp.sendRedirect(req.getContextPath() + "/customer/support-ticket");
            return;
        }

        try {
            // ✅ First get customerId from userId
            Customer customer = customerService.findByUserId(userId);
            if (customer == null) {
                session.setAttribute("flash_error", "Customer profile not found.");
                resp.sendRedirect(req.getContextPath() + "/customer/support-ticket");
                return;
            }

            boolean created = supportTicketService.createTicket(customer.getId(), subject, description);
            if (created) {
                session.setAttribute("flash_success", "Support ticket submitted successfully.");
            } else {
                session.setAttribute("flash_error", "Failed to submit support ticket.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash_error", "Server error while submitting ticket.");
        }
        resp.sendRedirect(req.getContextPath() + "/customer/support-ticket");
    }

}
