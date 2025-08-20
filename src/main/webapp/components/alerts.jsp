<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- ✅ Success Message -->
<c:if test="${not empty sessionScope.flash_success}">
  <div class="alert alert-success alert-dismissible fade show shadow-sm animate__animated animate__fadeInDown" role="alert">
    <i class="bi bi-check-circle-fill me-2"></i> ${sessionScope.flash_success}
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
  </div>
  <c:remove var="flash_success" scope="session"/>
</c:if>

<!-- ✅ Error Message -->
<c:if test="${not empty sessionScope.flash_error}">
  <div class="alert alert-danger alert-dismissible fade show shadow-sm animate__animated animate__fadeInDown" role="alert">
    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${sessionScope.flash_error}
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
  </div>
  <c:remove var="flash_error" scope="session"/>
</c:if>

<!-- ✅ Inline Success -->
<c:if test="${not empty success}">
  <div class="alert alert-success alert-dismissible fade show shadow-sm animate__animated animate__fadeInDown" role="alert">
    <i class="bi bi-check-circle-fill me-2"></i> ${success}
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
  </div>
</c:if>

<!-- ✅ Inline Error -->
<c:if test="${not empty error}">
  <div class="alert alert-danger alert-dismissible fade show shadow-sm animate__animated animate__fadeInDown" role="alert">
    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
  </div>
</c:if>
