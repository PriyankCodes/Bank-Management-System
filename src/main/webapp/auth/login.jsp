<%@ page contentType="text/html; charset=UTF-8"%>
<jsp:include page="/components/header.jsp">
  <jsp:param name="pageTitle" value="Login"/>
</jsp:include>
<jsp:include page="/components/navbar.jsp"/>
<div class="container">
  <jsp:include page="/components/alerts.jsp"/>
  <div class="row justify-content-center">
    <div class="col-md-6">
      <div class="card shadow-sm">
        <div class="card-body">
          <h5 class="card-title mb-3">Login</h5>
          <form method="post" action="${pageContext.request.contextPath}/AuthServlet">
            <input type="hidden" name="action" value="login"/>
            <div class="mb-3">
              <label>Email</label>
              <input name="email" type="email" class="form-control" required/>
            </div>
            <div class="mb-3">
              <label>Password</label>
              <input name="password" type="password" class="form-control" required/>
            </div>
            <button class="btn btn-primary" type="submit">Login</button>
            <a href="${pageContext.request.contextPath}/AuthServlet?action=register" class="btn btn-link">Register</a>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
<jsp:include page="/components/footer.jsp"/>
