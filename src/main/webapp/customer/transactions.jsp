<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/components/header.jsp">
    <jsp:param name="pageTitle" value="Transactions"/>
</jsp:include>
<jsp:include page="/components/navbar.jsp"/>

<!-- Bootstrap + DataTables CSS -->
<link href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" rel="stylesheet"/>
<link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<style>
    .section-lg {
        padding: 40px 0;
    }

    h3 {
        margin-bottom: 20px;
        font-weight: 600;
        background: linear-gradient(90deg, #343a40, #495057);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
    }

    /* Card-style wrapper for table */
    .table-card {
        background: #fff;
        border-radius: 12px;
        padding: 20px;
        box-shadow: 0 6px 15px rgba(0,0,0,0.08);
    }

    /* DataTable customization */
    #transactionsTable {
        border-collapse: collapse;
        width: 100%;
    }

    #transactionsTable thead {
        background: linear-gradient(90deg, #212529, #343a40);
        color: #fff;
    }

    #transactionsTable tbody tr:hover {
        background-color: #f1f3f5;
        transition: background-color 0.3s ease;
    }

    .badge {
        font-size: 0.85rem;
        padding: 6px 10px;
        border-radius: 8px;
        font-weight: 500;
    }

    .dataTables_wrapper .dataTables_paginate .paginate_button {
        border-radius: 6px;
        padding: 6px 12px;
        margin: 2px;
        border: none;
        background: #e9ecef;
        color: #343a40 !important;
    }

    .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
        background: #343a40;
        color: #fff !important;
        transition: all 0.3s ease;
    }

    .dataTables_filter input {
        border-radius: 8px;
        border: 1px solid #ced4da;
        padding: 5px 10px;
    }
</style>

<div class="container section-lg fade-in">
    <jsp:include page="/components/alerts.jsp"/>

    <h3>Transactions</h3>

    <c:if test="${empty transactions}">
        <p>No transactions to display.</p>
    </c:if>

    <c:if test="${not empty transactions}">
        <div class="table-card">
            <table id="transactionsTable" class="table table-hover align-middle" style="width:100%">
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
                            </c:choose>">
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
        </div>
    </c:if>
</div>

<script>
    $(document).ready(function() {
        $('#transactionsTable').DataTable({
            paging: true,
            searching: true,
            info: true,
            ordering: true,
            responsive: true,
            language: {
                search: "🔍 Filter records:"
            },
            "order": [[0, "desc"]] // <-- 0 = first column (Date), desc = descending

        });
    });
</script>

<jsp:include page="/components/footer.jsp"/>
