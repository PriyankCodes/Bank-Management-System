package com.bank.admin;

import com.bank.model.SupportTicket;
import com.bank.service.SupportTicketService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/support-tickets")
public class AdminSupportTicketServlet extends HttpServlet {

    private final SupportTicketService supportTicketService = new SupportTicketService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String statusFilter = req.getParameter("status");
        String priorityFilter = req.getParameter("priority");

        try {
            List<SupportTicket> tickets = supportTicketService.getTicketsFiltered(statusFilter, priorityFilter);
            req.setAttribute("tickets", tickets);
            req.getRequestDispatcher("/admin/support-tickets.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to load support tickets.");
            req.getRequestDispatcher("/admin/support-tickets.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String ticketIdStr = req.getParameter("ticketId");
        HttpSession session = req.getSession();

        if (ticketIdStr == null || action == null) {
            session.setAttribute("flash_error", "Invalid request.");
            resp.sendRedirect(req.getContextPath() + "/admin/support-tickets");
            return;
        }

        try {
            long ticketId = Long.parseLong(ticketIdStr);

            if ("updateStatus".equals(action)) {
                String newStatus = req.getParameter("status");
                if (supportTicketService.updateTicketStatus(ticketId, newStatus)) {
                    session.setAttribute("flash_success", "Ticket status updated.");
                } else {
                    session.setAttribute("flash_error", "Cannot update staus now.");
                }
            } else if ("updatePriority".equals(action)) {
                String newPriority = req.getParameter("priority");
                if (supportTicketService.updateTicketPriority(ticketId, newPriority)) {
                    session.setAttribute("flash_success", "Ticket priority updated.");
                } else {
                    session.setAttribute("flash_error", "cannot update ticket priority now.");
                }
            } else {
                session.setAttribute("flash_error", "Unknown action.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash_error", "Server error while updating ticket.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/support-tickets");
    }
}
