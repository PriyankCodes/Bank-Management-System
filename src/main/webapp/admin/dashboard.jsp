<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/admin/components/header.jsp">
  <jsp:param name="pageTitle" value="Admin Dashboard"/>
</jsp:include>

<jsp:include page="/admin/components/navbar.jsp"/>

<div class="container mt-4">
  <h2 class="mb-4">Admin Dashboard</h2>

  <c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
  </c:if>

  <div class="row mb-4">
    <div class="col-md-3">
      <div class="card text-white bg-primary mb-3">
        <div class="card-body">
          <h5 class="card-title">Pending Account Approvals</h5>
          <p class="card-text display-5">${pendingAccounts}</p>
        </div>
      </div>
    </div>
    <div class="col-md-3">
      <div class="card text-white bg-success mb-3">
        <div class="card-body">
          <h5 class="card-title">Active Customers</h5>
          <p class="card-text display-5">${activeCustomers}</p>
        </div>
      </div>
    </div>
    <div class="col-md-3">
      <div class="card text-white bg-warning mb-3">
        <div class="card-body">
          <h5 class="card-title">Soft Deleted Customers</h5>
          <p class="card-text display-5">${softDeletedCustomers}</p>
        </div>
      </div>
    </div>
    <div class="col-md-3">
      <div class="card text-white bg-info mb-3">
        <div class="card-body">
          <h5 class="card-title">Average Interest Rate (%)</h5>
          <p class="card-text display-5">${avgInterestRate}</p>
        </div>
      </div>
    </div>
  </div>

  <h4>Recent Customer Registrations</h4>
  <c:if test="${empty recentCustomers}">
    <p>No recent customer registrations.</p>
  </c:if>
  <c:if test="${not empty recentCustomers}">
    <table class="table table-striped table-hover">
      <thead>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>Email</th>
          <th>Registered On</th>
          <th>Status</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="cust" items="${recentCustomers}">
          <tr>
            <td><c:out value="${cust.id}"/></td>
            <td><c:out value="${cust.firstName}"/> <c:out value="${cust.lastName}"/></td>
            <td><c:out value="${cust.email}"/></td>
            <td><c:out value="${cust.registeredOn}"/></td>
            <td><c:out value="${cust.status}"/></td>
            <td>
              <!-- Add edit/view/delete links here -->
              <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/admin/customers/edit?id=${cust.id}">Edit</a>
              <a class="btn btn-sm btn-danger" href="${pageContext.request.contextPath}/admin/customers/delete?id=${cust.id}" onclick="return confirm('Are you sure?')">Delete</a>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </c:if>
</div>

<jsp:include page="/admin/components/footer.jsp"/>
