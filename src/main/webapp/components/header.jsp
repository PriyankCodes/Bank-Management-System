<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  String pageTitle = "Bank Portal";
  if (request.getAttribute("pageTitle") != null)
    pageTitle = (String)request.getAttribute("pageTitle");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title><%= pageTitle %></title>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <!-- Bootstrap 5 CDN -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Optionally, include your theme.css if used -->
  <c:if test="${not empty pageContext.request.contextPath}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css" />
  </c:if>
</head>
<body>
