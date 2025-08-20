package com.bank.webApp.admin;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bank.model.Customer;
import com.bank.service.AdminService;
import com.bank.util.ValidationUtil;

@WebServlet("/admin/customers")
public class AdminCustomersServlet extends HttpServlet {

	private final AdminService adminService = new AdminService();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
			resp.sendRedirect(req.getContextPath() + "/auth");
			return;
		}
		try {
			List<Customer> customers = adminService.getAllCustomers();
			req.setAttribute("customers", customers);

			String editIdStr = req.getParameter("editId");
			if (editIdStr != null && ValidationUtil.isPositiveInteger(editIdStr)) {
				long editId = Long.parseLong(editIdStr);
				Customer editCustomer = adminService.getCustomerById(editId);
				req.setAttribute("editCustomer", editCustomer);
			}

		} catch (Exception e) {
			e.printStackTrace();
			req.setAttribute("error", "Unable to load customers.");
		}
		req.getRequestDispatcher("/admin/customers.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
			resp.sendRedirect(req.getContextPath() + "/auth");
			return;
		}

		String action = req.getParameter("action");

		if ("toggleStatus".equals(action)) {
			try {
				long userId = Long.parseLong(req.getParameter("userId"));

				boolean result = adminService.toggleCustomerStatus(userId);
				if (result) {
					req.getSession().setAttribute("flash_success", "Customer status toggled and accounts updated.");
				} else {
					req.getSession().setAttribute("flash_error", "Failed to toggle status.");
				}
			} catch (Exception e) {
				e.printStackTrace();
				req.getSession().setAttribute("flash_error", "Server error occurred.");
			}
		} else if ("update".equals(action)) {
			try {
				long customerId = Long.parseLong(req.getParameter("customerId"));
				long userId = Long.parseLong(req.getParameter("userId"));
				String firstName = req.getParameter("firstName");
				String lastName = req.getParameter("lastName");
				String email = req.getParameter("email");
				String dobStr = req.getParameter("dob");
				String city = req.getParameter("city");
				String state = req.getParameter("state");
				String phone = req.getParameter("phone");
			


				// Simple validation could be added here

				Customer cust = new Customer();
				cust.setId(customerId);
				cust.setUserId(userId);
				cust.setFirstName(firstName);
				cust.setLastName(lastName);
				cust.setPhone(phone);

				cust.setEmail(email);
				cust.setDob(dobStr == null || dobStr.isEmpty() ? null : java.sql.Date.valueOf(dobStr).toLocalDate());
				cust.setCity(city);
				cust.setState(state);

				boolean updated = adminService.updateCustomer(cust);
				if (updated) {
					req.getSession().setAttribute("flash_success", "Customer updated successfully.");
				} else {
					req.getSession().setAttribute("flash_error", "Customer update failed.");
				}
			} catch (Exception e) {
				e.printStackTrace();
				req.getSession().setAttribute("flash_error", "Server error occurred.");
			}
		}
		resp.sendRedirect(req.getContextPath() + "/admin/customers");
	}
}
