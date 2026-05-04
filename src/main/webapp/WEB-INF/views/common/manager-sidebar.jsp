<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<aside class="manager-sidebar">
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
    <a class="${fn:contains(pageContext.request.requestURI, '/schedule') ? 'active' : ''}" href="${pageContext.request.contextPath}/station-manager/schedule"><i class="fa-regular fa-clock"></i>Schedule</a>
    <a class="${fn:contains(pageContext.request.requestURI, '/reports') ? 'active' : ''}" href="${pageContext.request.contextPath}/station-manager/reports"><i class="fa-solid fa-chart-column"></i>Reports</a>
  </nav>

  <a class="manager-logout" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket"></i>Log Out</a>
</aside>
