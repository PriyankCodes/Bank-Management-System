package com.bank.service;

import java.sql.SQLException;
import java.util.List;

import com.bank.dao.SupportTicketDao;
import com.bank.model.SupportTicket;

public class SupportTicketService {

    private final SupportTicketDao supportTicketDao = new SupportTicketDao();

    public boolean createTicket(long customerId, String subject, String description) throws Exception {
        // You can add validations here if needed
        supportTicketDao.insertTicket(customerId, subject, description);
        return true;
    }
    
    public List<SupportTicket> getTicketsFiltered(String status, String priority) throws SQLException {
        return supportTicketDao.findTicketsFiltered(status, priority);
    }

    public boolean updateTicketStatus(long ticketId, String newStatus) throws SQLException {
    	  SupportTicket ticket = supportTicketDao.findById(ticketId);
    	    if (ticket == null) {
    	        return false;
    	    }

    	    // Prevent modifying CLOSED tickets
    	    if ("CLOSED".equalsIgnoreCase(ticket.getStatus())) {
    	        return false;
    	    }

    	    return supportTicketDao.updateStatus(ticketId, newStatus);    }

    public boolean updateTicketPriority(long ticketId, String newPriority) throws SQLException {
    	  SupportTicket ticket = supportTicketDao.findById(ticketId);
    	    if (ticket == null) {
    	        return false;
    	    }

    	    // Prevent modifying CLOSED tickets
    	    if ("CLOSED".equalsIgnoreCase(ticket.getStatus())) {
    	        return false;
    	    }

    	    return supportTicketDao.updatePriority(ticketId, newPriority);    }

    public List<SupportTicket> getTicketsForCustomer(long customerId) throws SQLException {
        return supportTicketDao.findTicketsByCustomer(customerId);
    }
}
