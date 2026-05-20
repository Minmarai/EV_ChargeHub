<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Rijam Shrestha --%>
<html>
<head>
  <title>Manage Payments</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <style>
    .admin-payments-page .admin-content {
      background: #F5F7FA;
    }

    .admin-payments-head {
      margin-top: 18px;
      display: flex;
      justify-content: space-between;
      align-items: flex-end;
      gap: 14px;
    }

    .admin-payments-head h1 {
      margin: 0;
      font-size: 56px;
      letter-spacing: -1px;
      line-height: 1.05;
      color: #1A1F2B;
    }

    .admin-payments-head p {
      margin: 6px 0 0;
      font-size: 17px;
      color: #6B7280;
    }

    .admin-payments-actions {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      flex-wrap: wrap;
    }

    .admin-btn,
    .admin-btn-primary {
      height: 52px;
      border-radius: 14px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #374151;
      padding: 0 20px;
      font-size: 15px;
      font-weight: 600;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      text-decoration: none;
      font-family: inherit;
      cursor: pointer;
    }

    .admin-btn:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F8FBFF;
    }

    .admin-btn-primary {
      background: #2E7D32;
      border-color: #2E7D32;
      color: #FFFFFF;
    }

    .admin-btn-primary:hover {
      background: #256B29;
      border-color: #256B29;
      color: #FFFFFF;
    }

    .admin-payments-stats {
      margin-top: 16px;
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 12px;
    }

    .admin-payment-stat {
      background: #FFFFFF;
      border: 1px solid #E5E7EB;
      border-radius: 16px;
      padding: 18px;
      min-height: 160px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
    }

    .admin-payment-stat label {
      color: #7B8798;
      font-size: 14px;
      font-weight: 600;
      margin: 0;
    }

    .admin-payment-stat h3 {
      margin: 8px 0 0;
      color: #1F2937;
      font-size: 46px;
      line-height: 1;
      letter-spacing: -0.8px;
    }

    .admin-payment-stat p {
      margin: 6px 0 0;
      color: #9CA3AF;
      font-size: 13px;
    }

    .admin-stat-icon {
      width: 58px;
      height: 58px;
      border-radius: 14px;
      display: grid;
      place-items: center;
      font-size: 22px;
    }

    .admin-stat-icon.green {
      background: #ECF8EE;
      color: #2E7D32;
    }

    .admin-stat-icon.blue {
      background: #EAF3FF;
      color: #1976D2;
    }

    .admin-stat-icon.orange {
      background: #FFF6EB;
      color: #FF9800;
    }

    .admin-stat-icon.red {
      background: #FDECEC;
      color: #DC2626;
    }

    .admin-stat-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 10px;
    }

    .admin-payments-filter-card {
      margin-top: 14px;
      background: #FFFFFF;
      border: 1px solid #E5E7EB;
      border-radius: 16px;
      overflow: hidden;
    }

    .admin-payments-filters {
      padding: 14px;
      display: grid;
      grid-template-columns: minmax(280px, 1fr) 220px 220px 250px auto auto;
      gap: 10px;
      align-items: center;
      border-bottom: 1px solid #E5E7EB;
    }

    .admin-filter-input,
    .admin-filter-select,
    .admin-filter-date {
      height: 56px;
      border: 1px solid #CBD5E1;
      border-radius: 14px;
      background: #FFFFFF;
      display: inline-flex;
      align-items: center;
      gap: 10px;
      padding: 0 14px;
      color: #94A3B8;
    }

    .admin-filter-input input,
    .admin-filter-select select,
    .admin-filter-date input {
      width: 100%;
      border: 0 !important;
      outline: 0;
      padding: 0 !important;
      margin: 0 !important;
      height: auto !important;
      background: transparent !important;
      color: #1F2937;
      box-shadow: none !important;
      font-size: 15px;
      font-family: inherit;
    }

    .admin-filter-select select {
      appearance: none;
      -webkit-appearance: none;
      height: 100% !important;
      padding: 0 40px 0 14px !important;
      cursor: pointer;
    }

    .admin-filter-select {
      position: relative;
      padding: 0;
      gap: 0;
    }

    .admin-filter-select::after {
      content: "";
      position: absolute;
      right: 16px;
      top: 50%;
      width: 8px;
      height: 8px;
      border-right: 2px solid #94A3B8;
      border-bottom: 2px solid #94A3B8;
      transform: translateY(-60%) rotate(45deg);
      pointer-events: none;
    }

    .admin-filter-actions {
      height: 56px;
      border: 1px solid #D1D5DB;
      border-radius: 14px;
      background: #FFFFFF;
      color: #4B5563;
      font-size: 15px;
      font-weight: 600;
      cursor: pointer;
      padding: 0 18px;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
    }

    .admin-filter-actions:hover {
      color: #1976D2;
    }

    .admin-payments-table {
      width: 100%;
      border-collapse: collapse;
      border: 0;
      border-radius: 0;
    }

    .admin-payments-table thead th {
      background: #F8FAFC;
      color: #4B5563;
      text-transform: none;
      letter-spacing: 0;
      font-size: 16px;
      font-weight: 700;
      border-bottom: 1px solid #E5E7EB;
      padding: 14px 12px;
    }

    .admin-payments-table tbody td {
      padding: 14px 12px;
      border-bottom: 1px solid #EEF2F7;
      font-size: 15px;
      color: #333333;
      vertical-align: middle;
    }

    .admin-payments-table tbody tr:hover {
      background: #FAFCFF;
    }

    .admin-payments-table .col-check {
      width: 44px;
      text-align: center;
    }

    .admin-payments-table input[type="checkbox"] {
      width: 20px;
      height: 20px;
      accent-color: #1976D2;
      cursor: pointer;
    }

    .txn-ref {
      color: #1F2937;
      text-decoration: underline;
      text-underline-offset: 3px;
      font-weight: 600;
    }

    .booking-link {
      color: #1976D2;
      font-weight: 700;
      text-decoration: none;
    }

    .booking-link:hover {
      text-decoration: underline;
    }

    .user-cell {
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .user-avatar {
      width: 44px;
      height: 44px;
      border-radius: 999px;
      background: #EAF3FF;
      color: #1976D2;
      font-weight: 700;
      font-size: 16px;
      display: grid;
      place-items: center;
      flex-shrink: 0;
    }

    .user-cell strong {
      display: block;
      color: #1F2937;
      font-size: 16px;
      line-height: 1.2;
    }

    .user-cell small {
      color: #9CA3AF;
      font-size: 13px;
    }

    .amount-cell {
      font-size: 20px;
      line-height: 1.15;
      font-weight: 700;
      color: #1F2937;
    }

    .method-pill,
    .status-pill {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 6px 14px;
      border-radius: 999px;
      border: 1px solid #D1D5DB;
      font-size: 15px;
      font-weight: 600;
      white-space: nowrap;
    }

    .method-pill.khalti {
      background: #EAF3FF;
      border-color: #CFE3FF;
      color: #1976D2;
    }

    .method-pill.fonepay {
      background: #FFF1F2;
      border-color: #FFD8DA;
      color: #E64A4A;
    }

    .method-pill.card,
    .method-pill.visa,
    .method-pill.mastercard {
      background: #ECF8EE;
      border-color: #CDE8CF;
      color: #2E7D32;
    }

    .method-pill.default {
      background: #F3F4F6;
      border-color: #E5E7EB;
      color: #4B5563;
    }

    .status-pill.paid,
    .status-pill.success {
      background: #FFFFFF;
      color: #2E7D32;
      border-color: #CDE8CF;
    }

    .status-pill.pending {
      background: #FFFFFF;
      color: #FF9800;
      border-color: #FFD59B;
    }

    .status-pill.failed {
      background: #FFF1F2;
      color: #DC2626;
      border-color: #FFC9CE;
    }

    .status-pill.refunded {
      background: #EAF3FF;
      color: #1976D2;
      border-color: #CFE3FF;
    }

    .actions-cell {
      min-width: 250px;
    }

    .actions-group {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      flex-wrap: wrap;
    }

    .action-icon,
    .action-btn {
      height: 38px;
      border-radius: 10px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #6B7280;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      text-decoration: none;
      padding: 0 12px;
      font-size: 14px;
      font-weight: 600;
      cursor: pointer;
      font-family: inherit;
    }

    .action-icon {
      width: 38px;
      padding: 0;
    }

    .action-icon:hover,
    .action-btn:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F8FBFF;
    }

    .action-update {
      display: inline-flex;
      align-items: center;
      gap: 6px;
    }

    .action-update select {
      height: 38px;
      border: 1px solid #D1D5DB;
      border-radius: 10px;
      padding: 0 10px;
      font-size: 14px;
      color: #1F2937;
      background: #FFFFFF;
      margin: 0;
      min-width: 110px;
    }

    .table-empty {
      text-align: center;
      padding: 44px 12px;
      color: #9CA3AF;
      font-size: 15px;
    }

    .admin-payments-footer {
      padding: 16px 18px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      color: #7B8798;
      font-size: 14px;
      border-top: 1px solid #E5E7EB;
    }

    .admin-payments-pager {
      display: inline-flex;
      gap: 8px;
      align-items: center;
    }

    .admin-payments-pager button,
    .admin-payments-pager span {
      height: 44px;
      min-width: 44px;
      border-radius: 12px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #4B5563;
      font-size: 16px;
      font-weight: 600;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 0 12px;
    }

    .admin-payments-pager .active {
      background: #1976D2;
      border-color: #1976D2;
      color: #FFFFFF;
    }

    .admin-footer-note {
      text-align: center;
      color: #9CA3AF;
      font-size: 12px;
      margin-top: 18px;
      padding-bottom: 6px;
    }

    @media (max-width: 1400px) {
      .admin-payments-stats {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }

      .admin-payments-filters {
        grid-template-columns: 1fr 1fr;
      }
    }

    @media (max-width: 1024px) {
      .admin-payments-head {
        flex-direction: column;
        align-items: flex-start;
      }

      .admin-payments-head h1 {
        font-size: 42px;
      }

      .admin-payments-table-wrap {
        overflow-x: auto;
      }

      .admin-payments-table {
        min-width: 1320px;
      }
    }

    @media (max-width: 760px) {
      .admin-payments-stats,
      .admin-payments-filters {
        grid-template-columns: 1fr;
      }

      .admin-payments-head h1 {
        font-size: 34px;
      }

      .admin-payments-actions {
        width: 100%;
      }

      .admin-btn,
      .admin-btn-primary {
        width: 100%;
        justify-content: center;
      }
    }
  </style>
