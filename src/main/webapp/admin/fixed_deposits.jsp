<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/admin/components/header.jsp">
  <jsp:param name="pageTitle" value="Fixed Deposits Management"/>
</jsp:include>

<jsp:include page="/admin/components/navbar.jsp"/>

<div class="container mt-5">
    <h2 class="mb-4 text-center fw-bold">Fixed Deposits Management</h2>

    <!-- Flash Messages -->
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

    <!-- Global interest rate update -->
    <div class="card mb-4 shadow-sm">
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

    <!-- Fixed Deposits Table -->
    <div class="table-responsive shadow-lg rounded bg-white p-3">
        <table id="fdTable" class="table table-striped table-hover table-bordered align-middle text-center" style="width:100%; table-layout:auto;">
            <thead class="table-dark">
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
                    <th style="min-width: 220px;">Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="fd" items="${fixedDeposits}">
                    <tr>
                        <td><c:out value="${fd.id}"/></td>
                        <td><c:out value="${fd.fdNumber != null ? fd.fdNumber : '-'}"/></td>
                        <td><c:out value="${fd.customerName}"/></td>
                        <td><c:out value="${fd.principal}"/></td>
                        <td><c:out value="${fd.tenureMonths}"/></td>
                        <td><c:out value="${fd.startDate}"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty fd.maturityDate}">
                                    <fmt:formatDate value="${fd.maturityDate}" pattern="dd-MM-yyyy"/>
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
                        <td style="white-space: nowrap;">
                            <form method="post" action="${pageContext.request.contextPath}/admin/fixed_deposits" class="d-flex gap-2 justify-content-center align-items-center">
                                <input type="hidden" name="action" value="updateStatus"/>
                                <input type="hidden" name="fdId" value="${fd.id}"/>
                                <select name="newStatus" class="form-select form-select-sm" style="min-width: 100px;">
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
</div>

<!-- DataTables JS & CSS -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css"/>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<script>
$(document).ready(function() {
    $('#fdTable').DataTable({
        "pageLength": 10,
        "lengthMenu": [5, 10, 25, 50, 100],
        "order": [[0, "desc"]],
        "columnDefs": [
            { "orderable": false, "targets": 9 } // Actions column not sortable
        ],
        "language": {
            "search": "_INPUT_",
            "searchPlaceholder": "Search FDs..."
        }
    });
});
</script>

<!-- Additional Styles -->
<style>
.table-hover tbody tr:hover {
    background-color: rgba(0,123,255,0.08);
    transition: background-color 0.3s;
}
.badge {
    padding: 0.5em 0.8em;
    font-size: 0.85rem;
    border-radius: 50px;
    font-weight: 500;
}
</style>

<jsp:include page="/admin/components/footer.jsp"/>
