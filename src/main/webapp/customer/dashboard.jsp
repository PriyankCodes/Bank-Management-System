<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/components/header.jsp">
    <jsp:param name="pageTitle" value="Dashboard"/>
</jsp:include>
<jsp:include page="/components/navbar.jsp"/>

<div class="container section-lg fade-in">
    <jsp:include page="/components/alerts.jsp"/>
  
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <h3>Welcome, <c:out value="${customer.firstName}"/>!</h3>

    <c:choose>
        <c:when test="${empty accounts}">
            <div class="alert alert-info">
                <p>You currently have no accounts. Please open a new savings or current account.</p>
            </div>

            <div class="card shadow-sm p-3 mb-4">
                <form method="post" action="${pageContext.request.contextPath}/customer/account-new" novalidate>
                    <div class="mb-3">
                        <label for="type" class="form-label">Account Type</label>
                        <select name="type" id="type" class="form-select" required>
                            <option value="">Select account type...</option>
                            <option value="SAVINGS">Savings</option>
                            <option value="CURRENT">Current</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="principal" class="form-label">Initial Deposit (₹ minimum 1000)</label>
                        <input type="number" min="1000" step="0.01" id="principal" name="principal" class="form-control" required/>
                        <div class="form-text">Minimum ₹ 1000 required to open an account.</div>
                    </div>

                    <button type="submit" class="btn btn-primary">Open Account</button>
                </form>
            </div>
        </c:when>
        <c:otherwise>
            <h5>Your Accounts</h5>
            <div class="table-responsive">
                <table class="table table-striped">
                    <thead>
                    <tr>
                        <th>Account Number</th>
                        <th>Type</th>
                        <th>Status</th>
                        <th>Balance (₹)</th>
                        <th>Opened At</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="a" items="${accounts}">
                        <tr>
                            <td><c:out value="${a.accountNumber}"/></td>
                            <td><c:out value="${a.type}"/></td>
                            <td><c:out value="${a.status}"/></td>
                            <td><c:out value="${a.balance}"/></td>
                            <td><c:out value="${a.openedAt}"/></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <div>
                <p>You can only have one Savings and one Current account.</p>
                <c:if test="${not hasSaving}">
                    <a href="${pageContext.request.contextPath}/customer/account-new?type=SAVINGS" class="btn btn-success me-2">Open Savings Account</a>
                </c:if>
                <c:if test="${not hasCurrent}">
                    <a href="${pageContext.request.contextPath}/customer/account-new?type=CURRENT" class="btn btn-success">Open Current Account</a>
                </c:if>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/components/footer.jsp"/>
