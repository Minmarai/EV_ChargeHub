<%-- Author: Denisha Tamang --%>
<!DOCTYPE html>
<html>
<head>
  <title>Error - ChargeHub Nepal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="error-page">
<main class="error-shell">
  <a class="error-brand" href="${pageContext.request.contextPath}/home">
    <span class="brand-icon" aria-hidden="true"><i class="fa-solid fa-bolt"></i></span>
    <span>ChargeHub Nepal</span>
  </a>

  <div class="error-image-box">
    <img src="${pageContext.request.contextPath}/assets/images/error.png" alt="Error illustration">
  </div>

  <span class="error-code">ERROR 404</span>
  <h1>Oops! Unplugged.</h1>
  <p>It looks like we couldn't find the page or charging station you were looking for. The link might be broken, or the page has moved.</p>

  <div class="error-actions">
    <a class="btn error-home-btn" href="${pageContext.request.contextPath}/home"><i class="fa-solid fa-house"></i> Back to Home</a>
    <a class="btn secondary error-support-btn" href="${pageContext.request.contextPath}/contact"><i class="fa-solid fa-headset"></i> Contact Support</a>
  </div>
</main>
</body>
</html>
