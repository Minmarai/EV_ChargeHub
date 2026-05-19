<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Kirti Dahal --%>
<html>
<head>
  <title>Station Details</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <style>
    .user-station-details-page {
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

    .user-station-details-page .layout {
      min-height: calc(100vh - 72px);
      background: #F5F7FA;
    }

    .user-station-details-page .user-sidebar {
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

    .user-station-details-page .user-side-brand,
    .user-station-details-page .user-side-logout {
      display: none;
    }

    .user-station-details-page .user-side-nav {
      display: grid;
      gap: 6px;
    }

    .user-station-details-page .user-side-nav a {
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

    .user-station-details-page .user-side-nav a i {
      width: 28px;
      text-align: center;
      color: #8C95A3;
      font-size: 18px;
      line-height: 1;
    }

    .user-station-details-page .user-side-nav a:hover {
      background: #FFFFFF;
      border-color: #E5E7EB;
      color: #4B5563;
    }

    .user-station-details-page .user-side-nav a.active {
      background: #00B300;
      border-color: #00B300;
      color: #FFFFFF;
      font-weight: 700;
    }

    .user-station-details-page .user-side-nav a.active i {
      color: #FFFFFF;
    }

    .user-station-details-page .main {
      padding: 18px;
      background: #F5F7FA;
    }

    .back-link {
      color: #8C95A3;
      text-decoration: none;
      font-size: 13px;
      line-height: 1;
      font-weight: 600;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      margin-bottom: 14px;
    }

    .back-link:hover {
      color: #1976D2;
    }

    .header-row {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      gap: 12px;
      flex-wrap: wrap;
      margin-bottom: 14px;
    }

    .title-block h1 {
      margin: 0;
      color: #111827;
      font-size: 30px;
      line-height: 1.05;
      letter-spacing: -0.9px;
      font-weight: 800;
      overflow-wrap: anywhere;
    }

    .title-sub {
      margin-top: 8px;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.35;
      font-weight: 500;
      display: inline-flex;
      align-items: center;
      gap: 14px;
      flex-wrap: wrap;
    }

    .title-sub span {
      display: inline-flex;
      align-items: center;
      gap: 6px;
    }

    .title-sub .open-tag {
      color: #2E7D32;
      font-weight: 700;
    }

    .header-actions {
      display: flex;
      align-items: center;
      gap: 8px;
      flex-wrap: wrap;
    }

    .icon-action {
      width: 44px;
      height: 44px;
      border-radius: 13px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #6B7280;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      font-size: 17px;
      line-height: 1;
      cursor: pointer;
    }

    .icon-action:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F1F7FF;
    }

    .icon-action.saved {
      border-color: #1976D2;
      color: #1976D2;
      background: #F1F7FF;
    }

    .favorite-btn {
      height: 44px;
      border-radius: 13px;
      border: 1px solid #1976D2;
      background: #FFFFFF;
      color: #1976D2;
      padding: 0 14px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      font-size: 13px;
      line-height: 1;
      font-weight: 700;
      font-family: inherit;
      cursor: pointer;
    }

    .favorite-btn:hover {
      background: #F1F7FF;
      border-color: #1767B7;
      color: #1767B7;
    }

    .favorite-btn.saved {
      background: #1976D2;
      border-color: #1976D2;
      color: #FFFFFF;
    }

    .favorite-btn.saved:hover {
      background: #1767B7;
      border-color: #1767B7;
      color: #FFFFFF;
    }

    .book-main-btn {
      height: 44px;
      border-radius: 13px;
      border: 1px solid #00B300;
      background: #00B300;
      color: #FFFFFF;
      font-size: 13px;
      line-height: 1;
      font-weight: 700;
      padding: 0 20px;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
    }

    .book-main-btn:hover {
      background: #059A05;
      border-color: #059A05;
      color: #FFFFFF;
    }

    .details-grid {
      display: grid;
      grid-template-columns: 2.1fr 1fr;
      gap: 14px;
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

    .panel-title {
      margin: 0;
      color: #111827;
      font-size: 18px;
      line-height: 1.1;
      letter-spacing: -0.3px;
      font-weight: 800;
    }

    .station-info-grid {
      margin-top: 14px;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 12px;
    }

    .info-card {
      border: 1px solid #EDF1F6;
      border-radius: 13px;
      background: #F8FAFC;
      padding: 12px;
      display: grid;
      gap: 5px;
    }

    .info-card strong {
      color: #1F2937;
      font-size: 14px;
      line-height: 1.2;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 8px;
    }

    .info-card p {
      margin: 0;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.35;
      font-weight: 500;
    }

    .slots-head {
      margin-top: 16px;
      display: flex;
      justify-content: space-between;
      align-items: flex-end;
      gap: 10px;
      flex-wrap: wrap;
    }

    .slots-head p {
      margin: 6px 0 0;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.35;
      font-weight: 500;
    }

    .slots-legend {
      color: #8C95A3;
      font-size: 13px;
      line-height: 1;
      font-weight: 600;
      display: inline-flex;
      align-items: center;
      gap: 12px;
    }

    .slots-legend span {
      display: inline-flex;
      align-items: center;
      gap: 6px;
    }

    .dot {
      width: 10px;
      height: 10px;
      border-radius: 999px;
      display: inline-block;
    }

    .dot.available {
      background: #2E7D32;
    }

    .dot.busy {
      background: #D1D5DB;
    }

    .slot-grid {
      margin-top: 12px;
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 10px;
    }

    .slot-card {
      border-radius: 13px;
      border: 1px solid #E5E7EB;
      background: #FFFFFF;
      padding: 12px;
      display: grid;
      gap: 4px;
    }

    .slot-card.in-use {
      background: #F8FAFC;
      border-color: #E5E7EB;
    }

    .slot-name {
      color: #111827;
      font-size: 14px;
      line-height: 1.2;
      font-weight: 700;
      display: inline-flex;
      justify-content: space-between;
      align-items: center;
      gap: 8px;
    }

    .slot-type {
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.2;
      font-weight: 500;
    }

    .slot-state {
      color: #2E7D32;
      font-size: 13px;
      line-height: 1.2;
      font-weight: 700;
    }

    .slot-card.in-use .slot-state {
      color: #6B7280;
    }

    .slot-time {
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.2;
      font-weight: 500;
    }

    .right-stack {
      display: grid;
      gap: 14px;
      align-content: start;
    }

    .overview-sub {
      margin: 8px 0 0;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.35;
      font-weight: 500;
    }

    .overview-list {
      margin-top: 14px;
      display: grid;
      gap: 10px;
    }

    .overview-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 8px;
      color: #1F2937;
      font-size: 13px;
      line-height: 1.2;
      font-weight: 700;
    }

    .overview-item span {
      display: inline-flex;
      align-items: center;
      gap: 6px;
    }

    .overview-item small {
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.2;
      font-weight: 500;
    }

    .overview-item .none {
      color: #DC2626;
      font-weight: 700;
    }

    .side-action {
      margin-top: 14px;
      display: block;
      width: 100%;
      height: 44px;
      border-radius: 13px;
      border: 1px solid #00B300;
      background: #00B300;
      color: #FFFFFF;
      font-size: 13px;
      line-height: 1;
      font-weight: 700;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
    }

    .side-action:hover {
      background: #059A05;
      border-color: #059A05;
      color: #FFFFFF;
    }

    .reviews-head {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 8px;
    }

    .rating-chip {
      color: #1F2937;
      font-size: 14px;
      line-height: 1;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 6px;
    }

    .reviews-list {
      margin-top: 12px;
      display: grid;
      gap: 12px;
    }

    .review-item {
      border-top: 1px solid #EDF1F6;
      padding-top: 12px;
      display: grid;
      gap: 6px;
    }

    .review-item:first-child {
      border-top: 0;
      padding-top: 0;
    }

    .review-meta {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 8px;
      flex-wrap: wrap;
    }

    .review-meta strong {
      color: #1F2937;
      font-size: 14px;
      line-height: 1.2;
      font-weight: 700;
    }

    .review-meta small {
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.2;
      font-weight: 500;
    }

    .review-comment {
      margin: 0;
      color: #6B7280;
      font-size: 13px;
      line-height: 1.4;
      font-weight: 500;
    }

    .reviews-link {
      margin-top: 14px;
      border-top: 1px solid #EDF1F6;
      padding-top: 14px;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      color: #1976D2;
      text-decoration: none;
      font-size: 13px;
      line-height: 1;
      font-weight: 700;
    }

    .reviews-link:hover {
      color: #1767B7;
    }

    .empty-line {
      margin-top: 10px;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.35;
      font-weight: 500;
    }

    @media (max-width: 1320px) {
      .details-grid {
        grid-template-columns: 1fr;
      }

      .slot-grid {
        grid-template-columns: repeat(3, minmax(0, 1fr));
      }
    }

    @media (max-width: 980px) {
      .user-station-details-page .layout {
        flex-direction: column;
      }

      .user-station-details-page .user-sidebar {
        position: static;
        width: 100%;
        min-height: auto;
        padding: 10px 12px;
        overflow: hidden;
      }

      .user-station-details-page .user-side-nav {
        display: flex;
        gap: 8px;
        overflow-x: auto;
        padding-bottom: 2px;
        scrollbar-width: thin;
        -webkit-overflow-scrolling: touch;
      }

      .user-station-details-page .user-side-nav a {
        flex: 0 0 auto;
        min-width: max-content;
        padding: 10px 12px;
        border-radius: 10px;
      }

      .title-block h1 {
        font-size: 28px;
      }

      .station-info-grid {
        grid-template-columns: 1fr;
      }

      .user-station-details-page .main {
        padding: 14px;
      }
    }

    @media (max-width: 700px) {
      .slot-grid {
        grid-template-columns: 1fr;
      }

      .header-actions {
        width: 100%;
      }

      .favorite-btn,
      .icon-action,
      .book-main-btn {
        width: 100%;
      }

      .book-main-btn {
        padding: 0 12px;
      }

      .title-sub {
        gap: 10px;
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

      .user-station-details-page .layout,
      .user-station-details-page .user-sidebar {
        min-height: auto;
      }

      .user-station-details-page .main {
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

      .title-block h1 {
        font-size: 22px;
      }

      .title-sub,
      .back-link {
        font-size: 12px;
      }

      .panel-title {
        font-size: 16px;
      }
    }
  </style>
</head>
<body class="user-station-details-page">
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
    <a class="back-link" href="${pageContext.request.contextPath}/user/station-list"><i class="fa-solid fa-angle-left"></i>Back to Station List</a>

    <section class="header-row">
      <div class="title-block">
        <h1>${station.stationName}</h1>
        <div class="title-sub">
          <span><i class="fa-solid fa-location-dot"></i>${station.districtName}</span>
          <span><i class="fa-regular fa-star"></i>
            <c:choose>
              <c:when test="${not empty reviews}">4.${(station.stationId % 5) + 1} (${fn:length(reviews)} reviews)</c:when>
              <c:otherwise>No reviews yet</c:otherwise>
            </c:choose>
          </span>
          <span class="open-tag">
            <c:choose>
              <c:when test="${fn:toLowerCase(station.status) == 'active'}">Open Now</c:when>
              <c:otherwise>Currently ${station.status}</c:otherwise>
            </c:choose>
          </span>
        </div>
      </div>

      <div class="header-actions">
        <form method="post" action="${pageContext.request.contextPath}/user/station-list">
          <input type="hidden" name="action" value="${isFavorite ? 'removeFavorite' : 'favorite'}">
          <input type="hidden" name="stationId" value="${station.stationId}">
          <button class="favorite-btn ${isFavorite ? 'saved' : ''}" type="submit" aria-label="Favorite toggle">
            <i class="${isFavorite ? 'fa-solid' : 'fa-regular'} fa-heart"></i>${isFavorite ? 'Remove Favorite' : 'Add Favorite'}
          </button>
        </form>
        <button class="icon-action" type="button" aria-label="Share station"><i class="fa-solid fa-share-nodes"></i></button>
        <a class="book-main-btn" href="${pageContext.request.contextPath}/user/book-slot?stationId=${station.stationId}&from=${activePage}"><i class="fa-solid fa-bolt"></i>Book Slot</a>
      </div>
    </section>

    <section class="details-grid">
      <div class="left-stack">
        <article class="panel">
          <div class="panel-body">
            <h2 class="panel-title">Station Information</h2>
            <div class="station-info-grid">
              <div class="info-card">
                <strong><i class="fa-solid fa-location-dot"></i>Address</strong>
                <p>${station.address}</p>
              </div>
              <div class="info-card">
                <strong><i class="fa-regular fa-clock"></i>Operating Hours</strong>
                <p>${station.openingTime} - ${station.closingTime}</p>
              </div>
              <div class="info-card">
                <strong><i class="fa-regular fa-map"></i>District</strong>
                <p>${station.districtName}</p>
              </div>
              <div class="info-card">
                <strong><i class="fa-solid fa-phone"></i>Contact Number</strong>
                <p>${station.contactNumber}</p>
              </div>
              <div class="info-card">
                <strong><i class="fa-regular fa-credit-card"></i>Pricing</strong>
                <p>NPR ${station.pricePerHour} / hour</p>
              </div>
              <div class="info-card">
                <strong><i class="fa-solid fa-plug-circle-bolt"></i>Charger Type</strong>
                <p>${station.chargerType}</p>
              </div>
              <div class="info-card">
                <strong><i class="fa-solid fa-bolt"></i>Total Ports</strong>
                <p>${station.totalPorts} total ports</p>
</div>
  </main>
</div>

<c:if test="${param.submitted == '1'}">
  <div id="successToast" class="toast-popup">
    <div class="toast-content">
      <i class="fa-solid fa-circle-check"></i>
      <span>Review successfully submitted!</span>
    </div>
  </div>
</c:if>

<style>
.toast-popup {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 9999;
  animation: slideIn 0.3s ease-out, fadeOut 0.5s ease-in 2.5s forwards;
}
.toast-content {
  background: #ECF8EE;
  border: 1px solid #C5E8CD;
  border-radius: 12px;
  padding: 14px 20px;
  display: flex;
  align-items: center;
  gap: 10px;
  color: #2E7D32;
  font-size: 14px;
  font-weight: 600;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}
.toast-content i {
  font-size: 18px;
}
@keyframes slideIn {
  from { transform: translateX(100%); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
}
@keyframes fadeOut {
  from { opacity: 1; }
  to { opacity: 0; visibility: hidden; }
}
</style>

<script>
(function() {
  var toast = document.getElementById('successToast');
  if (toast) {
    setTimeout(function() {
      toast.style.display = 'none';
    }, 3000);
  }
})();
</script>
</body>
</html>
