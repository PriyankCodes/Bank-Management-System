<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/components/header.jsp">
  <jsp:param name="pageTitle" value="Beneficiaries"/>
</jsp:include>
<jsp:include page="/components/navbar.jsp"/>

<link href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" rel="stylesheet"/>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

<div class="container section-lg">

  <jsp:include page="/components/alerts.jsp"/>

  <c:choose>
    <c:when test="${hasPendingAccount}">
      <div class="alert alert-warning">
        Account creation is pending approval. You cannot add beneficiaries until account activation.
      </div>
    </c:when>
    <c:otherwise>
      <div class="card shadow-sm p-4 mt-4">
        <h5>
          <c:choose>
            <c:when test="${not empty beneficiaryToEdit}">Update Beneficiary</c:when>
            <c:otherwise>Add New Beneficiary</c:otherwise>
          </c:choose>
        </h5>

        <form method="post" action="${pageContext.request.contextPath}/customer/beneficiaries" novalidate>
          <c:if test="${not empty beneficiaryToEdit}">
            <input type="hidden" name="action" value="update"/>
            <input type="hidden" name="id" value="${beneficiaryToEdit.id}"/>
          </c:if>
          
          <div class="mb-3">
            <label for="name" class="form-label">Beneficiary Name</label>
            <input type="text" id="name" name="name" class="form-control" required minlength="2"
                   value="${beneficiaryToEdit.name != null ? beneficiaryToEdit.name : ''}"/>
          </div>

          <div class="mb-3">
            <label for="accountNumber" class="form-label">Account Number</label>
            <input type="text" id="accountNumber" name="accountNumber" class="form-control" pattern="[A-Za-z0-9]+" required
                   value="${beneficiaryToEdit.accountNumber != null ? beneficiaryToEdit.accountNumber : ''}"/>
          </div>

          <div class="mb-3">
            <label for="bankName" class="form-label">Bank Name</label>
            <input type="text" id="bankName" name="bankName" class="form-control" required minlength="2"
                   value="${beneficiaryToEdit.bankName != null ? beneficiaryToEdit.bankName : ''}"/>
          </div>

          <button type="submit" class="btn btn-primary">
            <c:choose>
              <c:when test="${not empty beneficiaryToEdit}">Update Beneficiary</c:when>
              <c:otherwise>Add Beneficiary</c:otherwise>
            </c:choose>
          </button>

          <c:if test="${not empty beneficiaryToEdit}">
            <a href="${pageContext.request.contextPath}/customer/beneficiaries" class="btn btn-secondary ms-2">Cancel</a>
          </c:if>
        </form>
      </div>
    </c:otherwise>
  </c:choose>

  <hr/>

  <h3>Your Beneficiaries</h3>

  <c:if test="${empty beneficiaries}">
    <p>No beneficiaries found.</p>
  </c:if>

  <c:if test="${not empty beneficiaries}">
    <table id="beneficiaryTable" class="table table-striped table-hover" style="width:100%">
      <thead>
        <tr>
          <th>Name</th>
          <th>Account Number</th>
          <th>Bank Name</th>
          <th>Added At</th>
          <th>Actions</th>  <!-- New column -->
        </tr>
      </thead>
      <tbody>
        <c:forEach var="b" items="${beneficiaries}">
          <tr>
            <td><c:out value="${b.name}"/></td>
            <td><c:out value="${b.accountNumber}"/></td>
            <td><c:out value="${b.bankName}"/></td>
            <td><c:out value="${b.addedAt}"/></td>
            <td>
              <a href="${pageContext.request.contextPath}/customer/beneficiaries?action=edit&id=${b.id}" class="btn btn-sm btn-warning">Update</a>
              <form action="${pageContext.request.contextPath}/customer/beneficiaries" method="post" style="display:inline" 
                    onsubmit="return confirm('Are you sure you want to delete this beneficiary?');">
                <input type="hidden" name="action" value="delete"/>
                <input type="hidden" name="id" value="${b.id}"/>
                <button type="submit" class="btn btn-sm btn-danger">Delete</button>
              </form>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </c:if>

</div>

<script>
  $(document).ready(function() {
    $('#beneficiaryTable').DataTable({
      paging: true,
      searching: true,
      info: true
    });
  });
</script>

<jsp:include page="/components/footer.jsp"/>
