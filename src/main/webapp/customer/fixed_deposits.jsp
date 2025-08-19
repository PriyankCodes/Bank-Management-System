<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/components/header.jsp">
    <jsp:param name="pageTitle" value="Fixed Deposits"/>
</jsp:include>
<jsp:include page="/components/navbar.jsp"/>

<!-- DataTables CSS and JS CDN -->
<link href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" rel="stylesheet"/>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

<div class="container section-lg fade-in">
    <jsp:include page="/components/alerts.jsp" />

    <h4>Apply for New Fixed Deposit</h4>
    <form method="post" action="${pageContext.request.contextPath}/customer/fixed_deposits" novalidate>
        <div class="mb-3">
            <label for="principal" class="form-label">Principal Amount (₹)</label>
            <input type="number" min="1000" step="0.01" id="principal" name="principal" class="form-control" required />
            <div class="form-text">Minimum ₹1000</div>
        </div>
        <div class="mb-3">
            <label for="tenureMonths" class="form-label">Tenure (Months)</label>
            <input type="number" min="1" id="tenureMonths" name="tenureMonths" class="form-control" required />
        </div>
        <div class="mb-3">
            <label for="accountId" class="form-label">Link to Account</label>
            <select id="accountId" name="accountId" class="form-select" required>
                <option value="" disabled selected>Select Account</option>
                <c:forEach var="acc" items="${accounts}">
                    <option value="${acc.id}">${acc.accountNumber} - ${acc.type} - Balance ₹${acc.balance}</option>
                </c:forEach>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Apply</button>
    </form>

    <hr/>

    <h3>Your Fixed Deposits</h3>
    <c:if test="${empty fixedDeposits}">
        <p>You have no fixed deposits.</p>
    </c:if>
    <c:if test="${not empty fixedDeposits}">
        <table id="fixedDepositsTable" class="table table-striped table-hover" style="width:100%">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Principal (₹)</th>
                    <th>Tenure (Months)</th>
                    <th>Status</th>
                    <th>Strated At</th>
                    <th>Maturity Date</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="fd" items="${fixedDeposits}">
                    <tr>
                        <td><c:out value="${fd.id}" /></td>
                        <td><c:out value="${fd.principal}" /></td>
                        <td><c:out value="${fd.tenureMonths}" /></td>
                        <td><c:out value="${fd.status}" /></td>
                        <td><c:out value="${fd.startDate}" /></td>
                        <td><c:out value="${fd.maturityDate}" /></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
</div>

<script>
    $(document).ready(function() {
        $('#fixedDepositsTable').DataTable({
            paging: true,
            searching: true,
            info: true
        });
    });
</script>

<jsp:include page="/components/footer.jsp"/>
