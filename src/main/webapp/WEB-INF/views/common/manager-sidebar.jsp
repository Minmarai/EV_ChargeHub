<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Rijam Shrestha --%>
<aside id="manager-sidebar-nav" class="manager-sidebar">
  <div class="manager-brand">
    <div class="manager-brand-icon"><i class="fa-solid fa-bolt"></i></div>
    <span>ChargeHub Nepal - Manager</span>
  </div>

  <nav class="manager-nav">
    <a class="${fn:contains(pageContext.request.requestURI, '/dashboard') ? 'active' : ''}" href="${pageContext.request.contextPath}/station-manager/dashboard"><i class="fa-solid fa-border-all"></i>Dashboard</a>
    <a class="${fn:contains(pageContext.request.requestURI, '/stations') || fn:contains(pageContext.request.requestURI, '/station-form') ? 'active' : ''}" href="${pageContext.request.contextPath}/station-manager/stations"><i class="fa-solid fa-location-dot"></i>Stations</a>
    <a class="${fn:contains(pageContext.request.requestURI, '/slots') || fn:contains(pageContext.request.requestURI, '/slot-form') ? 'active' : ''}" href="${pageContext.request.contextPath}/station-manager/slots"><i class="fa-regular fa-calendar-days"></i>Slots</a>
    <a class="${fn:contains(pageContext.request.requestURI, '/bookings') || fn:contains(pageContext.request.requestURI, '/booking') ? 'active' : ''}" href="${pageContext.request.contextPath}/station-manager/bookings"><i class="fa-regular fa-bookmark"></i>Bookings</a>
    <a class="${fn:contains(pageContext.request.requestURI, '/payments') || fn:contains(pageContext.request.requestURI, '/payment') ? 'active' : ''}" href="${pageContext.request.contextPath}/station-manager/payments"><i class="fa-regular fa-credit-card"></i>Payments</a>
    <a class="${fn:contains(pageContext.request.requestURI, '/reports') ? 'active' : ''}" href="${pageContext.request.contextPath}/station-manager/reports"><i class="fa-solid fa-chart-column"></i>Reports</a>
  </nav>

  <a class="manager-logout" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket"></i>Log Out</a>
</aside>

<button type="button" class="mobile-nav-toggle manager-mobile-toggle" aria-label="Toggle navigation" aria-controls="manager-sidebar-nav" aria-expanded="false">
  <i class="fa-solid fa-bars"></i>
</button>
<div class="mobile-nav-backdrop manager-mobile-backdrop" aria-hidden="true"></div>

<script>
  (function () {
    const body = document.body;
    const toggle = document.querySelector('.manager-mobile-toggle');
    const backdrop = document.querySelector('.manager-mobile-backdrop');
    const navLinks = document.querySelectorAll('.manager-sidebar a');
    const openClass = 'manager-mobile-nav-open';

    if (!toggle || !backdrop) {
      return;
    }

    function setOpenState(isOpen) {
      body.classList.toggle(openClass, isOpen);
      toggle.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
    }

    toggle.addEventListener('click', function () {
      setOpenState(!body.classList.contains(openClass));
    });

    backdrop.addEventListener('click', function () {
      setOpenState(false);
    });

    navLinks.forEach(function (link) {
      link.addEventListener('click', function () {
        setOpenState(false);
      });
    });

    document.addEventListener('keydown', function (event) {
      if (event.key === 'Escape') {
        setOpenState(false);
      }
    });
  })();
</script>
