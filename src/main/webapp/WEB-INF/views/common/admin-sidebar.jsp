<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<aside class="admin-sidebar">
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
