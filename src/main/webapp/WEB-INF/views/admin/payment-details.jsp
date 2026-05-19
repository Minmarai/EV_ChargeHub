<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Rijam Shrestha --%>
<html>
<head>
  <title>Payment Details</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <style>
    .admin-payment-detail-page .admin-content {
      background: #F5F7FA;
    }

    .payment-detail-back {
      margin-top: 14px;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      color: #1976D2;
      text-decoration: none;
      font-size: 14px;
      font-weight: 700;
    }

    .payment-detail-back:hover {
      text-decoration: underline;
      text-underline-offset: 2px;
    }

    .payment-detail-head {
      margin-top: 10px;
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      gap: 14px;
      flex-wrap: wrap;
    }

    .payment-detail-head h1 {
      margin: 0;
      font-size: 52px;
      letter-spacing: -1px;
      line-height: 1.05;
      color: #1A1F2B;
    }

    .payment-detail-head p {
      margin: 8px 0 0;
      color: #6B7280;
      font-size: 16px;
    }

    .payment-head-status {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      border: 1px solid #D1D5DB;
      border-radius: 999px;
      padding: 8px 14px;
      font-size: 14px;
      font-weight: 700;
      white-space: nowrap;
    }

    .payment-head-status.paid,
    .payment-head-status.success {
      border-color: #CDE8CF;
      color: #2E7D32;
      background: #FFFFFF;
    }

    .payment-head-status.pending {
      border-color: #FFD59B;
      color: #FF9800;
      background: #FFFFFF;
    }

    .payment-head-status.failed {
      border-color: #FFC9CE;
      color: #DC2626;
      background: #FFF1F2;
    }

    .payment-head-status.refunded {
      border-color: #CFE3FF;
      color: #1976D2;
      background: #EAF3FF;
    }

    .payment-details-grid {
      margin-top: 16px;
      display: grid;
      grid-template-columns: minmax(0, 1.7fr) minmax(320px, 1fr);
      gap: 14px;
      align-items: start;
    }

    .payment-card {
      background: #FFFFFF;
      border: 1px solid #E5E7EB;
      border-radius: 16px;
      padding: 20px;
    }

    .payment-card + .payment-card {
      margin-top: 14px;
    }

    .payment-card h2 {
      margin: 0;
      font-size: 21px;
      color: #1F2937;
      display: flex;
      align-items: center;
      gap: 9px;
    }

    .payment-card h2 i {
      color: #1976D2;
    }

    .payment-meta-grid {
      margin-top: 16px;
      display: grid;
      grid-template-columns: repeat(3, minmax(0, 1fr));
      gap: 14px;
    }

    .meta-item {
      border: 1px solid #E9EDF2;
      border-radius: 12px;
      background: #FAFCFF;
      padding: 12px;
      min-height: 76px;
    }

    .meta-item label {
      display: block;
      margin: 0;
      color: #8190A5;
      font-size: 12px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.4px;
    }

    .meta-item p {
      margin: 8px 0 0;
      color: #1F2937;
      font-size: 15px;
      line-height: 1.35;
      font-weight: 600;
      word-break: break-word;
    }

    .meta-item .amount {
      font-size: 26px;
      letter-spacing: -0.3px;
    }

    .meta-item.full {
      grid-column: 1 / -1;
    }

    .remarks-box {
      padding: 12px;
      border-radius: 10px;
      border: 1px solid #E5E7EB;
      background: #FFFFFF;
      color: #4B5563;
      font-size: 14px;
      min-height: 54px;
      white-space: pre-wrap;
    }

    .booking-topline {
      margin-top: 14px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 10px;
      flex-wrap: wrap;
    }

    .booking-id-badge {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      border: 1px solid #CFE3FF;
      background: #EAF3FF;
      color: #1976D2;
      font-size: 14px;
      font-weight: 700;
      border-radius: 999px;
      padding: 8px 12px;
    }

    .booking-view-link {
      color: #1976D2;
      font-size: 14px;
      font-weight: 700;
      text-decoration: none;
    }

    .booking-view-link:hover {
      text-decoration: underline;
      text-underline-offset: 2px;
    }

    .booking-grid,
    .user-grid {
      margin-top: 14px;
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 12px;
    }

    .status-update {
      margin-top: 14px;
      border: 1px dashed #CFE3FF;
      border-radius: 14px;
      padding: 14px;
      background: #F8FBFF;
    }

    .status-update h3 {
      margin: 0;
      color: #1F2937;
      font-size: 16px;
    }

    .status-update p {
      margin: 6px 0 0;
      color: #6B7280;
      font-size: 13px;
    }

    .status-update form {
      margin-top: 12px;
      display: flex;
      gap: 8px;
      align-items: center;
      flex-wrap: wrap;
    }

    .status-update select {
      height: 42px;
      border: 1px solid #CBD5E1;
      border-radius: 10px;
      padding: 0 12px;
      min-width: 170px;
      margin: 0;
      background: #FFFFFF;
      color: #1F2937;
      font-size: 14px;
      font-family: inherit;
    }

    .status-update button {
      height: 42px;
      border: 1px solid #2E7D32;
      background: #2E7D32;
      color: #FFFFFF;
      border-radius: 10px;
      padding: 0 14px;
      font-size: 14px;
      font-weight: 700;
      cursor: pointer;
      font-family: inherit;
    }

    .status-update button:hover {
      background: #256B29;
      border-color: #256B29;
    }

    .payment-not-found {
      margin-top: 14px;
      background: #FFFFFF;
      border: 1px solid #E5E7EB;
      border-radius: 14px;
      padding: 24px;
      color: #4B5563;
    }

    .payment-not-found h2 {
      margin: 0;
      color: #1F2937;
      font-size: 22px;
    }

    .payment-not-found p {
      margin: 8px 0 0;
      font-size: 14px;
    }

    @media (max-width: 1200px) {
      .payment-details-grid {
        grid-template-columns: 1fr;
      }
    }

    @media (max-width: 900px) {
      .payment-detail-head h1 {
        font-size: 38px;
      }

      .payment-meta-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }
    }

    @media (max-width: 640px) {
      .payment-meta-grid,
      .booking-grid,
      .user-grid {
        grid-template-columns: 1fr;
      }

      .payment-detail-head h1 {
        font-size: 32px;
      }
    }
  </style>
