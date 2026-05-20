<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Author: Denisha Tamang --%>
<!DOCTYPE html>
<html>
<head>
  <title>Contact - ChargeHub Nepal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="contact-page">
<jsp:include page="../common/header.jsp"/>

<section class="contact-hero">
  <h1>Get in Touch</h1>
  <p>Have questions about our charging stations or need support with your account? Our team is here to help. Reach out to us through any of the channels below.</p>
</section>

<section class="contact-main">
  <div class="contact-left">
    <div class="contact-map">
      <img src="${pageContext.request.contextPath}/assets/images/contact.png" alt="Charging network map">
    </div>

    <h2>Contact Information</h2>

    <div class="contact-info-list">
      <div class="contact-info-item">
        <div class="contact-icon"><i class="fa-solid fa-location-dot"></i></div>
        <div>
          <h3>Headquarters</h3>
          <p>123 Green Energy Avenue,<br>Kathmandu, Bagmati Province, Nepal</p>
        </div>
      </div>

      <div class="contact-info-item">
        <div class="contact-icon"><i class="fa-solid fa-phone"></i></div>
        <div>
          <h3>Phone Support</h3>
          <p>+977-9815672390 (Mobile)<br>+025-527189 (Telephone)</p>
        </div>
      </div>

      <div class="contact-info-item">
        <div class="contact-icon"><i class="fa-regular fa-envelope"></i></div>
        <div>
          <h3>Email Address</h3>
          <p>support@chargehub.com.np<br>info@chargehub.com.np</p>
        </div>
      </div>

      <div class="contact-divider"></div>

      <div class="contact-info-item">
        <div class="contact-icon"><i class="fa-regular fa-clock"></i></div>
        <div>
          <h3>Operating Hours</h3>
          <p>Sunday - Friday: 9:00 AM - 6:00 PM<br>Emergency Support: 24/7</p>
        </div>
      </div>
    </div>
  </div>

  <div class="contact-right">
    <div class="contact-form-card">
      <h2>Send us a message</h2>
      <p>Fill out the form below and our support team will get back to you within 24 hours.</p>

      <c:if test="${not empty success}">
        <div id="contact-success-alert" class="alert success">${success}</div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert error">${error}</div>
      </c:if>

      <form method="post" action="${pageContext.request.contextPath}/contact" class="contact-form">
        <div class="contact-grid">
          <div>
            <label for="name">Full Name</label>
            <input id="name" class="input contact-input" name="name" placeholder="John Doe" required>
          </div>
          <div>
            <label for="email">Email Address</label>
            <input id="email" class="input contact-input" type="email" name="email" placeholder="john@example.com" required>
          </div>
        </div>

        <div class="contact-field">
          <label for="subject">Subject</label>
          <input id="subject" class="input contact-input" name="subject" placeholder="How can we help you?" required>
        </div>

        <div class="contact-field">
          <label for="message">Message</label>
          <textarea id="message" class="input contact-input contact-textarea" name="message" placeholder="Please describe your issue or inquiry in detail..." required></textarea>
        </div>

        <button class="btn contact-submit" type="submit">Send Message <i class="fa-regular fa-paper-plane"></i></button>
      </form>
    </div>
  </div>
</section>

<jsp:include page="../common/footer.jsp"/>
<script>
  (function () {
    var successAlert = document.getElementById('contact-success-alert');
    if (!successAlert) {
      return;
    }

    successAlert.style.transition = 'opacity 0.4s ease';
    setTimeout(function () {
      successAlert.style.opacity = '0';
      setTimeout(function () {
        successAlert.remove();
      }, 400);
    }, 3000);
  })();
</script>
</body>
</html>
