<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/components/header.jsp">
    <jsp:param name="pageTitle" value="Submit Support Ticket"/>
</jsp:include>
<jsp:include page="/components/navbar.jsp"/>

<div class="container section-lg fade-in py-5">

    <!-- Flash messages -->
    <c:if test="${not empty sessionScope.flash_success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${sessionScope.flash_success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="flash_success" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.flash_error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${sessionScope.flash_error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="flash_error" scope="session"/>
    </c:if>

    <h3 class="mb-4 text-gradient fw-bold">
        <i class="bi bi-life-preserver me-2"></i> Submit a Support Ticket
    </h3>

    <!-- Submit Ticket Form -->
    <div class="card shadow-sm rounded-4 p-4 mb-5">
        <form method="post" action="${pageContext.request.contextPath}/customer/support-ticket" novalidate>
            <div class="mb-3">
                <label for="subject" class="form-label fw-semibold">Subject</label>
                <select id="subject" name="subject" class="form-select stylish-select" required>
                    <option value="">-- Select Subject --</option>
                    <option value="Account Issue">Account Issue</option>
                    <option value="Transaction Problem">Transaction Problem</option>
                    <option value="Technical Support">Technical Support</option>
                    <option value="Other">Other</option>
                </select>
            </div>

            <div class="mb-3">
                <label for="description" class="form-label fw-semibold">Description</label>
                <textarea id="description" name="description" rows="5" class="form-control stylish-input" required placeholder="Describe your issue"></textarea>
            </div>

            <button type="submit" class="btn btn-gradient px-4 glow-btn">
                <i class="bi bi-send me-1"></i> Submit Ticket
            </button>
        </form>
    </div>

    <!-- Your Tickets Table -->
    <h4 class="mb-3 text-gradient fw-bold"><i class="bi bi-card-list me-2"></i> Your Support Tickets</h4>

    <c:choose>
        <c:when test="${empty tickets}">
            <div class="alert alert-info">
                You currently have no support tickets.
            </div>
        </c:when>
        <c:otherwise>
            <div class="table-responsive shadow-sm rounded-4">
                <table class="table table-hover table-bordered align-middle mb-0">
                    <thead class="table-dark text-white">
                        <tr>
                            <th>Ticket ID</th>
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
                                <td><c:out value="${ticket.subject}"/></td>
                                <td><c:out value="${ticket.description}"/></td>
                                <td>
                                    <span class="badge 
                                        ${ticket.status == 'OPEN' ? 'bg-warning text-dark' : ''}
                                        ${ticket.status == 'IN_PROGRESS' ? 'bg-info text-dark' : ''}
                                        ${ticket.status == 'RESOLVED' ? 'bg-success' : ''}
                                        ${ticket.status == 'CLOSED' ? 'bg-secondary' : ''}">
                                        ${ticket.status}
                                    </span>
                                </td>
                                <td>
                                    <span class="badge 
                                        ${ticket.priority == 'LOW' ? 'bg-secondary' : ''}
                                        ${ticket.priority == 'MEDIUM' ? 'bg-primary' : ''}
                                        ${ticket.priority == 'HIGH' ? 'bg-danger' : ''}">
                                        ${ticket.priority}
                                    </span>
                                </td>
                                <td><fmt:formatDate value="${ticket.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/components/footer.jsp"/>

<style>
    /* Gradient heading */
    .text-gradient {
        background: linear-gradient(90deg, #ff416c, #ff4b2b);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
    }

    /* Gradient button */
    .btn-gradient {
        background: linear-gradient(90deg, #ff416c, #ff4b2b);
        border: none;
        color: #fff !important;
        border-radius: 12px;
        transition: all 0.3s ease;
    }
    .btn-gradient:hover {
        background: linear-gradient(90deg, #ff4b2b, #ff416c);
        transform: translateY(-2px);
        box-shadow: 0 6px 15px rgba(255, 65, 108, 0.4);
    }

    /* Glow effect */
    .glow-btn {
        box-shadow: 0 4px 10px rgba(255, 75, 43, 0.3);
    }

    /* Stylish inputs */
    .stylish-input, .stylish-select {
        border-radius: 10px;
        transition: all 0.3s ease;
    }
    .stylish-input:focus, .stylish-select:focus {
        border-color: #ff416c;
        box-shadow: 0 0 8px rgba(255, 65, 108, 0.3);
    }

    /* Table hover highlight */
    .table-hover tbody tr:hover {
        background-color: rgba(255, 65, 108, 0.1);
        transition: background-color 0.3s ease;
    }

    /* Fade-in animation */
    .fade-in {
        animation: fadeInUp 0.8s ease-in-out;
    }
    @keyframes fadeInUp {
        from { opacity: 0; transform: translateY(30px); }
        to { opacity: 1; transform: translateY(0); }
    }
</style>
