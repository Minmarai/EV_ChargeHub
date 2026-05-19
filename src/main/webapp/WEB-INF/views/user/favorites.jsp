<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Rijam Shrestha --%>
<html>
<head>
  <title>Favorite Stations</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <style>
    .user-favorites-page {
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

    .user-favorites-page .layout {
      min-height: calc(100vh - 72px);
      background: #F5F7FA;
    }

    .user-favorites-page .user-sidebar {
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

    .user-favorites-page .user-side-brand,
    .user-favorites-page .user-side-logout {
      display: none;
    }

    .user-favorites-page .user-side-nav {
      display: grid;
      gap: 6px;
    }

    .user-favorites-page .user-side-nav a {
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

    .user-favorites-page .user-side-nav a i {
      width: 28px;
      text-align: center;
      color: #8C95A3;
      font-size: 18px;
      line-height: 1;
    }

    .user-favorites-page .user-side-nav a:hover {
      background: #FFFFFF;
      border-color: #E5E7EB;
      color: #4B5563;
    }

    .user-favorites-page .user-side-nav a.active {
      background: #00B300;
      border-color: #00B300;
      color: #FFFFFF;
      font-weight: 700;
    }

    .user-favorites-page .user-side-nav a.active i {
      color: #FFFFFF;
    }

    .user-favorites-page .main {
      background: #F5F7FA;
      padding: 18px;
    }

    .favorites-shell {
      max-width: 1260px;
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

    .grid {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
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
      min-height: 280px;
    }

    .thumb {
      height: 140px;
      background: linear-gradient(145deg, #B7D5F3 0%, #89B4DA 55%, #6A98C4 100%);
      position: relative;
      overflow: hidden;
    }

    .thumb::before,
    .thumb::after {
      content: "";
      position: absolute;
      border-radius: 999px;
      opacity: 0.3;
      background: #FFFFFF;
    }

    .thumb::before {
      width: 220px;
      height: 220px;
      top: -110px;
      right: -40px;
    }

    .thumb::after {
      width: 160px;
      height: 160px;
      bottom: -80px;
      left: -40px;
    }

    .state-chip {
      position: absolute;
      top: 12px;
      left: 12px;
      border-radius: 999px;
      border: 1px solid #E5E7EB;
      background: rgba(255, 255, 255, 0.95);
      color: #1F2937;
      padding: 7px 12px;
      font-size: 12px;
      line-height: 1;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      text-transform: capitalize;
    }

    .state-chip.active {
      color: #2E7D32;
      border-color: #BCE7C2;
      background: rgba(236, 248, 238, 0.96);
    }

    .state-chip.inactive,
    .state-chip.maintenance {
      color: #B45309;
      border-color: #FFD9B0;
      background: rgba(255, 244, 232, 0.96);
    }

    .station-body {
      padding: 14px;
      display: grid;
      gap: 10px;
      flex: 1;
    }

    .title-row {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      gap: 8px;
    }

    .title-row h3 {
      margin: 0;
      color: #111827;
      font-size: 16px;
      line-height: 1.2;
      letter-spacing: -0.2px;
      font-weight: 700;
    }

    .rating {
      border-radius: 999px;
      background: #ECF8EE;
      color: #2E7D32;
      border: 1px solid #C5E8CD;
      padding: 6px 10px;
      font-size: 12px;
      line-height: 1;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 5px;
      white-space: nowrap;
    }

    .summary {
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.35;
      font-weight: 500;
      display: inline-flex;
      align-items: flex-start;
      gap: 7px;
      word-break: break-word;
    }

    .meta-tags {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
    }

    .meta-tags span {
      border-radius: 999px;
      border: 1px solid #E5E7EB;
      background: #F8FAFC;
      color: #374151;
      font-size: 13px;
      line-height: 1;
      font-weight: 600;
      padding: 7px 10px;
    }

    .card-actions {
      border-top: 1px solid #EDF1F6;
      padding: 12px 14px;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .remove-btn {
      width: 38px;
      height: 38px;
      border-radius: 10px;
      border: 1px solid #FBCACA;
      background: #FFF5F5;
      color: #DC2626;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      font-size: 13px;
      line-height: 1;
    }

    .remove-btn:hover {
      border-color: #EF4444;
      background: #FDEDED;
      color: #EF4444;
    }

    .act-link {
      min-height: 38px;
      border-radius: 11px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #1F2937;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 0 13px;
      font-size: 13px;
      line-height: 1;
      font-weight: 700;
      flex: 1;
      white-space: nowrap;
    }

    .act-link:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F1F7FF;
    }

    .act-link.book {
      background: #00B300;
      border-color: #00B300;
      color: #FFFFFF;
      flex: 1.15;
    }

    .act-link.book:hover {
      background: #059A05;
      border-color: #059A05;
      color: #FFFFFF;
    }

    .empty {
      background: #FFFFFF;
      border: 1px solid #E5E7EB;
      border-radius: 16px;
      box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04);
      padding: 34px 18px;
      text-align: center;
      color: #8C95A3;
      font-size: 15px;
      line-height: 1.4;
      font-weight: 500;
    }

    .empty a {
      color: #1976D2;
      text-decoration: none;
      font-weight: 700;
    }

    .empty a:hover {
      color: #145CA3;
      text-decoration: underline;
    }

    @media (max-width: 1500px) {
      .grid {
        grid-template-columns: repeat(3, minmax(0, 1fr));
      }
    }

    @media (max-width: 1220px) {
      .grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }
    }

    @media (max-width: 980px) {
      .user-favorites-page .layout {
        flex-direction: column;
      }

      .user-favorites-page .user-sidebar {
        position: static;
        width: 100%;
        min-height: auto;
        padding: 10px 12px;
        overflow: hidden;
      }

      .user-favorites-page .user-side-nav {
        display: flex;
        gap: 8px;
        overflow-x: auto;
        padding-bottom: 2px;
        scrollbar-width: thin;
        -webkit-overflow-scrolling: touch;
      }

      .user-favorites-page .user-side-nav a {
        flex: 0 0 auto;
        min-width: max-content;
        padding: 10px 12px;
        border-radius: 10px;
      }

      .user-favorites-page .main {
        padding: 14px;
      }

      .head-row h1 {
        font-size: 26px;
      }

      .head-row p {
        font-size: 13px;
      }
    }

    @media (max-width: 700px) {
      .grid {
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

      .user-favorites-page .main {
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
<body class="user-favorites-page">
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
    <div class="favorites-shell">
      <section class="head-row">
        <div>
          <h1>Favorite Stations</h1>
          <p>Quickly access and book slots at your preferred charging locations.</p>
        </div>
      </section>

      <c:choose>
        <c:when test="${not empty favorites}">
          <section class="grid">
            <c:forEach var="s" items="${favorites}">
              <article class="station-card">
                <div class="thumb">
                  <span class="state-chip ${fn:toLowerCase(s.status)}"><i class="fa-regular fa-clock"></i>${s.status}</span>
                </div>

                <div class="station-body">
                  <div class="title-row">
                    <h3>${s.stationName}</h3>
                    <span class="rating"><i class="fa-regular fa-star"></i>4.${(s.stationId % 5) + 1}</span>
                  </div>

                  <div class="summary"><i class="fa-solid fa-location-dot"></i>${s.address}</div>

                  <div class="meta-tags">
                    <span>${s.chargerType}</span>
                    <span>${s.totalPorts} Ports</span>
                    <span>${s.districtName}</span>
                  </div>
                </div>

                <div class="card-actions">
                  <form method="post" action="${pageContext.request.contextPath}/user/favorites" style="margin:0;">
                    <input type="hidden" name="action" value="removeFavorite">
                    <input type="hidden" name="stationId" value="${s.stationId}">
                    <button class="remove-btn" type="submit" title="Remove favorite"><i class="fa-regular fa-trash-can"></i></button>
                  </form>

                  <a class="act-link" href="${pageContext.request.contextPath}/user/station?id=${s.stationId}&from=station-list">View Details</a>
                  <a class="act-link book" href="${pageContext.request.contextPath}/user/book-slot?stationId=${s.stationId}&from=station-list">Book Now</a>
                </div>
              </article>
            </c:forEach>
          </section>
        </c:when>
        <c:otherwise>
          <div class="empty">
            You have no favorite stations yet. Start by exploring stations and save your preferred hubs from
            <a href="${pageContext.request.contextPath}/user/station-list">Station List</a>.
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </main>
</div>
</body>
</html>
