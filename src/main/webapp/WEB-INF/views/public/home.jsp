<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>ChargeHub Nepal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="home-page">
<jsp:include page="../common/header.jsp"/>

<section class="home-hero">
  <div class="hero-mark"><i class="fa-solid fa-bolt"></i></div>
  <div class="hero-inner">
    <span class="hero-pill"><i class="fa-solid fa-bolt"></i> Powering Nepal's EV Future</span>
    <h1>Find &amp; Book EV Charging Stations <span>Across Nepal</span></h1>
    <p>ChargeHub Nepal is your reliable platform to locate available charging slots, reserve your spot, and travel with confidence across all districts.</p>
    <div class="hero-actions">
      <a class="btn" href="${pageContext.request.contextPath}/register">Search Stations <i class="fa-solid fa-arrow-right"></i></a>
      <a class="btn secondary" href="${pageContext.request.contextPath}/login">Login</a>
      <a class="btn secondary" href="${pageContext.request.contextPath}/register">Register</a>
    </div>
    <div class="hero-stats">
      <div><strong>77+</strong><span>Districts Covered</span></div>
      <div><strong>500+</strong><span>Active Stations</span></div>
      <div><strong>24/7</strong><span>Support Available</span></div>
      <div><strong>10k+</strong><span>Happy EV Owners</span></div>
    </div>
  </div>
</section>

<section class="home-block">
  <h2>Everything You Need to Drive Electric</h2>
  <p class="home-sub">ChargeHub Nepal provides a comprehensive suite of tools designed to make your EV experience smooth, reliable, and hassle-free.</p>
  <div class="feature-grid">
    <article class="feature-box">
      <span class="feature-badge"><i class="fa-solid fa-location-dot"></i></span>
      <h3>District-Based Search</h3>
      <p>Easily locate charging stations across all 77 districts of Nepal. Filter by connector type, availability, and distance to find the perfect spot for your journey.</p>
    </article>
    <article class="feature-box">
      <span class="feature-badge"><i class="fa-regular fa-calendar-check"></i></span>
      <h3>Instant Slot Booking</h3>
      <p>Reserve your charging time in advance. No more waiting in lines. Secure your slot and arrive knowing your charger is ready and waiting for you.</p>
    </article>
    <article class="feature-box">
      <span class="feature-badge"><i class="fa-regular fa-credit-card"></i></span>
      <h3>Secure Payments</h3>
      <p>Seamless and secure digital payments integrated directly into the app. Pay for your charge effortlessly using local wallets or standard cards.</p>
    </article>
    <article class="feature-box">
      <span class="feature-badge"><i class="fa-regular fa-circle-check"></i></span>
      <h3>Verified Stations</h3>
      <p>All stations on our platform are verified for reliability and safety. Access detailed information, user reviews, and real-time status updates.</p>
    </article>
  </div>
</section>

<section class="home-about">
  <div class="about-copy">
    <p class="micro"><i class="fa-regular fa-clock"></i> The Future Is Now</p>
    <h2>Accelerating Nepal's Transition to Sustainable Mobility</h2>
    <p>As Nepal moves towards a greener future, reliable EV infrastructure is paramount. ChargeHub Nepal bridges the gap between EV owners and charging stations, providing a centralized, easy-to-use platform that removes range anxiety and simplifies the charging experience.</p>
    <p>Whether you are commuting within Kathmandu or planning a road trip to Pokhara, we ensure you stay powered up and connected.</p>
    <a class="btn secondary" href="${pageContext.request.contextPath}/about">Learn More About Us</a>
  </div>
  <div class="about-visual">
    <img class="about-photo" src="https://cdn.prod.website-files.com/5ec85520c4dfff034b036be2/68d711fb2101e287bf7b6224_Hyundia-EV-parked-%20hero.webp" alt="Electric car charging at a station" loading="lazy" referrerpolicy="no-referrer">
    <div class="station-chip">
      <span><i class="fa-solid fa-bolt"></i></span>
      <div>
        <strong>Station 42, Lalitpur</strong>
        <small>2 Slots Available Now</small>
      </div>
    </div>
  </div>
</section>

<section class="home-cta-wrap">
  <div class="home-cta">
    <h2>Ready to Hit the Road?</h2>
    <p>Join thousands of EV drivers across Nepal who use ChargeHub to keep their vehicles powered. Create your account today to start booking slots instantly.</p>
    <div class="cta-actions">
      <a class="btn secondary" href="${pageContext.request.contextPath}/register">Create Free Account</a>
      <a class="btn secondary" href="${pageContext.request.contextPath}/contact">Contact Support</a>
    </div>
  </div>
</section>

<jsp:include page="../common/footer.jsp"/>
</body>
</html>
