<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Imtiyaz Ansari IIC --%>
<html>
<head>
  <title>Station Reports</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="manager-dashboard-page manager-reports-page">
<div class="manager-shell">
  <jsp:include page="../common/manager-sidebar.jsp"/>

  <main class="manager-content">
    <section class="reports-head">
      <div>
        <h1>Station Reports</h1>
        <p>Analytics and performance metrics for your managed stations.</p>
      </div>
    </section>

    <section class="report-cards">
      <article class="report-card">
        <div class="top"><span>Total Revenue</span><i class="fa-regular fa-credit-card"></i></div>
        <h3>NPR ${totalRevenue}</h3>
        <p><i class="fa-solid fa-arrow-trend-up"></i> +12.5% <span>from last month</span></p>
      </article>
      <article class="report-card">
        <div class="top"><span>Total Bookings</span><i class="fa-solid fa-bolt"></i></div>
        <h3>${totalBookings}</h3>
        <p><i class="fa-solid fa-arrow-trend-up"></i> +8.2% <span>from last month</span></p>
      </article>
      <article class="report-card">
        <div class="top"><span>Completion Rate</span><i class="fa-regular fa-circle-check"></i></div>
        <h3>${completionRate}%</h3>
        <p class="danger"><i class="fa-solid fa-arrow-trend-down"></i> -1.1% <span>from last month</span></p>
      </article>
      <article class="report-card">
        <div class="top"><span>Avg. Utilization</span><i class="fa-solid fa-wave-square"></i></div>
        <h3>${avgUtilization}%</h3>
        <p><i class="fa-solid fa-arrow-trend-up"></i> +3.4% <span>from last month</span></p>
      </article>
    </section>

    <section class="report-mid-grid">
      <article class="report-panel status-panel">
        <h2>Booking Outcome Distribution</h2>
        <p>Distribution of booking outcomes</p>
        <div class="status-stats">
          <div><span class="dot done"></span> Completed <b>${totalBookings == 0 ? 0 : (completedBookings * 100 / totalBookings)}%</b></div>
          <div><span class="dot cancelled"></span> Cancelled <b>${totalBookings == 0 ? 0 : (cancelledBookings * 100 / totalBookings)}%</b></div>
          <div><span class="dot noshow"></span> No-Show <b>${totalBookings == 0 ? 0 : (noShowBookings * 100 / totalBookings)}%</b></div>
        </div>
      </article>

      <article class="report-panel slot-panel">
        <h2>Most Used Time Slot</h2>
        <p>Top time slot by booking count</p>
        <div class="slot-insight">
          <label>Time Slot</label>
          <strong>${mostUsedSlot}</strong>
          <small>${mostUsedSlotCount} bookings</small>
        </div>
      </article>
    </section>

    <section class="report-panel station-breakdown">
      <div class="station-breakdown-head">
        <h2>Station Performance Breakdown</h2>
        <p>Detailed metrics for all managed stations</p>
        <button type="button">View All Stations</button>
      </div>

      <table>
        <thead>
        <tr>
          <th>Station Name</th>
          <th>District</th>
          <th>Revenue (NPR)</th>
          <th>Bookings</th>
          <th>Utilization</th>
          <th>Status</th>
          <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="station" items="${reportStations}">
          <tr>
            <td>
              <strong>${station.stationName}</strong>
              <small>ST-${station.stationId}</small>
            </td>
            <td>${empty station.districtName ? '-' : station.districtName}</td>
            <td>${stationRevenue[station.stationId]}</td>
            <td>${stationBookingCount[station.stationId]}</td>
            <td>
              <div class="util-cell">
                <c:set var="u" value="${stationBookingCount[station.stationId] > 0 ? (stationBookingCount[station.stationId] * 7) : 0}"/>
                <span>${u > 100 ? 100 : u}%</span>
                <div class="util-bar"><em style="width:${u > 100 ? 100 : u}%"></em></div>
              </div>
            </td>
            <td><span class="station-status ${fn:toLowerCase(station.status)}">${station.status}</span></td>
            <td><a class="action-more" href="${pageContext.request.contextPath}/station-manager/station-form?id=${station.stationId}"><i class="fa-solid fa-ellipsis-vertical"></i></a></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </section>
  </main>
</div>
</body>
</html>
