<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Kirti Dahal --%>
<html>
<head>
  <title>User Dashboard</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <style>
    .user-dashboard-page {
      background: #F5F7FA;
      color: #333333;
    }

    .user-topbar {
      height: 72px;
      background: #FFFFFF;
      border-bottom: 1px solid #E5E7EB;
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 0 20px;
    }

    .topbar-brand {
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .topbar-brand-mark {
      width: 36px;
      height: 36px;
      border-radius: 10px;
      background: #00B300;
      color: #FFFFFF;
      display: grid;
      place-items: center;
      font-size: 16px;
    }

    .topbar-brand-text {
      margin: 0;
      color: #00B300;
      font-size: 24px;
      line-height: 1;
      font-weight: 800;
      letter-spacing: -0.4px;
    }

    .topbar-actions {
      display: flex;
      align-items: center;
      gap: 18px;
    }

    .topbar-bell {
      color: #9CA3AF;
      font-size: 18px;
      line-height: 1;
    }

    .topbar-avatar {
      width: 40px;
      height: 40px;
      border-radius: 999px;
      border: 1px solid #E5E7EB;
      background: #EEF3FC;
      color: #64748B;
      display: grid;
      place-items: center;
      font-size: 14px;
      font-weight: 700;
      position: relative;
    }

    .topbar-avatar::after {
      content: "";
      width: 9px;
      height: 9px;
      border-radius: 999px;
      border: 2px solid #FFFFFF;
      background: #2E7D32;
      position: absolute;
      right: 1px;
      bottom: 1px;
    }

    .user-dashboard-page .layout {
      min-height: calc(100vh - 72px);
      background: #F5F7FA;
    }

    .user-dashboard-page .user-sidebar {
      width: 315px;
      min-height: calc(100vh - 72px);
      position: sticky;
      top: 72px;
      background: #F8FAFC;
      border-right: 1px solid #E5E7EB;
      padding: 16px;
      display: flex;
      flex-direction: column;
      gap: 8px;
    }

    .user-dashboard-page .user-side-brand,
    .user-dashboard-page .user-side-logout {
      display: none;
    }

    .user-dashboard-page .user-side-nav {
      display: grid;
      gap: 6px;
    }

    .user-dashboard-page .user-side-nav a {
      border-radius: 12px;
      border: 1px solid transparent;
      color: #8C95A3;
      text-decoration: none;
      padding: 12px 14px;
      display: flex;
      align-items: center;
      gap: 12px;
      font-size: 14px;
      font-weight: 500;
      line-height: 1.2;
    }

    .user-dashboard-page .user-side-nav a i {
      width: 28px;
      text-align: center;
      color: #8C95A3;
      font-size: 18px;
      line-height: 1;
    }

    .user-dashboard-page .user-side-nav a:hover {
      background: #FFFFFF;
      border-color: #E5E7EB;
      color: #4B5563;
    }

    .user-dashboard-page .user-side-nav a.active {
      background: #00B300;
      border-color: #00B300;
      color: #FFFFFF;
      font-weight: 700;
    }

    .user-dashboard-page .user-side-nav a.active i {
      color: #FFFFFF;
    }

    .user-dashboard-page .main {
      background: #F5F7FA;
      padding: 18px;
    }

    .dash-wrap {
      display: grid;
      gap: 14px;
    }

    .welcome h1 {
      margin: 0;
      color: #111827;
      font-size: 30px;
      line-height: 1.05;
      letter-spacing: -0.9px;
      font-weight: 800;
      overflow-wrap: anywhere;
    }

    .welcome p {
      margin: 8px 0 0;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.35;
    }

    .stats-grid {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 12px;
    }

    .stat-card {
      background: #FFFFFF;
      border: 1px solid #E5E7EB;
      border-radius: 16px;
      min-height: 170px;
      padding: 18px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04);
    }

    .stat-head {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 8px;
    }

    .stat-head label {
      margin: 0;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.2;
      font-weight: 600;
    }

    .stat-icon {
      width: 50px;
      height: 50px;
      border-radius: 999px;
      display: grid;
      place-items: center;
      font-size: 20px;
      line-height: 1;
    }

    .stat-icon.bookings {
      background: #DDF3E0;
      color: #00B300;
    }

    .stat-icon.upcoming,
    .stat-icon.payments {
      background: #F3F4F6;
      color: #1F2937;
    }

    .stat-icon.saved {
      background: #FDEDED;
      color: #EF4444;
    }

    .stat-card h2 {
      margin: 0;
      color: #111827;
      font-size: 32px;
      line-height: 1;
      letter-spacing: -0.8px;
      font-weight: 800;
    }

    .stat-card p {
      margin: 8px 0 0;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.35;
      font-weight: 500;
    }

    .grid-two {
      display: grid;
      grid-template-columns: 2.2fr 1.05fr;
      gap: 14px;
    }

    .panel {
      background: #FFFFFF;
      border: 1px solid #E5E7EB;
      border-radius: 16px;
      overflow: hidden;
      box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04);
    }

    .panel-head {
      padding: 18px;
      border-bottom: 1px solid #E5E7EB;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 10px;
      flex-wrap: wrap;
    }

    .panel-head h3 {
      margin: 0;
      color: #111827;
      font-size: 18px;
      line-height: 1.1;
      letter-spacing: -0.3px;
      font-weight: 800;
    }

    .panel-head p {
      margin: 5px 0 0;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.3;
      font-weight: 500;
    }

    .view-btn {
      height: 44px;
      border-radius: 13px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #374151;
      text-decoration: none;
      padding: 0 16px;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      font-size: 13px;
      line-height: 1;
      font-weight: 700;
    }

    .view-btn:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F8FBFF;
    }

    .recent-table {
      width: 100%;
      border-collapse: collapse;
      border: 0;
    }

    .recent-table-wrap {
      width: 100%;
      overflow-x: auto;
      -webkit-overflow-scrolling: touch;
    }

    .recent-table th,
    .recent-table td {
      border-bottom: 1px solid #EDF1F6;
      padding: 14px 18px;
      text-align: left;
      vertical-align: middle;
    }

    .recent-table th {
      color: #8C95A3;
      background: #FFFFFF;
      text-transform: none;
      letter-spacing: 0;
      font-size: 14px;
      font-weight: 700;
    }

    .recent-table tbody tr:last-child td {
      border-bottom: 0;
    }

    .id-cell {
      color: #8C95A3;
      font-size: 14px;
      line-height: 1.2;
      font-weight: 700;
    }

    .station-cell strong {
      display: block;
      color: #111827;
      font-size: 16px;
      line-height: 1.25;
      font-weight: 700;
    }

    .station-cell small {
      display: inline-flex;
      align-items: center;
      gap: 5px;
      margin-top: 3px;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.2;
    }

    .datetime-cell strong {
      display: block;
      color: #111827;
      font-size: 14px;
      line-height: 1.2;
      font-weight: 600;
    }

    .badge-pill {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-width: 92px;
      padding: 5px 12px;
      border-radius: 999px;
      border: 1px solid #E5E7EB;
      background: #F8FAFC;
      color: #374151;
      font-size: 14px;
      line-height: 1;
      font-weight: 700;
      text-transform: capitalize;
    }

    .badge-pill.pending,
    .badge-pill.confirmed {
      color: #2E7D32;
      border-color: #C5E8CD;
      background: #ECF8EE;
    }

    .badge-pill.completed {
      color: #111827;
      border-color: #E5E7EB;
      background: #F8FAFC;
    }

    .badge-pill.cancelled {
      color: #EF4444;
      border-color: #F7C5C5;
      background: #FDEDED;
    }

    .detail-link {
      color: #111827;
      text-decoration: none;
      font-size: 14px;
      line-height: 1;
      font-weight: 700;
    }

    .detail-link:hover {
      color: #1976D2;
    }

    .quick-title {
      display: inline-flex;
      align-items: center;
      gap: 8px;
    }

    .quick-title i {
      color: #00B300;
      font-size: 16px;
    }

    .quick-list {
      display: grid;
      padding: 8px 0;
    }

    .quick-item {
      display: grid;
      grid-template-columns: 50px 1fr 20px;
      gap: 14px;
      align-items: center;
      border-bottom: 1px solid #EDF1F6;
      padding: 14px 18px;
      text-decoration: none;
    }

    .quick-item:last-child {
      border-bottom: 0;
    }

    .quick-item:hover {
      background: #F8FBFF;
    }

    .quick-icon {
      width: 44px;
      height: 44px;
      border-radius: 999px;
      background: #F3F4F6;
      color: #1F2937;
      display: grid;
      place-items: center;
      font-size: 17px;
      line-height: 1;
    }

    .quick-body strong {
      display: block;
      color: #111827;
      font-size: 14px;
      line-height: 1.2;
      font-weight: 700;
    }

    .quick-body small {
      display: block;
      margin-top: 3px;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.3;
      font-weight: 500;
    }

    .quick-arrow {
      color: #A1AAB8;
      font-size: 18px;
      line-height: 1;
      text-align: right;
      font-weight: 600;
    }

    .empty-state {
      color: #6B7280;
      font-size: 16px;
      line-height: 1.4;
      padding: 22px 18px;
    }

    @media (max-width: 1340px) {
      .stats-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }

      .grid-two {
        grid-template-columns: 1fr;
      }
    }

    @media (max-width: 980px) {
      .user-dashboard-page .layout {
        flex-direction: column;
      }

      .user-dashboard-page .user-sidebar {
        position: static;
        width: 100%;
        min-height: auto;
        padding: 10px 12px;
        overflow: hidden;
      }

      .user-dashboard-page .user-side-nav {
        display: flex;
        gap: 8px;
        overflow-x: auto;
        padding-bottom: 2px;
        scrollbar-width: thin;
        -webkit-overflow-scrolling: touch;
      }

      .user-dashboard-page .user-side-nav a {
        flex: 0 0 auto;
        min-width: max-content;
        padding: 10px 12px;
        border-radius: 10px;
      }

      .user-dashboard-page .main {
        padding: 14px;
      }

      .welcome h1 {
        font-size: 28px;
      }

      .welcome p {
        font-size: 13px;
      }
    }

    @media (max-width: 680px) {
      .stats-grid {
        grid-template-columns: 1fr;
      }

      .grid-two {
        gap: 10px;
      }

      .panel-head {
        padding-top: 14px;
        padding-bottom: 14px;
      }

      .panel-head > div {
        width: 100%;
      }

      .view-btn {
        width: 100%;
        justify-content: center;
      }
    }

    @media (max-width: 640px) {
      .user-topbar {
        height: 64px;
        padding: 0 12px;
      }

      .topbar-brand {
        gap: 8px;
      }

      .topbar-brand-mark {
        width: 30px;
        height: 30px;
        border-radius: 8px;
        font-size: 13px;
      }

      .topbar-brand-text {
        font-size: 18px;
        max-width: 160px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }

      .topbar-avatar {
        width: 34px;
        height: 34px;
        font-size: 12px;
      }

      .user-dashboard-page .layout,
      .user-dashboard-page .user-sidebar {
        min-height: auto;
      }

      .user-dashboard-page .main {
        padding: 10px;
      }

      .welcome h1 {
        font-size: 24px;
      }

      .stat-card {
        min-height: 140px;
        padding: 14px;
      }

      .stat-card h2 {
        font-size: 26px;
      }

      .stat-icon {
        width: 42px;
        height: 42px;
        font-size: 16px;
      }

      .panel-head,
      .quick-item,
      .empty-state {
        padding-left: 12px;
        padding-right: 12px;
      }

      .recent-table {
        min-width: 620px;
      }
    }

    @media (max-width: 420px) {
      .user-topbar {
        padding: 0 10px;
      }

      .topbar-brand-text {
        max-width: 126px;
        font-size: 16px;
      }

      .topbar-actions {
        gap: 10px;
      }

      .welcome h1 {
        font-size: 21px;
      }

      .welcome p,
      .panel-head p,
      .quick-body small {
        font-size: 12px;
      }

      .quick-item {
        grid-template-columns: 42px 1fr 14px;
        gap: 10px;
      }

      .quick-icon {
        width: 38px;
        height: 38px;
        font-size: 14px;
      }
    }
  </style>
