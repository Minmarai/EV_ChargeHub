<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Author: Denisha Tamang --%>
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Login - ChargeHub Nepal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="auth-page">
<main class="auth-shell">
  <section class="auth-card">
    <div class="auth-logo-box">
      <i class="fa-solid fa-bolt"></i>
    </div>
    <h1>Welcome back</h1>
    <p class="auth-subtitle">Enter your credentials to access your ChargeHub account.</p>

    <c:if test="${not empty error}">
      <div class="alert error">${error}</div>
    </c:if>
    <c:if test="${not empty success}">
      <div class="alert success">${success}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/login" class="auth-form">
      <div class="auth-group">
        <label for="email">Email address</label>
        <div class="auth-input-wrap">
          <i class="fa-regular fa-envelope"></i>
          <input id="email" class="input auth-input" type="email" name="email" placeholder="ram@example.com" required>
        </div>
      </div>

      <div class="auth-group">
        <div class="auth-row">
          <label for="password">Password</label>
          <a class="auth-forgot" href="${pageContext.request.contextPath}/contact">Forgot password?</a>
        </div>
        <div class="auth-input-wrap">
          <i class="fa-solid fa-lock"></i>
          <input id="password" class="input auth-input" type="password" name="password" placeholder="Enter your password" required minlength="8">
        </div>
      </div>

      <button class="btn auth-submit" type="submit">Sign in to account <i class="fa-solid fa-arrow-right"></i></button>
    </form>

    <p class="auth-meta">Don't have an account? <a href="${pageContext.request.contextPath}/register">Create one now</a></p>
  </section>

  <div class="auth-links">
    <a href="#">Terms of Service</a>
    <span>&middot;</span>
    <a href="#">Privacy Policy</a>
    <span>&middot;</span>
    <a href="${pageContext.request.contextPath}/contact">Contact Support</a>
  </div>
</main>
<script>
  (function () {
    var params = new URLSearchParams(window.location.search);
    var scale = parseFloat(params.get('scale'));
    if (!isNaN(scale) && scale >= 0.85 && scale <= 1.25) {
      document.documentElement.style.setProperty('--auth-scale', String(scale));
    }
  })();
</script>
</body>
</html>
