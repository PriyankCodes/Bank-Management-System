<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/admin/components/header.jsp">
  <jsp:param name="pageTitle" value="Admin Dashboard"/>
</jsp:include>

<jsp:include page="/admin/components/navbar.jsp"/>

<h2>Manage Accounts</h2>

<c:if test="${not empty error}">
  <div class="alert alert-danger">${error}</div>
</c:if>

<c:if test="${not empty sessionScope.flash_success}">
  <div class="alert alert-success">${sessionScope.flash_success}</div>
  <c:remove var="flash_success" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.flash_error}">
  <div class="alert alert-danger">${sessionScope.flash_error}</div>
  <c:remove var="flash_error" scope="session"/>
</c:if>

<table id="accountsTable" class="table table-bordered table-striped">
  <thead>
    <tr>
      <th>Account Number</th>
      <th>Customer</th>
      <th>Type</th>
      <th>Status</th>
      <th>Balance</th>
      <th>Opened At</th>
      <th>Actions</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="account" items="${accounts}">
      <tr>
        <td><c:out value="${account.accountNumber}"/></td>
        <td><c:out value="${account.customerName}"/></td>
        <td><c:out value="${account.type}"/></td>
        <td><c:out value="${account.status}"/></td>
        <td>₹ <c:out value="${account.balance}"/></td>
        <td><fmt:formatDate value="${account.openedAt}" pattern="yyyy-MM-dd"/></td>
        <td>
          <form method="post" action="${pageContext.request.contextPath}/admin/accounts" style="display:inline;">
            <input type="hidden" name="accountId" value="${account.id}"/>
            <select name="action" class="form-select form-select-sm d-inline-block w-auto" required>
              <option value="">Change Status</option>
              <option value="PENDING">Pending</option>
              <option value="ACTIVE">Active</option>
              <option value="SUSPENDED">Suspended</option>
              <option value="CLOSED">Closed</option>
            </select>
            <button type="submit" class="btn btn-sm btn-primary">Update</button>
          </form>
        </td>
      </tr>
    </c:forEach>
  </tbody>
</table>

<!-- Include jQuery and DataTables JS & CSS -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css"/>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

<script>
  $(document).ready(function() {
    $('#accountsTable').DataTable({
      "pageLength": 10,
      "lengthMenu": [5, 10, 25, 50, 100],
      "order": [[5, "desc"]] // Order by Opened At column descending by default
    });
  });
</script>
