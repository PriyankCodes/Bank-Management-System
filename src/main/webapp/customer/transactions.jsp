<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/components/header.jsp">
    <jsp:param name="pageTitle" value="Transactions"/>
</jsp:include>
<jsp:include page="/components/navbar.jsp"/>

<!-- DataTables CSS and JS CDN -->
<link href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" rel="stylesheet"/>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

<div class="container section-lg fade-in">
    <jsp:include page="/components/alerts.jsp"/>

    <h3>Transactions</h3>

    <c:if test="${empty transactions}">
        <p>No transactions to display.</p>
    </c:if>

    <c:if test="${not empty transactions}">
        <table id="transactionsTable" class="table table-striped table-hover" style="width:100%">
            <thead>
            <tr>
                <th>Date</th>
                <th>Type</th>
                <th>Amount (₹)</th>
                <th>Reference No</th>
                <th>Affected Account</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="txn" items="${transactions}">
                <tr>
                    <td><c:out value="${txn.createdAt}"/></td>
                    <td>
                      <span class="badge 
                        <c:choose>
                          <c:when test='${txn.txnType == "CREDIT"}'>bg-success</c:when>
                          <c:when test='${txn.txnType == "DEBIT"}'>bg-danger</c:when>
                          <c:otherwise>bg-secondary</c:otherwise>
                        </c:choose> text-white">
                        <c:out value="${txn.txnType}"/>
                      </span>
                    </td>
                    <td><c:out value="${txn.amount}"/></td>
                    <td><c:out value="${txn.referenceNo}"/></td>
                    <td><c:out value="${txn.accountNumber}"/></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>
</div>

<script>
    $(document).ready(function() {
        $('#transactionsTable').DataTable({
            paging: true,
            searching: true,
            info: true
        });
    });
</script>

<jsp:include page="/components/footer.jsp"/>
