<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/admin/components/header.jsp">
  <jsp:param name="pageTitle" value="Manage Accounts"/>
</jsp:include>

<jsp:include page="/admin/components/navbar.jsp"/>

<div class="container mt-5">
  <h2 class="mb-4 text-center fw-bold">Manage Accounts</h2>

  <c:if test="${not empty error}">
    <div class="alert alert-danger shadow-sm">${error}</div>
  </c:if>

  <c:if test="${not empty sessionScope.flash_success}">
    <div class="alert alert-success shadow-sm">${sessionScope.flash_success}</div>
    <c:remove var="flash_success" scope="session"/>
  </c:if>

  <c:if test="${not empty sessionScope.flash_error}">
    <div class="alert alert-danger shadow-sm">${sessionScope.flash_error}</div>
    <c:remove var="flash_error" scope="session"/>
  </c:if>

  <div class="table-responsive shadow-sm rounded">
    <table id="accountsTable" class="table table-striped table-hover align-middle text-center mb-0">
      <thead style="background: linear-gradient(135deg, #36d1dc 0%, #5b86e5 100%); color: white;">
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
            <td>
              <span class="badge 
                ${account.status eq 'ACTIVE' ? 'bg-success' : account.status eq 'PENDING' ? 'bg-warning text-dark' : account.status eq 'SUSPENDED' ? 'bg-danger' : 'bg-secondary'}">
                <c:out value="${account.status}"/>
              </span>
            </td>
            <td>₹ <c:out value="${account.balance}"/></td>
            <td><fmt:formatDate value="${account.openedAt}" pattern="dd-MM-yyyy"/></td>
            <td>
              <form method="post" action="${pageContext.request.contextPath}/admin/accounts" class="d-flex justify-content-center align-items-center gap-2">
                <input type="hidden" name="accountId" value="${account.id}"/>
                <select name="action" class="form-select form-select-sm w-auto" required>
                  <option value="">Change Status</option>
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
  </div>
</div>
<jsp:include page="/admin/components/footer.jsp"/>

<!-- Include jQuery and DataTables JS & CSS -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css"/>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

<script>
  $(document).ready(function() {
    $('#accountsTable').DataTable({
      "pageLength": 10,
      "lengthMenu": [5, 10, 25, 50, 100],
      "order": [[5, "desc"]],
      "language": {
        "search": "_INPUT_",
        "searchPlaceholder": "Search accounts..."
      }
    });
  });
</script>

<!-- Additional Styling -->
<style>
  #accountsTable thead th {
    font-weight: 600;
    letter-spacing: 0.5px;
  }

  #accountsTable tbody tr:hover {
    background-color: rgba(0, 123, 255, 0.08);
    transition: background-color 0.3s;
  }

  .badge {
    padding: 0.5em 0.8em;
    font-size: 0.85rem;
    border-radius: 50px;
    font-weight: 500;
  }

  .table-responsive {
    border-radius: 12px;
    overflow: hidden;
  }
</style>
