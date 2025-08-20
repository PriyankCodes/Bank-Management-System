<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/admin/components/header.jsp">
  <jsp:param name="pageTitle" value="Fixed Deposits Management"/>
</jsp:include>

<jsp:include page="/admin/components/navbar.jsp"/>

<h2>Fixed Deposits Management</h2>

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

<!-- Global interest rate update (applies to all FDs) -->
<div class="card mb-4">
  <div class="card-body">
    <form method="post" action="${pageContext.request.contextPath}/admin/fixed_deposits" class="row g-2 align-items-end">
      <input type="hidden" name="action" value="updateInterestRate"/>
      <div class="col-auto">
        <label for="newRate" class="form-label mb-0">Update Global Interest Rate (%)</label>
        <input type="number" id="newRate" name="newRate" step="0.01" min="0" class="form-control" placeholder="e.g., 6.50" required/>
      </div>
      <div class="col-auto">
        <button type="submit" class="btn btn-primary">Update All FD Rates</button>
      </div>
      <div class="col-12">
        <small class="text-muted">This updates rate_percent for all existing fixed deposits.</small>
      </div>
    </form>
  </div>
</div>

<!-- Fixed Deposits table -->
<div class="table-responsive">
  <table class="table table-bordered table-striped align-middle">
    <thead class="table-light">
      <tr>
        <th>FD ID</th>
        <th>FD Number</th>
        <th>Customer</th>
        <th>Principal</th>
        <th>Tenure (months)</th>
        <th>Start Date</th>
        <th>Maturity Date</th>
        <th>Interest Rate (%)</th>
        <th>Status</th>
        <th style="width: 220px;">Actions</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="fd" items="${fixedDeposits}">
        <tr>
          <td><c:out value="${fd.id}"/></td>

          <!-- FD number shown if your model has it; otherwise leave blank -->
          <td>
            <c:choose>
              <c:when test="${not empty fd.fdNumber}">
                <c:out value="${fd.fdNumber}"/>
              </c:when>
              <c:otherwise>-</c:otherwise>
            </c:choose>
          </td>

          <td><c:out value="${fd.customerName}"/></td>
          <td><c:out value="${fd.principal}"/></td>
          <td><c:out value="${fd.tenureMonths}"/></td>

          <!-- startDate is String in your model; print as-is -->
          <td><c:out value="${fd.startDate}"/></td>

          <!-- maturityDate is Timestamp; format to yyyy-MM-dd -->
          <td>
            <c:choose>
              <c:when test="${not empty fd.maturityDate}">
                <fmt:formatDate value="${fd.maturityDate}" pattern="yyyy-MM-dd"/>
              </c:when>
              <c:otherwise>-</c:otherwise>
            </c:choose>
          </td>

          <td><c:out value="${fd.interestRate}"/></td>

          <td>
            <span class="badge ${fd.status == 'ACTIVE' ? 'bg-success' : (fd.status == 'CLOSED' ? 'bg-secondary' : 'bg-warning text-dark')}">
              <c:out value="${fd.status}"/>
            </span>
          </td>

          <td>
            <form method="post" action="${pageContext.request.contextPath}/admin/fixed_deposits" class="d-inline-flex gap-2">
              <input type="hidden" name="action" value="updateStatus"/>
              <input type="hidden" name="fdId" value="${fd.id}"/>

              <select name="newStatus" class="form-select form-select-sm w-auto">
                <option value="ACTIVE" ${fd.status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                <option value="CLOSED" ${fd.status == 'CLOSED' ? 'selected' : ''}>Closed</option>
                <option value="PREMATURED" ${fd.status == 'PREMATURED' ? 'selected' : ''}>Prematured</option>
              </select>

              <button type="submit" class="btn btn-sm btn-primary">Update</button>
            </form>
          </td>
        </tr>
      </c:forEach>

      <c:if test="${empty fixedDeposits}">
        <tr>
          <td colspan="10" class="text-center text-muted">No Fixed Deposits found.</td>
        </tr>
      </c:if>
    </tbody>
  </table>
</div>

<jsp:include page="/admin/components/footer.jsp"/>
