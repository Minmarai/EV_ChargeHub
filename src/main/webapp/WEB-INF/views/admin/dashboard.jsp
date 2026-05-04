<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Admin Dashboard</title>
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
                <label class="admin-search"><i class="fa-solid fa-magnifying-glass"></i><input type="text" placeholder="Search records..."></label>
                <i class="fa-regular fa-bell"></i>
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
            <article class="admin-card admin-chart-card">
                <div class="admin-card-head">
                    <div>
                        <h2>Revenue Performance</h2>
                        <p>Monthly revenue vs targets in NPR</p>
                    </div>
                    <div class="admin-card-head-actions">
                        <button type="button">Export Report</button>
                        <button type="button">Filter Range</button>
                    </div>
                </div>
                <div class="admin-chart-area">
                    <svg id="adminRevenueChart" class="admin-chart-svg" viewBox="0 0 860 240" preserveAspectRatio="none" aria-label="Revenue and target trend chart">
                        <g class="admin-chart-grid">
                            <line x1="52" y1="24" x2="828" y2="24"></line>
                            <line x1="52" y1="72" x2="828" y2="72"></line>
                            <line x1="52" y1="120" x2="828" y2="120"></line>
                            <line x1="52" y1="168" x2="828" y2="168"></line>
                            <line x1="52" y1="216" x2="828" y2="216"></line>
                        </g>
                        <polyline id="adminTargetLine" class="admin-target-line" points=""></polyline>
                        <polyline id="adminRevenueLine" class="admin-revenue-line" points=""></polyline>
                        <g id="adminTargetDots"></g>
                        <g id="adminRevenueDots"></g>
                        <g id="adminXAxisLabels"></g>
                    </svg>
                    <div class="admin-chart-legend">
                        <span><i class="dot-revenue"></i>Actual Revenue</span>
                        <span><i class="dot-target"></i>Target Revenue</span>
                    </div>
                </div>
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
<script>
    (function () {
        function parseList(raw) {
            if (!raw) return [];
            return raw.replace(/^\[|\]$/g, "")
                .split(",")
                .map(function (v) { return v.trim(); })
                .filter(function (v) { return v.length > 0; });
        }

        var labels = parseList("${chartLabels}");
        var revenue = parseList("${chartRevenue}").map(function (v) { return Number(v) || 0; });
        var target = parseList("${chartTarget}").map(function (v) { return Number(v) || 0; });
        if (!labels.length || !revenue.length || !target.length) return;

        var chartWidth = 860;
        var chartHeight = 240;
        var left = 52;
        var right = 32;
        var top = 24;
        var bottom = 24;
        var w = chartWidth - left - right;
        var h = chartHeight - top - bottom;

        var maxValue = Math.max.apply(null, revenue.concat(target));
        if (maxValue <= 0) maxValue = 1;

        function xAt(i, size) { return left + (w * i / (size - 1 || 1)); }
        function yAt(v) { return top + (h - ((v / maxValue) * h)); }

        var revPts = revenue.map(function (v, i) { return xAt(i, revenue.length) + "," + yAt(v); }).join(" ");
        var tgtPts = target.map(function (v, i) { return xAt(i, target.length) + "," + yAt(v); }).join(" ");

        document.getElementById("adminRevenueLine").setAttribute("points", revPts);
        document.getElementById("adminTargetLine").setAttribute("points", tgtPts);

        var revDots = document.getElementById("adminRevenueDots");
        var tgtDots = document.getElementById("adminTargetDots");
        var xLabels = document.getElementById("adminXAxisLabels");

        labels.forEach(function (label, i) {
            var rx = xAt(i, revenue.length);
            var ry = yAt(revenue[i] || 0);
            var tx = xAt(i, target.length);
            var ty = yAt(target[i] || 0);

            var rDot = document.createElementNS("http://www.w3.org/2000/svg", "circle");
            rDot.setAttribute("cx", rx);
            rDot.setAttribute("cy", ry);
            rDot.setAttribute("r", "3.5");
            rDot.setAttribute("class", "admin-revenue-dot");
            revDots.appendChild(rDot);

            var tDot = document.createElementNS("http://www.w3.org/2000/svg", "circle");
            tDot.setAttribute("cx", tx);
            tDot.setAttribute("cy", ty);
            tDot.setAttribute("r", "3");
            tDot.setAttribute("class", "admin-target-dot");
            tgtDots.appendChild(tDot);

            var txt = document.createElementNS("http://www.w3.org/2000/svg", "text");
            txt.setAttribute("x", rx);
            txt.setAttribute("y", chartHeight - 6);
            txt.setAttribute("text-anchor", "middle");
            txt.setAttribute("class", "admin-axis-label");
            txt.textContent = label;
            xLabels.appendChild(txt);
        });
    })();
</script>
</body>
</html>