</head>
<body class="admin-dashboard-page admin-payments-page">
<div class="admin-shell">
  <jsp:include page="../common/admin-sidebar.jsp"/>

  <main class="admin-content">
    <section class="admin-topbar">
      <div class="admin-breadcrumb">
        <span>Console</span>
        <i class="fa-solid fa-chevron-right"></i>
        <strong>Manage Payments</strong>
      </div>
      <div class="admin-topbar-actions">
        <div class="admin-user-chip">
          <div><strong>Admin User</strong><small>Super Administrator</small></div>
          <span>A</span>
        </div>
      </div>
    </section>

    <section class="admin-payments-head">
      <div>
        <h1>Manage Payments</h1>
        <p>Review, monitor, and audit transaction records across the network.</p>
      </div>
    </section>

    <section class="admin-payments-stats">
      <article class="admin-payment-stat">
        <div class="admin-stat-row">
          <div>
            <label>Total Revenue</label>
            <h3>NPR ${paymentsRevenue}</h3>
          </div>
          <span class="admin-stat-icon green"><i class="fa-regular fa-credit-card"></i></span>
        </div>
        <p><i class="fa-solid fa-arrow-trend-up"></i> paid transactions summary</p>
      </article>

      <article class="admin-payment-stat">
        <div class="admin-stat-row">
          <div>
            <label>Successful Payments</label>
            <h3>${paidCount}</h3>
          </div>
          <span class="admin-stat-icon blue"><i class="fa-regular fa-circle-check"></i></span>
        </div>
        <p><i class="fa-solid fa-arrow-trend-up"></i> completed and verified</p>
      </article>

      <article class="admin-payment-stat">
        <div class="admin-stat-row">
          <div>
            <label>Pending Verification</label>
            <h3>${pendingCount}</h3>
          </div>
          <span class="admin-stat-icon orange"><i class="fa-regular fa-clock"></i></span>
        </div>
        <p><i class="fa-regular fa-clock"></i> requires status update</p>
      </article>

      <article class="admin-payment-stat">
        <div class="admin-stat-row">
          <div>
            <label>Failed Transactions</label>
            <h3>${failedCount}</h3>
          </div>
          <span class="admin-stat-icon red"><i class="fa-regular fa-circle-xmark"></i></span>
        </div>
        <p><i class="fa-solid fa-triangle-exclamation"></i> review payment logs</p>
      </article>
    </section>

    <section class="admin-payments-filter-card">
      <form class="admin-payments-filters" method="get" action="${pageContext.request.contextPath}/admin/payments">
        <input type="hidden" name="pageSize" value="${pageSize}">
        <label class="admin-filter-input">
          <i class="fa-solid fa-magnifying-glass"></i>
          <input id="payment-search" type="text" name="q" value="${q}" placeholder="Search Transaction ID, booking, or user...">
        </label>

        <div class="admin-filter-select">
          <select name="status">
            <option value="">All Status</option>
            <option value="paid" ${status == 'paid' ? 'selected' : ''}>Success</option>
            <option value="pending" ${status == 'pending' ? 'selected' : ''}>Pending</option>
            <option value="failed" ${status == 'failed' ? 'selected' : ''}>Failed</option>
            <option value="refunded" ${status == 'refunded' ? 'selected' : ''}>Refunded</option>
          </select>
        </div>

        <div class="admin-filter-select">
          <select name="method">
            <option value="">All Methods</option>
            <c:forEach var="m" items="${methods}">
              <option value="${m}" ${method == m ? 'selected' : ''}>${m}</option>
            </c:forEach>
          </select>
        </div>

        <label class="admin-filter-date">
          <i class="fa-regular fa-calendar"></i>
          <input type="date" name="paymentDate" value="${paymentDate}">
        </label>

        <a class="admin-filter-actions" href="${pageContext.request.contextPath}/admin/payments">Reset</a>
        <button class="admin-btn-primary" type="submit">Apply Filters</button>
      </form>

      <div class="admin-payments-table-wrap">
        <table class="admin-payments-table">
          <thead>
          <tr>
            <th class="col-check"><input type="checkbox" id="checkAllPayments"></th>
            <th>Transaction Ref</th>
            <th>Booking ID</th>
            <th>User</th>
            <th>Amount</th>
            <th>Method</th>
            <th>Date & Time</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="p" items="${payments}">
            <tr>
              <td class="col-check"><input type="checkbox" name="selectedPayments" value="${p.paymentId}"></td>
              <td><span class="txn-ref">${empty p.transactionReference ? 'TRX-' : p.transactionReference}</span></td>
              <td><a class="booking-link" href="${pageContext.request.contextPath}/admin/booking?id=${p.bookingId}">BK-${p.bookingId}</a></td>
              <td>
                <div class="user-cell">
                  <span class="user-avatar">
                    <c:choose>
                      <c:when test="${not empty p.userName}">${fn:substring(p.userName, 0, 1)}</c:when>
                      <c:otherwise>U</c:otherwise>
                    </c:choose>
                  </span>
                  <div>
                    <strong>${p.userName}</strong>
                    <small>${p.stationName}</small>
                  </div>
                </div>
              </td>
              <td class="amount-cell">NPR ${p.amount}</td>
              <td>
                <c:set var="methodLc" value="${fn:toLowerCase(p.paymentMethod)}"/>
                <span class="method-pill ${fn:contains(methodLc, 'khalti') ? 'khalti' : (fn:contains(methodLc, 'fonepay') ? 'fonepay' : (fn:contains(methodLc, 'card') ? 'card' : (fn:contains(methodLc, 'visa') ? 'visa' : (fn:contains(methodLc, 'master') ? 'mastercard' : 'default'))))}">
                  <i class="fa-regular fa-credit-card"></i>
                  ${p.paymentMethod}
                </span>
              </td>
              <td>${p.paymentDate}</td>
              <td>
                <span class="status-pill ${fn:toLowerCase(p.paymentStatus)}">
                  <i class="fa-regular fa-circle-dot"></i>
                  ${fn:toUpperCase(fn:substring(p.paymentStatus,0,1))}${fn:substring(p.paymentStatus,1,fn:length(p.paymentStatus))}
                </span>
              </td>
              <td class="actions-cell">
                <div class="actions-group">
                  <a class="action-icon" title="View Details" href="${pageContext.request.contextPath}/admin/payment?id=${p.paymentId}"><i class="fa-regular fa-eye"></i></a>
                  <form method="post" class="action-update">
                    <input type="hidden" name="action" value="paymentStatus">
                    <input type="hidden" name="paymentId" value="${p.paymentId}">
                    <select name="status">
                      <option value="paid" ${p.paymentStatus == 'paid' ? 'selected' : ''}>paid</option>
                      <option value="pending" ${p.paymentStatus == 'pending' ? 'selected' : ''}>pending</option>
                      <option value="failed" ${p.paymentStatus == 'failed' ? 'selected' : ''}>failed</option>
                      <option value="refunded" ${p.paymentStatus == 'refunded' ? 'selected' : ''}>refunded</option>
                    </select>
                    <button class="action-btn" type="submit">Update</button>
                  </form>
                </div>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty payments}">
            <tr>
              <td colspan="9" class="table-empty">No payments found for the selected filters.</td>
            </tr>
          </c:if>
          </tbody>
        </table>
      </div>

      <div class="admin-payments-footer">
        <span>Showing ${paymentsFrom}-${paymentsTo} of ${paymentsFilteredCount} transactions</span>
        <div class="admin-payments-pager">
          <a class="admin-btn" href="${pageContext.request.contextPath}/admin/payments?q=${q}&status=${status}&method=${method}&paymentDate=${paymentDate}&pageSize=${pageSize}&page=${page - 1}" ${page <= 1 ? 'aria-disabled="true" style="height:44px;pointer-events:none;opacity:.5"' : 'style="height:44px"'}>Previous</a>
          <c:forEach begin="1" end="${totalPages}" var="pNum">
            <a class="admin-btn ${pNum == page ? 'active' : ''}" style="height:44px;min-width:44px;padding:0 12px;justify-content:center" href="${pageContext.request.contextPath}/admin/payments?q=${q}&status=${status}&method=${method}&paymentDate=${paymentDate}&pageSize=${pageSize}&page=${pNum}">${pNum}</a>
          </c:forEach>
          <a class="admin-btn" href="${pageContext.request.contextPath}/admin/payments?q=${q}&status=${status}&method=${method}&paymentDate=${paymentDate}&pageSize=${pageSize}&page=${page + 1}" ${page >= totalPages ? 'aria-disabled="true" style="height:44px;pointer-events:none;opacity:.5"' : 'style="height:44px"'}>Next</a>
        </div>
      </div>
    </section>

    <div class="admin-footer-note">&copy; 2026 ChargeHub Nepal Admin Console. All rights reserved.</div>
  </main>
</div>

<script>
  document.getElementById('checkAllPayments')?.addEventListener('change', function() {
    document.querySelectorAll('input[name="selectedPayments"]').forEach((checkbox) => {
      checkbox.checked = this.checked;
    });
  });
</script>
</body>
</html>
