<%@ page contentType="text/html; charset=UTF-8"%>
<jsp:include page="/components/header.jsp">
  <jsp:param name="pageTitle" value="Login"/>
</jsp:include>
<jsp:include page="/components/navbar.jsp"/>

<div class="container py-5">
  <jsp:include page="/components/alerts.jsp"/>

  <div class="row justify-content-center">
    <div class="col-md-6">
      <div class="card shadow-lg border-0 rounded-4 animate__animated animate__fadeInDown">
        <div class="card-body p-4">
          <h3 class="card-title text-center mb-4 text-danger fw-bold">
            <i class="bi bi-shield-lock-fill"></i> Secure Login
          </h3>

          <form method="post" action="${pageContext.request.contextPath}/AuthServlet">
            <input type="hidden" name="action" value="login"/>

            <!-- Email -->
            <div class="mb-3">
              <label class="form-label fw-semibold">Email Address</label>
              <div class="input-group">
                <span class="input-group-text bg-danger text-white">
                  <i class="bi bi-envelope-fill"></i>
                </span>
                <input name="email" type="email" class="form-control" placeholder="Enter your email" required/>
              </div>
            </div>

            <!-- Password -->
            <div class="mb-3">
              <label class="form-label fw-semibold">Password</label>
              <div class="input-group">
                <span class="input-group-text bg-danger text-white">
                  <i class="bi bi-lock-fill"></i>
                </span>
                <input name="password" type="password" class="form-control" placeholder="Enter your password" required/>
              </div>
            </div>

            <!-- Actions -->
            <div class="d-grid gap-2 mt-4">
             <button class="btn btn-glow btn-lg" type="submit">
  <i class="bi bi-box-arrow-in-right"></i> Login
</button>

              <a href="${pageContext.request.contextPath}/AuthServlet?action=register" 
                 class="btn btn-outline-danger rounded-pill">
                 <i class="bi bi-person-plus-fill"></i> Create New Account
              </a>
            </div>

          </form>
        </div>
      </div>
    </div>
  </div>
</div>

<jsp:include page="/components/footer.jsp"/>
