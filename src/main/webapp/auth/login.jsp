<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Login - Secure Access</title>

  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Poppins:wght@700&display=swap" rel="stylesheet"/>

  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>

  <!-- Animate.css -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet"/>

  <style>
    :root {
      --primary: #000;
      --primary-light: #1a1a1a;
      --gradient-start: #f9f9ff;
      --gradient-end: #f0f4ff;
      --card-bg: rgba(255, 255, 255, 0.85);
      --shadow: rgba(0, 0, 0, 0.08);
      --border-radius: 20px;
      --transition: all 0.3s ease;
    }

    body {
      background: linear-gradient(135deg, var(--gradient-start) 0%, var(--gradient-end) 100%);
      font-family: 'Inter', sans-serif;
      min-height: 100vh;
      margin: 0;
      color: #333;
      background-attachment: fixed;
    }

    /* Subtle animated background */
    body::before {
      content: '';
      position: fixed;
      top: -50%;
      left: -50%;
      width: 200%;
      height: 200%;
      background: radial-gradient(circle, rgba(100, 100, 255, 0.05) 0%, transparent 50%);
      pointer-events: none;
      animation: pulse 15s infinite alternate;
      z-index: -1;
    }

    @keyframes pulse {
      0% { transform: scale(1); opacity: 0.6; }
      100% { transform: scale(1.2); opacity: 0.8; }
    }

    /* Card styling */
    .card {
      background: var(--card-bg);
      backdrop-filter: blur(16px);
      -webkit-backdrop-filter: blur(16px);
      border: 1px solid rgba(255, 255, 255, 0.3);
      border-radius: var(--border-radius);
      box-shadow: 0 12px 30px var(--shadow);
      transition: var(--transition);
      position: relative;
      overflow: hidden;
    }

    .card::before {
      content: '';
      position: absolute;
      inset: 0;
      background: linear-gradient(135deg, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 0.03) 50%, rgba(0, 0, 0, 0.06) 100%);
      border-radius: var(--border-radius);
      z-index: -1;
    }

    .card:hover {
      transform: translateY(-8px) scale(1.01);
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.18);
    }

    /* Input focus */
    .form-control:focus {
      border-color: #000;
      box-shadow: 0 0 0 0.2rem rgba(0, 0, 0, 0.15);
    }

    /* Input group */
    .input-group {
      border: 1px solid #e0e0e0;
      border-radius: 12px;
      overflow: hidden;
      transition: var(--transition);
    }

    .input-group:focus-within {
      box-shadow: 0 0 0 0.2rem rgba(0, 0, 0, 0.15);
      border-color: #000;
    }

    .input-group .input-group-text {
      background: var(--primary);
      color: white;
      border: none;
      padding: 12px 16px;
    }

    .input-group .form-control {
      border: none;
      padding: 12px 16px;
    }

    /* Button */
    .btn-glow {
      background: var(--primary);
      color: white;
      font-weight: 600;
      letter-spacing: 0.8px;
      border: none;
      border-radius: 12px;
      padding: 14px 0;
      font-size: 1.1rem;
      transition: var(--transition);
      box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
    }

    .btn-glow:hover {
      background: #000;
      transform: translateY(-3px);
      box-shadow: 0 12px 25px rgba(0, 0, 0, 0.25);
    }

    /* Outline button */
    .btn-outline-secondary {
      color: #444;
      border-color: #ddd;
      font-weight: 500;
      border-radius: 12px;
      transition: var(--transition);
    }

    .btn-outline-secondary:hover {
      background: #f8f9fa;
      border-color: #ccc;
      color: #222;
      transform: translateY(-2px);
    }

    /* Typography */
    .card-title {
      font-family: 'Poppins', sans-serif;
      color: var(--primary);
      font-weight: 700;
      font-size: 1.85rem;
      letter-spacing: -0.5px;
      margin-bottom: 1.5rem;
    }

    label {
      color: #555;
      font-weight: 500;
      font-size: 0.9rem;
    }

    .container {
      padding-top: 60px;
      padding-bottom: 60px;
    }

    /* Responsive */
    @media (max-width: 768px) {
      .card-body { padding: 1.5rem; }
      .card-title { font-size: 1.6rem; }
    }
  </style>
</head>
<body>

<jsp:include page="/components/header.jsp">
  <jsp:param name="pageTitle" value="Login"/>
</jsp:include>

<div class="container py-5">
  <jsp:include page="/components/alerts.jsp"/>

  <div class="row justify-content-center">
    <div class="col-lg-5 col-md-7">
      <div class="card shadow-sm border-0 animate__animated animate__fadeInDown">
        <div class="card-body p-5">

          <h3 class="card-title text-center mb-4">
            <i class="bi bi-shield-lock-fill me-2"></i> Welcome Back
          </h3>
          <p class="text-center text-muted mb-4" style="font-size: 0.95rem;">
            Sign in to continue to your account.
          </p>

          <form method="post" action="${pageContext.request.contextPath}/AuthServlet">
            <input type="hidden" name="action" value="login"/>

            <!-- Email -->
            <div class="mb-4">
              <label for="email" class="form-label">Email Address</label>
              <div class="input-group">
                <span class="input-group-text bg-black text-white">
                  <i class="bi bi-envelope-fill"></i>
                </span>
                <input type="email" name="email" id="email" class="form-control" placeholder="Enter your email" required/>
              </div>
            </div>

            <!-- Password -->
            <div class="mb-4">
              <label for="password" class="form-label">Password</label>
              <div class="input-group">
                <span class="input-group-text bg-black text-white">
                  <i class="bi bi-lock-fill"></i>
                </span>
                <input type="password" name="password" id="password" class="form-control" placeholder="Enter your password" required/>
              </div>
            </div>

            <!-- Actions -->
            <div class="d-grid gap-3 mt-4">
              <button class="btn btn-glow btn-lg" type="submit">
                <i class="bi bi-box-arrow-in-right me-2"></i> Log In
              </button>

              <a href="${pageContext.request.contextPath}/AuthServlet?action=register" 
                 class="btn btn-outline-secondary">
                 <i class="bi bi-person-plus-fill me-2"></i> Create New Account
              </a>
            </div>

          </form>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>