</head>
<body class="user-dashboard-page">
<header class="user-topbar">
  <div class="topbar-brand">
    <span class="topbar-brand-mark"><i class="fa-solid fa-bolt"></i></span>
    <h1 class="topbar-brand-text">ChargeHub Nepal</h1>
  </div>

  <div class="topbar-actions">
    <a class="topbar-avatar" href="${pageContext.request.contextPath}/user/profile" aria-label="Open profile">${sessionScope.fullName != null ? fn:substring(sessionScope.fullName, 0, 1) : 'U'}</a>
  </div>
</header>

<div class="layout">
  <jsp:include page="../common/user-sidebar.jsp"/>

  <main class="main">
    <div class="dash-wrap">
      <section class="welcome">
        <h1>Welcome back, ${sessionScope.fullName}! <span role="img" aria-label="wave">&#128075;</span></h1>
        <p>Here is what's happening with your EV charging activities today.</p>
      </section>

      <section class="stats-grid">
        <article class="stat-card">
          <div class="stat-head">
            <label>Total Bookings</label>
            <span class="stat-icon bookings"><i class="fa-regular fa-calendar-check"></i></span>
          </div>
          <div>
            <h2>${bookingCount}</h2>
            <p>Total booking sessions</p>
          </div>
        </article>

        <article class="stat-card">
          <div class="stat-head">
            <label>Upcoming Bookings</label>
            <span class="stat-icon upcoming"><i class="fa-regular fa-clock"></i></span>
          </div>
          <div>
            <h2>${upcomingBookings}</h2>
            <p>Next scheduled charging visits</p>
          </div>
        </article>

        <article class="stat-card">
          <div class="stat-head">
            <label>Total Payments</label>
            <span class="stat-icon payments"><i class="fa-regular fa-credit-card"></i></span>
          </div>
          <div>
            <h2>Rs. ${totalPaymentAmount}</h2>
            <p>Across all stations</p>
          </div>
        </article>

        <article class="stat-card">
          <div class="stat-head">
            <label>Saved Stations</label>
            <span class="stat-icon saved"><i class="fa-regular fa-heart"></i></span>
          </div>
          <div>
            <h2>${favCount}</h2>
            <p>In your favorites list</p>
          </div>
        </article>
      </section>

      <section class="grid-two">
        <article class="panel">
          <div class="panel-head">
            <div>
              <h3>Recent Bookings</h3>
              <p>Your latest charging station reservations.</p>
            </div>
            <a class="view-btn" href="${pageContext.request.contextPath}/user/bookings">View All <i class="fa-solid fa-chevron-right"></i></a>
          </div>

          <c:choose>
            <c:when test="${not empty bookings}">
              <div class="recent-table-wrap">
                <table class="recent-table">
                  <thead>
                  <tr>
                    <th>ID</th>
                    <th>Station</th>
                    <th>Date &amp; Time</th>
                    <th>Status</th>
                    <th>Action</th>
                  </tr>
                  </thead>
                  <tbody>
                  <c:forEach var="b" items="${bookings}" begin="0" end="4">
                    <tr>
                      <td><span class="id-cell">CHN-${b.bookingId}</span></td>
                      <td class="station-cell">
                        <strong>${b.stationName}</strong>
                        <small><i class="fa-solid fa-location-dot"></i>Charging Station</small>
                      </td>
                      <td class="datetime-cell"><strong>${b.slotInfo}</strong></td>
                      <td><span class="badge-pill ${fn:toLowerCase(b.bookingStatus)}">${b.bookingStatus}</span></td>
                      <td><a class="detail-link" href="${pageContext.request.contextPath}/user/booking?id=${b.bookingId}">Details</a></td>
                    </tr>
                  </c:forEach>
                  </tbody>
                </table>
              </div>
            </c:when>
            <c:otherwise>
              <div class="empty-state">No bookings yet. Start by searching stations and reserve your first slot.</div>
            </c:otherwise>
          </c:choose>
        </article>

        <article class="panel">
          <div class="panel-head">
            <div>
              <h3 class="quick-title"><i class="fa-solid fa-bolt"></i>Quick Actions</h3>
              <p>Fast access to common tasks.</p>
            </div>
          </div>

          <div class="quick-list">
            <a class="quick-item" href="${pageContext.request.contextPath}/user/stations">
              <span class="quick-icon"><i class="fa-solid fa-magnifying-glass"></i></span>
              <span class="quick-body"><strong>Search Stations</strong><small>Find available chargers near you</small></span>
              <span class="quick-arrow">&gt;</span>
            </a>
            <a class="quick-item" href="${pageContext.request.contextPath}/user/bookings">
              <span class="quick-icon"><i class="fa-solid fa-clock-rotate-left"></i></span>
              <span class="quick-body"><strong>Booking History</strong><small>Review your past charging sessions</small></span>
              <span class="quick-arrow">&gt;</span>
            </a>
            <a class="quick-item" href="${pageContext.request.contextPath}/user/payments">
              <span class="quick-icon"><i class="fa-regular fa-credit-card"></i></span>
              <span class="quick-body"><strong>Payment History</strong><small>View invoices and transactions</small></span>
              <span class="quick-arrow">&gt;</span>
            </a>
            <a class="quick-item" href="${pageContext.request.contextPath}/user/favorites">
              <span class="quick-icon"><i class="fa-regular fa-heart"></i></span>
              <span class="quick-body"><strong>Favorites</strong><small>Manage your saved charging spots</small></span>
              <span class="quick-arrow">&gt;</span>
            </a>
            <a class="quick-item" href="${pageContext.request.contextPath}/user/profile">
              <span class="quick-icon"><i class="fa-regular fa-user"></i></span>
              <span class="quick-body"><strong>Profile Settings</strong><small>Update your vehicle and personal info</small></span>
              <span class="quick-arrow">&gt;</span>
            </a>
          </div>
        </article>
      </section>
    </div>
  </main>
</div>
</body>
</html>
