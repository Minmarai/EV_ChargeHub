<%@ page contentType="text/html;charset=UTF-8" %>
<%-- Author: Minma Rai IIC--%>
<html>
<head>
    <title>Admin Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="admin-dashboard-page">
<div class="admin-shell">
    <jsp:include page="../common/admin-sidebar.jsp"/>

    <main class="admin-content">
        <section class="admin-topbar">
            <div class="admin-breadcrumb">
                <strong>System Overview</strong>
                <i class="fa-solid fa-chevron-right"></i>
                <span>ChargeHub Nepal Admin Module</span>
            </div>
            <div class="admin-topbar-actions">
                <div class="admin-user-chip">
                    <div>
                        <strong>Admin User</strong>
                        <small>Super Admin</small>
                    </div>
                    <span>A</span>
                </div>
            </div>
        </section>

        <section class="admin-summary-grid">
            <article class="admin-summary-card"><label>Total Users</label><h3>${userCount}</h3></article>
            <article class="admin-summary-card"><label>Station Managers</label><h3>${managerCount}</h3></article>
            <article class="admin-summary-card"><label>Total Stations</label><h3>${stationCount}</h3></article>
            <article class="admin-summary-card"><label>Total Bookings</label><h3>${bookingCount}</h3></article>
            <article class="admin-summary-card"><label>Total Payments</label><h3>${paymentCount}</h3></article>
            <article class="admin-summary-card"><label>Pending Reviews/Messages</label><h3>${pendingReviews + pendingMessages}</h3></article>
        </section>

        <section class="admin-dashboard-grid">
            <article class="admin-card admin-activity-card">
                <div class="admin-card-head">
                    <div>
                        <h2>Recent System Activity</h2>
                        <p>Live updates across all administrative modules</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/reports">View All Activity</a>
                </div>
                <table>
                    <thead><tr><th>ENTITY/USER</th><th>ACTION TAKEN</th><th>STATUS</th><th>TIMESTAMP</th></tr></thead>
                    <tbody>
                    <tr><td><span class="dot">U</span> New Users</td><td>User registrations</td><td><em>user</em></td><td>2 mins ago</td></tr>
                    <tr><td><span class="dot">S</span> Stations</td><td>Station updates</td><td><em>station</em></td><td>15 mins ago</td></tr>
                    <tr><td><span class="dot">P</span> Payments</td><td>Payments reconciled</td><td><em>payment</em></td><td>1 hr ago</td></tr>
                    </tbody>
                </table>
            </article>

            <article class="admin-card admin-quick-card">
                <h2>Admin Quick Actions</h2>
                <p>Common management tasks</p>
                <div class="quick-grid">
                    <a href="${pageContext.request.contextPath}/admin/user-form"><i class="fa-solid fa-plus"></i><span>Add User</span></a>
                    <a href="${pageContext.request.contextPath}/admin/station-form"><i class="fa-solid fa-bolt"></i><span>New Station</span></a>
                    <a href="${pageContext.request.contextPath}/admin/manager-form"><i class="fa-regular fa-user"></i><span>New Manager</span></a>
                    <a href="${pageContext.request.contextPath}/admin/reports"><i class="fa-solid fa-gear"></i><span>Configs</span></a>
                </div>
            </article>

            <aside class="admin-side-stack">
                <article class="admin-card network-card">
                    <h2>Network Status</h2>
                    <p>Real-time station availability</p>
                    <div class="metric-row"><span>Active Stations</span><b>${stationCount}</b></div>
                    <div class="metric-row"><span>Under Maintenance</span><b>${pendingReviews}</b></div>
                    <div class="metric-row"><span>Critical Errors</span><b>${pendingMessages}</b></div>
                </article>
                <article class="admin-card support-card">
                    <h2>Support Queue</h2>
                    <p>${pendingMessages} unresolved tickets</p>
                    <a href="${pageContext.request.contextPath}/admin/messages">Go to Messages <i class="fa-solid fa-chevron-right"></i></a>
                </article>
            </aside>
        </section>
    </main>
</div>
</body>
</html>
