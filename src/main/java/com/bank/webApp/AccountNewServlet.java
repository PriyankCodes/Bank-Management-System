package com.bank.webApp;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bank.model.Customer;
import com.bank.service.AccountService;
import com.bank.service.CustomerService;
import com.bank.util.Util;

@WebServlet("/customer/account-new")
public class AccountNewServlet extends HttpServlet {
	private final AccountService accountService = new AccountService();
	private final CustomerService customerService = new CustomerService();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String type = Util.safeString(req.getParameter("type"));
		if ("SAVINGS".equalsIgnoreCase(type) || "CURRENT".equalsIgnoreCase(type)) {
			req.setAttribute("prefillType", type.toUpperCase());
		}
		req.getRequestDispatcher("/customer/account_new.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Long userId = (Long) req.getSession().getAttribute("userId");
		if (userId == null) {
			resp.sendRedirect(req.getContextPath() + "/AuthServlet");
			return;
		}

		String type = Util.safeString(req.getParameter("type"));
		String principalStr = Util.safeString(req.getParameter("principal"));

		if (type == null || principalStr == null) {
			req.setAttribute("error", "Account type and initial deposit are required.");
			doGet(req, resp);
			return;
		}

		try {
			BigDecimal principal = new BigDecimal(principalStr);
			if (!Util.isValidInitialDeposit(principal)) {
				req.setAttribute("error", "Initial deposit must be at least ₹1000.");
				doGet(req, resp);
				return;
			}

			Customer customer = customerService.findByUserId(userId);
			if (customer == null) {
				req.setAttribute("error", "Customer profile not found.");
				doGet(req, resp);
				return;
			}

			if (!accountService.canCreateAccount(customer.getId(), type)) {
				req.setAttribute("error", "Account of type " + type + " already exists.");
				doGet(req, resp);
				return;
			}
			if (accountService.hasNonActiveAccountOfType(customer.getId(), type)) {
				req.setAttribute("error", "You already have a non-active " + type
						+ " account. Please wait for approval or contact support.");
				doGet(req, resp);
				return;
			}

			if (!accountService.canCreateAccount(customer.getId(), type)) {
				req.setAttribute("error", "You already have an active " + type + " account.");
				doGet(req, resp);
				return;
			}

			long accountId = accountService.createAccount(customer.getId(), type, principal);
			req.getSession().setAttribute("flash_success", "Account created successfully. Awaiting admin approval.");
			resp.sendRedirect(req.getContextPath() + "/customer/dashboard");
		} catch (NumberFormatException ex) {
			req.setAttribute("error", "Invalid deposit amount.");
			doGet(req, resp);
		} catch (IllegalArgumentException | IllegalStateException ex) {
			req.setAttribute("error", ex.getMessage());
			doGet(req, resp);
		} catch (SQLException e) {
			e.printStackTrace();
			req.setAttribute("error", "Failed to create account due to server error.");
			doGet(req, resp);
		}
	}
}
