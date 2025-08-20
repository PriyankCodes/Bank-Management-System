<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/admin/components/header.jsp">
  <jsp:param name="pageTitle" value="Admin Dashboard"/>
</jsp:include>

<jsp:include page="/admin/components/navbar.jsp"/>

<h2>Manage Customers</h2>

<c:if test="${not empty error}">
  <div class="alert alert-danger">${error}</div>
</c:if>

<c:if test="${not empty sessionScope.flash_success}">
  <div class="alert alert-success">${sessionScope.flash_success}</div>
  <c:remove var="flash_success" scope="session" />
</c:if>

<c:if test="${not empty sessionScope.flash_error}">
  <div class="alert alert-danger">${sessionScope.flash_error}</div>
  <c:remove var="flash_error" scope="session" />
</c:if>

<table class="table table-bordered table-striped">
  <thead>
    <tr>
      <th>Name</th>
      <th>Email</th>
      <th>DOB</th>
      <th>City</th>
      <th>State</th>
      <th>Registered On</th>
      <th>Status</th>
      <th>Actions</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="cust" items="${customers}">
      <tr>
        <td><c:out value="${cust.firstName}" /> <c:out value="${cust.lastName}" /></td>
        <td><c:out value="${cust.email}" /></td>
        <td><c:out value="${cust.dob}" /></td>
        <td><c:out value="${cust.city}" /></td>
        <td><c:out value="${cust.state}" /></td>
        <td><c:out value="${cust.registeredOn}" /></td>
        <td><c:out value="${cust.status}" /></td>
        <td>
        <form method="post" action="${pageContext.request.contextPath}/admin/customers" style="display:inline;">
  <input type="hidden" name="userId" value="${cust.userId}" />
  <input type="hidden" name="action" value="toggleStatus" />
  <button type="submit" class="btn btn-sm ${cust.status == 'ACTIVE' ? 'btn-danger' : 'btn-success'}">
    ${cust.status == 'ACTIVE' ? 'Disable' : 'Enable'}
  </button>
</form>

          <a href="${pageContext.request.contextPath}/admin/customers?editId=${cust.id}" class="btn btn-sm btn-warning ms-1">Edit</a>
        </td>
      </tr>
    </c:forEach>
  </tbody>
</table>

<c:if test="${not empty editCustomer}">
  <h3>Edit Customer - <c:out value="${editCustomer.firstName}"/> <c:out value="${editCustomer.lastName}"/></h3>
  <form method="post" action="${pageContext.request.contextPath}/admin/customers" class="mb-5">
    <input type="hidden" name="customerId" value="${editCustomer.id}" />
    <input type="hidden" name="userId" value="${editCustomer.userId}" />
    <input type="hidden" name="action" value="update" />

    <div class="mb-3">
      <label for="firstName" class="form-label">First Name</label>
      <input type="text" id="firstName" name="firstName" class="form-control" value="${editCustomer.firstName}" required />
    </div>

    <div class="mb-3">
      <label for="lastName" class="form-label">Last Name</label>
      <input type="text" id="lastName" name="lastName" class="form-control" value="${editCustomer.lastName}" required />
    </div>

    <div class="mb-3">
      <label for="email" class="form-label">Email</label>
      <input type="email" id="email" name="email" class="form-control" value="${editCustomer.email}" required />
    </div>
    <div class="mb-3">
  <label for="phone" class="form-label">Phone</label>
  <input type="text" id="phone" name="phone" class="form-control" value="${editCustomer.phone}" required/>
</div>
    

    <div class="mb-3">
      <label for="dob" class="form-label">Date of Birth</label>
      <input type="date" id="dob" name="dob" class="form-control" value="${editCustomer.dob}" required />
    </div>

    <div class="mb-3">
      <label for="city" class="form-label">City</label>
      <input type="text" id="city" name="city" class="form-control" value="${editCustomer.city}" required />
    </div>

    <div class="mb-3">
      <label for="state" class="form-label">State</label>
      <input type="text" id="state" name="state" class="form-control" value="${editCustomer.state}" required />
    </div>

    <button type="submit" class="btn btn-primary">Save Changes</button>
    <a href="${pageContext.request.contextPath}/admin/customers" class="btn btn-secondary ms-2">Cancel</a>
  </form>
</c:if>
