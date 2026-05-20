<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Denisha Tamang --%>
<html>
<head>
  <title>Complete Payment</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <style>
    .user-payment-page {
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

    .user-payment-page .layout {
      min-height: calc(100vh - 72px);
      background: #F5F7FA;
    }

    .user-payment-page .user-sidebar {
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

    .user-payment-page .user-side-brand,
    .user-payment-page .user-side-logout {
      display: none;
    }

    .user-payment-page .user-side-nav {
      display: grid;
      gap: 6px;
    }

    .user-payment-page .user-side-nav a {
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

    .user-payment-page .user-side-nav a i {
      width: 28px;
      text-align: center;
      color: #8C95A3;
      font-size: 18px;
      line-height: 1;
    }

    .user-payment-page .user-side-nav a:hover {
      background: #FFFFFF;
      border-color: #E5E7EB;
      color: #4B5563;
    }

    .user-payment-page .user-side-nav a.active {
      background: #00B300;
      border-color: #00B300;
      color: #FFFFFF;
      font-weight: 700;
    }

    .user-payment-page .user-side-nav a.active i {
      color: #FFFFFF;
    }

    .user-payment-page .main {
      background: #F5F7FA;
      padding: 18px;
    }

    .payment-shell {
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

    .page-title h1 {
      margin: 0;
      color: #111827;
      font-size: 48px;
      line-height: 1;
      letter-spacing: -1.1px;
      font-weight: 800;
      overflow-wrap: anywhere;
    }

    .page-title p {
      margin: 9px 0 0;
      color: #8C95A3;
      font-size: 16px;
      line-height: 1.35;
      font-weight: 500;
    }

    .payment-layout {
      display: grid;
      grid-template-columns: 1.85fr 1fr;
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
      font-size: 35px;
      line-height: 1;
      letter-spacing: -0.7px;
      font-weight: 800;
    }

    .section-sub {
      margin: 0;
      color: #8C95A3;
      font-size: 16px;
      line-height: 1.35;
      font-weight: 500;
    }

    .field {
      display: grid;
      gap: 7px;
    }

    .field label {
      color: #1F2937;
      font-size: 13px;
      line-height: 1;
      font-weight: 700;
    }

    .field input,
    .field select,
    .field textarea {
      width: 100%;
      min-height: 44px;
      border-radius: 12px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #1F2937;
      font-size: 15px;
      font-family: inherit;
      padding: 0 12px;
    }

    .field textarea {
      min-height: 98px;
      padding: 10px 12px;
      resize: vertical;
    }

    .field input:focus,
    .field select:focus,
    .field textarea:focus {
      outline: none;
      border-color: #1976D2;
      box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.12);
    }

    .readonly-field {
      background: #F8FAFC;
      font-weight: 700;
    }

    .instruction-box {
      border-radius: 12px;
      border: 1px solid #E5E7EB;
      background: #F8FAFC;
      padding: 12px;
      display: grid;
      gap: 9px;
    }

    .instruction-box strong {
      color: #111827;
      font-size: 21px;
      line-height: 1.2;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 8px;
    }

    .instruction-box ol {
      margin: 0;
      padding-left: 20px;
      display: grid;
      gap: 5px;
      color: #6B7280;
      font-size: 15px;
      line-height: 1.4;
      font-weight: 500;
    }

    .help-line {
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.3;
      font-weight: 500;
    }

    .summary-top {
      border-bottom: 1px solid #EDF1F6;
      padding-bottom: 12px;
      display: grid;
      gap: 7px;
    }

    .summary-top p {
      margin: 0;
      color: #8C95A3;
      font-size: 16px;
      line-height: 1.3;
      font-weight: 500;
    }

    .summary-station {
      border-bottom: 1px solid #EDF1F6;
      padding-bottom: 12px;
      display: grid;
      gap: 4px;
    }

    .summary-station strong {
      color: #111827;
      font-size: 16px;
      line-height: 1.25;
      font-weight: 700;
    }

    .summary-station small {
      color: #8C95A3;
      font-size: 14px;
      line-height: 1.3;
      font-weight: 500;
    }

    .meta-list,
    .cost-list {
      display: grid;
      gap: 9px;
    }

    .meta-row,
    .cost-row {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 10px;
      color: #8C95A3;
      font-size: 15px;
      line-height: 1.2;
      font-weight: 500;
    }

    .meta-row strong,
    .cost-row strong {
      color: #111827;
      font-weight: 700;
    }

    .total-row {
      border-top: 1px solid #E5E7EB;
      padding-top: 12px;
      margin-top: 2px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 10px;
    }

    .total-row b {
      color: #111827;
      font-size: 17px;
      line-height: 1;
      font-weight: 800;
    }

    .total-row strong {
      color: #00A511;
      font-size: 42px;
      line-height: 1;
      letter-spacing: -0.9px;
      font-weight: 900;
    }

    .pay-btn {
      width: 100%;
      min-height: 50px;
      border-radius: 13px;
      border: 1px solid #00B300;
      background: #00B300;
      color: #FFFFFF;
      font-size: 16px;
      line-height: 1;
      font-weight: 700;
      font-family: inherit;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
    }

    .pay-btn:hover {
      background: #059A05;
      border-color: #059A05;
    }

    .secure-line {
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.3;
      font-weight: 500;
      text-align: center;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 7px;
      width: 100%;
    }

    @media (max-width: 1180px) {
      .payment-layout {
        grid-template-columns: 1fr;
      }
    }

    @media (max-width: 980px) {
      .user-payment-page .layout {
        flex-direction: column;
      }

      .user-payment-page .user-sidebar {
        position: static;
        width: 100%;
        min-height: auto;
        padding: 10px 12px;
        overflow: hidden;
      }

      .user-payment-page .user-side-nav {
        display: flex;
        gap: 8px;
        overflow-x: auto;
        padding-bottom: 2px;
        scrollbar-width: thin;
        -webkit-overflow-scrolling: touch;
      }

      .user-payment-page .user-side-nav a {
        flex: 0 0 auto;
        min-width: max-content;
        padding: 10px 12px;
        border-radius: 10px;
      }

      .user-payment-page .main {
        padding: 14px;
      }

      .page-title h1 {
        font-size: 36px;
      }

      .page-title p {
        font-size: 14px;
      }
    }

    @media (max-width: 700px) {
      .total-row strong {
        font-size: 30px;
      }

      .page-title h1 {
        font-size: 30px;
      }

      .section-title {
        font-size: 28px;
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

      .user-payment-page .layout,
      .user-payment-page .user-sidebar {
        min-height: auto;
      }

      .user-payment-page .main {
        padding: 10px;
      }

      .panel-body {
        padding: 12px;
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

      .page-title h1 {
        font-size: 24px;
      }

      .page-title p,
      .back-link,
      .field input,
      .field select,
      .help-line {
        font-size: 12px;
      }

      .section-title {
        font-size: 22px;
      }

      .total-row strong {
        font-size: 24px;
      }
    }
  </style>
</head>
<body class="user-payment-page">
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
    <div class="payment-shell">
      <a class="back-link" href="${pageContext.request.contextPath}/user/booking?id=${booking.bookingId}"><i class="fa-solid fa-arrow-left"></i>Back to Booking Details</a>

      <section class="page-title">
        <h1>Complete Payment</h1>
        <p>Please review your booking details and select a payment method to confirm your slot.</p>
      </section>

      <form method="post" action="${pageContext.request.contextPath}/user/payment" class="payment-layout">
        <input type="hidden" name="action" value="pay">
        <input type="hidden" name="bookingId" value="${booking.bookingId}">
        <input type="hidden" name="amount" value="${paymentAmount}">

        <section class="panel">
          <div class="panel-body">
            <h2 class="section-title">Payment Method</h2>
            <p class="section-sub">Select your preferred way to pay securely.</p>

            <div class="field">
              <label for="provider">Payment Method</label>
              <select id="provider" name="paymentMethod" required>
                <option value="esewa" selected>eSewa Mobile Wallet</option>
                <option value="khalti">Khalti</option>
                <option value="fonepay">Fonepay</option>
                <option value="bank-transfer">Bank Transfer</option>
              </select>
            </div>

            <div class="instruction-box">
              <strong><i class="fa-regular fa-circle-info"></i>Payment Instructions</strong>
              <ol>
                <li>Open your selected payment app or banking portal.</li>
                <li>Use transaction details shown in your payment app.</li>
                <li>Pay the exact amount: <b>NPR ${paymentAmount}</b>.</li>
                <li>Keep the transaction reference for verification.</li>
                <li>Submit the form below after successful payment.</li>
              </ol>
            </div>

            <div class="field">
              <label for="transactionReference">Transaction Reference *</label>
              <input id="transactionReference" name="transactionReference" type="text" placeholder="e.g. TXN-92837465" required>
              <small class="help-line">Required to verify your payment.</small>
            </div>

            <div class="field">
              <label for="remarks">Remarks (optional)</label>
              <textarea id="remarks" name="remarks" placeholder="Any note related to this payment"></textarea>
            </div>
          </div>
        </section>

        <aside class="panel">
          <div class="panel-body">
            <h2 class="section-title">Booking Summary</h2>

            <div class="summary-top">
              <p>Booking ID: CHN-${booking.bookingId}</p>
            </div>

            <div class="summary-station">
              <strong>${station != null ? station.stationName : booking.stationName}</strong>
              <small><i class="fa-solid fa-location-dot"></i> ${station != null ? station.districtName : 'Charging Station'}</small>
            </div>

            <div class="meta-list">
              <div class="meta-row"><span>Date</span><strong>${paymentDate}</strong></div>
              <div class="meta-row"><span>Time Slot</span><strong>${paymentTime}</strong></div>
              <div class="meta-row"><span>Charger</span><strong>${station != null ? station.chargerType : '-'}</strong></div>
              <div class="meta-row"><span>Duration</span><strong>${paymentDuration}</strong></div>
            </div>

            <div class="cost-list">
              <div class="cost-row"><span>Charging Rate (Rs. ${paymentRate}/hr)</span><strong>Rs. ${paymentAmount}</strong></div>
              <div class="cost-row"><span>Booking Fee</span><strong>Rs. 0.00</strong></div>
              <div class="cost-row"><span>VAT (13%)</span><strong>Rs. 0.00</strong></div>
            </div>

            <div class="total-row">
              <b>Amount</b>
              <strong>Rs. ${paymentAmount}</strong>
            </div>

            <button class="pay-btn" type="submit"><i class="fa-regular fa-credit-card"></i>Confirm Payment</button>
            <span class="secure-line"><i class="fa-solid fa-shield-halved"></i>Payments are secure and encrypted</span>
          </div>
        </aside>
      </form>
    </div>
  </main>
</div>
</body>
</html>
