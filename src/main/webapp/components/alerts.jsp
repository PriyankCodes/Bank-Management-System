<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${not empty sessionScope.flash_success}">
  <div class="alert alert-success" role="alert">${sessionScope.flash_success}</div>
  <c:remove var="flash_success" scope="session"/>
</c:if>
<c:if test="${not empty sessionScope.flash_error}">
  <div class="alert alert-danger" role="alert">${sessionScope.flash_error}</div>
  <c:remove var="flash_error" scope="session"/>
</c:if>
<c:if test="${not empty success}">
  <div class="alert alert-success" role="alert">${success}</div>
</c:if>
<c:if test="${not empty error}">
  <div class="alert alert-danger" role="alert">${error}</div>
</c:if>
