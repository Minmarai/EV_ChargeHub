<%-- Author: Denisha Tamang --%>
<!DOCTYPE html>
<html>
<head>
  <title>About - ChargeHub Nepal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="about-page">
<jsp:include page="../common/header.jsp"/>

<section class="about-hero">
  <h1>Driving Nepal's <span>Electric</span> Journey Forward</h1>
  <p>ChargeHub Nepal is on a mission to make electric vehicle charging accessible, reliable, and seamless across every district, accelerating the nation's transition to green energy.</p>
  <div class="about-hero-media">
    <img src="https://cdn.prod.website-files.com/647a70bc0d93f4f460f783e0/67114e1a8894be064010bb76_DSC06998-1.jpg" alt="EV charging infrastructure">
  </div>
</section>

<section class="about-purpose">
  <div class="about-purpose-text">
    <h2>Our Purpose</h2>
    <div class="about-purpose-line"></div>
    <p>As Nepal embraces sustainable transportation, the need for a robust and intelligent charging infrastructure is paramount. We realized that for EV owners, finding an available, functioning charging station was often a challenge of uncertainty.</p>
    <p>ChargeHub was built to bridge this gap. We provide a centralized platform that connects EV drivers with reliable charging points while giving station operators the tools they need to manage their infrastructure efficiently. We envision a Nepal where range anxiety is a thing of the past.</p>
  </div>
  <div class="about-purpose-grid">
    <article class="about-mini-card">
      <i class="fa-solid fa-location-dot"></i>
      <h3>Nationwide Coverage</h3>
      <p>Expanding networks across all 77 districts.</p>
    </article>
    <article class="about-mini-card">
      <i class="fa-solid fa-bolt"></i>
      <h3>Reliable Energy</h3>
      <p>Ensuring high uptime for all connected stations.</p>
    </article>
    <article class="about-mini-card">
      <i class="fa-regular fa-shield"></i>
      <h3>Secure Platform</h3>
      <p>Safe bookings and transparent transactions.</p>
    </article>
    <article class="about-mini-card">
      <i class="fa-regular fa-user"></i>
      <h3>Community Driven</h3>
      <p>Built for the growing EV community of Nepal.</p>
    </article>
  </div>
</section>

<section class="about-block">
  <h2>Empowering EV Drivers</h2>
  <p>We designed ChargeHub to remove the friction from your daily commute and<br>long-distance travels. Experience true freedom on the road.</p>
  <div class="about-feature-grid">
    <article class="about-feature-card">
      <i class="fa-solid fa-location-dot"></i>
      <h3>Find Stations Instantly</h3>
      <p>Locate the nearest compatible charging stations using district-based smart maps. Filter by connector type and charging speed.</p>
    </article>
    <article class="about-feature-card">
      <i class="fa-regular fa-clock"></i>
      <h3>Guarantee Your Spot</h3>
      <p>Say goodbye to waiting in lines. Book your charging slot in advance and arrive with peace of mind that your charger is ready for you.</p>
    </article>
    <article class="about-feature-card">
      <i class="fa-regular fa-clipboard"></i>
      <h3>Seamless Experience</h3>
      <p>Manage all your bookings, track your charging history, and receive real-time notifications right from your clean, easy-to-use dashboard.</p>
    </article>
  </div>
</section>

<section class="about-block">
  <h2>Elevating Station Operators</h2>
  <p>For businesses and individuals investing in EV infrastructure, ChargeHub<br>provides the visibility and management tools to maximize your return.</p>
  <div class="about-feature-grid">
    <article class="about-feature-card">
      <i class="fa-solid fa-arrow-trend-up"></i>
      <h3>Increase Visibility</h3>
      <p>Put your charging station on the map. Reach thousands of EV drivers actively looking for reliable places to charge your district.</p>
    </article>
    <article class="about-feature-card">
      <i class="fa-solid fa-bolt"></i>
      <h3>Streamline Operations</h3>
      <p>Manage slot availability, set pricing rules, and monitor station status in real-time through a dedicated operator portal.</p>
    </article>
    <article class="about-feature-card">
      <i class="fa-regular fa-chart-bar"></i>
      <h3>Data-Driven Insights</h3>
      <p>Access comprehensive reports on usage patterns, revenue generation, and peak hours to optimize your business strategy.</p>
    </article>
  </div>
</section>

<section class="about-cta-wrap">
  <div class="about-cta">
    <h2>Ready to Join the Revolution?</h2>
    <p>Whether you are an EV driver looking for your next charge, or an operator wanting to list your station, ChargeHub is your partner.</p>
    <div class="about-cta-actions">
      <a class="btn secondary" href="${pageContext.request.contextPath}/register">Create an Account</a>
      <a class="btn secondary" href="${pageContext.request.contextPath}/login">Search Stations First</a>
    </div>
  </div>
</section>

<jsp:include page="../common/footer.jsp"/>
</body>
</html>
