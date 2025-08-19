<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/components/header.jsp">
  <jsp:param name="pageTitle" value="Open New Account"/>
</jsp:include>
<jsp:include page="/components/navbar.jsp"/>

<div class="container section-lg fade-in">
  <jsp:include page="/components/alerts.jsp"/>

  <div class="row justify-content-center">
    <div class="col-md-6">
      <div class="card shadow-sm p-4">
        <h5 class="card-title mb-4">Open New Account</h5>

        <form method="post" action="${pageContext.request.contextPath}/customer/account-new" novalidate>
          <div class="mb-3">
            <label for="type" class="form-label">Account Type</label>
            <select name="type" id="type" class="form-select" required>
              <option value="">Select account type...</option>
              <option value="SAVINGS" <c:if test="${prefillType == 'SAVINGS'}">selected</c:if>>Savings</option>
              <option value="CURRENT" <c:if test="${prefillType == 'CURRENT'}">selected</c:if>>Current</option>
            </select>
          </div>

          <div class="mb-3">
            <label for="principal" class="form-label">Initial Deposit (₹ minimum 1000)</label>
            <input type="number" min="1000" step="0.01" id="principal" name="principal" class="form-control" required/>
            <div class="form-text">Minimum ₹ 1000 required to open an account.</div>
          </div>

          <button type="submit" class="btn btn-primary">Create Account</button>
          <a href="${pageContext.request.contextPath}/customer/dashboard" class="btn btn-secondary ms-2">Cancel</a>
        </form>

      </div>
    </div>
  </div>
</div>

<jsp:include page="/components/footer.jsp"/>
