<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Denisha Tamang --%>
<html>
<head>
  <title>Booking Details</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <style>
    .user-booking-detail-page {
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

    .user-booking-detail-page .layout {
      min-height: calc(100vh - 72px);
      background: #F5F7FA;
    }

    .user-booking-detail-page .user-sidebar {
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

    .user-booking-detail-page .user-side-brand,
    .user-booking-detail-page .user-side-logout {
      display: none;
    }

    .user-booking-detail-page .user-side-nav {
      display: grid;
      gap: 6px;
    }

    .user-booking-detail-page .user-side-nav a {
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

    .user-booking-detail-page .user-side-nav a i {
      width: 28px;
      text-align: center;
      color: #8C95A3;
      font-size: 18px;
      line-height: 1;
    }

    .user-booking-detail-page .user-side-nav a:hover {
      background: #FFFFFF;
      border-color: #E5E7EB;
      color: #4B5563;
    }

    .user-booking-detail-page .user-side-nav a.active {
      background: #00B300;
      border-color: #00B300;
      color: #FFFFFF;
      font-weight: 700;
    }

    .user-booking-detail-page .user-side-nav a.active i {
      color: #FFFFFF;
    }

    .user-booking-detail-page .main {
      background: #F5F7FA;
      padding: 18px;
    }

    .detail-shell {
      max-width: 1240px;
      margin: 0 auto;
      display: grid;
      gap: 14px;
    }

    .back-link {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      color: #8C95A3;
      text-decoration: none;
      font-size: 14px;
      line-height: 1;
      font-weight: 700;
    }

    .back-link:hover {
      color: #1976D2;
    }

    .title-row {
      display: flex;
      align-items: flex-end;
      justify-content: space-between;
      gap: 10px;
      flex-wrap: wrap;
    }

    .title-row h1 {
      margin: 0;
      color: #111827;
      font-size: 30px;
      line-height: 1.05;
      letter-spacing: -0.7px;
      font-weight: 800;
      overflow-wrap: anywhere;
    }

    .title-row p {
      margin: 9px 0 0;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.35;
      font-weight: 500;
    }

    .status-chip {
      border-radius: 999px;
      border: 1px solid #E5E7EB;
      background: #FFFFFF;
      color: #374151;
      padding: 9px 14px;
      font-size: 15px;
      line-height: 1;
      font-weight: 700;
      text-transform: capitalize;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
    }

    .status-chip.pending,
    .status-chip.pending-payment,
    .status-chip.upcoming {
      background: #FFF4E8;
      border-color: #FFD9B0;
      color: #B45309;
    }

    .status-chip.completed,
    .status-chip.paid {
      background: #ECF8EE;
      border-color: #C5E8CD;
      color: #2E7D32;
    }

    .status-chip.cancelled {
      background: #FDEDED;
      border-color: #F7C5C5;
      color: #DC2626;
    }

    .detail-layout {
      display: grid;
      grid-template-columns: 1.85fr 0.9fr;
      gap: 14px;
      align-items: start;
    }

    .panel {
      background: #FFFFFF;
      border: 1px solid #E5E7EB;
      border-radius: 16px;
      box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04);
      overflow: hidden;
    }

    .panel-body {
      padding: 16px;
      display: grid;
      gap: 14px;
    }

    .section-title {
      margin: 0;
      color: #111827;
      font-size: 18px;
      line-height: 1;
      letter-spacing: -0.3px;
      font-weight: 800;
      display: inline-flex;
      align-items: center;
      gap: 10px;
    }

    .section-title i {
      color: #8C95A3;
      font-size: 16px;
    }

    .summary-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px;
    }

    .info-card {
      border: 1px solid #EDF1F6;
      border-radius: 12px;
      background: #F8FAFC;
      padding: 12px;
      display: grid;
      gap: 5px;
    }

    .info-card label {
      color: #8C95A3;
      font-size: 13px;
      line-height: 1;
      font-weight: 600;
      display: inline-flex;
      align-items: center;
      gap: 7px;
    }

    .info-card strong {
      color: #111827;
      font-size: 14px;
      line-height: 1.3;
      font-weight: 600;
      word-break: break-word;
    }

    .slot-bar {
      border: 1px solid #EDF1F6;
      border-radius: 12px;
      background: #F8FAFC;
      padding: 12px;
      display: grid;
      grid-template-columns: 1fr 1fr 1fr;
      gap: 10px;
    }

    .slot-cell {
      border-right: 1px solid #E5E7EB;
      padding-right: 10px;
      display: grid;
      gap: 4px;
    }

    .slot-cell:last-child {
      border-right: 0;
      padding-right: 0;
    }

    .slot-cell span {
      color: #8C95A3;
      font-size: 11px;
      line-height: 1;
      font-weight: 600;
      text-transform: uppercase;
    }

    .slot-cell strong {
      color: #111827;
      font-size: 14px;
      line-height: 1.15;
      font-weight: 700;
    }

    .right-col {
      display: grid;
      gap: 14px;
    }

    .summary-list {
      display: grid;
      gap: 10px;
    }

    .summary-item {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 8px;
      font-size: 14px;
      line-height: 1.2;
      color: #8C95A3;
      font-weight: 500;
    }

    .summary-item strong {
      color: #111827;
      font-weight: 700;
    }

    .summary-total {
      border-top: 1px solid #E5E7EB;
      padding-top: 10px;
      margin-top: 2px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 8px;
    }

    .summary-total b {
      color: #111827;
      font-size: 14px;
      line-height: 1;
      font-weight: 700;
    }

    .summary-total strong {
      color: #2E7D32;
      font-size: 20px;
      line-height: 1;
      font-weight: 800;
      letter-spacing: -0.3px;
    }

    .note {
      border-radius: 10px;
      border: 1px solid #EEF2F7;
      background: #F8FAFC;
      padding: 10px;
      color: #6B7280;
      font-size: 13px;
      line-height: 1.35;
      font-weight: 500;
    }

    .action-stack {
      display: grid;
      gap: 10px;
    }

    .action-btn {
      width: 100%;
      min-height: 44px;
      border-radius: 12px;
      border: 1px solid transparent;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      font-size: 14px;
      line-height: 1;
      font-weight: 700;
      font-family: inherit;
      cursor: pointer;
    }

    .action-btn.primary {
      background: #00B300;
      border-color: #00B300;
      color: #FFFFFF;
    }

    .action-btn.primary:hover {
      background: #059A05;
      border-color: #059A05;
    }

    .action-btn.outline {
      background: #FFFFFF;
      border-color: #D1D5DB;
      color: #1F2937;
    }

    .action-btn.outline:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F1F7FF;
    }

    .action-btn.danger {
      background: #FFF5F5;
      border-color: #FBCACA;
      color: #DC2626;
    }

    .action-btn.danger:hover {
      border-color: #EF4444;
      color: #EF4444;
      background: #FDEDED;
    }

    @media (max-width: 1180px) {
      .detail-layout {
        grid-template-columns: 1fr;
      }
    }

    @media (max-width: 980px) {
      .user-booking-detail-page .layout {
        flex-direction: column;
      }

      .user-booking-detail-page .user-sidebar {
        position: static;
        width: 100%;
        min-height: auto;
        padding: 10px 12px;
        overflow: hidden;
      }

      .user-booking-detail-page .user-side-nav {
        display: flex;
        gap: 8px;
        overflow-x: auto;
        padding-bottom: 2px;
        scrollbar-width: thin;
        -webkit-overflow-scrolling: touch;
      }

      .user-booking-detail-page .user-side-nav a {
        flex: 0 0 auto;
        min-width: max-content;
        padding: 10px 12px;
        border-radius: 10px;
      }

      .user-booking-detail-page .main {
        padding: 14px;
      }

      .title-row h1 {
        font-size: 26px;
      }

      .title-row p {
        font-size: 13px;
      }
    }

    @media (max-width: 700px) {
      .summary-grid,
      .slot-bar {
        grid-template-columns: 1fr;
      }

      .slot-cell {
        border-right: 0;
        border-bottom: 1px solid #E5E7EB;
        padding-right: 0;
        padding-bottom: 10px;
      }

      .slot-cell:last-child {
        border-bottom: 0;
        padding-bottom: 0;
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

      .user-booking-detail-page .main {
        padding: 10px;
      }

      .status-chip {
        font-size: 13px;
        padding: 7px 11px;
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

      .title-row h1 {
        font-size: 22px;
      }

      .title-row p,
      .back-link {
        font-size: 12px;
      }
    }
  </style>
</head>
<body class="user-booking-detail-page">
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
    <div class="detail-shell">
      <a class="back-link" href="${pageContext.request.contextPath}/user/bookings"><i class="fa-solid fa-arrow-left"></i>Back to Booking History</a>

      <section class="title-row">
        <div>
          <h1>Booking Details</h1>
          <p>CHN-${booking.bookingId} &middot; Booked on ${bookedOn}</p>
        </div>
        <span class="status-chip ${fn:replace(fn:toLowerCase(detailDisplayStatus), ' ', '-')}"><i class="fa-regular fa-circle-dot"></i>${detailDisplayStatus}</span>
      </section>

      <section class="detail-layout">
        <div class="left-col" style="display:grid; gap:14px;">
          <article class="panel">
            <div class="panel-body">
              <h2 class="section-title"><i class="fa-solid fa-bolt"></i>Full Booking Summary</h2>

              <div class="summary-grid">
                <div class="info-card">
                  <label><i class="fa-solid fa-location-dot"></i>Station Details</label>
                  <strong>${station != null ? station.stationName : booking.stationName}</strong>
                  <strong>${station != null ? station.address : '-'}</strong>
                </div>

                <div class="info-card">
                  <label><i class="fa-regular fa-id-card"></i>Vehicle Number</label>
                  <strong>${empty booking.vehicleNumber ? '-' : booking.vehicleNumber}</strong>
                </div>

                <div class="info-card">
                  <label><i class="fa-solid fa-plug-circle-bolt"></i>Charger Type</label>
                  <strong>${station != null ? station.chargerType : '-'}</strong>
                </div>

                <div class="info-card">
                  <label><i class="fa-solid fa-phone"></i>Contact</label>
                  <strong>${station != null ? station.contactNumber : '-'}</strong>
                </div>
              </div>

              <h2 class="section-title" style="margin-top:2px;"><i class="fa-regular fa-clock"></i>Slot Date and Time</h2>
              <div class="slot-bar">
                <div class="slot-cell">
                  <span>Date</span>
                  <strong>${detailSlotDate}</strong>
                </div>
                <div class="slot-cell">
                  <span>Time</span>
                  <strong>${detailSlotTime}</strong>
                </div>
                <div class="slot-cell">
                  <span>Duration</span>
                  <strong>${detailDuration}</strong>
                </div>
              </div>

              <c:if test="${not empty booking.notes}">
                <div class="note"><strong style="color:#111827;">Special Note:</strong> ${booking.notes}</div>
              </c:if>
            </div>
          </article>
        </div>

        <aside class="right-col">
          <article class="panel">
            <div class="panel-body">
              <h2 class="section-title"><i class="fa-regular fa-credit-card"></i>Payment Summary</h2>

              <div class="summary-list">
                <div class="summary-item"><span>Estimated Cost</span><strong>NPR ${detailAmount}</strong></div>
                <div class="summary-item"><span>Booking Status</span><span class="status-chip ${fn:replace(fn:toLowerCase(detailDisplayStatus), ' ', '-')}">${detailDisplayStatus}</span></div>
                <div class="summary-item"><span>Payment Status</span><span class="status-chip ${fn:replace(fn:toLowerCase(booking.paymentStatus != null ? booking.paymentStatus : 'pending payment'), ' ', '-')}">${booking.paymentStatus != null ? booking.paymentStatus : 'Pending Payment'}</span></div>
              </div>

              <div class="summary-total">
                <b>Total Amount</b>
                <strong>NPR ${detailAmount}</strong>
              </div>

              <div class="note"><i class="fa-solid fa-circle-info"></i> You can pay online now or at the station before charging starts.</div>

              <div class="action-stack">
                <c:if test="${fn:toLowerCase(booking.bookingStatus) != 'cancelled' && fn:toLowerCase(booking.paymentStatus != null ? booking.paymentStatus : '') != 'paid'}">
                  <a class="action-btn primary" href="${pageContext.request.contextPath}/user/payment?bookingId=${booking.bookingId}"><i class="fa-regular fa-credit-card"></i>Pay Now</a>
                </c:if>

                <c:if test="${fn:toLowerCase(detailDisplayStatus) != 'cancelled' && fn:toLowerCase(detailDisplayStatus) != 'completed'}">
                  <form method="post" action="${pageContext.request.contextPath}/user/bookings" style="margin:0;">
                    <input type="hidden" name="action" value="cancelBooking">
                    <input type="hidden" name="bookingId" value="${booking.bookingId}">
                    <button class="action-btn danger" type="submit"><i class="fa-regular fa-circle-xmark"></i>Cancel Booking</button>
                  </form>
                </c:if>

                <a class="action-btn outline" href="${pageContext.request.contextPath}/user/bookings"><i class="fa-solid fa-arrow-left"></i>Back to History</a>
              </div>
            </div>
          </article>
        </aside>
      </section>
    </div>
  </main>
</div>
</body>
</html>
