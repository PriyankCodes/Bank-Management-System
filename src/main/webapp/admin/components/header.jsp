<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title><c:out value="${param.pageTitle != null ? param.pageTitle : 'Admin Panel'}"/></title>
  
  <!-- Bootstrap CSS CDN -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  
  <!-- Optional custom CSS -->
  <link href="${pageContext.request.contextPath}/css/admin-style.css" rel="stylesheet"/>
</head>
<body>