</head>
<body class="admin-dashboard-page admin-payment-detail-page">
<div class="admin-shell">
  <jsp:include page="../common/admin-sidebar.jsp"/>

  <main class="admin-content">
    <section class="admin-topbar">
      <div class="admin-breadcrumb">
        <span>Console</span>
        <i class="fa-solid fa-chevron-right"></i>
        <a href="${pageContext.request.contextPath}/admin/payments">Manage Payments</a>
        <i class="fa-solid fa-chevron-right"></i>
        <strong>Payment Details</strong>
      </div>
      <div class="admin-topbar-actions">
        <label class="admin-search"><i class="fa-solid fa-magnifying-glass"></i><input type="text" placeholder="Search bookings, payments, or users..."></label>
        <div class="admin-user-chip">
          <div><strong>Admin User</strong><small>Super Administrator</small></div>
          <span>A</span>
        </div>
      </div>
    </section>

    <a class="payment-detail-back" href="${pageContext.request.contextPath}/admin/payments"><i class="fa-solid fa-arrow-left"></i> Back to Manage Payments</a>

    <c:choose>
      <c:when test="${not empty payment}">
        <section class="payment-detail-head">
          <div>
            <h1>Payment Details</h1>
            <p>Transaction reference ${empty payment.transactionReference ? 'TRX-' : payment.transactionReference}</p>
          </div>
          <span class="payment-head-status ${fn:toLowerCase(payment.paymentStatus)}">
            <i class="fa-regular fa-circle-dot"></i>
            ${empty payment.paymentStatus ? 'unknown' : payment.paymentStatus}
          </span>
        </section>

        <section class="payment-details-grid">
          <div>
            <article class="payment-card">
              <h2><i class="fa-regular fa-credit-card"></i> Payment Summary</h2>
              <div class="payment-meta-grid">
                <div class="meta-item">
                  <label>Payment ID</label>
                  <p>PAY-${payment.paymentId}</p>
                </div>
                <div class="meta-item">
                  <label>Amount</label>
                  <p class="amount">NPR ${payment.amount}</p>
                </div>
                <div class="meta-item">
                  <label>Method</label>
                  <p>${empty payment.paymentMethod ? '-' : payment.paymentMethod}</p>
                </div>
                <div class="meta-item">
                  <label>Status</label>
                  <p>${empty payment.paymentStatus ? '-' : payment.paymentStatus}</p>
                </div>
                <div class="meta-item">
                  <label>Transaction Reference</label>
                  <p>${empty payment.transactionReference ? '-' : payment.transactionReference}</p>
                </div>
                <div class="meta-item">
                  <label>Payment Date</label>
                  <p>${empty payment.paymentDate ? '-' : payment.paymentDate}</p>
                </div>
                <div class="meta-item full">
                  <label>Remarks</label>
                  <div class="remarks-box">${empty payment.remarks ? 'No remarks available.' : payment.remarks}</div>
                </div>
              </div>
            </article>

            <article class="payment-card">
              <h2><i class="fa-regular fa-calendar-check"></i> Booking Info</h2>
              <div class="booking-topline">
                <span class="booking-id-badge"><i class="fa-solid fa-hashtag"></i> BK-${empty payment.bookingId ? '-' : payment.bookingId}</span>
                <a class="booking-view-link" href="${pageContext.request.contextPath}/admin/booking?id=${payment.bookingId}">View booking details <i class="fa-solid fa-arrow-up-right-from-square"></i></a>
              </div>
              <div class="booking-grid">
                <div class="meta-item">
                  <label>Station</label>
                  <p>${not empty booking.stationName ? booking.stationName : (empty payment.stationName ? '-' : payment.stationName)}</p>
                </div>
                <div class="meta-item">
                  <label>Slot</label>
                  <p>${empty booking.slotInfo ? '-' : booking.slotInfo}</p>
                </div>
                <div class="meta-item">
                  <label>Booking Date</label>
                  <p>${empty booking.bookingDate ? '-' : booking.bookingDate}</p>
                </div>
                <div class="meta-item">
                  <label>Vehicle Number</label>
                  <p>${empty booking.vehicleNumber ? '-' : booking.vehicleNumber}</p>
                </div>
                <div class="meta-item full">
                  <label>Booking Status</label>
                  <p>${empty booking.bookingStatus ? '-' : booking.bookingStatus}</p>
                </div>
              </div>
            </article>
          </div>

          <aside>
            <article class="payment-card">
              <h2><i class="fa-regular fa-user"></i> User Info</h2>
              <div class="user-grid">
                <div class="meta-item full">
                  <label>Full Name</label>
                  <p>${not empty paymentUser.fullName ? paymentUser.fullName : (empty payment.userName ? '-' : payment.userName)}</p>
                </div>
                <div class="meta-item full">
                  <label>Email</label>
                  <p>${empty paymentUser.email ? '-' : paymentUser.email}</p>
                </div>
                <div class="meta-item">
                  <label>Phone</label>
                  <p>${empty paymentUser.phone ? '-' : paymentUser.phone}</p>
                </div>
                <div class="meta-item">
                  <label>Vehicle Number</label>
                  <p>${empty paymentUser.vehicleNumber ? '-' : paymentUser.vehicleNumber}</p>
                </div>
                <div class="meta-item full">
                  <label>Address</label>
                  <p>${empty paymentUser.address ? '-' : paymentUser.address}</p>
                </div>
              </div>

              <div class="status-update">
                <h3>Update Payment Status</h3>
                <p>Use this control to sync the payment state after manual verification.</p>
                <form method="post" action="${pageContext.request.contextPath}/admin/payment?id=${payment.paymentId}">
                  <input type="hidden" name="action" value="paymentStatus">
                  <input type="hidden" name="paymentId" value="${payment.paymentId}">
                  <select name="status">
                    <option value="paid" ${payment.paymentStatus == 'paid' ? 'selected' : ''}>paid</option>
                    <option value="pending" ${payment.paymentStatus == 'pending' ? 'selected' : ''}>pending</option>
                    <option value="failed" ${payment.paymentStatus == 'failed' ? 'selected' : ''}>failed</option>
                    <option value="refunded" ${payment.paymentStatus == 'refunded' ? 'selected' : ''}>refunded</option>
                  </select>
                  <button type="submit"><i class="fa-regular fa-floppy-disk"></i> Save Status</button>
                </form>
              </div>
            </article>
          </aside>
        </section>
      </c:when>
      <c:otherwise>
        <section class="payment-not-found">
          <h2>Payment not found</h2>
          <p>The requested payment could not be loaded. Please go back to Manage Payments and try again.</p>
        </section>
      </c:otherwise>
    </c:choose>
  </main>
</div>
</body>
</html>
