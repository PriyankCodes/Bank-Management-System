<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Support Ticket - BankApp</title>

  <!-- Bootstrap 5.3 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />

  <style>
    body {
      background-color: #f8f9fa;
      color: #000;
      font-family: 'Inter', sans-serif;
    }

    /* Simple Black Heading */
    .page-title {
      color: #000;
      font-weight: 700;
    }

    /* Card */
    .card {
      border-radius: 12px;
      border: 1px solid #dee2e6;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
    }

    /* Form Inputs */
    .form-control, .form-select {
      border-radius: 8px;
    }

    .form-control:focus, .form-select:focus {
      border-color: #000;
      box-shadow: 0 0 0 0.2rem rgba(0, 0, 0, 0.1);
    }

    /* Button */
    .btn-primary {
      background-color: #000;
      border: none;
      padding: 0.5rem 1.5rem;
      border-radius: 8px;
      font-weight: 500;
    }

    .btn-primary:hover {
      background-color: #111;
    }

    /* Table Header */
    .table thead th {
      background-color: #f1f1f1;
      color: #000;
      font-weight: 600;
      border-bottom: 2px solid #dee2e6;
    }

    /* Badge Colors */
    .badge {
      border-radius: 6px;
      padding: 0.5em 0.8em;
      font-size: 0.85rem;
      font-weight: 500;
    }

  /* Status Colors */
.status-open       { background: #ffc107; color: #212529; }   /* bright yellow */
.status-in-progress { background: #0dcaf0; color: #fff; }     /* cyan/sky-blue */
.status-resolved    { background: #28a745; color: #fff; }     /* strong green */
.status-closed      { background: #6c757d; color: #fff; }     /* neutral gray */

/* Priority Colors */
.priority-low    { background: #6c757d; color: #fff; }        /* muted gray */
.priority-medium { background: #0d6efd; color: #fff; }        /* blue */
.priority-high   { background: #dc3545; color: #fff; }        /* red */


    /* Centered Empty State */
    .empty-state {
      text-align: center;
      padding: 2rem 0;
      color: #6c757d;
    }

    /* Responsive */
    @media (max-width: 576px) {
      .btn {
        width: 100%;
      }
      .table-responsive {
        font-size: 0.9rem;
      }
    }
  </style>
</head>
<body>

<jsp:include page="/components/header.jsp">
    <jsp:param name="pageTitle" value="Support Ticket"/>
</jsp:include>
<jsp:include page="/components/navbar.jsp"/>

<div class="container py-5">
  <!-- Flash Messages -->
  <c:if test="${not empty sessionScope.flash_success}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
      ${sessionScope.flash_success}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <c:remove var="flash_success" scope="session"/>
  </c:if>

  <c:if test="${not empty sessionScope.flash_error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
      ${sessionScope.flash_error}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <c:remove var="flash_error" scope="session"/>
  </c:if>

  <!-- Page Title -->
  <h3 class="mb-4 page-title">
    <i class="bi bi-life-preserver me-2"></i> Submit a Support Ticket
  </h3>

  <!-- Ticket Form -->
  <div class="card mb-5">
    <div class="card-body">
      <form method="post" action="${pageContext.request.contextPath}/customer/support-ticket" novalidate>
        <div class="mb-3">
          <label for="subject" class="form-label">Subject</label>
          <select id="subject" name="subject" class="form-select" required>
            <option value="" disabled selected>-- Select Subject --</option>
            <option value="Account Issue">Account Issue</option>
            <option value="Transaction Problem">Transaction Problem</option>
            <option value="Technical Support">Technical Support</option>
            <option value="Other">Other</option>
          </select>
        </div>

        <div class="mb-3">
          <label for="description" class="form-label">Description</label>
          <textarea id="description" name="description" rows="5" class="form-control"
                    placeholder="Describe your issue" required></textarea>
        </div>

        <button type="submit" class="btn btn-primary">
          <i class="bi bi-send me-1"></i> Submit Ticket
        </button>
      </form>
    </div>
  </div>

  <!-- Your Tickets -->
  <h4 class="mb-4 page-title">
    <i class="bi bi-card-list me-2"></i> Your Support Tickets
  </h4>

  <c:choose>
    <c:when test="${empty tickets}">
      <div class="empty-state">
        <i class="bi bi-ticket-detailed" style="font-size: 2rem;"></i>
        <p class="mt-2">You have no support tickets.</p>
      </div>
    </c:when>
    <c:otherwise>
      <div class="table-responsive">
        <table class="table table-bordered table-hover align-middle">
          <thead>
            <tr>
              <th>Subject</th>
              <th>Description</th>
              <th>Status</th>
              <th>Priority</th>
              <th>Created At</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="ticket" items="${tickets}">
              <tr>
                <td>${ticket.subject}</td>
                <td style="max-width: 250px;">
                  <div class="text-truncate" title="${ticket.description}">
                    ${ticket.description}
                  </div>
                </td>
                <td>
                  <span class="badge status-${ticket.status.toLowerCase().replace(' ', '-')}">
                    ${ticket.status}
                  </span>
                </td>
                <td>
                  <span class="badge priority-${ticket.priority.toLowerCase()}">
                    ${ticket.priority}
                  </span>
                </td>
                <td><fmt:formatDate value="${ticket.createdAt}" pattern="dd-MMM-yyyy HH:mm"/></td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </c:otherwise>
  </c:choose>
</div>

<jsp:include page="/components/footer.jsp"/>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>