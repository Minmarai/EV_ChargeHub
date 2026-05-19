<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Kirti Dahal --%>
<html>
<head>
  <title>Book Slot</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <style>
    .user-book-slot-page {
      --primary-green: #2E7D32;
      --secondary-blue: #1976D2;
      --accent-orange: #FF9800;
      --light-bg: #F5F7FA;
      --white: #FFFFFF;
      --text-dark: #333333;
      --title: #111827;
      --muted: #8C95A3;
      --border: #E5E7EB;
      --panel-shadow: 0 1px 2px rgba(15, 23, 42, 0.04);
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

    .user-book-slot-page .layout {
      min-height: calc(100vh - 72px);
      background: var(--light-bg);
    }

    .user-book-slot-page .user-sidebar {
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

    .user-book-slot-page .user-side-brand,
    .user-book-slot-page .user-side-logout {
      display: none;
    }

    .user-book-slot-page .user-side-nav {
      display: grid;
      gap: 6px;
    }

    .user-book-slot-page .user-side-nav a {
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

    .user-book-slot-page .user-side-nav a i {
      width: 28px;
      text-align: center;
      color: #8C95A3;
      font-size: 18px;
      line-height: 1;
    }

    .user-book-slot-page .user-side-nav a:hover {
      background: #FFFFFF;
      border-color: #E5E7EB;
      color: #4B5563;
    }

    .user-book-slot-page .user-side-nav a.active {
      background: #FFFFFF;
      border-color: #E5E7EB;
      color: #4B5563;
      font-weight: 600;
    }

    .user-book-slot-page .user-side-nav a.active i {
      color: #4B5563;
    }

    .user-book-slot-page .main {
      padding: 18px;
      background: var(--light-bg);
    }

    .booking-shell {
      max-width: 1368px;
      margin: 0 auto;
    }

    .page-head {
      display: flex;
      align-items: flex-start;
      gap: 16px;
    }

    .back-circle {
      width: 44px;
      height: 44px;
      border-radius: 999px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #4B5563;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      font-size: 14px;
      line-height: 1;
      flex-shrink: 0;
      margin-top: 2px;
    }

    .back-circle:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F1F7FF;
    }

    .page-head h1 {
      margin: 0;
      color: #181D25;
      font-size: 30px;
      line-height: 1.05;
      letter-spacing: -0.9px;
      font-weight: 800;
      overflow-wrap: anywhere;
    }

    .page-head p {
      margin: 10px 0 0;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.35;
      font-weight: 500;
    }

    .book-layout {
      margin-top: 14px;
      display: grid;
      grid-template-columns: 1fr 1.9fr;
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
      padding: 18px;
    }

    .station-cover {
      height: 230px;
      border: 1px solid #E5E7EB;
      border-radius: 14px;
      background: linear-gradient(145deg, #C6D9EE, #8FB2D7);
      position: relative;
      overflow: hidden;
      display: flex;
      align-items: flex-start;
      justify-content: flex-end;
      padding: 12px;
    }

    .station-cover::after {
      content: "";
      position: absolute;
      left: -40px;
      bottom: -78px;
      width: 210px;
      height: 210px;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.24);
    }

    .station-cover::before {
      content: "";
      position: absolute;
      right: -28px;
      top: -58px;
      width: 190px;
      height: 190px;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.2);
    }

    .availability-pill {
      position: relative;
      z-index: 1;
      border-radius: 999px;
      padding: 8px 16px;
      background: rgba(255, 255, 255, 0.95);
      border: 1px solid rgba(255, 255, 255, 0.98);
      color: #1F2937;
      font-size: 12px;
      line-height: 1;
      font-weight: 700;
      text-transform: capitalize;
    }

    .summary-wrap {
      margin-top: 14px;
    }

    .summary-wrap h2 {
      margin: 0;
      color: #181D25;
      font-size: 24px;
      line-height: 1.1;
      letter-spacing: -0.4px;
      font-weight: 800;
      word-break: break-word;
    }

    .summary-address {
      margin-top: 9px;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.35;
      font-weight: 500;
      display: inline-flex;
      align-items: center;
      gap: 7px;
    }

    .summary-specs {
      margin-top: 13px;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px;
    }

    .spec-card {
      border: 1px solid #EEF2F7;
      border-radius: 12px;
      background: #F8FAFC;
      padding: 11px 12px;
      display: grid;
      gap: 4px;
    }

    .spec-label {
      color: #8C95A3;
      font-size: 12px;
      line-height: 1.1;
      font-weight: 600;
      display: inline-flex;
      align-items: center;
      gap: 6px;
    }

    .spec-value {
      color: #111827;
      font-size: 16px;
      line-height: 1.2;
      font-weight: 800;
    }

    .rate-card {
      margin-top: 12px;
      border: 1px solid #A6E2AE;
      border-radius: 14px;
      background: #EDF8EF;
      padding: 14px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 10px;
    }

    .rate-card label {
      color: #1F2937;
      font-size: 13px;
      line-height: 1;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 8px;
    }

    .rate-card strong {
      color: #0AA80A;
      font-size: 21px;
      line-height: 1;
      letter-spacing: -0.2px;
      font-weight: 900;
    }

    .guidelines {
      margin-top: 12px;
      border-top: 1px solid #EDF1F6;
      padding-top: 12px;
    }

    .guidelines h3 {
      margin: 0;
      color: #111827;
      font-size: 16px;
      line-height: 1.2;
      font-weight: 800;
      display: inline-flex;
      align-items: center;
      gap: 8px;
    }

    .guidelines ul {
      margin: 8px 0 0 20px;
      padding: 0;
      color: #374151;
      font-size: 13px;
      line-height: 1.4;
      font-weight: 500;
    }

    .booking-panel .head {
      padding: 18px;
      border-bottom: 1px solid #E5E7EB;
    }

    .booking-panel .head h2 {
      margin: 0;
      color: #181D25;
      font-size: 30px;
      line-height: 1.05;
      letter-spacing: -0.9px;
      font-weight: 800;
    }

    .booking-panel .head p {
      margin: 9px 0 0;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.35;
      font-weight: 500;
    }

    .booking-form {
      display: grid;
      gap: 16px;
    }

    .form-body {
      padding: 18px;
      display: grid;
      gap: 16px;
    }

    .section-title {
      margin: 0;
      color: #1B212B;
      font-size: 18px;
      line-height: 1.1;
      letter-spacing: -0.3px;
      font-weight: 800;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding-bottom: 11px;
      border-bottom: 1px solid #EDF1F6;
      width: 100%;
    }

    .section-title i {
      color: #10B325;
      font-size: 20px;
    }

    .schedule-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 12px;
      align-items: start;
    }

    .field {
      display: grid;
      gap: 7px;
    }

    .field label {
      color: #1F2937;
      font-size: 14px;
      line-height: 1.2;
      font-weight: 700;
      min-height: 18px;
      display: inline-flex;
      align-items: center;
    }

    .required::after {
      content: " *";
      color: #EF4444;
    }

    .field input,
    .field select,
    .field textarea {
      width: 100%;
      border: 1px solid #D1D5DB;
      border-radius: 13px;
      background: #FFFFFF;
      color: #1F2937;
      font-size: 14px;
      font-family: inherit;
      box-sizing: border-box;
      margin: 0;
      display: block;
    }

    .field input,
    .field select {
      height: 48px;
      padding: 0 14px;
    }

    .field textarea {
      min-height: 120px;
      resize: vertical;
      padding: 12px 14px;
    }

    .field input:focus,
    .field select:focus,
    .field textarea:focus {
      outline: none;
      border-color: #1976D2;
      box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.12);
    }

    .hint {
      margin: 2px 0 0;
      color: #8C95A3;
      font-size: 12px;
      line-height: 1.3;
      font-weight: 500;
    }

    .alert-box {
      border: 1px solid #E5E7EB;
      border-radius: 13px;
      background: #FAFAFA;
      padding: 12px 14px;
      display: grid;
      gap: 5px;
    }

    .alert-box strong {
      color: #1F2937;
      font-size: 15px;
      line-height: 1.2;
      font-weight: 800;
      display: inline-flex;
      align-items: center;
      gap: 8px;
    }

    .alert-box p {
      margin: 0;
      color: #6B7280;
      font-size: 13px;
      line-height: 1.35;
      font-weight: 500;
    }

    .footer-row {
      border-top: 1px solid #E5E7EB;
      padding: 14px 18px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 12px;
      flex-wrap: wrap;
    }

    .footer-row p {
      margin: 0;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.3;
      font-weight: 500;
      display: inline-flex;
      align-items: center;
      gap: 8px;
    }

    .footer-actions {
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .btn {
      height: 52px;
      border-radius: 13px;
      border: 1px solid transparent;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      text-decoration: none;
      font-size: 14px;
      line-height: 1;
      font-weight: 700;
      font-family: inherit;
      padding: 0 26px;
      cursor: pointer;
    }

    .btn.cancel {
      background: #FFFFFF;
      border-color: #D1D5DB;
      color: #374151;
    }

    .btn.cancel:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F8FBFF;
    }

    .btn.confirm {
      background: #2E7D32;
      border-color: #2E7D32;
      color: #FFFFFF;
      min-width: 208px;
    }

    .btn.confirm:hover {
      background: #276B2B;
      border-color: #276B2B;
    }

    .btn.confirm:disabled {
      background: #CBD5E1;
      border-color: #CBD5E1;
      cursor: not-allowed;
    }

    @media (max-width: 1320px) {
      .page-head h1,
      .booking-panel .head h2 {
        font-size: 28px;
      }

      .summary-wrap h2,
      .section-title {
        font-size: 22px;
      }
    }

    @media (max-width: 1120px) {
      .book-layout {
        grid-template-columns: 1fr;
      }

      .schedule-grid {
        grid-template-columns: 1fr;
      }

      .page-head h1,
      .booking-panel .head h2,
      .summary-wrap h2,
      .section-title {
        font-size: 24px;
      }
    }

    @media (max-width: 980px) {
      .user-book-slot-page .layout {
        flex-direction: column;
      }

      .user-book-slot-page .user-sidebar {
        position: static;
        width: 100%;
        min-height: auto;
        padding: 10px 12px;
        overflow: hidden;
      }

      .user-book-slot-page .user-side-nav {
        display: flex;
        gap: 8px;
        overflow-x: auto;
        padding-bottom: 2px;
        scrollbar-width: thin;
        -webkit-overflow-scrolling: touch;
      }

      .user-book-slot-page .user-side-nav a {
        flex: 0 0 auto;
        min-width: max-content;
        padding: 10px 12px;
        border-radius: 10px;
      }

      .user-book-slot-page .main {
        padding: 14px;
      }

      .page-head h1,
      .booking-panel .head h2,
      .summary-wrap h2,
      .section-title {
        font-size: 22px;
      }
    }

    @media (max-width: 700px) {
      .summary-specs {
        grid-template-columns: 1fr;
      }

      .page-head {
        gap: 10px;
      }

      .footer-actions {
        width: 100%;
      }

      .btn.cancel,
      .btn.confirm {
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

      .user-book-slot-page .layout,
      .user-book-slot-page .user-sidebar {
        min-height: auto;
      }

      .user-book-slot-page .main {
        padding: 10px;
      }

      .panel-body,
      .booking-panel .head,
      .form-body,
      .footer-row {
        padding-left: 12px;
        padding-right: 12px;
      }

      .station-cover {
        height: 180px;
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

      .page-head h1,
      .booking-panel .head h2,
      .summary-wrap h2,
      .section-title {
        font-size: 20px;
      }

      .page-head p,
      .hint,
      .footer-row p {
        font-size: 12px;
      }
    }
  </style>
</head>
<body class="user-book-slot-page">
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
    <div class="booking-shell">
      <section class="page-head">
        <a class="back-circle" href="${pageContext.request.contextPath}/user/station?id=${station.stationId}&from=${fromPage != null ? fromPage : 'stations'}" aria-label="Back to station details"><i class="fa-solid fa-angle-left"></i></a>
        <div>
          <h1>Secure Your Charging Slot</h1>
          <p>Review station details and confirm your booking time.</p>
        </div>
      </section>

      <section class="book-layout">
        <article class="panel">
          <div class="panel-body">
            <div class="station-cover">
              <span class="availability-pill ${fn:toLowerCase(station.status)}">${fn:toLowerCase(station.status) == 'active' ? 'Available Now' : station.status}</span>
            </div>

            <div class="summary-wrap">
              <h2>${station.stationName}</h2>
              <div class="summary-address"><i class="fa-solid fa-location-dot"></i>${station.address}</div>

              <div class="summary-specs">
                <div class="spec-card">
                  <span class="spec-label"><i class="fa-solid fa-plug-circle-bolt"></i>Charger Type</span>
                  <span class="spec-value">${station.chargerType}</span>
                </div>
                <div class="spec-card">
                  <span class="spec-label"><i class="fa-regular fa-clock"></i>Total Ports</span>
                  <span class="spec-value">${station.totalPorts}</span>
                </div>
              </div>

              <div class="rate-card">
                <label><i class="fa-regular fa-credit-card"></i>Rate per Hour</label>
                <strong>Rs. ${station.pricePerHour}</strong>
              </div>
            </div>

            <div class="guidelines">
              <h3><i class="fa-solid fa-circle-info"></i>Booking Guidelines</h3>
              <ul>
                <li>Please arrive 5 minutes before your scheduled time.</li>
                <li>Slots are held for a maximum of 15 minutes post start time.</li>
                <li>Cancellations are free up to 2 hours before the slot.</li>
              </ul>
            </div>
          </div>
        </article>

        <article class="panel booking-panel">
          <div class="head">
            <h2>Booking Details</h2>
            <p>Fill in the required information to reserve your slot.</p>
          </div>

          <form method="post" action="${pageContext.request.contextPath}/user/book-slot" class="booking-form" id="bookingForm">
            <input type="hidden" name="action" value="book">
            <input type="hidden" name="stationId" value="${station.stationId}">
            <input type="hidden" name="fromPage" value="${fromPage}">

            <div class="form-body">
              <section>
                <h3 class="section-title"><i class="fa-regular fa-calendar"></i>Schedule</h3>
                <div class="schedule-grid" style="margin-top:12px;">
                  <div class="field">
                    <label class="required" for="bookingDate">Date</label>
                    <input id="bookingDate" name="bookingDate" type="date" value="${selectedBookingDate}" min="${minBookingDate}" required>
                  </div>

                  <div class="field">
                    <label class="required" for="slotId">Available Time Slot</label>
                    <select id="slotId" name="slotId" required>
                      <option value="">Select a slot</option>
                      <c:forEach var="sl" items="${availableSlots}">
                        <option value="${sl.slotId}" data-date="${fn:substring(sl.slotDate,0,10)}">${sl.startTime} - ${sl.endTime}</option>
                      </c:forEach>
                    </select>
                    <p class="hint" id="slotHint">Choose from available slots for selected date.</p>
                  </div>
                </div>
              </section>

              <section>
                <h3 class="section-title"><i class="fa-solid fa-car-side"></i>Vehicle Information</h3>
                <div class="field" style="margin-top:12px; max-width: 440px;">
                  <label class="required" for="vehicleNumber">Vehicle Registration Number</label>
                  <input id="vehicleNumber" name="vehicleNumber" type="text" placeholder="e.g. BA 1 PA 1234" required>
                  <p class="hint">Helps station operators identify your vehicle upon arrival.</p>
                </div>
              </section>

              <section>
                <h3 class="section-title"><i class="fa-regular fa-note-sticky"></i>Additional Notes (Optional)</h3>
                <div class="field" style="margin-top:12px;">
                  <textarea id="notes" name="notes" placeholder="Any special requests or notes for the station operator..."></textarea>
                </div>
              </section>

              <div class="alert-box" id="bookingAlert">
                <strong><i class="fa-regular fa-circle-xmark"></i>Incomplete Booking Details</strong>
                <p>Please ensure you have selected a date, time slot, and entered your vehicle number to proceed.</p>
              </div>
            </div>

            <div class="footer-row">
              <p><i class="fa-regular fa-credit-card"></i>Payment collected at station or next step</p>
              <div class="footer-actions">
                <a class="btn cancel" href="${pageContext.request.contextPath}/user/station?id=${station.stationId}&from=${fromPage != null ? fromPage : 'stations'}">Cancel</a>
                <button class="btn confirm" type="submit" id="confirmBtn">Confirm Booking</button>
              </div>
            </div>
          </form>
        </article>
      </section>
    </div>
  </main>
</div>

<script>
  (function () {
    var dateInput = document.getElementById('bookingDate');
    var slotSelect = document.getElementById('slotId');
    var vehicleInput = document.getElementById('vehicleNumber');
    var confirmBtn = document.getElementById('confirmBtn');
    var slotHint = document.getElementById('slotHint');
    var bookingAlert = document.getElementById('bookingAlert');
    if (!dateInput || !slotSelect || !vehicleInput || !confirmBtn || !slotHint || !bookingAlert) return;

    var sourceOptions = Array.prototype.slice.call(slotSelect.querySelectorAll('option[data-date]')).map(function (opt) {
      return {
        value: opt.value,
        date: opt.getAttribute('data-date'),
        label: opt.textContent
      };
    });
    var requestedSlotId = '${param.slotId}' || '';
    slotSelect.setAttribute('data-selected-value', requestedSlotId);

    function filterSlotsByDate(dateValue) {
      slotSelect.innerHTML = '';

      var defaultOption = document.createElement('option');
      defaultOption.value = '';
      defaultOption.textContent = 'Select a slot';
      slotSelect.appendChild(defaultOption);

      var normalizedDate = dateValue ? dateValue.trim() : '';
      var matches = sourceOptions.filter(function (item) {
        return !normalizedDate || item.date === normalizedDate;
      });

      if (normalizedDate && matches.length === 0 && sourceOptions.length > 0) {
        var fallbackDate = sourceOptions[0].date;
        dateInput.value = fallbackDate;
        normalizedDate = fallbackDate;
        matches = sourceOptions.filter(function (item) {
          return item.date === fallbackDate;
        });
      }

      var selectedValue = slotSelect.getAttribute('data-selected-value') || '';

      matches.forEach(function (item) {
        var option = document.createElement('option');
        option.value = item.value;
        option.textContent = item.label;
        if (selectedValue && selectedValue === item.value) option.selected = true;
        slotSelect.appendChild(option);
      });

      if (!slotSelect.value && matches.length > 0) {
        slotSelect.selectedIndex = 1;
      }

      if (sourceOptions.length === 0) {
        slotSelect.disabled = true;
        slotHint.textContent = 'No available slots for selected date.';
      } else if (matches.length === 0) {
        slotSelect.disabled = true;
        slotHint.textContent = 'No available slots for selected date.';
      } else {
        slotSelect.disabled = false;
        slotHint.textContent = 'Choose from available slots for selected date.';
      }
    }

    function updateConfirmState() {
      var ready = !!dateInput.value && !!slotSelect.value && vehicleInput.value.trim().length > 0;
      confirmBtn.disabled = !ready;
      bookingAlert.style.display = ready ? 'none' : 'grid';
      slotSelect.setAttribute('data-selected-value', slotSelect.value || '');
    }

    filterSlotsByDate(dateInput.value);
    updateConfirmState();

    dateInput.addEventListener('change', function () {
      filterSlotsByDate(dateInput.value);
      updateConfirmState();
    });

    slotSelect.addEventListener('change', updateConfirmState);
    vehicleInput.addEventListener('input', updateConfirmState);
  })();
</script>
</body>
</html>
