<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Kirti Dahal --%>
<html>
<head>
  <title>Station List</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <style>
    .user-station-list-page {
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

    .user-station-list-page .layout {
      min-height: calc(100vh - 72px);
      background: #F5F7FA;
    }

    .user-station-list-page .user-sidebar {
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

    .user-station-list-page .user-side-brand,
    .user-station-list-page .user-side-logout {
      display: none;
    }

    .user-station-list-page .user-side-nav {
      display: grid;
      gap: 6px;
    }

    .user-station-list-page .user-side-nav a {
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

    .user-station-list-page .user-side-nav a i {
      width: 28px;
      text-align: center;
      color: #8C95A3;
      font-size: 18px;
      line-height: 1;
    }

    .user-station-list-page .user-side-nav a:hover {
      background: #FFFFFF;
      border-color: #E5E7EB;
      color: #4B5563;
    }

    .user-station-list-page .user-side-nav a.active {
      background: #00B300;
      border-color: #00B300;
      color: #FFFFFF;
      font-weight: 700;
    }

    .user-station-list-page .user-side-nav a.active i {
      color: #FFFFFF;
    }

    .user-station-list-page .main {
      padding: 18px;
      background: #F5F7FA;
    }

    .crumbs {
      color: #9CA3AF;
      font-size: 13px;
      display: inline-flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 12px;
    }

    .crumbs strong {
      color: #1F2937;
      font-weight: 700;
    }

    .list-head {
      display: flex;
      align-items: flex-end;
      justify-content: space-between;
      gap: 12px;
      flex-wrap: wrap;
    }

    .list-head h1 {
      margin: 0;
      color: #111827;
      font-size: 30px;
      line-height: 1.05;
      letter-spacing: -0.9px;
      font-weight: 800;
      overflow-wrap: anywhere;
    }

    .list-head p {
      margin: 8px 0 0;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.35;
      font-weight: 500;
    }

    .stations-grid {
      margin-top: 14px;
      display: grid;
      grid-template-columns: repeat(3, minmax(0, 1fr));
      gap: 14px;
    }

    .station-card {
      background: #FFFFFF;
      border: 1px solid #E5E7EB;
      border-radius: 16px;
      overflow: hidden;
      box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04);
      display: flex;
      flex-direction: column;
    }

    .station-visual {
      height: 180px;
      border-bottom: 1px solid #E5E7EB;
      padding: 14px;
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      position: relative;
      overflow: hidden;
      background: linear-gradient(145deg, #D6E7F7 0%, #AFC8E6 55%, #8CB0D7 100%);
    }

    .station-visual::before {
      content: "";
      position: absolute;
      left: -26px;
      bottom: -54px;
      width: 170px;
      height: 170px;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.25);
    }

    .station-visual::after {
      content: "";
      position: absolute;
      right: -18px;
      top: -52px;
      width: 170px;
      height: 170px;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.23);
    }

    .status-pill {
      position: relative;
      z-index: 1;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      border-radius: 999px;
      padding: 6px 13px;
      font-size: 13px;
      line-height: 1;
      font-weight: 700;
      border: 1px solid rgba(255, 255, 255, 0.95);
      text-transform: capitalize;
      background: rgba(255, 255, 255, 0.94);
      color: #1976D2;
    }

    .status-pill.active {
      color: #2E7D32;
    }

    .status-pill.maintenance,
    .status-pill.inactive,
    .status-pill.offline {
      color: #EF4444;
    }

    .fav-icon {
      position: relative;
      z-index: 1;
      width: 40px;
      height: 40px;
      border-radius: 999px;
      border: 1px solid rgba(255, 255, 255, 0.96);
      background: rgba(255, 255, 255, 0.9);
      color: #9CA3AF;
      display: grid;
      place-items: center;
      font-size: 18px;
      line-height: 1;
    }

    .fav-icon.saved {
      color: #1976D2;
      border-color: #D6E6FA;
      background: #F1F7FF;
    }

    .station-content {
      padding: 16px;
      display: grid;
      gap: 10px;
    }

    .station-content h3 {
      margin: 0;
      color: #111827;
      font-size: 16px;
      line-height: 1.25;
      font-weight: 700;
      min-height: 40px;
    }

    .station-address {
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.3;
      font-weight: 500;
      display: inline-flex;
      align-items: flex-start;
      gap: 6px;
    }

    .info-box {
      margin-top: 2px;
      border-radius: 12px;
      background: #F8FAFC;
      border: 1px solid #EEF2F7;
      padding: 10px 12px;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px;
    }

    .info-item {
      display: grid;
      gap: 2px;
    }

    .info-label {
      color: #8C95A3;
      font-size: 11px;
      letter-spacing: 0.6px;
      text-transform: uppercase;
      line-height: 1;
      font-weight: 700;
    }

    .info-value {
      color: #1F2937;
      font-size: 13px;
      line-height: 1.2;
      font-weight: 700;
    }

    .card-divider {
      margin: 0 16px;
      border-top: 1px solid #EDF1F6;
    }

    .station-actions {
      padding: 14px 16px 16px;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px;
    }

    .btn-link,
    .btn-action {
      height: 44px;
      border-radius: 13px;
      border: 1px solid transparent;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      text-decoration: none;
      font-size: 13px;
      line-height: 1;
      font-weight: 700;
      font-family: inherit;
      gap: 7px;
      padding: 0 12px;
      cursor: pointer;
    }

    .btn-link {
      background: #2E7D32;
      border-color: #2E7D32;
      color: #FFFFFF;
    }

    .btn-link:hover {
      background: #27692A;
      border-color: #27692A;
      color: #FFFFFF;
    }

    .btn-action {
      background: #FFFFFF;
      border-color: #1976D2;
      color: #1976D2;
    }

    .btn-action:hover {
      background: #F1F7FF;
      border-color: #1767B7;
      color: #1767B7;
    }

    .btn-action.saved {
      background: #1976D2;
      border-color: #1976D2;
      color: #FFFFFF;
    }

    .btn-action.saved:hover {
      background: #1767B7;
      border-color: #1767B7;
      color: #FFFFFF;
    }

    .empty-card {
      margin-top: 14px;
      background: #FFFFFF;
      border: 1px solid #E5E7EB;
      border-radius: 16px;
      padding: 30px 20px;
      text-align: center;
      color: #8C95A3;
      font-size: 14px;
      line-height: 1.4;
      font-weight: 500;
    }

    @media (max-width: 1320px) {
      .stations-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }
    }

    @media (max-width: 980px) {
      .user-station-list-page .layout {
        flex-direction: column;
      }

      .user-station-list-page .user-sidebar {
        position: static;
        width: 100%;
        min-height: auto;
        padding: 10px 12px;
        overflow: hidden;
      }

      .user-station-list-page .user-side-nav {
        display: flex;
        gap: 8px;
        overflow-x: auto;
        padding-bottom: 2px;
        scrollbar-width: thin;
        -webkit-overflow-scrolling: touch;
      }

      .user-station-list-page .user-side-nav a {
        flex: 0 0 auto;
        min-width: max-content;
        padding: 10px 12px;
        border-radius: 10px;
      }

      .list-head h1 {
        font-size: 28px;
      }

      .user-station-list-page .main {
        padding: 14px;
      }
    }

    @media (max-width: 700px) {
      .stations-grid {
        grid-template-columns: 1fr;
      }

      .station-actions {
        grid-template-columns: 1fr;
      }

      .crumbs {
        flex-wrap: wrap;
        gap: 6px;
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

      .user-station-list-page .layout,
      .user-station-list-page .user-sidebar {
        min-height: auto;
      }

      .user-station-list-page .main {
        padding: 10px;
      }

      .station-visual {
        height: 156px;
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

      .list-head h1 {
        font-size: 22px;
      }

      .list-head p,
      .crumbs {
        font-size: 12px;
      }
    }
  </style>
</head>
<body class="user-station-list-page">
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
    <div class="crumbs">
      <i class="fa-solid fa-house"></i>
      <span>Dashboard</span>
      <i class="fa-solid fa-angle-right"></i>
      <span>Search Stations</span>
      <i class="fa-solid fa-angle-right"></i>
      <strong>Station List</strong>
    </div>

    <section class="list-head">
      <div>
        <h1>Station List</h1>
        <p>Showing ${fn:length(stations)} charging stations near you.</p>
      </div>
    </section>

    <c:choose>
      <c:when test="${not empty stations}">
        <section class="stations-grid">
          <c:forEach var="s" items="${stations}">
            <c:set var="isFavorite" value="false"/>
            <c:forEach var="favId" items="${favoriteStationIds}">
              <c:if test="${favId == s.stationId}">
                <c:set var="isFavorite" value="true"/>
              </c:if>
            </c:forEach>

            <article class="station-card">
              <div class="station-visual">
                <span class="status-pill ${fn:toLowerCase(s.status)}">${s.status}</span>
                <span class="fav-icon ${isFavorite ? 'saved' : ''}"><i class="${isFavorite ? 'fa-solid' : 'fa-regular'} fa-heart"></i></span>
              </div>

              <div class="station-content">
                <h3>${s.stationName}</h3>
                <span class="station-address"><i class="fa-solid fa-location-dot"></i>${s.districtName}</span>
                <span class="station-address"><i class="fa-regular fa-map"></i>${s.address}</span>

                <div class="info-box">
                  <div class="info-item">
                    <span class="info-label">Charger</span>
                    <span class="info-value">${s.chargerType}</span>
                  </div>
                  <div class="info-item">
                    <span class="info-label">Ports</span>
                    <span class="info-value">${s.totalPorts} Total</span>
                  </div>
                </div>
              </div>

              <div class="card-divider"></div>

              <div class="station-actions">
                <a class="btn-link" href="${pageContext.request.contextPath}/user/station?id=${s.stationId}&from=station-list">View Details</a>
                <form method="post" action="${pageContext.request.contextPath}/user/station-list">
                  <input type="hidden" name="action" value="${isFavorite ? 'removeFavorite' : 'favorite'}">
                  <input type="hidden" name="stationId" value="${s.stationId}">
                  <button class="btn-action ${isFavorite ? 'saved' : ''}" type="submit">
                    <i class="fa-regular fa-heart"></i>${isFavorite ? 'Saved' : 'Add Favorite'}
                  </button>
                </form>
              </div>
            </article>
          </c:forEach>
        </section>

      </c:when>
      <c:otherwise>
        <div class="empty-card">No stations found right now. Please check back again shortly.</div>
      </c:otherwise>
    </c:choose>
  </main>
</div>
</body>
</html>
