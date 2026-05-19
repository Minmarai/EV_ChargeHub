<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Rijam Shrestha --%>
<aside id="admin-sidebar-nav" class="admin-sidebar">
  <div class="admin-brand">
    <span class="admin-brand-icon"><i class="fa-solid fa-bolt"></i></span>
    <span>ChargeHub</span>
  </div>

  <nav class="admin-nav">
    <a class="${fn:contains(pageContext.request.requestURI, '/dashboard') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa-solid fa-border-all"></i>Dashboard</a>
    <a class="${fn:contains(pageContext.request.requestURI, '/users') || fn:contains(pageContext.request.requestURI, '/user-form') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/users"><i class="fa-regular fa-user"></i>Users</a>
    <a class="${fn:contains(pageContext.request.requestURI, '/managers') || fn:contains(pageContext.request.requestURI, '/manager-form') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/managers"><i class="fa-solid fa-user-gear"></i>Station Managers</a>
    <a class="${fn:contains(pageContext.request.requestURI, '/stations') || fn:contains(pageContext.request.requestURI, '/station-form') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/stations"><i class="fa-solid fa-location-dot"></i>Stations</a>
    <a class="${fn:contains(pageContext.request.requestURI, '/slots') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/slots"><i class="fa-regular fa-calendar-days"></i>Slots</a>
    <a class="${fn:contains(pageContext.request.requestURI, '/bookings') || fn:contains(pageContext.request.requestURI, '/booking') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/bookings"><i class="fa-regular fa-bookmark"></i>Bookings</a>
    <a class="${fn:contains(pageContext.request.requestURI, '/payments') || fn:contains(pageContext.request.requestURI, '/payment') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/payments"><i class="fa-regular fa-credit-card"></i>Payments</a>
    <a class="${fn:contains(pageContext.request.requestURI, '/reviews') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/reviews"><i class="fa-regular fa-star"></i>Reviews</a>
    <a class="${fn:contains(pageContext.request.requestURI, '/messages') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/messages"><i class="fa-regular fa-envelope"></i>Messages</a>
    <a class="${fn:contains(pageContext.request.requestURI, '/reports') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/reports"><i class="fa-solid fa-chart-column"></i>Reports</a>
  </nav>

  <div class="admin-sidebar-footer">
    <a href="${pageContext.request.contextPath}/admin/reports"><i class="fa-solid fa-gear"></i>Settings</a>
    <a class="logout" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket"></i>Logout</a>
  </div>
</aside>

<button type="button" class="mobile-nav-toggle admin-mobile-toggle" aria-label="Toggle navigation" aria-controls="admin-sidebar-nav" aria-expanded="false">
  <i class="fa-solid fa-bars"></i>
</button>
<div class="mobile-nav-backdrop admin-mobile-backdrop" aria-hidden="true"></div>

<script>
  (function () {
    const body = document.body;
    const toggle = document.querySelector('.admin-mobile-toggle');
    const backdrop = document.querySelector('.admin-mobile-backdrop');
    const navLinks = document.querySelectorAll('.admin-sidebar a');
    const openClass = 'admin-mobile-nav-open';

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
