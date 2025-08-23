<!-- Footer -->
<footer class="footer py-4 bg-black text-white text-center mt-auto" style="margin-top: 3rem;">
  <div class="container">
    <!-- Logo/Icon -->
    <div class="mb-2">
      <i class="bi bi-bank" style="font-size: 1.8rem; color: white;"></i>
    </div>

    <!-- Quick Links -->
    <div class="d-flex justify-content-center gap-4 mb-2">
      <a href="${pageContext.request.contextPath}/admin/dashboard" class="text-white text-decoration-none small">Dashboard</a>
      <a href="${pageContext.request.contextPath}/admin/reports" class="text-white text-decoration-none small">Reports</a>
      <a href="${pageContext.request.contextPath}/admin/accounts" class="text-white text-decoration-none small">Accounts</a>
      <a href="${pageContext.request.contextPath}/admin/support-tickets" class="text-white text-decoration-none small">Support</a>
    </div>

    <!-- Legal Links -->
    <div class="d-flex justify-content-center gap-4">
      <a href="#" class="text-white-50 text-decoration-none small">Privacy Policy</a>
      <a href="#" class="text-white-50 text-decoration-none small">Terms</a>
      <a href="#" class="text-white-50 text-decoration-none small">Contact</a>
    </div>

    <!-- Copyright -->
    <p class="mt-3 mb-0 text-white-50 small">&copy; 2025 BankApp. All rights reserved.</p>
  </div>
</footer>

<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<!-- Make sure body is flex column -->
<style>
  body {
    display: flex;
    flex-direction: column;
    min-height: 100vh; /* full height */
  }

  main {
    flex: 1; /* pushes footer to bottom if content is short */
  }
</style>
