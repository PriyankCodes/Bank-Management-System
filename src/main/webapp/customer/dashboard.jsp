<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/components/header.jsp">
    <jsp:param name="pageTitle" value="Dashboard"/>
</jsp:include>
<jsp:include page="/components/navbar.jsp"/>

<div class="container section-lg fade-in">

    <!-- Flash messages -->
    <c:if test="${not empty sessionScope.flash_success}">
        <div class="alert alert-success">${sessionScope.flash_success}</div>
        <c:remove var="flash_success" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.flash_error}">
        <div class="alert alert-danger">${sessionScope.flash_error}</div>
        <c:remove var="flash_error" scope="session"/>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <h3 class="mb-4">Welcome, <c:out value="${customer.firstName}"/>!</h3>

    <c:choose>
        <c:when test="${empty accounts}">
            <!-- Account opening form (unchanged) -->
        </c:when>
        <c:otherwise>
            <h5 class="mb-3">Your Accounts</h5>
            <div class="row g-4">
                <c:forEach var="a" items="${accounts}">
                    <div class="col-md-4">
                        <div class="card account-card shadow-sm border-0">
                            <div class="card-body">
                                <h6 class="card-title text-muted">Account Number</h6>
                                <p class="fw-bold mb-2"><c:out value="${a.accountNumber}"/></p>

                                <div class="d-flex justify-content-between mb-2">
                                    <span class="badge bg-primary text-uppercase"><c:out value="${a.type}"/></span>
                                    <span class="badge bg-secondary"><c:out value="${a.status}"/></span>
                                </div>

                                <h5 class="text-dark fw-bold">₹ <c:out value="${a.balance}"/></h5>
                                <p class="text-muted small mb-3">Opened At: <c:out value="${a.openedAt}"/></p>

                                <!-- Deposit/Withdraw Buttons (postback with account info) -->
                                <form method="post" action="${pageContext.request.contextPath}/customer/dashboard" style="display:inline;">
                                    <input type="hidden" name="showForm" value="${a.accountNumber}"/>
                                    <input type="hidden" name="formType" value="deposit"/>
                                    <button type="submit" class="btn btn-success btn-sm mb-1">Deposit</button>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/customer/dashboard" style="display:inline;">
                                    <input type="hidden" name="showForm" value="${a.accountNumber}"/>
                                    <input type="hidden" name="formType" value="withdraw"/>
                                    <button type="submit" class="btn btn-danger btn-sm mb-1 ms-2">Withdraw</button>
                                </form>

                                <!-- Only show deposit/withdraw form for the currently selected account -->
                                <c:if test="${param.showForm == a.accountNumber}">
                                    <form method="post" action="${pageContext.request.contextPath}/customer/dashboard" class="mt-3">
                                        <input type="hidden" name="accountNumber" value="${a.accountNumber}"/>
                                        <input type="hidden" name="action" value="${param.formType}"/>
                                        <div class="mb-2">
                                            <label class="form-label mb-0">Account Number</label>
                                            <input type="text" class="form-control form-control-sm" value="${a.accountNumber}" readonly/>
                                        </div>
                                        <div class="mb-2">
                                            <label for="amount" class="form-label mb-0">
                                                <c:choose>
                                                    <c:when test="${param.formType == 'deposit'}">Deposit Amount (₹)</c:when>
                                                    <c:otherwise>Withdraw Amount (₹)</c:otherwise>
                                                </c:choose>
                                            </label>
                                            <input type="number" min="1" step="0.01" name="amount" required class="form-control form-control-sm" placeholder="Enter amount"/>
                                        </div>
                                        <button type="submit" class="btn ${param.formType == 'deposit' ? 'btn-success' : 'btn-danger'} btn-sm">
                                            <c:out value="${param.formType == 'deposit' ? 'Deposit' : 'Withdraw'}"/>
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <!-- Rest of dashboard code as before -->
        </c:otherwise>
    </c:choose>
</div>
<jsp:include page="/components/footer.jsp"/>
<style>
    .account-card { background: linear-gradient(to bottom right, #fff, #f8f9fa); /* ... */ }
    .account-card:hover { /* ... */ }
    .account-card .card-title { font-size: 0.85rem; font-weight: 600; }
</style>
