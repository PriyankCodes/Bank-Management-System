<%@ page contentType="text/html; charset=UTF-8"%>
<jsp:include page="/components/header.jsp">
  <jsp:param name="pageTitle" value="Register"/>
</jsp:include>
<jsp:include page="/components/navbar.jsp"/>

<div class="container py-5">
  <jsp:include page="/components/alerts.jsp"/>

  <div class="row justify-content-center">
    <div class="col-md-10 col-lg-8">
      <div class="card shadow-lg border-0 rounded-4 animate__animated animate__fadeInUp">
        <div class="card-body p-4">
          <h3 class="card-title text-center mb-4 text-danger fw-bold">
            <i class="bi bi-person-plus-fill"></i> Create Your Account
          </h3>

          <form method="post" action="${pageContext.request.contextPath}/AuthServlet">
            <input type="hidden" name="action" value="register"/>

            <div class="row g-3">

              <!-- First Name -->
              <div class="col-md-6">
                <label class="form-label fw-semibold">First Name</label>
                <div class="input-group">
                  <span class="input-group-text bg-danger text-white">
                    <i class="bi bi-person-fill"></i>
                  </span>
                  <input name="firstName" class="form-control" placeholder="Enter first name" required/>
                </div>
              </div>

              <!-- Last Name -->
              <div class="col-md-6">
                <label class="form-label fw-semibold">Last Name</label>
                <div class="input-group">
                  <span class="input-group-text bg-danger text-white">
                    <i class="bi bi-person-badge-fill"></i>
                  </span>
                  <input name="lastName" class="form-control" placeholder="Enter last name" required/>
                </div>
              </div>

              <!-- Email -->
              <div class="col-md-6">
                <label class="form-label fw-semibold">Email</label>
                <div class="input-group">
                  <span class="input-group-text bg-danger text-white">
                    <i class="bi bi-envelope-fill"></i>
                  </span>
                  <input name="email" type="email" class="form-control" placeholder="Enter email" required/>
                </div>
              </div>

              <!-- Phone -->
              <div class="col-md-6">
                <label class="form-label fw-semibold">Phone</label>
                <div class="input-group">
                  <span class="input-group-text bg-danger text-white">
                    <i class="bi bi-telephone-fill"></i>
                  </span>
                  <input name="phone" class="form-control" placeholder="Enter phone number"/>
                </div>
              </div>

              <!-- Password -->
              <div class="col-md-6">
                <label class="form-label fw-semibold">Password</label>
                <div class="input-group">
                  <span class="input-group-text bg-danger text-white">
                    <i class="bi bi-lock-fill"></i>
                  </span>
                  <input name="password" type="password" class="form-control" placeholder="Create password" required/>
                </div>
              </div>

              <!-- DOB -->
              <div class="col-md-6">
                <label class="form-label fw-semibold">Date of Birth</label>
                <div class="input-group">
                  <span class="input-group-text bg-danger text-white">
                    <i class="bi bi-calendar-event-fill"></i>
                  </span>
                  <input name="dob" type="date" class="form-control" required/>
                </div>
              </div>

              <!-- City -->
              <div class="col-md-6">
                <label class="form-label fw-semibold">City</label>
                <div class="input-group">
                  <span class="input-group-text bg-danger text-white">
                    <i class="bi bi-geo-alt-fill"></i>
                  </span>
                  <input name="city" class="form-control" placeholder="Enter city" required/>
                </div>
              </div>

              <!-- State -->
              <div class="col-md-6">
                <label class="form-label fw-semibold">State</label>
                <div class="input-group">
                  <span class="input-group-text bg-danger text-white">
                    <i class="bi bi-map-fill"></i>
                  </span>
                  <input name="state" class="form-control" placeholder="Enter state" required/>
                </div>
              </div>

            </div>

            <!-- Actions -->
            <div class="d-grid gap-2 mt-4">
            <button class="btn btn-glow btn-lg" type="submit">
  <i class="bi bi-check-circle-fill"></i> Register
</button>

              <a href="${pageContext.request.contextPath}/AuthServlet" class="btn btn-outline-danger rounded-pill">
                <i class="bi bi-box-arrow-in-right"></i> Already have an account? Login
              </a>
            </div>

          </form>
        </div>
      </div>
    </div>
  </div>
</div>

<jsp:include page="/components/footer.jsp"/>
