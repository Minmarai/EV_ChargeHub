<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Rijam Shrestha --%>
<html>
<head>
  <title>Manage Bookings</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <style>
    /* ─── BOOKINGS PAGE OVERRIDES ─── */
    .admin-bookings-page .admin-content {
      padding: 0 24px 24px;
      background: #F9FAFB;
    }

    /* ── Top bar ── */
    .admin-bookings-page .admin-topbar {
      background: #fff;
      border: none;
      border-bottom: 1px solid #E5E7EB;
      border-radius: 0;
      padding: 12px 0;
      margin: 0 0 20px;
    }

    .admin-bookings-page .admin-breadcrumb strong {
      font-size: 14px;
      color: #111827;
    }
    .admin-bookings-page .admin-breadcrumb span {
      font-size: 13px;
      color: #9CA3AF;
    }

    /* ── Page header ── */
    .bookings-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
    }

    .bookings-header h1 {
      margin: 0;
      font-size: 24px;
      font-weight: 800;
      color: #111827;
      letter-spacing: -0.3px;
    }

    .bookings-header-actions {
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .btn-refresh {
      width: 38px;
      height: 38px;
      padding: 0;
      border-radius: 10px;
      border: 1px solid #D1D5DB;
      background: #fff;
      color: #374151;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      font-size: 14px;
    }
    .btn-refresh:hover {
      border-color: #9CA3AF;
      background: #F9FAFB;
    }

    .btn-create {
      height: 38px;
      padding: 0 18px;
      border-radius: 10px;
      border: none;
      background: #16A34A;
      color: #fff;
      font-weight: 600;
      font-size: 13px;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      cursor: pointer;
      font-family: inherit;
      text-decoration: none;
    }
    .btn-create:hover {
      background: #15803D;
    }

    /* ── Filter card ── */
    .bookings-filter-card {
      background: #fff;
      border: 1px solid #E5E7EB;
      border-radius: 14px;
      padding: 20px 24px;
      margin-bottom: 20px;
    }

    .bookings-filter-row {
      display: flex;
      align-items: flex-start;
      gap: 20px;
    }

    .filter-group {
      display: flex;
      flex-direction: column;
      gap: 6px;
      flex-shrink: 0;
    }

    .filter-group label,
    .filter-status-group > label {
      font-size: 11px !important;
      font-weight: 600 !important;
      color: #6B7280 !important;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      margin: 0 !important;
    }

    /* Override global select/input styles for filter controls */
    .bookings-filter-card select,
    .bookings-filter-card input[type="text"] {
      height: 38px !important;
      border: 1px solid #D1D5DB !important;
      border-radius: 8px !important;
      padding: 0 12px !important;
      font-size: 13px !important;
      color: #374151 !important;
      background: #fff !important;
      font-family: inherit;
      margin: 0 !important;
      box-sizing: border-box;
      min-width: 150px;
    }

    .bookings-filter-card select:focus,
    .bookings-filter-card input[type="text"]:focus {
      outline: none;
      border-color: #16A34A !important;
      box-shadow: 0 0 0 2px rgba(22, 163, 74, 0.1);
    }

    .filter-date-wrap {
      position: relative;
    }

    .filter-date-wrap input[type="text"] {
      padding: 0 12px 0 34px !important;
      min-width: 180px;
    }

    .filter-date-wrap i {
      position: absolute;
      left: 12px;
      top: 50%;
      transform: translateY(-50%);
      color: #9CA3AF;
      font-size: 13px;
      pointer-events: none;
    }

    /* ── Status pills in filter ── */
    .filter-status-group {
      display: flex;
      flex-direction: column;
      gap: 6px;
      flex: 1;
      min-width: 0;
    }

    .filter-status-pills {
      display: flex;
      align-items: center;
      gap: 6px;
      flex-wrap: nowrap;
    }

    .status-pill-filter {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      border: 1px solid #D1D5DB;
      background: #fff;
      color: #6B7280;
      border-radius: 20px;
      height: 32px;
      padding: 0 14px;
      font-size: 13px;
      font-weight: 500;
      text-decoration: none;
      cursor: pointer;
      transition: all 0.15s;
      white-space: nowrap;
    }

    .status-pill-filter:hover {
      border-color: #16A34A;
      color: #16A34A;
    }

    .status-pill-filter.active {
      background: #16A34A;
      color: #fff;
      border-color: #16A34A;
    }

    /* ── Filter actions (below status pills) ── */
    .filter-actions-inline {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-top: 8px;
    }

    .btn-reset-filters {
      height: 32px;
      padding: 0 16px;
      border-radius: 8px;
      border: none;
      background: #16A34A;
      color: #fff;
      font-size: 13px;
      font-weight: 600;
      cursor: pointer;
      font-family: inherit;
      text-decoration: none;
      white-space: nowrap;
      display: inline-flex;
      align-items: center;
      gap: 4px;
    }
    .btn-reset-filters:hover {
      background: #15803D;
    }

    .btn-apply {
      height: 32px;
      padding: 0 20px;
      border-radius: 8px;
      border: none;
      background: #16A34A;
      color: #fff;
      font-weight: 600;
      font-size: 13px;
      cursor: pointer;
      font-family: inherit;
    }
    .btn-apply:hover {
      background: #15803D;
    }

    /* ── Table card ── */
    .bookings-table-card {
      background: #fff;
      border: 1px solid #E5E7EB;
      border-radius: 14px;
      overflow: hidden;
    }

    .bookings-table {
      width: 100%;
      border-collapse: collapse;
    }

    .bookings-table th {
      padding: 12px 16px;
      background: #F9FAFB;
      color: #6B7280;
      text-align: left;
      font-size: 11px;
      font-weight: 600;
      letter-spacing: 0.04em;
      text-transform: uppercase;
      border-bottom: 1px solid #E5E7EB;
    }

    .bookings-table td {
      padding: 14px 16px;
      border-bottom: 1px solid #F3F4F6;
      font-size: 13px;
      color: #374151;
      vertical-align: middle;
    }

    .bookings-table tbody tr:hover {
      background: #F9FAFB;
    }

    .bookings-table tbody tr:last-child td {
      border-bottom: none;
    }

    /* Checkbox column */
    .col-check {
      width: 40px;
      text-align: center;
    }
    .col-check input[type="checkbox"] {
      width: 16px;
      height: 16px;
      accent-color: #16A34A;
      cursor: pointer;
    }

    /* Booking ID */
    .booking-id {
      color: #16A34A;
      font-weight: 700;
      font-size: 13px;
    }

    /* User details cell */
    .user-details {
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .user-avatar {
      width: 36px;
      height: 36px;
      border-radius: 50%;
      background: #E5E7EB;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 14px;
      font-weight: 700;
      color: #6B7280;
      flex-shrink: 0;
      overflow: hidden;
    }

    .user-avatar img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    .user-info strong {
      display: block;
      font-size: 13px;
      font-weight: 600;
      color: #111827;
    }

    .user-info small {
      color: #9CA3AF;
      font-size: 12px;
    }

    /* Station cell */
    .station-cell {
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .station-cell i {
      color: #9CA3AF;
      font-size: 12px;
    }

    /* Slot & Duration */
    .slot-duration {
      line-height: 1.5;
    }

    .slot-duration .slot-date {
      display: flex;
      align-items: center;
      gap: 5px;
      font-weight: 600;
      color: #111827;
      font-size: 13px;
    }

    .slot-duration .slot-date i {
      color: #16A34A;
      font-size: 11px;
    }

    .slot-duration .slot-time {
      color: #9CA3AF;
      font-size: 12px;
    }

    /* Payment cell */
    .payment-cell .amount {
      font-weight: 700;
      color: #111827;
      font-size: 13px;
    }
    .payment-cell .pay-status {
      font-size: 11px;
      text-transform: uppercase;
      font-weight: 600;
      letter-spacing: 0.03em;
    }
    .payment-cell .pay-status.paid {
      color: #16A34A;
    }
    .payment-cell .pay-status.pending {
      color: #D97706;
    }
    .payment-cell .pay-status.refunded {
      color: #DC2626;
    }

    /* Status pill */
    .status-pill {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 6px;
      font-weight: 600;
      font-size: 12px;
      border: 1px solid;
      line-height: 1.4;
      text-transform: capitalize;
    }

    .status-pill.reserved {
      color: #16A34A;
      background: #F0FDF4;
      border-color: #BBF7D0;
    }
    .status-pill.active {
      color: #16A34A;
      background: #F0FDF4;
      border-color: #BBF7D0;
    }
    .status-pill.completed {
      color: #6B7280;
      background: #F3F4F6;
      border-color: #E5E7EB;
    }
    .status-pill.cancelled {
      color: #DC2626;
      background: #FEF2F2;
      border-color: #FECACA;
    }
    .status-pill.pending {
      color: #D97706;
      background: #FFFBEB;
      border-color: #FDE68A;
    }

    /* Manager cell */
    .manager-cell {
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .manager-cell i {
      color: #9CA3AF;
      font-size: 12px;
    }
    .manager-cell span {
      font-size: 13px;
      color: #374151;
    }

    /* Actions */
    .table-actions {
      display: flex;
      gap: 6px;
      align-items: center;
    }

    .icon-action {
      width: 32px;
      height: 32px;
      border-radius: 8px;
      border: 1px solid #E5E7EB;
      background: #fff;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      color: #6B7280;
      text-decoration: none;
      cursor: pointer;
      font-size: 13px;
      transition: all 0.15s;
    }
    .icon-action:hover {
      border-color: #16A34A;
      color: #16A34A;
      background: #F0FDF4;
    }

    /* ── Table footer ── */
    .table-footer {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 14px 16px;
      border-top: 1px solid #F3F4F6;
    }

    .table-footer .showing-text {
      font-size: 13px;
      color: #6B7280;
    }

    .pagination {
      display: flex;
      align-items: center;
      gap: 4px;
    }

    .pagination a, .pagination span {
      min-width: 32px;
      height: 32px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      border-radius: 8px;
      font-size: 13px;
      font-weight: 500;
      color: #374151;
      border: 1px solid #E5E7EB;
      background: #fff;
      text-decoration: none;
      cursor: pointer;
      transition: all 0.15s;
    }

    .pagination a:hover {
      border-color: #16A34A;
      color: #16A34A;
    }

    .pagination .active-page {
      background: #16A34A;
      color: #fff;
      border-color: #16A34A;
    }

    .pagination .ellipsis {
      border: none;
      background: none;
      cursor: default;
      color: #9CA3AF;
    }

    /* ── Empty state ── */
    .empty-row {
      text-align: center;
      color: #9CA3AF;
      padding: 48px 16px;
      font-size: 14px;
    }

    /* ── Footer bar ── */
    .admin-footer-bar {
      text-align: center;
      padding: 20px 0;
      color: #9CA3AF;
      font-size: 12px;
      margin-top: 24px;
    }

    /* ── Responsive ── */
    @media (max-width: 1280px) {
      .bookings-filter-row {
        flex-wrap: wrap;
      }
      .filter-status-group {
        width: 100%;
      }
      .filter-status-pills {
        flex-wrap: wrap;
      }
    }

    @media (max-width: 768px) {
      .bookings-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 12px;
      }
      .bookings-filter-row {
        flex-direction: column;
      }
      .filter-group {
        width: 100%;
      }
      .bookings-filter-card select,
      .bookings-filter-card input[type="text"] {
        width: 100% !important;
        min-width: unset !important;
      }
    }
  </style>
</head>
<body class="admin-dashboard-page admin-bookings-page">
<div class="admin-shell">
  <jsp:include page="../common/admin-sidebar.jsp"/>

  <main class="admin-content">
    <!-- Topbar -->
    <section class="admin-topbar">
      <div class="admin-breadcrumb">
        <span>Console</span>
        <i class="fa-solid fa-chevron-right"></i>
        <strong>Manage Bookings</strong>
      </div>
      <div class="admin-topbar-actions">
        <div class="admin-user-chip">
          <div><strong>Admin User</strong><small>Super Administrator</small></div>
          <span>A</span>
        </div>
      </div>
    </section>

    <!-- Page header -->
    <section class="bookings-header">
      <h1>Manage Bookings</h1>
      <div class="bookings-header-actions">
        <a class="btn-refresh" href="${pageContext.request.contextPath}/admin/bookings"><i class="fa-solid fa-arrow-rotate-right"></i></a>
      </div>
    </section>

    <!-- Filter card -->
    <section class="bookings-filter-card">
      <form method="get" action="${pageContext.request.contextPath}/admin/bookings">
        <input type="hidden" name="pageSize" value="${pageSize}">
        <div class="bookings-filter-row">
          <!-- Station -->
          <div class="filter-group">
            <label>Station</label>
            <select name="stationId">
              <option value="">All Stations</option>
              <c:forEach var="s" items="${stations}">
                <option value="${s.stationId}" ${stationId == s.stationId.toString() ? 'selected' : ''}>${s.stationName}</option>
              </c:forEach>
            </select>
          </div>

          <!-- Manager -->
          <div class="filter-group">
            <label>Manager</label>
            <select name="managerId">
              <option value="">All Managers</option>
              <c:forEach var="m" items="${managers}">
                <option value="${m.userId}" ${managerId == m.userId.toString() ? 'selected' : ''}>${m.fullName}</option>
              </c:forEach>
            </select>
          </div>

          <!-- Date Range -->
          <div class="filter-group">
            <label>Date Range</label>
            <div class="filter-date-wrap">
              <i class="fa-regular fa-calendar"></i>
              <input type="text" name="bookingDate" value="${bookingDate}" placeholder="Select date range">
            </div>
          </div>

          <!-- Booking Status -->
          <div class="filter-status-group">
            <label>Booking Status</label>
            <div class="filter-status-pills">
              <a class="status-pill-filter ${empty status ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/bookings?stationId=${stationId}&managerId=${managerId}&bookingDate=${bookingDate}">All</a>
              <a class="status-pill-filter ${status == 'reserved' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/bookings?stationId=${stationId}&managerId=${managerId}&bookingDate=${bookingDate}&status=reserved">Reserved</a>
              <a class="status-pill-filter ${status == 'active' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/bookings?stationId=${stationId}&managerId=${managerId}&bookingDate=${bookingDate}&status=active">Active</a>
              <a class="status-pill-filter ${status == 'completed' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/bookings?stationId=${stationId}&managerId=${managerId}&bookingDate=${bookingDate}&status=completed">Completed</a>
              <a class="status-pill-filter ${status == 'cancelled' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/bookings?stationId=${stationId}&managerId=${managerId}&bookingDate=${bookingDate}&status=cancelled">Cancelled</a>
              <input type="hidden" name="status" value="${status}">
            </div>
            <div class="filter-actions-inline">
              <a href="${pageContext.request.contextPath}/admin/bookings" class="btn-reset-filters">Reset Filters</a>
              <button type="submit" class="btn-apply">Apply</button>
            </div>
          </div>
        </div>
      </form>
    </section>

    <!-- Table -->
    <section class="bookings-table-card">
      <table class="bookings-table">
        <thead>
        <tr>
          <th class="col-check"><input type="checkbox" id="selectAll"></th>
          <th>Booking ID</th>
          <th>User Details</th>
          <th>Charging Station</th>
          <th>Slot & Duration</th>
          <th>Payment</th>
          <th>Status</th>
          <th>Manager</th>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="b" items="${bookings}">
          <tr>
            <td class="col-check"><input type="checkbox" name="bookingCheck" value="${b.bookingId}"></td>
            <td><span class="booking-id">BK-${b.bookingId}</span></td>
            <td>
              <div class="user-details">
                <div class="user-avatar">
                  <c:choose>
                    <c:when test="${not empty b.userName}">
                      ${fn:substring(b.userName, 0, 1)}
                    </c:when>
                    <c:otherwise>?</c:otherwise>
                  </c:choose>
                </div>
                <div class="user-info">
                  <strong>${b.userName}</strong>
                  <small>${empty b.userPhone ? '' : b.userPhone}</small>
                </div>
              </div>
            </td>
            <td>
              <div class="station-cell">
                <i class="fa-solid fa-location-dot"></i>
                <span>${empty b.stationName ? '-' : b.stationName}</span>
              </div>
            </td>
            <td>
              <div class="slot-duration">
                <div class="slot-date"><i class="fa-regular fa-calendar"></i> ${empty b.bookingDate ? '-' : fn:substringBefore(b.bookingDate, ' ')}</div>
                <div class="slot-time">${empty b.slotInfo ? '-' : b.slotInfo}</div>
              </div>
            </td>
            <td>
              <div class="payment-cell">
                <div class="amount">${empty b.amount ? '-' : 'Rs. '}${empty b.amount ? '' : b.amount}</div>
                <div class="pay-status ${fn:toLowerCase(empty b.paymentStatus ? '' : b.paymentStatus)}">${empty b.paymentStatus ? '-' : fn:toUpperCase(b.paymentStatus)}</div>
              </div>
            </td>
            <td>
              <span class="status-pill ${empty b.bookingStatus ? 'pending' : b.bookingStatus}">${empty b.bookingStatus ? 'pending' : b.bookingStatus}</span>
            </td>
            <td>
              <div class="manager-cell">
                <i class="fa-regular fa-user"></i>
                <span>${empty b.managerName ? '-' : b.managerName}</span>
              </div>
            </td>
            <td>
              <div class="table-actions">
                <a class="icon-action" title="View" href="${pageContext.request.contextPath}/admin/booking?id=${b.bookingId}"><i class="fa-regular fa-eye"></i></a>
                <form method="post" style="display:inline">
                  <input type="hidden" name="action" value="deleteBooking">
                  <input type="hidden" name="bookingId" value="${b.bookingId}">
                  <button type="submit" class="icon-action" title="Delete" onclick="return confirm('Delete this booking?');"><i class="fa-solid fa-trash-can"></i></button>
                </form>
              </div>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty bookings}">
          <tr>
            <td colspan="9" class="empty-row">No bookings matched the selected filters.</td>
          </tr>
        </c:if>
        </tbody>
      </table>
      <div class="table-footer">
        <span class="showing-text">Showing ${bookingsFrom}-${bookingsTo} of ${bookingsFilteredCount} bookings</span>
        <div class="pagination">
          <a href="${pageContext.request.contextPath}/admin/bookings?q=${q}&stationId=${stationId}&managerId=${managerId}&bookingDate=${bookingDate}&status=${status}&pageSize=${pageSize}&page=${page - 1}" ${page <= 1 ? 'style="pointer-events:none;opacity:.5"' : ''}><i class="fa-solid fa-chevron-left"></i></a>
          <c:forEach begin="1" end="${totalPages}" var="pNum">
            <a class="${pNum == page ? 'active-page' : ''}" href="${pageContext.request.contextPath}/admin/bookings?q=${q}&stationId=${stationId}&managerId=${managerId}&bookingDate=${bookingDate}&status=${status}&pageSize=${pageSize}&page=${pNum}">${pNum}</a>
          </c:forEach>
          <a href="${pageContext.request.contextPath}/admin/bookings?q=${q}&stationId=${stationId}&managerId=${managerId}&bookingDate=${bookingDate}&status=${status}&pageSize=${pageSize}&page=${page + 1}" ${page >= totalPages ? 'style="pointer-events:none;opacity:.5"' : ''}><i class="fa-solid fa-chevron-right"></i></a>
        </div>
      </div>
    </section>

    <!-- Footer -->
    <div class="admin-footer-bar">
      &copy; 2026 ChargeHub Nepal Admin Console. All rights reserved.
    </div>
  </main>
</div>

<script>
  // Select all checkboxes
  document.getElementById('selectAll')?.addEventListener('change', function() {
    document.querySelectorAll('input[name="bookingCheck"]').forEach(cb => {
      cb.checked = this.checked;
    });
  });

  // Status pill click handler - updates hidden input
  document.querySelectorAll('.status-pill-filter').forEach(pill => {
    pill.addEventListener('click', function(e) {
      // Let the link navigate naturally
    });
  });
</script>
</body>
</html>
