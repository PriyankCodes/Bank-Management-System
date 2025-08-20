<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/admin/components/header.jsp">
  <jsp:param name="pageTitle" value="Manage Customers"/>
</jsp:include>

<jsp:include page="/admin/components/navbar.jsp"/>

<div class="container mt-5">
  <h2 class="mb-4 text-center fw-bold">Manage Customers</h2>

  <!-- Flash Messages -->
  <c:if test="${not empty error}">
    <div class="alert alert-danger shadow-sm">${error}</div>
  </c:if>

  <c:if test="${not empty sessionScope.flash_success}">
    <div class="alert alert-success shadow-sm">${sessionScope.flash_success}</div>
    <c:remove var="flash_success" scope="session" />
  </c:if>

  <c:if test="${not empty sessionScope.flash_error}">
    <div class="alert alert-danger shadow-sm">${sessionScope.flash_error}</div>
    <c:remove var="flash_error" scope="session" />
  </c:if>

  <!-- Customers Table -->
  <div class="table-responsive shadow-lg rounded mb-5 p-3" style="background: #fff;">
    <table id="customersTable" class="table table-striped table-hover table-bordered align-middle text-center mb-0">
      <thead style="background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%); color: white; font-weight: 600;">
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
            <td>
              <span class="badge 
                ${cust.status eq 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">
                <c:out value="${cust.status}" />
              </span>
            </td>
            <td>
              <form method="post" action="${pageContext.request.contextPath}/admin/customers" class="d-inline">
                <input type="hidden" name="userId" value="${cust.userId}" />
                <input type="hidden" name="action" value="toggleStatus" />
                <button type="submit" class="btn btn-sm ${cust.status == 'ACTIVE' ? 'btn-danger' : 'btn-success'}">
                  ${cust.status == 'ACTIVE' ? 'Disable' : 'Enable'}
                </button>
              </form>
              <a href="${pageContext.request.contextPath}/admin/customers?editId=${cust.id}" 
                 class="btn btn-sm btn-warning ms-1">Edit</a>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>

  <!-- Edit Form -->
  <c:if test="${not empty editCustomer}">
    <div id="editFormContainer" class="card shadow-lg p-4 mb-5">
      <h3 class="mb-4">Edit Customer - <c:out value="${editCustomer.firstName}"/> <c:out value="${editCustomer.lastName}"/></h3>
      <form method="post" action="${pageContext.request.contextPath}/admin/customers">
        <input type="hidden" name="customerId" value="${editCustomer.id}" />
        <input type="hidden" name="userId" value="${editCustomer.userId}" />
        <input type="hidden" name="action" value="update" />

        <div class="row g-3">
          <div class="col-md-6">
            <label for="firstName" class="form-label">First Name</label>
            <input type="text" id="firstName" name="firstName" class="form-control" value="${editCustomer.firstName}" required />
          </div>
          <div class="col-md-6">
            <label for="lastName" class="form-label">Last Name</label>
            <input type="text" id="lastName" name="lastName" class="form-control" value="${editCustomer.lastName}" required />
          </div>
          <div class="col-md-6">
            <label for="email" class="form-label">Email</label>
            <input type="email" id="email" name="email" class="form-control" value="${editCustomer.email}" required />
          </div>
          <div class="col-md-6">
            <label for="phone" class="form-label">Phone</label>
            <input type="text" id="phone" name="phone" class="form-control" value="${editCustomer.phone}" required/>
          </div>
          <div class="col-md-6">
            <label for="dob" class="form-label">Date of Birth</label>
            <input type="date" id="dob" name="dob" class="form-control" value="${editCustomer.dob}" required />
          </div>
          <div class="col-md-6">
            <label for="city" class="form-label">City</label>
            <input type="text" id="city" name="city" class="form-control" value="${editCustomer.city}" required />
          </div>
          <div class="col-md-6">
            <label for="state" class="form-label">State</label>
            <input type="text" id="state" name="state" class="form-control" value="${editCustomer.state}" required />
          </div>
        </div>

        <div class="mt-4">
          <button type="submit" class="btn btn-primary">Save Changes</button>
          <a href="${pageContext.request.contextPath}/admin/customers" class="btn btn-secondary ms-2">Cancel</a>
        </div>
      </form>
    </div>
  </c:if>
</div>

<!-- Include jQuery, DataTables & Bootstrap 5 integration -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css"/>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<script>
  $(document).ready(function() {
    $('#customersTable').DataTable({
      "pageLength": 10,
      "lengthMenu": [5, 10, 25, 50, 100],
      "order": [[5, "desc"]],
      "language": {
        "search": "_INPUT_",
        "searchPlaceholder": "Search customers..."
      },
      "columnDefs": [
        { "orderable": false, "targets": 7 } // Disable sorting on Actions column
      ]
    });
  });
</script>

<!-- Additional Styles -->
<style>
  .table-hover tbody tr:hover {
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
    box-shadow: 0 5px 20px rgba(0,0,0,0.1);
    background: #fff;
  }
  #editFormContainer {
    border-radius: 12px;
    background: #fff;
    box-shadow: 0 8px 25px rgba(0,0,0,0.12);
    padding: 25px;
  }
  #editFormContainer h3 {
    font-weight: 600;
  }
</style>
