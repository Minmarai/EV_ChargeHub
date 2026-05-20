<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Denisha Tamang --%>
<html>
<head>
  <title>Booking History</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <style>
    .user-bookings-page {
      --primary-green: #2E7D32;
      --secondary-blue: #1976D2;
      --accent-orange: #FF9800;
      --light-bg: #F5F7FA;
      --white-card: #FFFFFF;
      --text-dark: #333333;
      background: var(--light-bg);
      color: var(--text-dark);
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
      overflow: hidden;
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

    .user-bookings-page .layout {
      min-height: calc(100vh - 72px);
      background: #F5F7FA;
    }

    .user-bookings-page .user-sidebar {
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

    .user-bookings-page .user-side-brand,
    .user-bookings-page .user-side-logout {
      display: none;
    }

    .user-bookings-page .user-side-nav {
      display: grid;
      gap: 6px;
    }

    .user-bookings-page .user-side-nav a {
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

    .user-bookings-page .user-side-nav a i {
      width: 28px;
      text-align: center;
      color: #8C95A3;
      font-size: 18px;
      line-height: 1;
    }

    .user-bookings-page .user-side-nav a:hover {
      background: #FFFFFF;
      border-color: #E5E7EB;
      color: #4B5563;
    }

    .user-bookings-page .user-side-nav a.active {
      background: #00B300;
      border-color: #00B300;
      color: #FFFFFF;
      font-weight: 700;
    }

    .user-bookings-page .user-side-nav a.active i {
      color: #FFFFFF;
    }

    .user-bookings-page .main {
      background: #F5F7FA;
      padding: 18px;
    }

    .history-shell {
      max-width: 1240px;
      margin: 0 auto;
      display: grid;
      gap: 14px;
    }

    .history-head {
      display: flex;
      align-items: flex-start;
      justify-content: space-between;
      gap: 12px;
      flex-wrap: wrap;
    }

    .history-title h1 {
      margin: 0;
      color: #111827;
      font-size: 30px;
      line-height: 1.05;
      letter-spacing: -0.7px;
      font-weight: 800;
      overflow-wrap: anywhere;
    }

    .history-title p {
      margin: 10px 0 0;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.35;
      font-weight: 500;
    }

    .head-actions {
      display: flex;
      align-items: center;
      gap: 10px;
      flex-wrap: wrap;
    }

    .head-btn {
      min-height: 42px;
      border-radius: 12px;
      border: 1px solid transparent;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      padding: 0 16px;
      font-size: 14px;
      line-height: 1;
      font-weight: 700;
      font-family: inherit;
      cursor: pointer;
    }

    .head-btn.secondary {
      background: #FFFFFF;
      border-color: #D1D5DB;
      color: #1F2937;
    }

    .head-btn.secondary:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F1F7FF;
    }

    .head-btn.primary {
      background: #00B300;
      border-color: #00B300;
      color: #FFFFFF;
    }

    .head-btn.primary:hover {
      background: #059A05;
      border-color: #059A05;
      color: #FFFFFF;
    }

    .filter-card,
    .table-card {
      background: #FFFFFF;
      border: 1px solid #E5E7EB;
      border-radius: 16px;
      box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04);
      overflow: hidden;
    }

    .filter-body {
      padding: 14px;
    }

    .filter-grid {
      display: grid;
      grid-template-columns: 1.8fr 0.8fr 0.8fr auto;
      gap: 10px;
      align-items: end;
    }

    .field {
      display: grid;
      gap: 6px;
    }

    .field label {
      color: #1F2937;
      font-size: 12px;
      line-height: 1;
      font-weight: 700;
      min-height: 14px;
      display: inline-flex;
      align-items: center;
    }

    .field input,
    .field select {
      width: 100%;
      height: 40px;
      border-radius: 11px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #1F2937;
      font-size: 14px;
      font-family: inherit;
      padding: 0 12px;
      margin: 0;
      display: block;
      box-sizing: border-box;
    }

    .field input:focus,
    .field select:focus {
      outline: none;
      border-color: #1976D2;
      box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.12);
    }

    .search-wrap {
      position: relative;
    }

    .search-wrap i {
      position: absolute;
      left: 12px;
      top: 50%;
      transform: translateY(-50%);
      color: #9CA3AF;
      font-size: 14px;
      pointer-events: none;
    }

    .search-wrap input {
      padding-left: 34px;
    }

    .filter-actions {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .filter-btn {
      min-height: 40px;
      border-radius: 11px;
      border: 1px solid #D1D5DB;
      background: #F8FAFC;
      color: #1F2937;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      padding: 0 14px;
      font-size: 14px;
      line-height: 1;
      font-weight: 700;
      cursor: pointer;
      text-decoration: none;
      font-family: inherit;
    }

    .filter-btn:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F1F7FF;
    }

    .booking-table {
      width: 100%;
      border-collapse: collapse;
    }

    .booking-table th,
    .booking-table td {
      padding: 14px 16px;
      border-bottom: 1px solid #EDF1F6;
      text-align: left;
      vertical-align: middle;
    }

    .booking-table th {
      background: #FFFFFF;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.1;
      font-weight: 700;
      white-space: nowrap;
    }

    .booking-table td {
      color: #1F2937;
      font-size: 13px;
      line-height: 1.3;
      font-weight: 600;
    }

    .id-cell {
      color: #111827;
      font-size: 14px;
      font-weight: 700;
      white-space: nowrap;
    }

    .station-cell strong {
      display: block;
      color: #111827;
      font-size: 13px;
      line-height: 1.2;
      font-weight: 700;
    }

    .station-cell small {
      display: block;
      margin-top: 2px;
      color: #8C95A3;
      font-size: 12px;
      line-height: 1.2;
      font-weight: 500;
    }

    .date-cell strong {
      display: block;
      color: #111827;
      font-size: 13px;
      line-height: 1.2;
      font-weight: 700;
    }

    .date-cell small {
      display: block;
      margin-top: 3px;
      color: #8C95A3;
      font-size: 12px;
      line-height: 1.2;
      font-weight: 500;
    }

    .status-pill {
      border-radius: 999px;
      border: 1px solid #E5E7EB;
      background: #F8FAFC;
      color: #374151;
      font-size: 12px;
      line-height: 1;
      font-weight: 700;
      text-transform: capitalize;
      padding: 6px 11px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      white-space: nowrap;
    }

    .status-pill.completed {
      background: #ECF8EE;
      border-color: #C5E8CD;
      color: #2E7D32;
    }

    .status-pill.upcoming {
      background: #EAF3FF;
      border-color: #C9DEFB;
      color: #1976D2;
    }

    .status-pill.pending-payment,
    .status-pill.pending {
      background: #FFF4E8;
      border-color: #FFD9B0;
      color: #B45309;
    }

    .status-pill.cancelled {
      background: #FDEDED;
      border-color: #F7C5C5;
      color: #DC2626;
    }

    .row-actions {
      display: flex;
      align-items: center;
      gap: 6px;
      flex-wrap: wrap;
    }

    .act-link,
    .act-btn {
      height: 32px;
      border-radius: 9px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #1F2937;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 0 10px;
      font-size: 12px;
      line-height: 1;
      font-weight: 700;
      font-family: inherit;
      cursor: pointer;
      white-space: nowrap;
    }

    .act-link:hover,
    .act-btn:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F1F7FF;
    }

    .act-btn.danger {
      border-color: #FBCACA;
      color: #DC2626;
      background: #FFF5F5;
    }

    .act-btn.danger:hover {
      border-color: #EF4444;
      color: #EF4444;
      background: #FDEDED;
    }

    .act-link.green {
      border-color: #BCE7C2;
      color: #2E7D32;
      background: #F0FBF2;
    }

    .act-link.green:hover {
      border-color: #2E7D32;
      color: #2E7D32;
      background: #ECF8EE;
    }

    .act-link.blue {
      border-color: #C9DEFB;
      color: #1976D2;
      background: #F1F7FF;
    }

    .act-link.blue:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #EAF3FF;
    }

    .table-foot {
      padding: 14px 16px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 10px;
      flex-wrap: wrap;
      color: #8C95A3;
      font-size: 13px;
      font-weight: 500;
    }

    .empty-state {
      padding: 30px 16px;
      color: #8C95A3;
      font-size: 14px;
      line-height: 1.4;
      text-align: center;
    }

    @media (max-width: 1220px) {
      .filter-grid {
        grid-template-columns: 1fr 1fr;
      }

      .filter-actions {
        grid-column: span 2;
      }
    }

    @media (max-width: 980px) {
      .user-bookings-page .layout {
        flex-direction: column;
      }

      .user-bookings-page .user-sidebar {
        position: static;
        width: 100%;
        min-height: auto;
        padding: 10px 12px;
        overflow: hidden;
      }

      .user-bookings-page .user-side-nav {
        display: flex;
        gap: 8px;
        overflow-x: auto;
        padding-bottom: 2px;
        scrollbar-width: thin;
        -webkit-overflow-scrolling: touch;
      }

      .user-bookings-page .user-side-nav a {
        flex: 0 0 auto;
        min-width: max-content;
        padding: 10px 12px;
        border-radius: 10px;
      }

      .history-title h1 {
        font-size: 26px;
      }

      .history-title p {
        font-size: 13px;
      }

      .user-bookings-page .main {
        padding: 14px;
      }

      .table-card {
        overflow-x: auto;
      }

      .booking-table {
        min-width: 980px;
      }
    }

    @media (max-width: 700px) {
      .filter-grid {
        grid-template-columns: 1fr;
      }

      .filter-actions {
        grid-column: span 1;
      }

      .head-actions,
      .head-btn {
        width: 100%;
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

      .user-bookings-page .main {
        padding: 10px;
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

      .history-title h1 {
        font-size: 22px;
      }

      .history-title p {
        font-size: 12px;
      }
    }
  </style>
</head>
<body class="user-bookings-page">
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
    <div class="history-shell">
      <section class="history-head">
        <div class="history-title">
          <h1>Booking History</h1>
          <p>Manage and track all your EV charging station reservations.</p>
        </div>

        <div class="head-actions">
          <a class="head-btn primary" href="${pageContext.request.contextPath}/user/stations">New Booking</a>
        </div>
      </section>

      <section class="filter-card">
        <div class="filter-body">
          <form method="get" action="${pageContext.request.contextPath}/user/bookings" class="filter-grid">
            <div class="field">
              <label for="q">Search</label>
              <div class="search-wrap">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input id="q" name="q" type="text" value="${bookingSearchFilter}" placeholder="Search by Booking ID or Station...">
              </div>
            </div>

            <div class="field">
              <label for="bookingDate">Date</label>
              <input id="bookingDate" name="bookingDate" type="date" value="${bookingDateFilter}">
            </div>

            <div class="field">
              <label for="status">Status</label>
              <select id="status" name="status">
                <option value="" ${empty bookingStatusFilter ? 'selected' : ''}>All</option>
                <option value="completed" ${bookingStatusFilter == 'completed' ? 'selected' : ''}>Completed</option>
                <option value="upcoming" ${bookingStatusFilter == 'upcoming' ? 'selected' : ''}>Upcoming</option>
                <option value="pending payment" ${bookingStatusFilter == 'pending payment' ? 'selected' : ''}>Pending Payment</option>
                <option value="cancelled" ${bookingStatusFilter == 'cancelled' ? 'selected' : ''}>Cancelled</option>
              </select>
            </div>

            <div class="filter-actions">
              <button class="filter-btn" type="submit"><i class="fa-solid fa-filter"></i>Apply Filters</button>
              <a class="filter-btn" href="${pageContext.request.contextPath}/user/bookings">Reset</a>
            </div>
          </form>
        </div>
      </section>

      <section class="table-card">
        <c:choose>
          <c:when test="${not empty bookings}">
            <table class="booking-table">
              <thead>
              <tr>
                <th>Booking ID</th>
                <th>Station</th>
                <th>Date</th>
                <th>Slot</th>
                <th>Status</th>
                <th>Action</th>
              </tr>
              </thead>
              <tbody>
              <c:forEach var="b" items="${bookings}">
                <c:set var="rowStatus" value="${bookingStatusLabels[b.bookingId]}"/>
                <c:set var="rowStatusClass" value="${fn:replace(fn:toLowerCase(rowStatus), ' ', '-')}"/>
                <tr>
                  <td><span class="id-cell">CHN-${b.bookingId}</span></td>
                  <td class="station-cell">
                    <strong>${b.stationName}</strong>
                    <small>${b.slotInfo}</small>
                  </td>
                  <td class="date-cell"><strong>${bookingSlotDates[b.bookingId]}</strong></td>
                  <td class="date-cell"><small>${bookingSlotTimes[b.bookingId]}</small></td>
                  <td><span class="status-pill ${rowStatusClass}">${rowStatus}</span></td>
                  <td>
                    <div class="row-actions">
                      <a class="act-link" href="${pageContext.request.contextPath}/user/booking?id=${b.bookingId}">View Details</a>

                      <c:if test="${rowStatusClass != 'cancelled' && rowStatusClass != 'completed'}">
                        <form method="post" action="${pageContext.request.contextPath}/user/bookings" style="margin:0;">
                          <input type="hidden" name="action" value="cancelBooking">
                          <input type="hidden" name="bookingId" value="${b.bookingId}">
                          <button class="act-btn danger" type="submit">Cancel Booking</button>
                        </form>
                      </c:if>

                      <a class="act-link green" href="${pageContext.request.contextPath}/user/station?id=${b.stationId}&from=bookings#reviews-preview">Review Station</a>

                      <c:if test="${rowStatusClass != 'completed' && rowStatusClass != 'cancelled'}">
                        <a class="act-link blue" href="${pageContext.request.contextPath}/user/payment?bookingId=${b.bookingId}">Pay Now</a>
                      </c:if>
                    </div>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </c:when>
          <c:otherwise>
            <div class="empty-state">No bookings found for the selected filters.</div>
          </c:otherwise>
        </c:choose>

        <div class="table-foot">
          <span>Showing ${fn:length(bookings)} of ${totalBookingCount} bookings</span>
          <span>Page 1 of 1</span>
        </div>
      </section>
    </div>
  </main>
</div>
</body>
</html>
