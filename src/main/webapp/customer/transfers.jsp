<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Transfers - BankApp</title>

  <!-- Favicon -->
  <link rel="icon" href="https://img.icons8.com/fluency/48/000000/money-transfer.png" type="image/png" />
  <link rel="apple-touch-icon" href="https://img.icons8.com/fluency/180/000000/money-transfer.png" />

  <!-- Google Fonts: Inter -->
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />

  <!-- Bootstrap 5.3 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />

  <style>
    body {
      font-family: 'Inter', sans-serif;
      background-color: #f8f9fa;
      color: #333;
    }

    /* === Card Styling === */
    .card-custom {
      border: 1px solid #e0e0e0;
      border-radius: 16px;
      background: #ffffff;
      transition: all 0.3s ease;
      overflow: hidden;
    }

    .card-custom:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 25px rgba(0, 0, 0, 0.12);
    }

    .card-body {
      padding: 1.5rem;
    }

    /* Header Icon */
    .card-title i {
      color: #007bff;
      margin-right: 8px;
    }

    /* Form Labels */
    .form-label {
      font-weight: 600;
      color: #495057;
    }

    /* Table Styling */
    .table thead th {
      background: linear-gradient(90deg, #f1f3f5, #e9ecef);
      font-weight: 600;
      color: #333;
      text-transform: uppercase;
      font-size: 0.85rem;
      border-bottom: 2px solid #dee2e6;
    }

    .table-hover tbody tr:hover {
      background-color: #f1f5f9 !important;
      transition: background 0.2s ease;
    }

    .table td, .table th {
      vertical-align: middle;
      padding: 0.75rem 1rem;
    }

    /* Badge Styling */
    .badge {
      font-weight: 500;
      padding: 0.5em 0.8em;
      border-radius: 6px;
    }

    .badge-success {
      background-color: #28a745;
      color: white;
    }

    .badge-warning {
      background-color: #ffc107;
      color: #000;
    }

    .badge-danger {
      background-color: #dc3545;
      color: white;
    }

    /* Button */
    .btn-primary {
      background: #007bff;
      border: none;
      font-weight: 600;
      padding: 0.4rem 1.5rem;
      border-radius: 8px;
    }

    .btn-primary:hover {
      background: #0069d9;
      transform: translateY(-2px);
      box-shadow: 0 4px 10px rgba(0, 123, 255, 0.2);
    }

    /* OR Divider */
    .or-divider {
      display: flex;
      align-items: center;
      text-align: center;
      margin: 0.5rem 0;
      color: #6c757d;
      font-size: 0.9rem;
    }

    .or-divider::before,
    .or-divider::after {
      content: '';
      flex: 1;
      border-bottom: 1px dashed #ccc;
    }

    .or-divider span {
      padding: 0 0.5rem;
      background: #fff;
    }

    /* Responsive */
    @media (max-width: 768px) {
      .table-responsive {
        font-size: 0.9rem;
      }
      .card-body {
        padding: 1rem;
      }
      .btn-primary {
        width: 100%;
      }
    }
  </style>
</head>
<body>

<jsp:include page="/components/header.jsp">
  <jsp:param name="pageTitle" value="Transfers"/>
</jsp:include>
<jsp:include page="/components/navbar.jsp"/>

<div class="container py-5">
  <jsp:include page="/components/alerts.jsp"/>

  <!-- New Transfer Card -->
  <div class="card card-custom shadow-sm mb-4">
    <div class="card-body">
      <h5 class="card-title mb-4">
        <i class="bi bi-send-fill"></i> Make a New Transfer
      </h5>

      <form method="post" action="${pageContext.request.contextPath}/customer/transfers" class="row g-4" novalidate>
        <!-- From Account -->
        <div class="col-md-4">
          <label for="fromAccountId" class="form-label">From Account</label>
          <select name="fromAccountId" id="fromAccountId" class="form-select" required>
            <option value="" disabled selected>Select account</option>
            <c:forEach var="acc" items="${accounts}">
              <option value="${acc.id}">${acc.accountNumber} (${acc.type})</option>
            </c:forEach>
          </select>
        </div>

        <!-- Beneficiary Dropdown or Manual Input -->
        <div class="col-md-4">
          <label class="form-label">Beneficiary</label>
          <select id="beneficiarySelect" name="beneficiaryId" class="form-select mb-2">
            <option value="">-- Select Beneficiary --</option>
            <c:forEach var="b" items="${beneficiaries}">
              <option value="${b.id}">${b.name} - ${b.accountNumber}</option>
            </c:forEach>
          </select>

          <div class="or-divider"><span>OR</span></div>

          <input type="text" id="beneficiaryAccountInput" 
                 name="beneficiaryAccountNumber" 
                 class="form-control" 
                 placeholder="Enter account number" />
        </div>

        <!-- Amount -->
        <div class="col-md-4">
          <label for="amount" class="form-label">Amount (₹)</label>
          <input type="number" step="0.01" min="1" name="amount" id="amount"
                 class="form-control" placeholder="Enter amount" required />
        </div>

        <!-- Submit Button -->
        <div class="col-12 mt-3">
          <button class="btn btn-primary" type="submit">
            <i class="bi bi-send-fill me-2"></i> Initiate Transfer
          </button>
        </div>
      </form>
    </div>
  </div>

  <!-- Recent Transfers Card -->
  <div class="card card-custom shadow-sm">
    <div class="card-body">
      <h5 class="card-title mb-4">
        <i class="bi bi-clock-history"></i> Recent Transfers
      </h5>

      <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
          <thead>
            <tr>
              <th>Date & Time</th>
              <th>From</th>
              <th>To</th>
              <th class="text-end">Amount</th>
              <th>Status</th>
              <th>Ref No.</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="t" items="${transfers}">
              <tr>
                <td><c:out value="${t.createdAt}" /></td>
                <td><c:out value="${t.fromAccountNumber}" /></td>
                <td><c:out value="${t.beneficiaryDisplay}" /></td>
                <td class="text-end fw-semibold">₹ <c:out value="${t.amount}" /></td>
                <td>
                  <span class="badge
                    <c:choose>
                      <c:when test="${t.status == 'SUCCESS'}">badge-success</c:when>
                      <c:when test="${t.status == 'PROCESSING'}">badge-warning</c:when>
                      <c:otherwise>badge-danger</c:otherwise>
                    </c:choose>">
                    ${t.status}
                  </span>
                </td>
                <td class="text-muted"><c:out value="${t.referenceNo}" /></td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>

      <c:if test="${empty transfers}">
        <div class="text-center py-4">
          <i class="bi bi-inbox text-muted" style="font-size: 2rem;"></i>
          <p class="text-muted mt-2 fst-italic mb-0">No transfers yet.</p>
        </div>
      </c:if>
    </div>
  </div>
</div>

<jsp:include page="/components/footer.jsp"/>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- Beneficiary Toggle Script -->
<script>
  const beneficiarySelect = document.getElementById("beneficiarySelect");
  const beneficiaryAccountInput = document.getElementById("beneficiaryAccountInput");

  // If dropdown selected, clear input
  beneficiarySelect.addEventListener("change", () => {
    if (beneficiarySelect.value) {
      beneficiaryAccountInput.value = "";
    }
  });

  // If input typed, clear dropdown
  beneficiaryAccountInput.addEventListener("input", () => {
    if (beneficiaryAccountInput.value.trim() !== "") {
      beneficiarySelect.value = "";
    }
  });
</script>

</body>
</html>