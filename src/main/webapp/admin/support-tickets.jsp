<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/admin/components/header.jsp">
    <jsp:param name="pageTitle" value="Support Tickets"/>
</jsp:include>
<jsp:include page="/admin/components/navbar.jsp"/>

<!-- DataTables CSS -->
<link rel="stylesheet" 
      href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css"/>

<div class="container section-lg fade-in">

    <h3 class="mb-4 text-gradient fw-bold">
        <i class="bi bi-headset me-2"></i> Manage Support Tickets
    </h3>

    <!-- Flash messages -->
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

    <!-- Filters -->
    <form method="get" action="${pageContext.request.contextPath}/admin/support-tickets" class="mb-4 row g-3 align-items-end">
        <div class="col-md-3">
            <label for="filterPriority" class="form-label">Filter by Priority:</label>
            <select id="filterPriority" name="priority" class="form-select">
                <option value="">All</option>
                <option value="LOW" ${param.priority == 'LOW' ? 'selected' : ''}>LOW</option>
                <option value="MEDIUM" ${param.priority == 'MEDIUM' ? 'selected' : ''}>MEDIUM</option>
                <option value="HIGH" ${param.priority == 'HIGH' ? 'selected' : ''}>HIGH</option>
            </select>
        </div>

        <div class="col-auto">
            <button type="submit" class="btn btn-outline-primary">
                <i class="bi bi-funnel-fill me-1"></i> Filter
            </button>
        </div>
    </form>

    <!-- Tickets Table -->
    <div class="table-responsive">
        <table id="ticketsTable" class="table table-striped table-hover table-bordered align-middle">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Customer</th>
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
                        <td><c:out value="${ticket.id}"/></td>
                        <td><c:out value="${ticket.customerName}"/></td>
                        <td><c:out value="${ticket.subject}"/></td>
                        <td><c:out value="${ticket.description}"/></td>

                        <!-- Status dropdown -->
                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/admin/support-tickets">
                                <input type="hidden" name="ticketId" value="${ticket.id}"/>
                                <input type="hidden" name="action" value="updateStatus"/>
                                <select name="status" class="form-select form-select-sm" onchange="this.form.submit()" 
                                        ${ticket.status == 'CLOSED' ? 'disabled' : ''}>
                                    <option value="OPEN" ${ticket.status == 'OPEN' ? 'selected' : ''}>OPEN</option>
                                    <option value="IN_PROGRESS" ${ticket.status == 'IN_PROGRESS' ? 'selected' : ''}>IN_PROGRESS</option>
                                    <option value="RESOLVED" ${ticket.status == 'RESOLVED' ? 'selected' : ''}>RESOLVED</option>
                                    <option value="CLOSED" ${ticket.status == 'CLOSED' ? 'selected' : ''}>CLOSED</option>
                                </select>
                            </form>
                        </td>

                        <!-- Priority dropdown -->
                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/admin/support-tickets">
                                <input type="hidden" name="ticketId" value="${ticket.id}"/>
                                <input type="hidden" name="action" value="updatePriority"/>
                                <select name="priority" class="form-select form-select-sm" onchange="this.form.submit()">
                                    <option value="LOW" ${ticket.priority == 'LOW' ? 'selected' : ''}>LOW</option>
                                    <option value="MEDIUM" ${ticket.priority == 'MEDIUM' ? 'selected' : ''}>MEDIUM</option>
                                    <option value="HIGH" ${ticket.priority == 'HIGH' ? 'selected' : ''}>HIGH</option>
                                </select>
                            </form>
                        </td>

                        <td><c:out value="${ticket.createdAt}"/></td>
                    </tr>
                </c:forEach>

                <c:if test="${empty tickets}">
                    <tr>
                        <td colspan="7" class="text-center text-muted">No support tickets found.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<!-- DataTables JS -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<script>
    $(document).ready(function () {
        $('#ticketsTable').DataTable({
            pageLength: 10,
            lengthMenu: [5, 10, 25, 50, 100],
            order: [[0, "desc"]],
            language: {
                search: "Search tickets:",
                lengthMenu: "Show _MENU_ tickets"
            }
        });
    });
</script>

<jsp:include page="/admin/components/footer.jsp"/>
