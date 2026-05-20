<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Kirti Dahal, IIC Java Hackerzz --%>
<html>
<head>
  <title>Booking Confirmation</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <style>
    .user-booking-confirm-page {
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

    .user-booking-confirm-page .layout {
      min-height: calc(100vh - 72px);
      background: #F5F7FA;
    }

    .user-booking-confirm-page .user-sidebar {
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

    .user-booking-confirm-page .user-side-brand,
    .user-booking-confirm-page .user-side-logout {
      display: none;
    }

    .user-booking-confirm-page .user-side-nav {
      display: grid;
      gap: 6px;
    }

    .user-booking-confirm-page .user-side-nav a {
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

    .user-booking-confirm-page .user-side-nav a i {
      width: 28px;
      text-align: center;
      color: #8C95A3;
      font-size: 18px;
      line-height: 1;
    }

    .user-booking-confirm-page .user-side-nav a:hover {
      background: #FFFFFF;
      border-color: #E5E7EB;
      color: #4B5563;
    }

    .user-booking-confirm-page .user-side-nav a.active {
      background: #00B300;
      border-color: #00B300;
      color: #FFFFFF;
      font-weight: 700;
    }

    .user-booking-confirm-page .user-side-nav a.active i {
      color: #FFFFFF;
    }

    .user-booking-confirm-page .main {
      background: #F5F7FA;
      padding: 18px;
    }

    .confirm-shell {
      max-width: 980px;
      margin: 0 auto;
    }

    .confirm-card {
      background: #FFFFFF;
      border: 1px solid #E5E7EB;
      border-radius: 18px;
      box-shadow: 0 10px 24px rgba(15, 23, 42, 0.08);
      overflow: hidden;
    }

    .confirm-top {
      padding: 46px 34px 32px;
      text-align: center;
      border-bottom: 1px solid #EEF2F7;
    }

    .success-icon {
      width: 92px;
      height: 92px;
      margin: 0 auto;
      border-radius: 999px;
      border: 7px solid #F1F5F9;
      display: grid;
      place-items: center;
      color: #1F2937;
      font-size: 30px;
    }

    .confirm-top h1 {
      margin: 20px 0 10px;
      color: #111827;
      font-size: 40px;
      line-height: 1;
      letter-spacing: -1.2px;
      font-weight: 800;
      overflow-wrap: anywhere;
    }

    .confirm-top p {
      margin: 0 auto;
      max-width: 520px;
      color: #8C95A3;
      font-size: 15px;
      line-height: 1.5;
      font-weight: 500;
    }

    .booking-id-pill {
      margin: 28px auto 0;
      min-height: 54px;
      border-radius: 14px;
      border: 1px solid #A6DDB0;
      background: #EAF7EC;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 14px;
      padding: 10px 28px;
    }

    .booking-id-pill label {
      color: var(--primary-green);
      font-size: 14px;
      line-height: 1;
      letter-spacing: 1px;
      font-weight: 600;
    }

    .booking-id-pill strong {
      color: #008A14;
      font-size: 28px;
      line-height: 1;
      letter-spacing: -0.5px;
      font-weight: 800;
    }

    .detail-block {
      background: #F8FAFC;
      border-top: 1px solid #EDF1F6;
      border-bottom: 1px solid #EDF1F6;
      padding: 26px 34px 28px;
    }

    .detail-head {
      margin: 0;
      color: #111827;
      font-size: 24px;
      line-height: 1.05;
      letter-spacing: -0.7px;
      font-weight: 800;
      display: inline-flex;
      align-items: center;
      gap: 12px;
    }

    .detail-head i {
      color: #9CA3AF;
      font-size: 22px;
    }

    .detail-grid {
      margin-top: 26px;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px 36px;
    }

    .detail-item {
      display: grid;
      gap: 8px;
    }

    .detail-item label {
      color: #8C95A3;
      font-size: 14px;
      line-height: 1;
      font-weight: 600;
      display: inline-flex;
      align-items: center;
      gap: 9px;
    }

    .detail-item strong {
      color: #111827;
      font-size: 22px;
      line-height: 1.2;
      letter-spacing: -0.4px;
      font-weight: 800;
      word-break: break-word;
    }

    .detail-item p {
      margin: 0;
      color: #8C95A3;
      font-size: 14px;
      line-height: 1.25;
      font-weight: 500;
      word-break: break-word;
    }

    .slot-time-line {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      color: #111827;
      font-size: 14px;
      line-height: 1.2;
      font-weight: 700;
      margin-top: 2px;
    }

    .cost-row {
      display: flex;
      align-items: center;
      gap: 12px;
      flex-wrap: wrap;
    }

    .cost-row strong {
      color: #111827;
      font-size: 30px;
      line-height: 1;
      letter-spacing: -0.8px;
    }

    .status-pill {
      border: 1px solid #E5E7EB;
      border-radius: 999px;
      background: #FFFFFF;
      color: #374151;
      font-size: 13px;
      line-height: 1;
      font-weight: 700;
      padding: 10px 18px;
      text-transform: capitalize;
      display: inline-flex;
      align-items: center;
      justify-content: center;
    }

    .status-pill.booking.pending,
    .status-pill.booking.confirmed,
    .status-pill.payment.pending,
    .status-pill.payment.pending-payment {
      background: #EAF3FF;
      border-color: #C9DEFB;
      color: var(--secondary-blue);
    }

    .status-pill.booking.cancelled {
      background: #FDEDED;
      border-color: #F7C5C5;
      color: #DC2626;
    }

    .status-pill.payment.paid,
    .status-pill.booking.completed {
      background: #ECF8EE;
      border-color: #C5E8CD;
      color: var(--primary-green);
    }

    .confirm-footer {
      padding: 18px 34px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 12px;
      flex-wrap: wrap;
    }

    .dashboard-link {
      color: #8C95A3;
      text-decoration: none;
      font-size: 16px;
      line-height: 1;
      font-weight: 500;
      display: inline-flex;
      align-items: center;
      gap: 10px;
    }

    .dashboard-link:hover {
      color: var(--secondary-blue);
    }

    .footer-actions {
      display: flex;
      align-items: center;
      gap: 12px;
      flex-wrap: wrap;
    }

    .action-btn {
      min-height: 52px;
      border-radius: 14px;
      border: 1px solid transparent;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 9px;
      padding: 0 18px;
      font-size: 15px;
      line-height: 1;
      font-weight: 700;
    }

    .action-btn.secondary {
      background: #FFFFFF;
      border-color: #D1D5DB;
      color: #1F2937;
    }

    .action-btn.secondary:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F1F7FF;
    }

    .action-btn.primary {
      background: var(--primary-green);
      border-color: var(--primary-green);
      color: #FFFFFF;
      box-shadow: 0 8px 14px rgba(46, 125, 50, 0.25);
    }

    .action-btn.primary:hover {
      background: #276B2B;
      border-color: #276B2B;
      color: #FFFFFF;
    }

    @media (max-width: 980px) {
      .user-booking-confirm-page .layout {
        flex-direction: column;
      }

      .user-booking-confirm-page .user-sidebar {
        position: static;
        width: 100%;
        min-height: auto;
        padding: 10px 12px;
        overflow: hidden;
      }

      .user-booking-confirm-page .user-side-nav {
        display: flex;
        gap: 8px;
        overflow-x: auto;
        padding-bottom: 2px;
        scrollbar-width: thin;
        -webkit-overflow-scrolling: touch;
      }

      .user-booking-confirm-page .user-side-nav a {
        flex: 0 0 auto;
        min-width: max-content;
        padding: 10px 12px;
        border-radius: 10px;
      }

      .confirm-top {
        padding-top: 40px;
      }

      .confirm-top h1 {
        font-size: 32px;
      }

      .action-btn,
      .dashboard-link,
      .confirm-top p,
      .slot-time-line,
      .status-pill {
        font-size: 14px;
      }

      .booking-id-pill strong {
        font-size: 24px;
      }

      .detail-head {
        font-size: 24px;
      }

      .detail-item strong {
        font-size: 18px;
      }

      .detail-item p,
      .detail-item label,
      .cost-row strong {
        font-size: 14px;
      }

      .success-icon {
        width: 82px;
        height: 82px;
        font-size: 28px;
      }
    }

    @media (max-width: 760px) {
      .detail-grid {
        grid-template-columns: 1fr;
      }

      .confirm-footer,
      .footer-actions,
      .action-btn {
        width: 100%;
      }

      .action-btn {
        min-height: 48px;
      }

      .user-booking-confirm-page .main,
      .confirm-top,
      .detail-block,
      .confirm-footer {
        padding-left: 16px;
        padding-right: 16px;
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

      .user-booking-confirm-page .layout,
      .user-booking-confirm-page .user-sidebar {
        min-height: auto;
      }

      .user-booking-confirm-page .main {
        padding: 10px;
      }

      .confirm-top h1 {
        font-size: 28px;
      }

      .booking-id-pill {
        width: 100%;
        justify-content: space-between;
        padding: 10px 16px;
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

      .confirm-top h1 {
        font-size: 24px;
      }

      .confirm-top p,
      .detail-item p,
      .dashboard-link {
        font-size: 12px;
      }

      .detail-head {
        font-size: 20px;
      }
    }
  </style>
</head>
<body class="user-booking-confirm-page">
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
    <div class="confirm-shell">
      <section class="confirm-card">
        <div class="confirm-top">
          <div class="success-icon"><i class="fa-solid fa-check"></i></div>
          <h1>Booking Confirmed!</h1>
          <p>Your charging slot has been successfully reserved. Please complete the payment to finalize.</p>
          <div class="booking-id-pill">
            <label>BOOKING ID</label>
            <strong>CH-BKG-${booking.bookingId}</strong>
          </div>
        </div>

        <div class="detail-block">
          <h2 class="detail-head"><i class="fa-regular fa-file-lines"></i>Reservation Details</h2>

          <div class="detail-grid">
            <div class="detail-item">
              <label><i class="fa-solid fa-location-dot"></i>Station Info</label>
              <strong>${station != null ? station.stationName : '-'}</strong>
              <p>${station != null ? station.address : '-'}</p>
            </div>

            <div class="detail-item">
              <label><i class="fa-regular fa-calendar"></i>Slot Details</label>
              <strong>${slotDateFormatted}</strong>
              <div class="slot-time-line"><i class="fa-regular fa-clock"></i>${slotTimeFormatted}${durationLabel != '-' ? ' (' : ''}${durationLabel != '-' ? durationLabel : ''}${durationLabel != '-' ? ')' : ''}</div>
            </div>

            <div class="detail-item">
              <label><i class="fa-solid fa-bolt"></i>Charger Specs</label>
              <strong>${station != null ? station.chargerType : '-'}</strong>
              <p>Total Ports: ${station != null ? station.totalPorts : '-'}</p>
            </div>

            <div class="detail-item">
              <label><i class="fa-regular fa-credit-card"></i>Estimated Cost</label>
              <div class="cost-row">
                <strong>Rs. ${estimatedCost}</strong>
                <span class="status-pill payment ${fn:replace(fn:toLowerCase(booking.paymentStatus != null ? booking.paymentStatus : 'pending payment'), ' ', '-')}">${booking.paymentStatus != null ? booking.paymentStatus : 'Pending Payment'}</span>
              </div>
            </div>

            <div class="detail-item">
              <label><i class="fa-regular fa-circle-check"></i>Booking Status</label>
              <span class="status-pill booking ${fn:toLowerCase(booking.bookingStatus != null ? booking.bookingStatus : 'pending')}">${booking.bookingStatus != null ? booking.bookingStatus : 'Pending'}</span>
            </div>
          </div>
        </div>

        <div class="confirm-footer">
          <a class="dashboard-link" href="${pageContext.request.contextPath}/user/dashboard"><i class="fa-solid fa-house"></i>Go to Dashboard</a>

          <div class="footer-actions">
            <a class="action-btn secondary" href="${pageContext.request.contextPath}/user/booking?id=${booking.bookingId}">View Details</a>
            <a class="action-btn primary" href="${pageContext.request.contextPath}/user/payment?bookingId=${booking.bookingId}">Continue to Payment <i class="fa-solid fa-arrow-right"></i></a>
          </div>
        </div>
      </section>
    </div>
  </main>
</div>
</body>
</html>
