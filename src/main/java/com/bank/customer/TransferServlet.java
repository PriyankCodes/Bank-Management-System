
package com.bank.customer;

import java.io.IOException;
import java.math.BigDecimal;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bank.service.AccountService;
import com.bank.service.BeneficiaryService;
import com.bank.service.CustomerService;
import com.bank.service.TransferService;
import com.bank.util.Util;

@WebServlet("/customer/transfers")
public class TransferServlet extends HttpServlet {
	private final AccountService accountService = new AccountService();
	private final CustomerService customerService = new CustomerService();
	private final TransferService transferService = new TransferService();
	private final BeneficiaryService beneficiaryService = new BeneficiaryService();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Long userId = (Long) req.getSession().getAttribute("userId");
		String role = (String) req.getSession().getAttribute("role");
		if (userId == null || !"CUSTOMER".equals(role)) {
			resp.sendRedirect(req.getContextPath() + "/AuthServlet");
			return;
		}
		try {
			long customerId = accountService.findCustomerIdByUserId(userId);

			req.setAttribute("accounts", accountService.getAccountsByCustomerId(customerId)); // assumes customer id =
																								// userId; adjust if
																								// necessary
			req.setAttribute("beneficiaries", customerService.listBeneficiaries(userId)); // implement this in
																							// CustomerService
			req.setAttribute("transfers", transferService.recentForUser(customerId));
		} catch (Exception e) {
			req.setAttribute("error", "Unable to load transfers data.");
		}
		req.getRequestDispatcher("/customer/transfers.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Long userId = (Long) req.getSession().getAttribute("userId");
		String role = (String) req.getSession().getAttribute("role");
		if (userId == null || !"CUSTOMER".equals(role)) {
			resp.sendRedirect(req.getContextPath() + "/AuthServlet");
			return;
		}
		try {
			long fromAccountId = Long.parseLong(req.getParameter("fromAccountId"));
			BigDecimal amount = new BigDecimal(req.getParameter("amount"));

			String fromAccNumber = accountService.getAccountNumberById(fromAccountId);

			// check beneficiaryId parameter safely

			String beneficiaryIdStr = req.getParameter("beneficiaryId");
			String beneficiaryAccNumber = null;
			long beneficiaryId = 0;
//			if (beneficiaryIdStr != null && !beneficiaryIdStr.isEmpty()) {
//				beneficiaryId = Long.parseLong(beneficiaryIdStr) - 1;
//				beneficiaryAccNumber = customerService.getBeneficiaryAccountNumberById(beneficiaryId);
//			} else {
//				beneficiaryAccNumber = req.getParameter("beneficiaryAccountNumber");
//				if (!Util.isValidAccountNumber(beneficiaryAccNumber)) {
//					throw new IllegalArgumentException("Invalid account number.");
//				}
//
//				// Check if account exists internally—throw exception or handle as needed
//				if (!beneficiaryService.isAccountExists(beneficiaryAccNumber)) {
//					throw new IllegalArgumentException("Account number does not exist in the bank.");
//				}
//				beneficiaryId = accountService.findAccountIdByAccountNumber(beneficiaryAccNumber);
//			}
			if (beneficiaryIdStr != null && !beneficiaryIdStr.isEmpty()) {
			    // Beneficiary chosen from dropdown
			    beneficiaryId = Long.parseLong(beneficiaryIdStr);
			    beneficiaryAccNumber = customerService.getBeneficiaryAccountNumberById(beneficiaryId);

			} else {
			    // Direct account number entry
			    beneficiaryAccNumber = req.getParameter("beneficiaryAccountNumber");

			    if (!Util.isValidAccountNumber(beneficiaryAccNumber)) {
			        throw new IllegalArgumentException("Invalid account number.");
			    }

			    // Check if account exists internally
			    if (!beneficiaryService.isAccountExists(beneficiaryAccNumber)) {
			        throw new IllegalArgumentException("Account number does not exist in the bank.");
			    }

			    // Do NOT set beneficiaryId here — keep it null
			    beneficiaryId = 0; // or simply leave as null in service call
			}

			if (beneficiaryAccNumber == null || beneficiaryAccNumber.isEmpty()) {
				req.setAttribute("error", "Please select or enter a beneficiary account.");
				doGet(req, resp);
				return;
			}

			// Check if account numbers are the same
			if (fromAccNumber != null && fromAccNumber.equals(beneficiaryAccNumber)) {
				req.setAttribute("error", "Source and destination account numbers cannot be the same.");
				doGet(req, resp);
				return;
			}

			String ref = transferService.transfer(
				    userId, 
				    fromAccountId, 
				    beneficiaryId > 0 ? beneficiaryId : 0,
				    beneficiaryAccNumber,   // always pass account number, even if beneficiary selected
				    amount
				);

			if (ref != null) {
				req.getSession().setAttribute("flash_success", "Transfer successful. Reference: " + ref);
				resp.sendRedirect(req.getContextPath() + "/customer/transfers");
			} else {
				req.setAttribute("error", "Transfer failed: check balance, ownership, or input values.");
				doGet(req, resp);
			}
		}
		catch (IllegalArgumentException iae) {
		    // show friendly validation message
		    req.setAttribute("error", iae.getMessage());
		    doGet(req, resp);

		}catch (Exception e) {
			req.setAttribute("error", "Transfer failed due to server error.");
			doGet(req, resp);
		}
	}

}
