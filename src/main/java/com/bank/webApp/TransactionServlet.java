package com.bank.webApp;

import com.bank.model.Customer;
import com.bank.service.CustomerService;
import com.bank.service.TransactionService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.bank.model.Transaction;

@WebServlet("/customer/transactions")
public class TransactionServlet extends HttpServlet {

	private final CustomerService customerService = new CustomerService();
	private final TransactionService transactionService = new TransactionService();

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
				req.getRequestDispatcher("/customer/transactions.jsp").forward(req, resp);
				return;
			}

			List<Transaction> transactions = transactionService.getTransactionsForCustomer(customer.getId());
			req.setAttribute("transactions", transactions);
			req.getRequestDispatcher("/customer/transactions.jsp").forward(req, resp);
		} catch (SQLException e) {
			e.printStackTrace();
			req.setAttribute("error", "Failed to load transactions.");
			req.getRequestDispatcher("/customer/transactions.jsp").forward(req, resp);
		}
	}
}
