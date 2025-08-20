<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>
  /* Gradient navbar background */
  .navbar-custom {
    background: linear-gradient(90deg, #000000, #1a1a1a, #333333);
  }

  /* Navbar links */
  .navbar-custom .nav-link {
    position: relative;
    color: #f1f1f1 !important;
    font-weight: 500;
    margin: 0 6px;
    transition: color 0.3s ease-in-out;
  }

  .navbar-custom .nav-link:hover {
    color: #00c2ff !important; /* Light aqua highlight */
  }

  /* Underline effect */
  .navbar-custom .nav-link::after {
    content: "";
    position: absolute;
    width: 0;
    height: 2px;
    left: 0;
    bottom: -4px;
    background: #00c2ff;
    transition: width 0.3s ease-in-out;
  }

  .navbar-custom .nav-link:hover::after {
    width: 100%;
  }

  /* Logout button */
  .logout-btn {
    background: #f8f9fa;
    border-radius: 25px;
    transition: all 0.3s ease-in-out;
  }

  .logout-btn:hover {
    background: #00c2ff;
    color: white !important;
    box-shadow: 0 0 12px rgba(0, 194, 255, 0.6);
  }
</style>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark navbar-custom shadow-sm sticky-top">
  <div class="container">

    <!-- Brand -->
    <a class="navbar-brand fw-bold text-white" href="${pageContext.request.contextPath}/admin/dashboard">
      <i class="bi bi-bank"></i> BankApp
    </a>

    <!-- Mobile Toggle -->
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" 
            data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" 
            aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <!-- Links -->
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      
      <!-- Left Menu -->
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <c:choose>
          <c:when test="${not empty sessionScope.userId}">
          <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/admin/accounts">Manage Accounts</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/admin/customers">Manage Customers</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/admin/fixed_deposits">FD Rates</a>
        </li>
      
          </c:when>

          <c:otherwise>
          
          </c:otherwise>
        </c:choose>
      </ul>

      <!-- Right Menu -->
      <c:if test="${not empty sessionScope.userId}">
        <ul class="navbar-nav ms-auto">
          <li class="nav-item">
            <a class="btn btn-sm fw-bold shadow-sm px-3 logout-btn" 
               href="${pageContext.request.contextPath}/auth/logout.jsp">
              <i class="bi bi-box-arrow-right"></i> Logout
            </a>
          </li>
        </ul>
      </c:if>
    </div>
  </div>
</nav>
