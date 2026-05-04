<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Register - ChargeHub Nepal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="register-page">
<main class="register-shell">
  <a class="register-brand" href="${pageContext.request.contextPath}/home">
    <span class="brand-icon"><i class="fa-solid fa-bolt"></i></span>
    <span>ChargeHub Nepal</span>
  </a>
  <h1>Create an Account</h1>
  <p class="register-subtitle">Join ChargeHub Nepal to start booking EV charging slots across the country.</p>

  <section class="register-card">
    <a class="register-back" href="${pageContext.request.contextPath}/login"><i class="fa-solid fa-arrow-left"></i> Back to Login</a>
    <div class="register-head">
      <h2>Registration Form</h2>
      <p>Please fill in your details to create a normal user account.</p>
    </div>

    <c:if test="${not empty error}">
      <div class="alert error">${error}</div>
    </c:if>
    <c:if test="${not empty success}">
      <div class="alert success">${success}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/register" class="register-form">
      <div class="register-section">
        <h3><i class="fa-regular fa-user"></i> PERSONAL INFORMATION</h3>
        <div class="register-grid">
          <div class="register-field">
            <label for="fullName">Full Name <span>*</span></label>
            <div class="register-input-wrap">
              <i class="fa-regular fa-user"></i>
              <input id="fullName" class="input register-input" name="fullName" placeholder="Ram Bahadur" required>
            </div>
          </div>
          <div class="register-field">
            <label for="email">Email Address <span>*</span></label>
            <div class="register-input-wrap">
              <i class="fa-regular fa-envelope"></i>
              <input id="email" class="input register-input" type="email" name="email" placeholder="ram@example.com" required>
            </div>
          </div>
          <div class="register-field">
            <label for="phone">Phone Number <span>*</span></label>
            <div class="register-input-wrap">
              <i class="fa-solid fa-phone"></i>
              <input id="phone" class="input register-input" name="phone" placeholder="+977 98XXXXXXXX" required>
            </div>
          </div>
          <div class="register-field">
            <label for="address">Address</label>
            <div class="register-input-wrap">
              <i class="fa-solid fa-location-dot"></i>
              <input id="address" class="input register-input" name="address" placeholder="Kathmandu, Bagmati">
            </div>
          </div>
        </div>
      </div>

      <div class="register-section">
        <h3><i class="fa-solid fa-car-side"></i> VEHICLE INFORMATION</h3>
        <div class="register-grid register-grid-single">
          <div class="register-field">
            <label for="vehicleNumber">Vehicle Number <small>(Optional)</small></label>
            <div class="register-input-wrap">
              <i class="fa-solid fa-car-side"></i>
              <input id="vehicleNumber" class="input register-input" name="vehicleNumber" placeholder="Ba 1 Cha 1234">
            </div>
            <p class="register-hint">Helps in quicker verification at stations.</p>
          </div>
        </div>
      </div>

      <div class="register-section">
        <h3><i class="fa-solid fa-lock"></i> SECURITY</h3>
        <div class="register-grid">
          <div class="register-field">
            <label for="password">Password <span>*</span></label>
            <div class="register-input-wrap">
              <i class="fa-solid fa-lock"></i>
              <input id="password" class="input register-input" type="password" name="password" placeholder="Enter your password" required minlength="8">
              <button class="register-toggle" type="button" data-target="password" aria-label="Show password">
                <i class="fa-regular fa-eye"></i>
              </button>
            </div>
            <p class="register-hint">Must be at least 8 characters.</p>
          </div>
          <div class="register-field">
            <label for="confirmPassword">Confirm Password <span>*</span></label>
            <div class="register-input-wrap">
              <i class="fa-solid fa-lock"></i>
              <input id="confirmPassword" class="input register-input" type="password" name="confirmPassword" placeholder="Re-enter password" required minlength="8">
              <button class="register-toggle" type="button" data-target="confirmPassword" aria-label="Show password">
                <i class="fa-regular fa-eye"></i>
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="register-submit-wrap">
        <button class="btn register-submit" type="submit">Create Account</button>
      </div>
    </form>

    <p class="register-meta">Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in here</a></p>
    <p class="register-legal">By registering, you agree to our <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a>.</p>
  </section>
</main>
<script>
  document.querySelectorAll('.register-toggle').forEach(function(button) {
    button.addEventListener('click', function() {
      var input = document.getElementById(button.getAttribute('data-target'));
      if (!input) return;
      var icon = button.querySelector('i');
      var show = input.type === 'password';
      input.type = show ? 'text' : 'password';
      icon.className = show ? 'fa-regular fa-eye-slash' : 'fa-regular fa-eye';
      button.setAttribute('aria-label', show ? 'Hide password' : 'Show password');
    });
  });
</script>
</body>
</html>
