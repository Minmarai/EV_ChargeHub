<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Denisha Tamang --%>
<html>
<head>
  <title>Payment History</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <style>
    .user-payments-page {
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

    .user-payments-page .layout {
      min-height: calc(100vh - 72px);
      background: #F5F7FA;
    }

    .user-payments-page .user-sidebar {
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

    .user-payments-page .user-side-brand,
    .user-payments-page .user-side-logout {
      display: none;
    }

    .user-payments-page .user-side-nav {
      display: grid;
      gap: 6px;
    }

    .user-payments-page .user-side-nav a {
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

    .user-payments-page .user-side-nav a i {
      width: 28px;
      text-align: center;
      color: #8C95A3;
      font-size: 18px;
      line-height: 1;
    }

    .user-payments-page .user-side-nav a:hover {
      background: #FFFFFF;
      border-color: #E5E7EB;
      color: #4B5563;
    }

    .user-payments-page .user-side-nav a.active {
      background: #00B300;
      border-color: #00B300;
      color: #FFFFFF;
      font-weight: 700;
    }

    .user-payments-page .user-side-nav a.active i {
      color: #FFFFFF;
    }

    .user-payments-page .main {
      background: #F5F7FA;
      padding: 18px;
    }

    .payments-shell {
      max-width: 1240px;
      margin: 0 auto;
      display: grid;
      gap: 14px;
    }

    .head-row {
      display: flex;
      align-items: flex-start;
      justify-content: space-between;
      gap: 12px;
      flex-wrap: wrap;
    }

    .head-row h1 {
      margin: 0;
      color: #111827;
      font-size: 30px;
      line-height: 1.05;
      letter-spacing: -0.7px;
      font-weight: 800;
      overflow-wrap: anywhere;
    }

    .head-row p {
      margin: 9px 0 0;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.35;
      font-weight: 500;
    }

    .export-btn {
      min-height: 42px;
      border-radius: 12px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #1F2937;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      padding: 0 16px;
      font-size: 14px;
      line-height: 1;
      font-weight: 700;
    }

    .export-btn:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F1F7FF;
    }

    .table-wrap {
      background: #FFFFFF;
      border: 1px solid #E5E7EB;
      border-radius: 16px;
      box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04);
      overflow: hidden;
    }

    .toolbar {
      padding: 14px;
      border-bottom: 1px solid #EDF1F6;
      display: grid;
      grid-template-columns: 1fr auto;
      gap: 10px;
      align-items: center;
    }

    .search-wrap {
      position: relative;
      max-width: 420px;
      width: 100%;
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
      width: 100%;
      min-height: 40px;
      border-radius: 11px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #1F2937;
      font-size: 14px;
      padding: 0 12px 0 34px;
      font-family: inherit;
    }

    .search-wrap input:focus,
    .status-filter:focus {
      outline: none;
      border-color: #1976D2;
      box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.12);
    }

    .toolbar-right {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .status-filter {
      min-height: 40px;
      border-radius: 11px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #1F2937;
      font-size: 14px;
      font-family: inherit;
      padding: 0 10px;
      min-width: 140px;
      margin: 0;
      display: inline-flex;
      align-items: center;
    }

    .apply-btn {
      min-height: 40px;
      border-radius: 11px;
      border: 1px solid #D1D5DB;
      background: #F8FAFC;
      color: #1F2937;
      font-size: 14px;
      line-height: 1;
      font-weight: 700;
      font-family: inherit;
      padding: 0 12px;
      cursor: pointer;
      margin: 0;
      display: inline-flex;
      align-items: center;
    }

    .apply-btn:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F1F7FF;
    }

    .payment-table {
      width: 100%;
      border-collapse: collapse;
    }

    .payment-table th,
    .payment-table td {
      padding: 14px 16px;
      border-bottom: 1px solid #EDF1F6;
      text-align: left;
      vertical-align: middle;
    }

    .payment-table th {
      background: #F8FAFC;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1;
      font-weight: 700;
      text-transform: uppercase;
      white-space: nowrap;
    }

    .payment-table td {
      color: #1F2937;
      font-size: 14px;
      line-height: 1.25;
      font-weight: 600;
    }

    .pid {
      color: #111827;
      font-size: 16px;
      line-height: 1;
      font-weight: 700;
      white-space: nowrap;
    }

    .booking-link {
      color: #00A511;
      text-decoration: none;
      font-weight: 700;
      white-space: nowrap;
    }

    .booking-link:hover {
      color: #2E7D32;
      text-decoration: underline;
    }

    .amount {
      color: #111827;
      font-size: 16px;
      font-weight: 800;
      white-space: nowrap;
    }

    .method {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      color: #1F2937;
      font-weight: 600;
      text-transform: capitalize;
    }

    .method i {
      width: 26px;
      height: 26px;
      border-radius: 8px;
      border: 1px solid #E5E7EB;
      background: #F8FAFC;
      display: grid;
      place-items: center;
      color: #8C95A3;
      font-size: 13px;
    }

    .status-pill {
      border-radius: 999px;
      border: 1px solid #E5E7EB;
      background: #F8FAFC;
      color: #374151;
      font-size: 13px;
      line-height: 1;
      font-weight: 700;
      padding: 7px 12px;
      text-transform: capitalize;
      display: inline-flex;
      align-items: center;
      gap: 7px;
      white-space: nowrap;
    }

    .status-pill.paid,
    .status-pill.success {
      background: #ECF8EE;
      border-color: #C5E8CD;
      color: #2E7D32;
    }

    .status-pill.pending {
      background: #FFF4E8;
      border-color: #FFD9B0;
      color: #B45309;
    }

    .status-pill.failed {
      background: #FDEDED;
      border-color: #F7C5C5;
      color: #DC2626;
    }

    .act-link {
      color: #1976D2;
      text-decoration: none;
      font-size: 13px;
      line-height: 1;
      font-weight: 700;
      white-space: nowrap;
      display: inline-flex;
      align-items: center;
      gap: 6px;
    }

    .act-link:hover {
      color: #145CA3;
    }

    .table-foot {
      padding: 14px 16px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 10px;
      flex-wrap: wrap;
      color: #8C95A3;
      font-size: 14px;
      font-weight: 500;
    }

    .pager {
      display: inline-flex;
      align-items: center;
      gap: 8px;
    }

    .pager-btn {
      min-height: 40px;
      border-radius: 12px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #1F2937;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 7px;
      padding: 0 14px;
      font-size: 14px;
      line-height: 1;
      font-weight: 700;
    }

    .pager-btn:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F1F7FF;
    }

    .pager-btn.disabled {
      border-color: #E5E7EB;
      color: #9CA3AF;
      background: #F8FAFC;
      pointer-events: none;
    }

    .pager-text {
      color: #111827;
      font-size: 15px;
      line-height: 1;
      font-weight: 700;
    }

    .empty {
      padding: 30px 16px;
      text-align: center;
      color: #8C95A3;
      font-size: 14px;
      line-height: 1.4;
      font-weight: 500;
    }

    @media (max-width: 980px) {
      .user-payments-page .layout {
        flex-direction: column;
      }

      .user-payments-page .user-sidebar {
        position: static;
        width: 100%;
        min-height: auto;
        padding: 10px 12px;
        overflow: hidden;
      }

      .user-payments-page .user-side-nav {
        display: flex;
        gap: 8px;
        overflow-x: auto;
        padding-bottom: 2px;
        scrollbar-width: thin;
        -webkit-overflow-scrolling: touch;
      }

      .user-payments-page .user-side-nav a {
        flex: 0 0 auto;
        min-width: max-content;
        padding: 10px 12px;
        border-radius: 10px;
      }

      .user-payments-page .main {
        padding: 14px;
      }

      .head-row h1 {
        font-size: 26px;
      }

      .head-row p {
        font-size: 13px;
      }

      .table-wrap {
        overflow-x: auto;
      }

      .payment-table {
        min-width: 1050px;
      }
    }

    @media (max-width: 700px) {
      .toolbar {
        grid-template-columns: 1fr;
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

      .user-payments-page .main {
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

      .head-row h1 {
        font-size: 22px;
      }

      .head-row p {
        font-size: 12px;
      }
    }
  </style>
</head>
<body class="user-payments-page">
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
    <div class="payments-shell">
      <section class="head-row">
        <div>
          <h1>Payment History</h1>
          <p>Manage and view all your transaction records.</p>
        </div>

        
      </section>

      <section class="table-wrap">
        <form method="get" action="${pageContext.request.contextPath}/user/payments" class="toolbar">
          <label class="search-wrap" for="q">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input id="q" name="q" type="text" value="${paymentSearchFilter}" placeholder="Search by Payment or Booking ID...">
          </label>

          <div class="toolbar-right">
            <select class="status-filter" name="status">
              <option value="" ${empty paymentStatusFilter ? 'selected' : ''}>All Status</option>
              <option value="success" ${paymentStatusFilter == 'success' ? 'selected' : ''}>Success</option>
              <option value="pending" ${paymentStatusFilter == 'pending' ? 'selected' : ''}>Pending</option>
            </select>
            <button class="apply-btn" type="submit">Apply</button>
          </div>
        </form>

        <c:choose>
          <c:when test="${not empty payments}">
            <table class="payment-table">
              <thead>
              <tr>
                <th>Payment ID</th>
                <th>Booking ID</th>
                <th>Amount</th>
                <th>Payment Method</th>
                <th>Status</th>
                <th>Payment Date</th>
                <th>Action</th>
              </tr>
              </thead>
              <tbody>
              <c:forEach var="p" items="${payments}">
                <c:set var="statusClass" value="${fn:toLowerCase(p.paymentStatus != null ? p.paymentStatus : 'pending')}"/>
                <tr>
                  <td><span class="pid">PAY-${p.paymentId}</span></td>
                  <td><a class="booking-link" href="${pageContext.request.contextPath}/user/booking?id=${p.bookingId}">CHN-${p.bookingId}</a></td>
                  <td><span class="amount">NPR ${p.amount}</span></td>
                  <td><span class="method"><i class="fa-regular fa-credit-card"></i>${p.paymentMethod}</span></td>
                  <td><span class="status-pill ${statusClass}"><i class="fa-regular fa-circle-check"></i>${statusClass == 'paid' ? 'Success' : p.paymentStatus}</span></td>
                  <td>${paymentDateLabels[p.paymentId]}</td>
                  <td><a class="act-link" href="${pageContext.request.contextPath}/user/booking?id=${p.bookingId}"><i class="fa-regular fa-eye"></i>View</a></td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </c:when>
          <c:otherwise>
            <div class="empty">No payments found for the selected filters.</div>
          </c:otherwise>
        </c:choose>

        <div class="table-foot">
          <span>Showing ${startResult} to ${endResult} of ${totalPaymentCount} results</span>
          <div class="pager">
            <c:choose>
              <c:when test="${hasPrev}">
                <a class="pager-btn" href="${pageContext.request.contextPath}/user/payments?page=${prevPage}&q=${fn:escapeXml(paymentSearchFilter)}&status=${paymentStatusFilter}"><i class="fa-solid fa-chevron-left"></i>Previous</a>
              </c:when>
              <c:otherwise>
                <span class="pager-btn disabled"><i class="fa-solid fa-chevron-left"></i>Previous</span>
              </c:otherwise>
            </c:choose>
            <span class="pager-text">Page ${currentPage} of ${totalPages}</span>
            <c:choose>
              <c:when test="${hasNext}">
                <a class="pager-btn" href="${pageContext.request.contextPath}/user/payments?page=${nextPage}&q=${fn:escapeXml(paymentSearchFilter)}&status=${paymentStatusFilter}">Next<i class="fa-solid fa-chevron-right"></i></a>
              </c:when>
              <c:otherwise>
                <span class="pager-btn disabled">Next<i class="fa-solid fa-chevron-right"></i></span>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </section>
    </div>
  </main>
</div>
</body>
</html>
