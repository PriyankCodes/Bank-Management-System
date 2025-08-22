<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/components/header.jsp">
  <jsp:param name="pageTitle" value="Transfers"/>
</jsp:include>
<jsp:include page="/components/navbar.jsp"/>

<style>
  /* Card Styling */
  .card-custom {
    border: 1px solid #e0e0e0;
    border-radius: 12px;
    background: #ffffff;
    transition: transform 0.2s ease-in-out, box-shadow 0.2s;
  }
  .card-custom:hover {
    transform: translateY(-4px);
    box-shadow: 0 6px 18px rgba(0,0,0,0.1);
  }

  /* Form Labels */
  .form-label {
    font-weight: 600;
    color: #495057;
  }

  /* Table Styling */
  .table thead {
    background: linear-gradient(90deg, #f8f9fa, #e9ecef);
  }
  .table thead th {
    font-weight: 600;
    color: #333;
    text-transform: uppercase;
    font-size: 0.85rem;
  }
  .table-hover tbody tr:hover {
    background-color: #f1f5f9;
    transition: 0.2s;
  }
  .table td, .table th {
    vertical-align: middle;
  }

  /* Badge Colors */
  .badge-success {
    background-color: #28a745 !important;
  }
  .badge-warning {
    background-color: #ffc107 !important;
    color: #000 !important;
  }
  .badge-danger {
    background-color: #dc3545 !important;
  }
</style>

<div class="container section-lg fade-in">
  <jsp:include page="/components/alerts.jsp"/>

  <!-- New Transfer Card -->
  <div class="card card-custom shadow-sm mb-4">
    <div class="card-body">
      <h5 class="card-title mb-3 text-primary">💸 New Transfer</h5>

      <form method="post" action="${pageContext.request.contextPath}/customer/transfers" class="row g-3 needs-validation" novalidate>
        <div class="col-md-4">
          <label class="form-label">From Account</label>
          <select name="fromAccountId" class="form-select" required>
            <c:forEach var="acc" items="${accounts}">
              <option value="${acc.id}">${acc.accountNumber} - ${acc.type}</option>
            </c:forEach>
          </select>
        </div>
<div class="col-md-4">
  <label class="form-label">Beneficiary</label>
  <select id="beneficiarySelect" name="beneficiaryId" class="form-select mb-2">
    <option value="">-- Select from Beneficiaries --</option>
    <c:forEach var="b" items="${beneficiaries}">
      <option value="${b.id}">${b.name} - ${b.accountNumber}</option>
    </c:forEach>
  </select>

  <div class="text-center fw-bold my-2">OR</div>

  <input type="text" id="beneficiaryAccountInput" 
         name="beneficiaryAccountNumber" 
         class="form-control" 
         placeholder="Enter account number directly"/>
</div>

        <div class="col-md-4">
          <label class="form-label">Amount</label>
          <input type="number" step="0.01" min="1" name="amount" class="form-control" placeholder="Enter amount" required/>
        </div>

        <div class="col-12 mt-3">
          <button class="btn btn-primary px-4" type="submit">
            <i class="bi bi-send-fill"></i> Transfer
          </button>
        </div>
      </form>
    </div>
  </div>

  <!-- Recent Transfers Card -->
  <div class="card card-custom shadow-sm">
    <div class="card-body">
      <h5 class="card-title mb-3 text-primary">📑 Recent Transfers</h5>

      <div class="table-responsive">
        <table class="table table-striped table-hover align-middle">
          <thead>
            <tr>
              <th>Date</th>
              <th>From Account</th>
              <th>Beneficiary</th>
              <th class="text-end">Amount (₹)</th>
              <th>Status</th>
              <th>Reference No</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="t" items="${transfers}">
              <tr>
                <td><c:out value="${t.createdAt}"/></td>
                <td><c:out value="${t.fromAccountNumber}"/></td>
                <td><c:out value="${t.beneficiaryName}"/></td>
                <td class="text-end fw-semibold">₹ <c:out value="${t.amount}"/></td>
                <td>
                  <span class="badge 
                    <c:choose>
                      <c:when test="${t.status == 'SUCCESS'}">badge-success</c:when>
                      <c:when test="${t.status == 'PROCESSING'}">badge-warning</c:when>
                      <c:otherwise>badge-danger</c:otherwise>
                    </c:choose>">
                    <c:out value="${t.status}"/>
                  </span>
                </td>
                <td class="fw-light"><c:out value="${t.referenceNo}"/></td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>

      <c:if test="${empty transfers}">
        <p class="text-muted fst-italic">No transfers yet.</p>
      </c:if>
    </div>
  </div>
</div>

<script>
  const beneficiarySelect = document.getElementById("beneficiarySelect");
  const beneficiaryAccountInput = document.getElementById("beneficiaryAccountInput");

  // When dropdown is changed, clear input
  beneficiarySelect.addEventListener("change", () => {
    if (beneficiarySelect.value) {
      beneficiaryAccountInput.value = "";
    }
  });

  // When input is typed, reset dropdown
  beneficiaryAccountInput.addEventListener("input", () => {
    if (beneficiaryAccountInput.value.trim() !== "") {
      beneficiarySelect.value = "";
    }
  });
</script>

<jsp:include page="/components/footer.jsp"/>
