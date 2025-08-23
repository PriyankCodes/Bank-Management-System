<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/components/header.jsp">
  <jsp:param name="pageTitle" value="Open New Account"/>
</jsp:include>
<jsp:include page="/components/navbar.jsp"/>

<div class="container py-5">
  <jsp:include page="/components/alerts.jsp"/>

  <div class="row justify-content-center">
    <div class="col-md-8 col-lg-6">

      <!-- Logo & Title -->
      <div class="text-center mb-4">
        <div class="d-inline-flex align-items-center justify-content-center rounded-circle mx-auto"
             style="width: 60px; height: 60px; background: #000; box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);">
          <i class="bi bi-wallet2 text-white fs-3"></i>
        </div>
        <h2 class="fw-bold mt-3 mb-1" style="color: #111;">Open New Account</h2>
        <p class="text-muted" style="font-size: 0.95rem;">Choose your account type and get started</p>
      </div>

      <!-- Card -->
      <div class="card border-0 shadow-sm rounded-4 glow-effect" style="overflow: hidden;">

        <div class="card-body p-5">

          <!-- Form -->
          <form method="post" action="${pageContext.request.contextPath}/customer/account-new" novalidate>

            <!-- Account Type -->
            <div class="mb-4">
              <label for="type" class="form-label text-black fw-medium">
                <i class="bi bi-credit-card me-2 text-secondary"></i> Account Type
              </label>
              <select name="type" id="type" class="form-select" style="border-radius: 10px; padding: 0.75rem;" required>
                <option value="" disabled selected>-- Select type --</option>
                <option value="SAVINGS" <c:if test="${prefillType == 'SAVINGS'}">selected</c:if>>💰 Savings Account</option>
                <option value="CURRENT" <c:if test="${prefillType == 'CURRENT'}">selected</c:if>>🏦 Current Account</option>
              </select>
            </div>

            <!-- Initial Deposit -->
            <div class="mb-4">
              <label for="principal" class="form-label text-black fw-medium">
                <i class="bi bi-cash me-2 text-secondary"></i> Initial Deposit
              </label>
              <div class="input-group">
                <span class="input-group-text bg-white border-end-0">
                  <i class="bi bi-currency-rupee text-black-50"></i>
                </span>
                <input type="number" min="1000" step="0.01" id="principal" name="principal"
                       class="form-control" style="border-left: none; border-radius: 10px;"
                       placeholder="Enter amount" required />
              </div>
              <div class="form-text text-muted mt-1" style="font-size: 0.875rem;">
                💡 Minimum ₹1000 required.
              </div>
            </div>

            <!-- Buttons -->
            <div class="d-grid gap-2 d-md-flex justify-content-md-center mt-4">
              <button type="submit" class="btn btn-dark px-5 py-2" style="
                border-radius: 10px;
                font-weight: 500;
                letter-spacing: 0.8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                transition: all 0.3s ease;
              ">
                <i class="bi bi-check-circle me-2"></i>Create Account
              </button>
              <a href="${pageContext.request.contextPath}/customer/dashboard"
                 class="btn btn-outline-secondary px-5 py-2"
                 style="border-radius: 10px; font-weight: 500;">
                <i class="bi bi-x-circle me-2"></i>Cancel
              </a>
            </div>

          </form>

        </div>
      </div>

      <!-- Subtle Glow Accent (Optional) -->
      <div class="text-center mt-3">
        <small class="text-black-50">
          <i class="bi bi-shield-check me-1"></i>
          Secure & Fast Process
        </small>
      </div>

    </div>
  </div>
</div>

<jsp:include page="/components/footer.jsp"/>

<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>

<!-- Custom Styles -->
<style>
  /* Soft Glow on Card */
  .glow-effect:hover {
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.18) !important;
    transform: translateY(-3px);
    transition: all 0.3s ease;
  }

  /* Input Focus Glow */
  .form-control:focus, .form-select:focus {
    border-color: #000 !important;
    box-shadow: 0 0 0 0.2rem rgba(0, 0, 0, 0.1) !important;
  }

  /* Smooth Button Hover */
  .btn-dark {
    background-color: #000;
    border: none;
    transition: all 0.3s ease;
  }

  .btn-dark:hover {
    background-color: #111;
    transform: translateY(-2px);
    box-shadow: 0 6px 15px rgba(0, 0, 0, 0.2);
  }

  .btn-outline-secondary:hover {
    background-color: #f8f9fa;
    border-color: #ddd;
    color: #000;
    transform: scale(1.02);
    transition: all 0.3s ease;
  }

  /* Subtle Gradient Separator (Optional Accent) */
  .divider {
    height: 1px;
    background: linear-gradient(to right, transparent, #ccc, transparent);
    margin: 2rem 0;
  }

  /* General Clean Font */
  body {
    font-family: 'Inter', sans-serif;
    background-color: #fafafa;
  }
</style>

<!-- Optional: Google Fonts for Inter (Clean Typography) -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>