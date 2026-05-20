<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Denisha Tamang --%>
<html>
<head>
  <title>User Profile</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <style>
    .user-profile-page {
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

    .user-profile-page .layout {
      min-height: calc(100vh - 72px);
      background: #F5F7FA;
    }

    .user-profile-page .user-sidebar {
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

    .user-profile-page .user-side-brand,
    .user-profile-page .user-side-logout {
      display: none;
    }

    .user-profile-page .user-side-nav {
      display: grid;
      gap: 6px;
    }

    .user-profile-page .user-side-nav a {
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

    .user-profile-page .user-side-nav a i {
      width: 28px;
      text-align: center;
      color: #8C95A3;
      font-size: 18px;
      line-height: 1;
    }

    .user-profile-page .user-side-nav a:hover {
      background: #FFFFFF;
      border-color: #E5E7EB;
      color: #4B5563;
    }

    .user-profile-page .user-side-nav a.active {
      background: #00B300;
      border-color: #00B300;
      color: #FFFFFF;
      font-weight: 700;
    }

    .user-profile-page .user-side-nav a.active i {
      color: #FFFFFF;
    }

    .user-profile-page .main {
      background: #F5F7FA;
      padding: 18px;
    }

    .profile-shell {
      max-width: 1260px;
      margin: 0 auto;
      display: grid;
      gap: 14px;
    }

    .head h1 {
      margin: 0;
      color: #111827;
      font-size: 30px;
      line-height: 1.05;
      letter-spacing: -0.7px;
      font-weight: 800;
      overflow-wrap: anywhere;
    }

    .head p {
      margin: 9px 0 0;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.35;
      font-weight: 500;
    }

    .notice {
      border-radius: 12px;
      border: 1px solid #E5E7EB;
      padding: 10px 12px;
      font-size: 14px;
      line-height: 1.3;
      font-weight: 600;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      width: fit-content;
    }

    .notice.ok {
      background: #ECF8EE;
      border-color: #BCE7C2;
      color: #2E7D32;
    }

    .notice.err {
      background: #FFF4E8;
      border-color: #FFD9B0;
      color: #B45309;
    }

    .profile-layout {
      display: grid;
      grid-template-columns: 1.8fr 0.88fr;
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

    .panel-title {
      margin: 0;
      color: #111827;
      font-size: 20px;
      line-height: 1;
      letter-spacing: -0.3px;
      font-weight: 800;
      display: inline-flex;
      align-items: center;
      gap: 9px;
    }

    .panel-title i {
      color: #2E7D32;
      font-size: 16px;
    }

    .panel-sub {
      margin: 0;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.35;
      font-weight: 500;
    }

    .row-two {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 12px;
    }

    .field {
      display: grid;
      gap: 6px;
    }

    .field label {
      color: #1F2937;
      font-size: 13px;
      line-height: 1;
      font-weight: 700;
    }

    .field input,
    .field textarea {
      width: 100%;
      min-height: 42px;
      border-radius: 12px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #1F2937;
      font-size: 14px;
      font-family: inherit;
      padding: 0 12px;
    }

    .field textarea {
      min-height: 78px;
      padding: 10px 12px;
      resize: vertical;
    }

    .field input:focus,
    .field textarea:focus {
      outline: none;
      border-color: #1976D2;
      box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.12);
    }

    .field input[readonly] {
      background: #F8FAFC;
      color: #6B7280;
    }

    .divider {
      border-top: 1px solid #EDF1F6;
      margin: 2px 0;
    }

    .actions {
      display: flex;
      justify-content: flex-end;
      gap: 8px;
      flex-wrap: wrap;
    }

    .btn {
      min-height: 42px;
      border-radius: 12px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #1F2937;
      font-size: 14px;
      line-height: 1;
      font-weight: 700;
      padding: 0 16px;
      font-family: inherit;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
    }

    .btn:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F1F7FF;
    }

    .btn.primary {
      border-color: #00B300;
      background: #00B300;
      color: #FFFFFF;
    }

    .btn.primary:hover {
      border-color: #059A05;
      background: #059A05;
      color: #FFFFFF;
    }

    .mini-card {
      border: 1px solid #EDF1F6;
      border-radius: 12px;
      background: #F8FAFC;
      padding: 12px;
      display: grid;
      gap: 8px;
    }

    .avatar {
      width: 76px;
      height: 76px;
      border-radius: 999px;
      border: 3px solid #FFFFFF;
      background: linear-gradient(145deg, #A9C9E8, #739FCB);
      color: #FFFFFF;
      display: grid;
      place-items: center;
      font-size: 20px;
      font-weight: 700;
      margin: 0 auto;
      box-shadow: 0 8px 16px rgba(15, 23, 42, 0.12);
    }

    .identity {
      text-align: center;
      display: grid;
      gap: 3px;
    }

    .identity h4 {
      margin: 0;
      color: #111827;
      font-size: 16px;
      line-height: 1.2;
      font-weight: 700;
    }

    .identity p {
      margin: 0;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.3;
      font-weight: 500;
      word-break: break-word;
    }

    .chip-row {
      display: flex;
      justify-content: center;
      gap: 7px;
      flex-wrap: wrap;
    }

    .chip {
      border-radius: 999px;
      border: 1px solid #E5E7EB;
      background: #FFFFFF;
      color: #6B7280;
      padding: 5px 10px;
      font-size: 12px;
      line-height: 1;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      text-transform: capitalize;
    }

    .chip.ok {
      border-color: #BCE7C2;
      background: #ECF8EE;
      color: #2E7D32;
    }

    .stat-list {
      display: grid;
      gap: 8px;
    }

    .stat {
      border: 1px solid #EDF1F6;
      border-radius: 12px;
      background: #FFFFFF;
      padding: 10px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 8px;
      font-size: 14px;
      line-height: 1.2;
      color: #374151;
      font-weight: 600;
    }

    .stat strong {
      color: #111827;
      font-weight: 800;
    }

    @media (max-width: 1180px) {
      .profile-layout {
        grid-template-columns: 1fr;
      }
    }

    @media (max-width: 980px) {
      .user-profile-page .layout {
        flex-direction: column;
      }

      .user-profile-page .user-sidebar {
        position: static;
        width: 100%;
        min-height: auto;
        padding: 10px 12px;
        overflow: hidden;
      }

      .user-profile-page .user-side-nav {
        display: flex;
        gap: 8px;
        overflow-x: auto;
        padding-bottom: 2px;
        scrollbar-width: thin;
        -webkit-overflow-scrolling: touch;
      }

      .user-profile-page .user-side-nav a {
        flex: 0 0 auto;
        min-width: max-content;
        padding: 10px 12px;
        border-radius: 10px;
      }

      .user-profile-page .main {
        padding: 14px;
      }

      .head h1 {
        font-size: 26px;
      }

      .head p {
        font-size: 13px;
      }
    }

    @media (max-width: 700px) {
      .row-two {
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

      .user-profile-page .main {
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

      .head h1 {
        font-size: 22px;
      }

      .head p {
        font-size: 12px;
      }
    }
  </style>
</head>
<body class="user-profile-page">
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
    <div class="profile-shell">
      <section class="head">
        <h1>User Profile</h1>
        <p>Manage your personal information, vehicle details, and security settings.</p>
      </section>

      <c:if test="${profileUpdated == 'true'}">
        <span class="notice ok"><i class="fa-regular fa-circle-check"></i>Profile updated successfully.</span>
      </c:if>
      <c:if test="${passwordUpdated == 'true'}">
        <span class="notice ok"><i class="fa-regular fa-circle-check"></i>Password updated successfully.</span>
      </c:if>
      <c:if test="${not empty passwordError}">
        <span class="notice err"><i class="fa-solid fa-circle-exclamation"></i>
          <c:choose>
            <c:when test="${passwordError == 'blank'}">Please fill all password fields.</c:when>
            <c:when test="${passwordError == 'current'}">Current password is incorrect.</c:when>
            <c:when test="${passwordError == 'length'}">New password must be at least 8 characters.</c:when>
            <c:when test="${passwordError == 'match'}">New password and confirm password do not match.</c:when>
            <c:otherwise>Unable to update password right now.</c:otherwise>
          </c:choose>
        </span>
      </c:if>

      <section class="profile-layout">
        <div style="display:grid; gap:14px;">
          <article class="panel">
            <div class="panel-body">
              <h2 class="panel-title"><i class="fa-regular fa-user"></i>Personal Information</h2>
              <p class="panel-sub">Update your contact details and default vehicle for faster bookings.</p>

              <form method="post" action="${pageContext.request.contextPath}/user/profile" style="display:grid; gap:12px;">
                <input type="hidden" name="action" value="profile">

                <div class="field">
                  <label for="fullName">Full Name</label>
                  <input id="fullName" name="fullName" value="${user.fullName}" required>
                </div>

                <div class="row-two">
                  <div class="field">
                    <label for="email">Email</label>
                    <input id="email" name="email" type="email" value="${user.email}" required>
                  </div>
                  <div class="field">
                    <label for="phone">Phone</label>
                    <input id="phone" name="phone" value="${user.phone}" required>
                  </div>
                </div>

                <div class="field">
                  <label for="address">Address</label>
                  <textarea id="address" name="address" required>${user.address}</textarea>
                </div>

                <div class="field">
                  <label for="vehicleNumber">Vehicle Number</label>
                  <input id="vehicleNumber" name="vehicleNumber" value="${user.vehicleNumber}">
                </div>

                <div class="actions">
                  <button class="btn primary" type="submit">Update Profile</button>
                </div>
              </form>
            </div>
          </article>

          <article class="panel">
            <div class="panel-body">
              <h2 class="panel-title"><i class="fa-solid fa-shield-halved"></i>Change Password</h2>
              <p class="panel-sub">Use a strong unique password to keep your account secure.</p>

              <form method="post" action="${pageContext.request.contextPath}/user/profile" style="display:grid; gap:12px;">
                <input type="hidden" name="action" value="changePassword">
                <div class="field">
                  <label for="currentPassword">Current Password</label>
                  <input id="currentPassword" name="currentPassword" type="password" required>
                </div>
                <div class="field">
                  <label for="newPassword">New Password</label>
                  <input id="newPassword" name="newPassword" type="password" required>
                </div>
                <div class="field">
                  <label for="confirmPassword">Confirm New Password</label>
                  <input id="confirmPassword" name="confirmPassword" type="password" required>
                </div>
                <div class="actions">
                  <button class="btn" type="submit">Update Password</button>
                </div>
              </form>
            </div>
          </article>
        </div>

        <aside style="display:grid; gap:14px;">
          <article class="panel">
            <div class="panel-body">
              <div class="avatar">${sessionScope.fullName != null ? fn:substring(sessionScope.fullName, 0, 1) : 'U'}</div>
              <div class="identity">
                <h4>${user.fullName}</h4>
                <p>${user.email}</p>
              </div>
              <div class="chip-row">
                <span class="chip ok"><i class="fa-regular fa-circle-check"></i>${user.status}</span>
                <span class="chip"><i class="fa-solid fa-car"></i>EV Owner</span>
              </div>
            </div>
          </article>

          <article class="panel">
            <div class="panel-body">
              <h2 class="panel-title"><i class="fa-solid fa-chart-line"></i>Activity Summary</h2>
              <div class="stat-list">
                <div class="stat"><span>Total Charging Sessions</span><strong>${bookingCount}</strong></div>
                <div class="stat"><span>Upcoming Bookings</span><strong>${upcomingCount}</strong></div>
                <div class="stat"><span>Total Spent</span><strong>Rs. ${profileSpent}</strong></div>
                <div class="stat"><span>Favorite Stations</span><strong>${favoriteCount}</strong></div>
                <div class="stat"><span>Reviews Submitted</span><strong>${reviewCount}</strong></div>
              </div>
            </div>
          </article>
        </aside>
      </section>
    </div>
  </main>
</div>
</body>
</html>
