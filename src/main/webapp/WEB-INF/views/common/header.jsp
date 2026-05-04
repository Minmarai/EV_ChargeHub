<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="topbar">
  <a class="brand" href="${pageContext.request.contextPath}/home">
    <span class="brand-icon" aria-hidden="true">
      <svg viewBox="0 0 24 24" role="img" focusable="false">
        <path d="M13.6 2.7L5.8 12h5.9l-1.1 8.9L18.2 12h-5.9l1.3-9.3z"></path>
      </svg>
    </span>
    ChargeHub Nepal
  </a>
  <nav class="nav nav-main">
    <a href="${pageContext.request.contextPath}/home">Home</a>
    <a href="${pageContext.request.contextPath}/about">About</a>
    <a href="${pageContext.request.contextPath}/contact">Contact</a>
  </nav>
  <nav class="nav nav-auth">
    <c:choose>
      <c:when test="${empty sessionScope.userId}">
        <a href="${pageContext.request.contextPath}/login">Login</a>
        <a class="btn" href="${pageContext.request.contextPath}/register">Register</a>
      </c:when>
      <c:otherwise>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
      </c:otherwise>
    </c:choose>
  </nav>
</div>
