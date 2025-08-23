<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Fixed Deposits - BankApp</title>

  <!-- Favicon -->
  <link rel="icon" href="https://img.icons8.com/fluency/48/000000/savings.png" type="image/png" />

  <!-- Google Fonts: Inter -->
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />

  <!-- Bootstrap 5.3 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />

  <!-- DataTables with Bootstrap 5 Theme -->
  <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet" />

  <style>
    body {
      font-family: 'Inter', sans-serif;
      background-color: #f8f9fa;
      color: #333;
    }

    /* Form Card */
    .form-card {
      background: #ffffff;
      border: 1px solid #e0e0e0;
      border-radius: 16px;
      box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
      transition: all 0.3s ease;
      overflow: hidden;
    }

    .form-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.12);
    }

    .form-card-header {
      background: linear-gradient(135deg, #f0f4ff, #e0e8f5);
      padding: 1rem 1.5rem;
      border-bottom: 1px solid #d0d8e5;
    }

    .form-card-body {
      padding: 1.5rem;
    }

    /* Table Styling */
    .table thead th {
      background: linear-gradient(135deg, #f1f5f9, #e6ecf3);
      font-weight: 600;
      color: #333;
      text-transform: uppercase;
      font-size: 0.85rem;
      border-bottom: 2px solid #dee2e6;
    }

    .table-hover tbody tr:hover {
      background-color: #f8fbff !important;
      transition: background 0.2s ease;
    }

    /* Status Badge Colors */
    .badge-status {
      font-weight: 500;
      padding: 0.5em 0.8em;
      border-radius: 6px;
      font-size: 0.85rem;
    }

    .badge-active {
      background-color: #28a745;
      color: white;
    }

    .badge-pending {
      background-color: #ffc107;
      color: #000;
    }

    .badge-closed {
      background-color: #6c757b;
      color: white;
    }

    /* Button */
    .btn-primary {
      background: linear-gradient(135deg, #2563eb, #3b82f6);
      border: none;
      font-weight: 600;
      padding: 0.5rem 1.5rem;
      border-radius: 8px;
      transition: all 0.3s ease;
    }

    .btn-primary:hover {
      background: linear-gradient(135deg, #1d4ed8, #2563eb);
      transform: translateY(-2px);
      box-shadow: 0 6px 15px rgba(37, 99, 235, 0.3);
    }

    /* Responsive */
    @media (max-width: 768px) {
      .container {
        padding-left: 1rem;
        padding-right: 1rem;
      }
      .form-card-body, .form-card-header {
        padding: 1rem;
      }
      .table th, .table td {
        font-size: 0.9rem;
        padding: 0.5rem;
      }
    }
  </style>
</head>
<body>

<jsp:include page="/components/header.jsp">
    <jsp:param name="pageTitle" value="Fixed Deposits"/>
</jsp:include>
<jsp:include page="/components/navbar.jsp"/>

<div class="container py-5">
    <jsp:include page="/components/alerts.jsp" />

    <!-- Apply for FD Form -->
    <div class="card form-card shadow-sm mb-5">
        <div class="form-card-header">
            <h4 class="mb-0">
                <i class="bi bi-piggy-bank-fill me-2 text-primary"></i> Open New Fixed Deposit
            </h4>
        </div>
        <div class="form-card-body">
            <form method="post" action="${pageContext.request.contextPath}/customer/fixed_deposit" novalidate>
                <div class="mb-3">
                    <label for="principal" class="form-label">Principal Amount (₹)</label>
                    <input type="number" min="1000" step="0.01" id="principal" name="principal"
                           class="form-control" placeholder="Enter amount" required />
                    <div class="form-text text-muted">Minimum ₹1,000 required.</div>
                </div>

                <div class="mb-3">
                    <label for="tenureMonths" class="form-label">Tenure (Months)</label>
                    <input type="number" min="1" id="tenureMonths" name="tenureMonths"
                           class="form-control" placeholder="e.g. 12" required />
                </div>

                <div class="mb-3">
                    <label for="accountId" class="form-label">Source Account</label>
                    <select id="accountId" name="accountId" class="form-select" required>
                        <option value="" disabled selected>Select Account</option>
                        <c:forEach var="acc" items="${accounts}">
                            <option value="${acc.id}">
                                ${acc.accountNumber} (${acc.type}) — ₹${acc.balance}
                            </option>
                        </c:forEach>
                    </select>
                    <div class="form-text text-muted">Funds will be debited from this account.</div>
                </div>

                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-check-circle me-2"></i> Apply for FD
                </button>
            </form>
        </div>
    </div>

    <!-- Your Fixed Deposits -->
    <h3 class="mb-4 fw-bold text-black">
        <i class="bi bi-journal-text me-2"></i> Your Fixed Deposits
    </h3>

    <c:if test="${empty fixedDeposits}">
        <div class="text-center py-5">
            <i class="bi bi-piggy-bank text-muted" style="font-size: 3rem;"></i>
            <p class="text-muted mt-3">You have no fixed deposits yet.</p>
        </div>
    </c:if>

    <c:if test="${not empty fixedDeposits}">
        <div class="card shadow-sm border-0 rounded-4 overflow-hidden">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table id="fixedDepositsTable" class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Principal (₹)</th>
                                <th>Tenure</th>
                                <th>Status</th>
                                <th>Start Date</th>
                                <th>Maturity Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="fd" items="${fixedDeposits}">
                                <tr>
                                    <td><c:out value="${fd.id}" /></td>
                                    <td><c:out value="${fd.principal}" /></td>
                                    <td><c:out value="${fd.tenureMonths}" /> months</td>
                                    <td>
                                        <span class="badge-status
                                            <c:choose>
                                                <c:when test="${fd.status == 'ACTIVE'}">badge-active</c:when>
                                                <c:when test="${fd.status == 'PENDING'}">badge-pending</c:when>
                                                <c:when test="${fd.status == 'CLOSED'}">badge-closed</c:when>
                                                <c:otherwise>badge-secondary</c:otherwise>
                                            </c:choose>">
                                            <c:out value="${fd.status}" />
                                        </span>
                                    </td>
                                    <td><c:out value="${fd.startDate}" /></td>
                                    <td><c:out value="${fd.maturityDate}" /></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </c:if>
</div>

<jsp:include page="/components/footer.jsp"/>

<!-- jQuery + DataTables JS -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<!-- Initialize DataTable -->
<script>
  $(document).ready(function () {
    $('#fixedDepositsTable').DataTable({
      paging: true,
      searching: true,
      info: true,
      ordering: true,
      order: [[0, 'desc']], // Sort by ID (or use [4, 'desc'] for Start Date)
      language: {
        search: "Search:",
        lengthMenu: "Show _MENU_ entries",
        emptyTable: "No fixed deposits found."
      },
      responsive: true
    });
  });
</script>

</body>
</html>