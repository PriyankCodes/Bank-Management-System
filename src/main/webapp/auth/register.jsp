<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Register</title>



  <!-- Custom CSS -->
  <style>
    body {
      background: linear-gradient(135deg, #f4f4f4 0%, #e9ecef 100%);
      font-family: 'Inter', sans-serif;
      min-height: 100vh;
      color: #333;
    }

    .card {
      background: rgba(255, 255, 255, 0.95);
      backdrop-filter: blur(10px);
      border: 1px solid #e0e0e0;
      border-radius: 16px !important;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .card:hover {
      transform: translateY(-5px);
      box-shadow: 0 16px 40px rgba(0, 0, 0, 0.15);
    }

    .form-control:focus {
      border-color: #000;
      box-shadow: 0 0 0 0.2rem rgba(0, 0, 0, 0.1);
    }

    .input-group .input-group-text {
      background-color: #000;
      border: none;
      color: white;
    }

    .input-group .form-control {
      border-left: none;
      border-color: #ced4da;
    }

    .input-group:focus-within {
      box-shadow: 0 0 0 0.2rem rgba(0, 0, 0, 0.1);
    }

    .btn-glow {
      background: #000;
      color: white;
      font-weight: 600;
      padding: 12px 0;
      letter-spacing: 0.8px;
      border: none;
      border-radius: 8px;
      transition: all 0.3s ease;
      position: relative;
      overflow: hidden;
    }

    .btn-glow:hover {
      background: #111;
      transform: translateY(-2px);
      box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
    }

    .btn-outline-danger {
      color: #555;
      border-color: #ccc;
      font-weight: 500;
    }

    .btn-outline-danger:hover {
      background: #f8f9fa;
      border-color: #bbb;
      color: #333;
      transform: scale(1.02);
    }

    .card-title {
      color: #000;
      font-weight: 700;
      font-size: 1.75rem;
    }

    label {
      color: #444;
      font-weight: 500;
    }

    .animate__fadeInUp {
      animation-duration: 0.8s;
    }
  </style>
</head>
<body>

<jsp:include page="/components/header.jsp">
  <jsp:param name="pageTitle" value="Register"/>
</jsp:include>

<div class="container py-5">
  <jsp:include page="/components/alerts.jsp"/>

  <div class="row justify-content-center">
    <div class="col-md-10 col-lg-8">
      <div class="card shadow-lg border-0 rounded-4 animate__animated animate__fadeInUp">
        <div class="card-body p-5">
          <h3 class="card-title text-center mb-4">
            <i class="bi bi-person-plus-fill me-2 text-black"></i> Create Your Account
          </h3>

          <form method="post" action="${pageContext.request.contextPath}/AuthServlet">
            <input type="hidden" name="action" value="register"/>

            <div class="row g-4">

              <!-- First Name -->
              <div class="col-md-6">
                <label for="firstName" class="form-label">First Name</label>
                <div class="input-group">
                  <span class="input-group-text bg-black text-white">
                    <i class="bi bi-person-fill"></i>
                  </span>
                  <input type="text" name="firstName" id="firstName" class="form-control" placeholder="Enter first name" required/>
                </div>
              </div>

              <!-- Last Name -->
              <div class="col-md-6">
                <label for="lastName" class="form-label">Last Name</label>
                <div class="input-group">
                  <span class="input-group-text bg-black text-white">
                    <i class="bi bi-person-badge"></i>
                  </span>
                  <input type="text" name="lastName" id="lastName" class="form-control" placeholder="Enter last name" required/>
                </div>
              </div>

              <!-- Email -->
              <div class="col-md-6">
                <label for="email" class="form-label">Email</label>
                <div class="input-group">
                  <span class="input-group-text bg-black text-white">
                    <i class="bi bi-envelope"></i>
                  </span>
                  <input type="email" name="email" id="email" class="form-control" placeholder="Enter email" required/>
                </div>
              </div>

              <!-- Phone -->
              <div class="col-md-6">
                <label for="phone" class="form-label">Phone</label>
                <div class="input-group">
                  <span class="input-group-text bg-black text-white">
                    <i class="bi bi-telephone"></i>
                  </span>
                  <input type="tel" name="phone" id="phone" class="form-control" placeholder="Enter phone number"/>
                </div>
              </div>

              <!-- Password -->
              <div class="col-md-6">
                <label for="password" class="form-label">Password</label>
                <div class="input-group">
                  <span class="input-group-text bg-black text-white">
                    <i class="bi bi-lock"></i>
                  </span>
                  <input type="password" name="password" id="password" class="form-control" placeholder="Create password" required/>
                </div>
              </div>

              <!-- DOB -->
              <div class="col-md-6">
                <label for="dob" class="form-label">Date of Birth</label>
                <div class="input-group">
                  <span class="input-group-text bg-black text-white">
                    <i class="bi bi-calendar-event"></i>
                  </span>
                  <input type="date" name="dob" id="dob" class="form-control" required/>
                </div>
              </div>

              <!-- City -->
              <div class="col-md-6">
                <label for="city" class="form-label">City</label>
                <div class="input-group">
                  <span class="input-group-text bg-black text-white">
                    <i class="bi bi-geo-alt"></i>
                  </span>
                  <input type="text" name="city" id="city" class="form-control" placeholder="Enter city" required/>
                </div>
              </div>

              <!-- State -->
              <div class="col-md-6">
                <label for="state" class="form-label">State</label>
                <div class="input-group">
                  <span class="input-group-text bg-black text-white">
                    <i class="bi bi-map"></i>
                  </span>
                  <input type="text" name="state" id="state" class="form-control" placeholder="Enter state" required/>
                </div>
              </div>

            </div>

            <!-- Actions -->
            <div class="d-grid gap-3 mt-5">
              <button class="btn btn-glow btn-lg" type="submit">
                <i class="bi bi-check-circle me-2"></i> Register Now
              </button>

              <a href="${pageContext.request.contextPath}/AuthServlet" class="btn btn-outline-secondary rounded-pill">
                <i class="bi bi-box-arrow-in-right me-2"></i> Already have an account? Login
              </a>
            </div>

          </form>
        </div>
      </div>
    </div>
  </div>
</div>


<!-- Bootstrap JS (Optional for interactions) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>