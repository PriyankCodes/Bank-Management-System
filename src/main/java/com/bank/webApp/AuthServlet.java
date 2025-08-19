package com.bank.webApp;

import com.bank.service.AuthService;
import com.bank.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/AuthServlet")
public class AuthServlet extends HttpServlet {
	private final AuthService authService = new AuthService();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String action = req.getParameter("action");
		if ("register".equals(action)) {
			req.getRequestDispatcher("/auth/register.jsp").forward(req, resp);
		} else {
			req.getRequestDispatcher("/auth/login.jsp").forward(req, resp);
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
		String action = req.getParameter("action");
		if ("register".equals(action)) {
			String firstName = req.getParameter("firstName");
			String lastName = req.getParameter("lastName");
			String email = req.getParameter("email");
			String phone = req.getParameter("phone");
			String password = req.getParameter("password");
			String dobStr = req.getParameter("dob");
			String city = req.getParameter("city");
			String state = req.getParameter("state");
			try {
				boolean ok = authService.register(email, phone, password, firstName, lastName, LocalDate.parse(dobStr),
						city, state);
				if (ok) {
					req.setAttribute("success", "Registration successful. Please login.");
					req.getRequestDispatcher("/auth/login.jsp").forward(req, resp);
				} else {
					req.setAttribute("error", "Email already exists.");
					req.getRequestDispatcher("/auth/register.jsp").forward(req, resp);
				}
			} catch (Exception e) {
				req.setAttribute("error", "Server error. Try again.");
				req.getRequestDispatcher("/auth/register.jsp").forward(req, resp);
			}
		} else {
			String email = req.getParameter("email");
			String password = req.getParameter("password");
			try {
				User u = authService.login(email, password);
				if (u == null) {
					req.setAttribute("error", "Invalid credentials or inactive account.");
					req.getRequestDispatcher("/auth/login.jsp").forward(req, resp);
					return;
				}
				HttpSession session = req.getSession(true);
				session.setAttribute("userId", u.getId());
				session.setAttribute("role", u.getRole());
				session.setAttribute("email", u.getEmail());
				
				
				if ("ADMIN".equals(u.getRole())) {
					resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
				} else {
					resp.sendRedirect(req.getContextPath() + "/customer/dashboard");
				}
			} catch (Exception e) {
				req.setAttribute("error", "Server error. Try again.");
				req.getRequestDispatcher("/auth/login.jsp").forward(req, resp);
			}
		}
	}
}
