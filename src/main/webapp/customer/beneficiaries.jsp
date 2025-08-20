<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/components/header.jsp">
  <jsp:param name="pageTitle" value="Beneficiaries"/>
</jsp:include>
<jsp:include page="/components/navbar.jsp"/>

<!-- DataTables -->
<link href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" rel="stylesheet"/>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

<div class="container section-lg fade-in py-4">

  <jsp:include page="/components/alerts.jsp"/>

  <c:choose>
    <c:when test="${hasPendingAccount}">
      <div class="alert alert-warning shadow-sm">
        ⚠️ Account creation is pending approval. You cannot add beneficiaries until account activation.
      </div>
    </c:when>
    <c:otherwise>
      <div class="card shadow-lg border-0 rounded-4 p-4">
        <h4 class="mb-3 text-gradient fw-bold">
          <c:choose>
            <c:when test="${not empty beneficiaryToEdit}">
              <i class="bi bi-pencil-square me-2"></i> Update Beneficiary
            </c:when>
            <c:otherwise>
              <i class="bi bi-person-plus-fill me-2"></i> Add New Beneficiary
            </c:otherwise>
          </c:choose>
        </h4>

        <!-- Beneficiary Form -->
        <form method="post" action="${pageContext.request.contextPath}/customer/beneficiaries" novalidate>
          <c:if test="${not empty beneficiaryToEdit}">
            <input type="hidden" name="action" value="update"/>
            <input type="hidden" name="id" value="${beneficiaryToEdit.id}"/>
          </c:if>

          <!-- Name -->
          <div class="mb-3">
            <label for="name" class="form-label fw-semibold">
              <i class="bi bi-person me-2 text-primary"></i> Beneficiary Name
            </label>
            <input type="text" id="name" name="name" class="form-control stylish-input shadow-sm"
                   value="${beneficiaryToEdit.name != null ? beneficiaryToEdit.name : ''}" 
                   required minlength="2" placeholder="Enter full name"/>
          </div>

          <!-- Account Number -->
          <div class="mb-3">
            <label for="accountNumber" class="form-label fw-semibold">
              <i class="bi bi-credit-card me-2 text-success"></i> Account Number
            </label>
            <input type="text" id="accountNumber" name="accountNumber" 
                   class="form-control stylish-input shadow-sm" 
                   value="${beneficiaryToEdit.accountNumber != null ? beneficiaryToEdit.accountNumber : ''}"
                   pattern="[A-Za-z0-9]+" required placeholder="Enter account number"/>
          </div>

          <!-- Bank Name -->
          <div class="mb-3">
            <label for="bankName" class="form-label fw-semibold">
              <i class="bi bi-bank me-2 text-info"></i> Bank Name
            </label>
            <input type="text" id="bankName" name="bankName" 
                   class="form-control stylish-input shadow-sm" 
                   value="${beneficiaryToEdit.bankName != null ? beneficiaryToEdit.bankName : ''}" 
                   required minlength="2" placeholder="Enter bank name"/>
          </div>

          <!-- Buttons -->
          <div class="mt-4">
            <button type="submit" class="btn btn-gradient glow-btn px-4 me-2">
              <c:choose>
                <c:when test="${not empty beneficiaryToEdit}">
                  <i class="bi bi-check-circle me-1"></i> Update Beneficiary
                </c:when>
                <c:otherwise>
                  <i class="bi bi-plus-circle me-1"></i> Add Beneficiary
                </c:otherwise>
              </c:choose>
            </button>

            <c:if test="${not empty beneficiaryToEdit}">
              <a href="${pageContext.request.contextPath}/customer/beneficiaries" 
                 class="btn btn-outline-secondary px-4">
                <i class="bi bi-x-circle me-1"></i> Cancel
              </a>
            </c:if>
          </div>
        </form>
      </div>
    </c:otherwise>
  </c:choose>

  <!-- Beneficiary Table -->
  <hr class="my-5"/>

  <h3 class="mb-3 fw-bold text-gradient"><i class="bi bi-people-fill me-2"></i>Your Beneficiaries</h3>

  <c:if test="${empty beneficiaries}">
    <p class="text-muted">No beneficiaries found.</p>
  </c:if>

  <c:if test="${not empty beneficiaries}">
    <div class="card shadow-lg border-0 rounded-4 p-3">
      <table id="beneficiaryTable" class="table table-hover align-middle mb-0">
        <thead class="table-dark">
          <tr>
            <th>Name</th>
            <th>Account Number</th>
            <th>Bank Name</th>
            <th>Added At</th>
            <th class="text-center">Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="b" items="${beneficiaries}">
            <tr>
              <td><c:out value="${b.name}"/></td>
              <td><c:out value="${b.accountNumber}"/></td>
              <td><c:out value="${b.bankName}"/></td>
              <td><c:out value="${b.addedAt}"/></td>
              <td class="text-center">
                <a href="${pageContext.request.contextPath}/customer/beneficiaries?action=edit&id=${b.id}" 
                   class="btn btn-sm btn-warning me-1">
                   <i class="bi bi-pencil-square"></i> Edit
                </a>
                <form action="${pageContext.request.contextPath}/customer/beneficiaries" method="post" 
                      style="display:inline" 
                      onsubmit="return confirm('Are you sure you want to delete this beneficiary?');">
                  <input type="hidden" name="action" value="delete"/>
                  <input type="hidden" name="id" value="${b.id}"/>
                  <button type="submit" class="btn btn-sm btn-danger">
                    <i class="bi bi-trash"></i> Delete
                  </button>
                </form>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </c:if>
</div>

<!-- DataTable Init -->
<script>
  $(document).ready(function() {
    $('#beneficiaryTable').DataTable({
      paging: true,
      searching: true,
      info: true,
      order: [[0, 'asc']]
    });
  });
</script>

<jsp:include page="/components/footer.jsp"/>

<!-- Page Styles -->
<style>
  .text-gradient {
    background: linear-gradient(90deg, #141E30, #243B55);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }
  .btn-gradient {
    background: linear-gradient(90deg, #141E30, #243B55);
    border: none;
    color: #fff !important;
    transition: all 0.3s ease;
    border-radius: 10px;
  }
  .btn-gradient:hover {
    background: linear-gradient(90deg, #243B55, #141E30);
    transform: translateY(-2px);
    box-shadow: 0 6px 15px rgba(20, 30, 48, 0.4);
  }
  .stylish-input {
    border-radius: 10px;
    transition: all 0.3s ease;
  }
  .stylish-input:focus {
    border-color: #243B55;
    box-shadow: 0 0 8px rgba(20, 30, 48, 0.3);
  }
  .fade-in {
    animation: fadeInUp 0.8s ease-in-out;
  }
  @keyframes fadeInUp {
    from { opacity: 0; transform: translateY(30px); }
    to   { opacity: 1; transform: translateY(0); }
  }
</style>
