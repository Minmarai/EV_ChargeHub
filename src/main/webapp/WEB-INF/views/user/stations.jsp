<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Kirti Dahal --%>
<html>
<head>
  <title>Search Stations</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <style>
    .user-stations-page {
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
      background: #EEF3FC;
      border: 1px solid #E5E7EB;
      display: grid;
      place-items: center;
      color: #64748B;
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
      background: #2E7D32;
      border: 2px solid #FFFFFF;
      position: absolute;
      right: 1px;
      bottom: 1px;
    }

    .user-stations-page .layout {
      min-height: calc(100vh - 72px);
      background: #F5F7FA;
    }

    .user-stations-page .user-sidebar {
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

    .user-stations-page .user-side-brand,
    .user-stations-page .user-side-logout {
      display: none;
    }

    .user-stations-page .user-side-nav {
      display: grid;
      gap: 6px;
    }

    .user-stations-page .user-side-nav a {
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

    .user-stations-page .user-side-nav a i {
      width: 28px;
      text-align: center;
      color: #8C95A3;
      font-size: 18px;
      line-height: 1;
    }

    .user-stations-page .user-side-nav a:hover {
      background: #FFFFFF;
      border-color: #E5E7EB;
      color: #4B5563;
    }

    .user-stations-page .user-side-nav a.active {
      background: #00B300;
      border-color: #00B300;
      color: #FFFFFF;
      font-weight: 700;
    }

    .user-stations-page .user-side-nav a.active i {
      color: #FFFFFF;
    }

    .user-stations-page .main {
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

    .page-head h1 {
      margin: 0;
      font-size: 30px;
      line-height: 1.05;
      letter-spacing: -0.9px;
      color: #111827;
      font-weight: 800;
      overflow-wrap: anywhere;
    }

    .page-head p {
      margin: 8px 0 0;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.35;
      font-weight: 500;
    }

    .search-panel {
      margin-top: 16px;
      background: #FFFFFF;
      border: 1px solid #E5E7EB;
      border-radius: 16px;
      box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04);
      overflow: hidden;
    }

    .search-panel-main {
      padding: 18px;
      display: grid;
      gap: 12px;
    }

    .search-panel h2 {
      margin: 0;
      color: #111827;
      font-size: 18px;
      line-height: 1.1;
      letter-spacing: -0.3px;
      font-weight: 800;
      display: inline-flex;
      align-items: center;
      gap: 10px;
    }

    .search-panel h2 i {
      color: #00B300;
      font-size: 16px;
    }

    .search-row {
      display: grid;
      gap: 8px;
    }

    .search-row label {
      font-size: 13px;
      color: #1F2937;
      font-weight: 600;
    }

    .search-input,
    .search-select {
      height: 44px;
      border: 1px solid #CBD5E1;
      border-radius: 13px;
      background: #FFFFFF;
      padding: 0 14px;
      display: inline-flex;
      align-items: center;
      gap: 10px;
      color: #9CA3AF;
    }

    .search-select {
      position: relative;
      display: flex;
      gap: 0;
    }

    .search-input input,
    .search-select select {
      width: 100%;
      border: 0;
      outline: 0;
      background: transparent;
      color: #1F2937;
      font-size: 14px;
      font-family: inherit;
    }

    .search-select select {
      appearance: none;
      -webkit-appearance: none;
      display: block;
      height: 42px;
      line-height: 42px;
      margin: 0;
      box-sizing: border-box;
      padding: 0 30px 0 0;
      font-weight: 500;
    }

    .search-select i {
      position: absolute;
      right: 14px;
      top: 50%;
      transform: translateY(-50%);
      pointer-events: none;
    }

    .search-select:focus-within {
      border-color: #CBD5E1;
      box-shadow: none;
    }

    .search-select select:focus,
    .search-select select:focus-visible {
      outline: none;
      box-shadow: none;
      border: 0;
    }

    .search-filters-grid {
      display: grid;
      grid-template-columns: repeat(3, minmax(0, 1fr));
      gap: 12px;
    }

    .search-panel-actions {
      border-top: 1px solid #E5E7EB;
      padding: 18px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 12px;
      flex-wrap: wrap;
    }

    .clear-link,
    .search-btn {
      height: 44px;
      border-radius: 13px;
      font-size: 14px;
      line-height: 1;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      text-decoration: none;
      padding: 0 20px;
      font-family: inherit;
      cursor: pointer;
      border: 1px solid transparent;
      gap: 8px;
    }

    .clear-link {
      background: #FFFFFF;
      border-color: #D1D5DB;
      color: #8C95A3;
    }

    .clear-link:hover {
      color: #1976D2;
      border-color: #1976D2;
      background: #F8FBFF;
    }

    .search-btn {
      background: #00B300;
      border-color: #00B300;
      color: #FFFFFF;
      min-width: 220px;
    }

    .search-btn:hover {
      background: #059A05;
      border-color: #059A05;
    }

    .section-head {
      margin-top: 20px;
      display: flex;
      align-items: flex-end;
      justify-content: space-between;
      gap: 14px;
      flex-wrap: wrap;
    }

    .section-head h3 {
      margin: 0;
      color: #111827;
      font-size: 24px;
      line-height: 1.05;
      letter-spacing: -0.4px;
      font-weight: 800;
    }

    .section-head p {
      margin: 5px 0 0;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.35;
      font-weight: 500;
    }

    .view-all-link {
      color: #00B300;
      font-size: 14px;
      font-weight: 700;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      gap: 8px;
    }

    .view-all-link:hover {
      color: #1976D2;
    }

    .stations-grid {
      margin-top: 12px;
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

    .station-card-cover {
      height: 170px;
      border-bottom: 1px solid #E5E7EB;
      padding: 14px;
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      background: linear-gradient(145deg, #C6D9EE, #8FB2D7);
      color: #1F2937;
      position: relative;
      overflow: hidden;
    }

    .station-card-cover::after {
      content: "";
      position: absolute;
      left: 50%;
      top: 48%;
      width: 160px;
      height: 160px;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.28);
      transform: translate(-50%, -50%);
    }

    .cover-status,
    .cover-rating {
      position: relative;
      z-index: 1;
      border-radius: 10px;
      font-size: 13px;
      font-weight: 700;
      padding: 5px 9px;
      background: rgba(255, 255, 255, 0.92);
      border: 1px solid rgba(255, 255, 255, 0.98);
    }

    .cover-status.active {
      color: #2E7D32;
    }

    .cover-status.maintenance,
    .cover-status.inactive,
    .cover-status.offline {
      color: #EF4444;
    }

    .station-card-body {
      padding: 16px;
      display: grid;
      gap: 10px;
    }

    .station-card h4 {
      margin: 0;
      color: #111827;
      font-size: 16px;
      line-height: 1.25;
      font-weight: 700;
    }

    .station-meta,
    .station-specs {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.3;
      font-weight: 500;
    }

    .station-meta span,
    .station-specs span {
      display: inline-flex;
      align-items: center;
      gap: 6px;
    }

    .station-card-actions {
      padding: 0 16px 16px;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px;
    }

    .station-btn {
      height: 44px;
      border-radius: 13px;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      font-size: 13px;
      line-height: 1;
      font-weight: 700;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #1F2937;
      font-family: inherit;
    }

    .station-btn:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F8FBFF;
    }

    .station-btn.primary {
      border-color: #00B300;
      background: #00B300;
      color: #FFFFFF;
    }

    .station-btn.primary:hover {
      border-color: #059A05;
      background: #059A05;
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
      .user-stations-page .layout {
        flex-direction: column;
      }

      .user-stations-page .user-sidebar {
        position: static;
        width: 100%;
        min-height: auto;
        padding: 10px 12px;
        overflow: hidden;
      }

      .user-stations-page .user-side-nav {
        display: flex;
        gap: 8px;
        overflow-x: auto;
        padding-bottom: 2px;
        scrollbar-width: thin;
        -webkit-overflow-scrolling: touch;
      }

      .user-stations-page .user-side-nav a {
        flex: 0 0 auto;
        min-width: max-content;
        padding: 10px 12px;
        border-radius: 10px;
      }

      .search-filters-grid {
        grid-template-columns: 1fr;
      }

      .page-head h1 {
        font-size: 28px;
      }

      .user-stations-page .main {
        padding: 14px;
      }
    }

    @media (max-width: 700px) {
      .stations-grid {
        grid-template-columns: 1fr;
      }

      .search-panel-actions {
        align-items: stretch;
      }

      .search-btn,
      .clear-link {
        width: 100%;
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

      .user-stations-page .layout,
      .user-stations-page .user-sidebar {
        min-height: auto;
      }

      .user-stations-page .main {
        padding: 10px;
      }

      .search-panel-main,
      .search-panel-actions {
        padding: 12px;
      }

      .station-card-cover {
        height: 152px;
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

      .page-head h1 {
        font-size: 22px;
      }

      .page-head p,
      .crumbs,
      .section-head p {
        font-size: 12px;
      }

      .section-head h3 {
        font-size: 20px;
      }
    }
  </style>
</head>
<body class="user-stations-page">
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
      <strong>Search Stations</strong>
    </div>

    <section class="page-head">
      <h1>Find a Charging Station</h1>
      <p>Filter by location, charger type, and availability to find the perfect spot for your EV.</p>
    </section>

    <form class="search-panel" method="get" action="${pageContext.request.contextPath}/user/stations">
      <div class="search-panel-main">
        <h2><i class="fa-solid fa-filter"></i>Search Criteria</h2>

        <div class="search-row">
          <label for="q">Station Name or Address</label>
          <div class="search-input">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input id="q" type="text" name="q" value="${searchKeyword}" placeholder="e.g. 'Pulchowk', 'Sajha', 'Bhatbhateni'">
          </div>
        </div>

        <div class="search-filters-grid">
          <div class="search-row">
            <label for="districtId">District / Region</label>
            <div class="search-select">
              <select id="districtId" name="districtId">
                <option value="">All Districts</option>
                <c:forEach var="d" items="${districts}">
                  <option value="${d.districtId}" ${selectedDistrictId == d.districtId ? 'selected' : ''}>${d.districtName}</option>
                </c:forEach>
              </select>
              <i class="fa-solid fa-angle-down"></i>
            </div>
          </div>

          <div class="search-row">
            <label for="chargerType">Charger Type</label>
            <div class="search-select">
              <select id="chargerType" name="chargerType">
                <option value="">All Types</option>
                <c:forEach var="type" items="${chargerTypes}">
                  <option value="${type}" ${selectedChargerType == type ? 'selected' : ''}>${type}</option>
                </c:forEach>
              </select>
              <i class="fa-solid fa-angle-down"></i>
            </div>
          </div>

          <div class="search-row">
            <label for="status">Status</label>
            <div class="search-select">
              <select id="status" name="status">
                <option value="">Status</option>
                <c:forEach var="st" items="${stationStatuses}">
                  <option value="${st}" ${selectedStatus == st ? 'selected' : ''}>
                    <c:choose>
                      <c:when test="${st == 'active'}">Available</c:when>
                      <c:when test="${st == 'maintenance'}">Maintenance</c:when>
                      <c:when test="${st == 'inactive'}">Inactive</c:when>
                      <c:otherwise>${st}</c:otherwise>
                    </c:choose>
                  </option>
                </c:forEach>
              </select>
              <i class="fa-solid fa-angle-down"></i>
            </div>
          </div>
        </div>
      </div>

      <div class="search-panel-actions">
        <a class="clear-link" href="${pageContext.request.contextPath}/user/stations">Clear Filters</a>
        <button class="search-btn" type="submit"><i class="fa-solid fa-magnifying-glass"></i>Search Stations</button>
      </div>
    </form>

    <section class="section-head">
      <div>
        <h3>Popular Stations Nearby</h3>
        <p>Recommended based on your current location.</p>
      </div>
      <a class="view-all-link" href="${pageContext.request.contextPath}/user/station-list">View all stations <i class="fa-solid fa-angle-right"></i></a>
    </section>

    <c:choose>
      <c:when test="${not empty stations}">
        <section class="stations-grid">
          <c:forEach var="s" items="${stations}">
            <article class="station-card">
              <div class="station-card-cover">
                <span class="cover-status ${fn:toLowerCase(s.status)}">${s.status}</span>
                <span class="cover-rating"><i class="fa-regular fa-star"></i> 4.${(s.stationId % 5) + 1}</span>
              </div>

              <div class="station-card-body">
                <h4>${s.stationName}</h4>
                <div class="station-meta">
                  <span><i class="fa-solid fa-location-dot"></i>${s.address}</span>
                  <span><i class="fa-regular fa-map"></i>${s.districtName}</span>
                </div>
                <div class="station-specs">
                  <span><i class="fa-solid fa-plug-circle-bolt"></i>${s.totalPorts} Ports</span>
                  <span><i class="fa-solid fa-bolt"></i>${s.chargerType}</span>
                  <span><i class="fa-solid fa-money-bill-wave"></i>Rs. ${s.pricePerHour}/hr</span>
                </div>
              </div>

              <div class="station-card-actions">
                <a class="station-btn" href="${pageContext.request.contextPath}/user/station?id=${s.stationId}">View Details</a>
                <a class="station-btn primary" href="${pageContext.request.contextPath}/user/station?id=${s.stationId}">Book Slot</a>
              </div>
            </article>
          </c:forEach>
        </section>
      </c:when>
      <c:otherwise>
        <div class="empty-card">No stations found for the selected filters. Try changing district, type, or status.</div>
      </c:otherwise>
    </c:choose>
  </main>
</div>
</body>
</html>
