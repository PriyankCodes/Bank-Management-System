<%@ page contentType="text/html; charset=UTF-8"%>
<jsp:include page="/components/header.jsp">
  <jsp:param name="pageTitle" value="Register"/>
</jsp:include>
<jsp:include page="/components/navbar.jsp"/>
<div class="container">
  <jsp:include page="/components/alerts.jsp"/>
  <div class="row justify-content-center">
    <div class="col-md-8">
      <div class="card shadow-sm">
        <div class="card-body">
          <h5 class="card-title mb-3">Register</h5>
          <form method="post" action="${pageContext.request.contextPath}/AuthServlet">
            <input type="hidden" name="action" value="register"/>
            <div class="row g-2">
              <div class="col-md-6 mb-3">
                <label>First Name</label>
                <input name="firstName" class="form-control" required/>
              </div>
              <div class="col-md-6 mb-3">
                <label>Last Name</label>
                <input name="lastName" class="form-control" required/>
              </div>
              <div class="col-md-6 mb-3">
                <label>Email</label>
                <input name="email" type="email" class="form-control" required/>
              </div>
              <div class="col-md-6 mb-3">
                <label>Phone</label>
                <input name="phone" class="form-control"/>
              </div>
              <div class="col-md-6 mb-3">
                <label>Password</label>
                <input name="password" type="password" class="form-control" required/>
              </div>
              <div class="col-md-6 mb-3">
                <label>Date of Birth</label>
                <input name="dob" type="date" class="form-control" required/>
              </div>
              <div class="col-md-6 mb-3">
                <label>City</label>
                <input name="city" class="form-control" required/>
              </div>
              <div class="col-md-6 mb-3">
                <label>State</label>
                <input name="state" class="form-control" required/>
              </div>
            </div>
            <button class="btn btn-primary" type="submit">Register</button>
            <a href="${pageContext.request.contextPath}/auth" class="btn btn-link">Login</a>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
<jsp:include page="/components/footer.jsp"/>
