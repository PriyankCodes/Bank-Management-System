<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/admin/components/header.jsp">
  <jsp:param name="pageTitle" value="Admin Dashboard"/>
</jsp:include>

<jsp:include page="/admin/components/navbar.jsp"/>

<div class="container mt-5">
  <h2 class="mb-5 text-center fw-bold">Admin Dashboard</h2>

  <c:if test="${not empty error}">
    <div class="alert alert-danger shadow-sm">${error}</div>
  </c:if>

  <!-- Dashboard Cards -->
  <div class="row g-4 mb-5">
    <div class="col-md-3 col-sm-6">
      <div class="card text-white shadow-lg h-100 dashboard-card" style="background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);">
        <div class="card-body d-flex flex-column justify-content-center align-items-center text-center">
          <h5 class="card-title fw-bold">Pending Account Approvals</h5>
          <p class="card-text display-4 fw-bold">${pendingAccounts}</p>
        </div>
      </div>
    </div>
    <div class="col-md-3 col-sm-6">
      <div class="card text-white shadow-lg h-100 dashboard-card" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">
        <div class="card-body d-flex flex-column justify-content-center align-items-center text-center">
          <h5 class="card-title fw-bold">Active Customers</h5>
          <p class="card-text display-4 fw-bold">${activeCustomers}</p>
        </div>
      </div>
    </div>
    <div class="col-md-3 col-sm-6">
      <div class="card text-white shadow-lg h-100 dashboard-card" style="background: linear-gradient(135deg, #f7971e 0%, #ffd200 100%);">
        <div class="card-body d-flex flex-column justify-content-center align-items-center text-center">
          <h5 class="card-title fw-bold">Inactive Customers</h5>
          <p class="card-text display-4 fw-bold">${softDeletedCustomers}</p>
        </div>
      </div>
    </div>
    <div class="col-md-3 col-sm-6">
      <div class="card text-white shadow-lg h-100 dashboard-card" style="background: linear-gradient(135deg, #36d1dc 0%, #5b86e5 100%);">
        <div class="card-body d-flex flex-column justify-content-center align-items-center text-center">
          <h5 class="card-title fw-bold">FD Average Interest Rate (%)</h5>
          <p class="card-text display-4 fw-bold">${avgInterestRate}</p>
        </div>
      </div>
    </div>
  </div>

  <!-- Hover effect for cards -->
  <style>
    .dashboard-card {
      border-radius: 15px;
      transition: transform 0.3s, box-shadow 0.3s;
    }
    .dashboard-card:hover {
      transform: translateY(-10px);
      box-shadow: 0 15px 25px rgba(0,0,0,0.3);
    }
    .table-custom {
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 5px 15px rgba(0,0,0,0.15);
      transition: transform 0.3s;
    }
    .table-custom:hover {
      transform: scale(1.01);
    }
    .table-custom thead {
      background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
      color: white;
    }
    .table-custom tbody tr:hover {
      background-color: rgba(0, 123, 255, 0.1);
    }
    .badge-status {
      padding: 0.5em 0.8em;
      font-size: 0.9rem;
      border-radius: 50px;
      font-weight: 500;
    }
  </style>

  <h4 class="mb-3">Recent Customer Registrations</h4>
  <c:if test="${empty recentCustomers}">
    <p class="text-muted">No recent customer registrations.</p>
  </c:if>
  <c:if test="${not empty recentCustomers}">
    <div class="table-responsive table-custom">
      <table class="table table-striped table-hover align-middle text-center mb-0">
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Registered On</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="cust" items="${recentCustomers}">
            <tr>
              <td><c:out value="${cust.id}"/></td>
              <td><c:out value="${cust.firstName}"/> <c:out value="${cust.lastName}"/></td>
              <td><c:out value="${cust.email}"/></td>
              <td><c:out value="${cust.registeredOn}"/></td>
              <td>
                <span class="badge badge-status
                  ${cust.status eq 'ACTIVE' ? 'bg-success' : cust.status eq 'PENDING' ? 'bg-warning text-dark' : 'bg-secondary'}">
                  <c:out value="${cust.status}"/>
                </span>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </c:if>
</div>

<jsp:include page="/admin/components/footer.jsp"/>
