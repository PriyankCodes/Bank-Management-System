<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/components/header.jsp">
  <jsp:param name="pageTitle" value="Open New Account"/>
</jsp:include>
<jsp:include page="/components/navbar.jsp"/>

<div class="container section-lg fade-in py-5">
  <jsp:include page="/components/alerts.jsp"/>

  <div class="row justify-content-center">
    <div class="col-md-7 col-lg-6">
      <div class="card account-card shadow-lg border-0 rounded-4 p-4">
        
        <!-- Title -->
        <h3 class="card-title text-center mb-4 text-gradient fw-bold">
          <i class="bi bi-person-plus-fill me-2"></i> Open New Account
        </h3>

        <!-- Account Form -->
        <form method="post" action="${pageContext.request.contextPath}/customer/account-new" novalidate>
          
          <!-- Account Type -->
          <div class="mb-3">
            <label for="type" class="form-label fw-semibold">
              <i class="bi bi-bank me-2 text-primary"></i> Account Type
            </label>
            <select name="type" id="type" class="form-select stylish-select shadow-sm" required>
              <option value="">-- Select account type --</option>
              <option value="SAVINGS" <c:if test="${prefillType == 'SAVINGS'}">selected</c:if>>💰 Savings Account</option>
              <option value="CURRENT" <c:if test="${prefillType == 'CURRENT'}">selected</c:if>>🏦 Current Account</option>
            </select>
          </div>

          <!-- Initial Deposit -->
          <div class="mb-3">
            <label for="principal" class="form-label fw-semibold">
              <i class="bi bi-cash-stack me-2 text-success"></i> Initial Deposit
            </label>
            <input type="number" min="1000" step="0.01" id="principal" name="principal" 
                   class="form-control stylish-input shadow-sm" placeholder="Enter deposit amount" required/>
            <div class="form-text text-muted">💡 Minimum ₹1000 required to open an account.</div>
          </div>

          <!-- Buttons -->
          <div class="d-flex justify-content-center mt-4">
            <button type="submit" class="btn btn-gradient px-4 glow-btn me-2">
              <i class="bi bi-check-circle me-1"></i> Create Account
            </button>
            <a href="${pageContext.request.contextPath}/customer/dashboard" 
               class="btn btn-outline-secondary px-4">
              <i class="bi bi-x-circle me-1"></i> Cancel
            </a>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

<jsp:include page="/components/footer.jsp"/>

<style>
  /* Gradient Heading */
  .text-gradient {
    background: linear-gradient(90deg, #ff416c, #ff4b2b);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }

  /* Button Gradient */
  .btn-gradient {
    background: linear-gradient(90deg, #ff416c, #ff4b2b);
    border: none;
    color: #fff !important;
    transition: all 0.3s ease;
    border-radius: 12px;
  }
  .btn-gradient:hover {
    background: linear-gradient(90deg, #ff4b2b, #ff416c);
    transform: translateY(-2px);
    box-shadow: 0 6px 15px rgba(255, 65, 108, 0.4);
  }

  /* Glow effect */
  .glow-btn {
    box-shadow: 0 4px 10px rgba(255, 75, 43, 0.3);
  }

  /* Stylish Input */
  .stylish-input, .stylish-select {
    border-radius: 10px;
    transition: all 0.3s ease;
  }
  .stylish-input:focus, .stylish-select:focus {
    border-color: #ff416c;
    box-shadow: 0 0 8px rgba(255, 65, 108, 0.3);
  }

  /* Fade-in animation */
  .fade-in {
    animation: fadeInUp 0.8s ease-in-out;
  }
  @keyframes fadeInUp {
    from {
      opacity: 0;
      transform: translateY(30px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
</style>
