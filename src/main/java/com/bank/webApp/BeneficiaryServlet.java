package com.bank.webApp;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bank.model.Beneficiary;
import com.bank.model.Customer;
import com.bank.service.BeneficiaryService;
import com.bank.service.CustomerService;

@WebServlet("/customer/beneficiaries")
public class BeneficiaryServlet extends HttpServlet {

	private final BeneficiaryService beneficiaryService = new BeneficiaryService();
	private final CustomerService customerService = new CustomerService();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Long userId = (Long) req.getSession().getAttribute("userId");
		if (userId == null) {
			resp.sendRedirect(req.getContextPath() + "/AuthServlet");
			return;
		}
		String action = req.getParameter("action");
		try {
			Customer customer = customerService.findByUserId(userId);
			if (customer == null) {
				req.setAttribute("error", "Customer profile not found.");
				req.getRequestDispatcher("/customer/beneficiaries.jsp").forward(req, resp);
				return;
			}

			if ("edit".equals(action)) {
				long beneficiaryId = Long.parseLong(req.getParameter("id"));
				// Load beneficiary to edit
				Beneficiary b = beneficiaryService.getBeneficiaryById(beneficiaryId);
				req.setAttribute("beneficiaryToEdit", b);
				req.getRequestDispatcher("/customer/beneficiaries.jsp").forward(req, resp);
				return;
			}

			// default: show list and add form
			List<Beneficiary> beneficiaries = beneficiaryService.listBeneficiaries(userId);
			req.setAttribute("beneficiaries", beneficiaries);

			req.getRequestDispatcher("/customer/beneficiaries.jsp").forward(req, resp);
		} catch (Exception e) {
			e.printStackTrace();
			req.setAttribute("error", "Failed to load beneficiary data.");
			req.getRequestDispatcher("/customer/beneficiaries.jsp").forward(req, resp);
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Long userId = (Long) req.getSession().getAttribute("userId");
		if (userId == null) {
			resp.sendRedirect(req.getContextPath() + "/AuthServlet");
			return;
		}
		String action = req.getParameter("action");
		try {
			// In your existing BeneficiaryServlet doPost method:
			if ("update".equals(action)) {
				long beneficiaryId = Long.parseLong(req.getParameter("id"));
				String name = req.getParameter("name");
				String accountNumber = req.getParameter("accountNumber");
				String bankName = req.getParameter("bankName");
				beneficiaryService.updateBeneficiary(userId, beneficiaryId, name, accountNumber, bankName);
				req.getSession().setAttribute("flash_success", "Beneficiary updated successfully.");
				resp.sendRedirect(req.getContextPath() + "/customer/beneficiaries");
				return;
			} else if ("delete".equals(action)) {
				// Handle delete beneficiary
				long beneficiaryId = Long.parseLong(req.getParameter("id"));
				beneficiaryService.deleteBeneficiary(userId, beneficiaryId);
				req.getSession().setAttribute("flash_success", "Beneficiary deleted successfully.");
				resp.sendRedirect(req.getContextPath() + "/customer/beneficiaries");
				return;
			} else {
				// Default add new beneficiary
				String name = req.getParameter("name");
				String accountNumber = req.getParameter("accountNumber");
				String bankName = req.getParameter("bankName");
				Customer customer = customerService.findByUserId(userId);
				beneficiaryService.addBeneficiary(customer.getId(), name, accountNumber, bankName);
				req.getSession().setAttribute("flash_success", "Beneficiary added successfully.");
				resp.sendRedirect(req.getContextPath() + "/customer/beneficiaries");
				return;
			}
		} catch (Exception e) {
			e.printStackTrace();
			req.setAttribute("error", "Operation failed: " + e.getMessage());
			doGet(req, resp);
		}
	}
}
