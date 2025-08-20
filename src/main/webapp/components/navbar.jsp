<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom sticky-top">
  <div class="container">
    <a class="navbar-brand fw-bold text-primary" href="${pageContext.request.contextPath}/">BankApp</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <c:choose>
          <c:when test="${not empty sessionScope.userId}">
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/customer/account-new">Open Account</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/customer/transfers">Transfers</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/customer/beneficiaries">Beneficiaries</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/customer/transactions">Transactions</a>
            </li>
             <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/customer/fixed_deposit">FD</a>
            </li>
          </c:when>
          
          
          <c:otherwise>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/auth/login">Login</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/auth/register">Register</a>
            </li>
          </c:otherwise>
        </c:choose>
      </ul>

      <c:if test="${not empty sessionScope.userId}">
        <ul class="navbar-nav ms-auto">

          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/auth/logout.jsp">Logout</a>
          </li>
        </ul>
      </c:if>
    </div>
  </div>
</nav>
