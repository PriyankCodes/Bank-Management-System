<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/components/header.jsp">
  <jsp:param name="pageTitle" value="Transfers"/>
</jsp:include>
<jsp:include page="/components/navbar.jsp"/>

<div class="container section-lg fade-in">
  <jsp:include page="/components/alerts.jsp"/>

  <div class="card shadow-sm mb-3">
    <div class="card-body">
      <h6 class="card-title mb-3">New Transfer</h6>

      <form method="post" action="${pageContext.request.contextPath}/customer/transfers" class="row g-2" novalidate>
        <div class="col-md-4">
          <label class="form-label">From Account</label>
          <select name="fromAccountId" class="form-select" required>
            <c:forEach var="acc" items="${accounts}">
              <option value="${acc.id}">${acc.accountNumber} - ${acc.type}</option>
            </c:forEach>
          </select>
        </div>

        <div class="col-md-4">
          <label class="form-label">Beneficiary</label>
          <select name="beneficiaryId" class="form-select" required>
            <c:forEach var="b" items="${beneficiaries}">
              <option value="${b.id}">${b.name} - ${b.accountNumber}</option>
            </c:forEach>
          </select>
        </div>

        <div class="col-md-4">
          <label class="form-label">Amount</label>
          <input type="number" step="0.01" min="1" name="amount" class="form-control" required/>
        </div>

        <div class="col-12 mt-3">
          <button class="btn btn-primary" type="submit">Transfer</button>
        </div>
      </form>
    </div>
  </div>

  <div class="card shadow-sm">
    <div class="card-body">
      <h6 class="card-title mb-3">Recent Transfers</h6>
      <table class="table table-striped table-hover">
        <thead>
          <tr>
            <th>Date</th>
            <th>From Account</th>
            <th>Beneficiary</th>
            <th class="text-end">Amount (₹)</th>
            <th>Status</th>
            <th>Reference No</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="t" items="${transfers}">
            <tr>
              <td><c:out value="${t.createdAt}"/></td>
              <td><c:out value="${t.fromAccountNumber}"/></td>
              <td><c:out value="${t.beneficiaryName}"/></td>
              <td class="text-end">₹ <c:out value="${t.amount}"/></td>
              <td><span class="badge 
                <c:choose>
                  <c:when test="${t.status == 'SUCCESS'}">badge-success</c:when>
                  <c:when test="${t.status == 'PROCESSING'}">badge-warning</c:when>
                  <c:otherwise>badge-danger</c:otherwise>
                </c:choose>
              "><c:out value="${t.status}"/></span></td>
              <td><c:out value="${t.referenceNo}"/></td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
      <c:if test="${empty transfers}">
        <p class="text-muted">No transfers yet.</p>
      </c:if>
    </div>
  </div>

</div>

<jsp:include page="/components/footer.jsp"/>
