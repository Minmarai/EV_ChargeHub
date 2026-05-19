<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Author: Minma Rai --%>
<html>
<head>
    <title>Reports &amp; Analytics</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .admin-reports-page .admin-content {
            background: #F5F7FA;
        }

        .admin-reports-head {
            margin-top: 18px;
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 14px;
            flex-wrap: wrap;
        }

        .admin-reports-head h1 {
            margin: 0;
            font-size: 54px;
            line-height: 1.05;
            letter-spacing: -1px;
            color: #1A1F2B;
        }

        .admin-reports-actions {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .period-btn,
        .admin-btn {
            height: 44px;
            border-radius: 12px;
            border: 1px solid #D1D5DB;
            background: #FFFFFF;
            color: #4B5563;
            padding: 0 14px;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            font-family: inherit;
            cursor: pointer;
            white-space: nowrap;
        }

        .period-btn:hover,
        .admin-btn:hover {
            border-color: #1976D2;
            color: #1976D2;
            background: #F8FBFF;
        }

        .period-btn.active {
            border-color: #1976D2;
            color: #1976D2;
            background: #EAF3FF;
        }

        .report-stats {
            margin-top: 16px;
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 12px;
        }

        .report-stat {
            background: #FFFFFF;
            border: 1px solid #E5E7EB;
            border-radius: 16px;
            padding: 18px;
            min-height: 138px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .report-stat-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 8px;
        }

        .report-stat-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: grid;
            place-items: center;
            font-size: 15px;
        }

        .report-stat-icon.green {
            background: #ECF8EE;
            color: #2E7D32;
        }

        .report-stat-icon.blue {
            background: #EAF3FF;
            color: #1976D2;
        }

        .report-stat-icon.orange {
            background: #FFF6EB;
            color: #FF9800;
        }

        .report-stat-icon.gray {
            background: #F3F4F6;
            color: #6B7280;
        }

        .trend {
            font-size: 13px;
            font-weight: 700;
            color: #6B7280;
        }

        .report-stat label {
            margin: 0;
            color: #6B7280;
            font-size: 14px;
            font-weight: 600;
        }

        .report-stat h3 {
            margin: 4px 0 0;
            color: #1F2937;
            font-size: 38px;
            line-height: 1;
            letter-spacing: -0.6px;
        }

        .reports-filter-row {
            margin-top: 14px;
            background: #FFFFFF;
            border: 1px solid #E5E7EB;
            border-radius: 16px;
            padding: 12px;
            display: grid;
            grid-template-columns: auto 220px 220px 250px auto;
            gap: 10px;
            align-items: center;
        }

        .reports-filter-label {
            color: #4B5563;
            font-size: 15px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 0 6px;
        }

        .reports-filter-select,
        .reports-filter-date {
            height: 46px;
            border: 1px solid #CBD5E1;
            border-radius: 10px;
            display: inline-flex;
            align-items: center;
            background: #FFFFFF;
            padding: 0 12px;
            gap: 8px;
            color: #94A3B8;
        }

        .reports-filter-select select,
        .reports-filter-date input {
            width: 100%;
            border: 0;
            outline: 0;
            padding: 0;
            margin: 0;
            background: transparent;
            color: #1F2937;
            font-size: 14px;
            font-family: inherit;
            box-shadow: none;
        }

        .reports-filter-submit,
        .reports-filter-clear {
            height: 46px;
            border-radius: 10px;
            border: 1px solid #D1D5DB;
            background: #FFFFFF;
            color: #4B5563;
            font-size: 14px;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0 14px;
            text-decoration: none;
            white-space: nowrap;
        }

        .reports-filter-submit:hover,
        .reports-filter-clear:hover {
            border-color: #1976D2;
            color: #1976D2;
            background: #F8FBFF;
        }

        .reports-grid-top {
            margin-top: 14px;
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 14px;
        }

        .reports-grid-mid,
        .reports-grid-bottom {
            margin-top: 14px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }

        .report-card {
            background: #FFFFFF;
            border: 1px solid #E5E7EB;
            border-radius: 16px;
            padding: 18px;
        }

        .report-card-head {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 10px;
        }

        .report-card h2 {
            margin: 0;
            font-size: 32px;
            letter-spacing: -0.6px;
            color: #111827;
        }

        .report-card h3 {
            margin: 0;
            font-size: 30px;
            letter-spacing: -0.4px;
            color: #111827;
        }

        .report-card p {
            margin: 4px 0 0;
            color: #6B7280;
            font-size: 14px;
        }

        .chart-box {
            position: relative;
            border-radius: 12px;
            border: 1px solid #EEF2F7;
            background: linear-gradient(180deg, #FFFFFF 0%, #FBFDFF 100%);
            padding: 10px;
        }

        .chart-box canvas {
            width: 100%;
            height: 260px;
            display: block;
        }

        .legend {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            color: #4B5563;
            font-size: 13px;
            font-weight: 700;
        }

        .legend span {
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

        .dot.green {
            background: #2E7D32;
        }

        .dot.blue {
            background: #1976D2;
        }

        .dot.orange {
            background: #FF9800;
        }

        .bar-chart {
            margin-top: 12px;
            display: grid;
            gap: 10px;
        }

        .bar-row {
            display: grid;
            grid-template-columns: 130px 1fr auto;
            gap: 10px;
            align-items: center;
        }

        .bar-label {
            font-size: 13px;
            color: #374151;
            font-weight: 600;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .bar-track {
            height: 13px;
            border-radius: 999px;
            background: #EEF2F7;
            overflow: hidden;
        }

        .bar-fill {
            height: 100%;
            border-radius: inherit;
        }

        .bar-fill.green {
            background: #2E7D32;
        }

        .bar-fill.blue {
            background: #1976D2;
        }

        .bar-value {
            font-size: 13px;
            color: #4B5563;
            font-weight: 700;
            min-width: 34px;
            text-align: right;
        }

        .table-shell {
            border: 1px solid #E5E7EB;
            border-radius: 12px;
            overflow: hidden;
            background: #FFFFFF;
        }

        .report-table {
            width: 100%;
            border-collapse: collapse;
        }

        .report-table thead th {
            background: #F8FAFC;
            color: #4B5563;
            font-size: 15px;
            font-weight: 700;
            text-align: left;
            padding: 12px;
            border-bottom: 1px solid #E5E7EB;
        }

        .report-table tbody td {
            padding: 12px;
            border-bottom: 1px solid #EEF2F7;
            color: #374151;
            font-size: 14px;
            vertical-align: middle;
        }

        .report-table tbody tr:last-child td {
            border-bottom: 0;
        }

        .util-track {
            width: 140px;
            height: 8px;
            border-radius: 999px;
            background: #EEF2F7;
            overflow: hidden;
            display: inline-block;
            vertical-align: middle;
            margin-right: 8px;
        }

        .util-fill {
            height: 100%;
            border-radius: inherit;
            background: #2E7D32;
        }

        .link-btn {
            height: 38px;
            border-radius: 10px;
            border: 1px solid #D1D5DB;
            background: #FFFFFF;
            color: #4B5563;
            padding: 0 12px;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .link-btn:hover {
            border-color: #1976D2;
            color: #1976D2;
            background: #F8FBFF;
        }

        @media (max-width: 1400px) {
            .report-stats {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .reports-filter-row {
                grid-template-columns: 1fr 1fr;
            }

            .reports-grid-top,
            .reports-grid-mid,
            .reports-grid-bottom {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 760px) {
            .admin-reports-head h1 {
                font-size: 36px;
            }

            .report-stats {
                grid-template-columns: 1fr;
            }

            .bar-row {
                grid-template-columns: 1fr;
            }

            .util-track {
                width: 100px;
            }
        }
    </style>
</head>
<body class="admin-dashboard-page admin-reports-page">
<div class="admin-shell">
    <jsp:include page="../common/admin-sidebar.jsp"/>

    <main class="admin-content">
        <section class="admin-topbar">
            <div class="admin-breadcrumb">
                <span>Dashboard</span>
                <i class="fa-solid fa-chevron-right"></i>
                <strong>Reports</strong>
            </div>
            <div class="admin-topbar-actions">
                <label class="admin-search"><i class="fa-solid fa-magnifying-glass"></i><input type="text" placeholder="Search..."></label>
                <div class="admin-user-chip">
                    <div><strong>Admin User</strong><small>Super Administrator</small></div>
                    <span>A</span>
                </div>
            </div>
        </section>

        <section class="admin-reports-head">
            <h1>Reports &amp; Analytics</h1>
            <div class="admin-reports-actions">
                <a class="period-btn ${period == 'today' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/reports?period=today&district=${district}&stationId=${stationId}&fromDate=${fromDate}&toDate=${toDate}">Today</a>
                <a class="period-btn ${period == '7d' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/reports?period=7d&district=${district}&stationId=${stationId}&fromDate=${fromDate}&toDate=${toDate}">7D</a>
                <a class="period-btn ${period == '30d' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/reports?period=30d&district=${district}&stationId=${stationId}&fromDate=${fromDate}&toDate=${toDate}">30D</a>
                <a class="period-btn ${period == 'ytd' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/reports?period=ytd&district=${district}&stationId=${stationId}&fromDate=${fromDate}&toDate=${toDate}">YTD</a>
            </div>
        </section>

        <section class="report-stats">
            <article class="report-stat">
                <div class="report-stat-head">
                    <span class="report-stat-icon green"><i class="fa-regular fa-calendar-check"></i></span>
                    <span class="trend">~ 12.5%</span>
                </div>
                <div>
                    <label>Total Bookings</label>
                    <h3>${totalBookings}</h3>
                </div>
            </article>

            <article class="report-stat">
                <div class="report-stat-head">
                    <span class="report-stat-icon blue"><i class="fa-regular fa-credit-card"></i></span>
                    <span class="trend">${paidPayments} paid</span>
                </div>
                <div>
                    <label>Total Revenue</label>
                    <h3>Rs. ${totalRevenue}</h3>
                </div>
            </article>

            <article class="report-stat">
                <div class="report-stat-head">
                    <span class="report-stat-icon orange"><i class="fa-regular fa-user"></i></span>
                    <span class="trend">Period users</span>
                </div>
                <div>
                    <label>New Users</label>
                    <h3>${newUsers}</h3>
                </div>
            </article>

            <article class="report-stat">
                <div class="report-stat-head">
                    <span class="report-stat-icon gray"><i class="fa-solid fa-bolt"></i></span>
                    <span class="trend">Stable</span>
                </div>
                <div>
                    <label>Active Stations</label>
                    <h3>${activeStations}</h3>
                </div>
            </article>
        </section>

        <section class="reports-grid-top">
            <article class="report-card">
                <div class="report-card-head">
                    <div>
                        <h3>Payment Summary</h3>
                        <p>Real paid revenue and booking volume across selected range</p>
                    </div>
                    <div class="legend"><span><i class="dot green"></i>Revenue</span><span><i class="dot blue"></i>Bookings</span></div>
                </div>
                <div class="chart-box"><canvas id="paymentTrendChart"></canvas></div>
                <p>Totals in range: Rs. ${totalRevenue} revenue, ${totalBookings} bookings, ${paidPayments} paid transactions.</p>
            </article>

            <article class="report-card">
                <div class="report-card-head">
                    <div>
                        <h3>User Registration Growth</h3>
                        <p>Real user account registrations over selected range</p>
                    </div>
                    <div class="legend"><span><i class="dot orange"></i>Users</span></div>
                </div>
                <div class="chart-box"><canvas id="userGrowthChart"></canvas></div>
                <p>Total newly registered users in range: ${newUsers}</p>
            </article>
        </section>

        <section class="reports-grid-mid">
            <article class="report-card">
                <div class="report-card-head">
                    <div>
                        <h3>Bookings by District</h3>
                        <p>Comparison of transaction volume across regions</p>
                    </div>
                </div>
                <c:set var="districtMax" value="${empty bookingsByDistrict ? 1 : bookingsByDistrict[0].count}"/>
                <div class="bar-chart">
                    <c:forEach var="row" items="${bookingsByDistrict}">
                        <div class="bar-row">
                            <div class="bar-label">${row.name}</div>
                            <div class="bar-track"><div class="bar-fill green" style="width: ${(row.count * 100.0) / districtMax}%;"></div></div>
                            <div class="bar-value">${row.count}</div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty bookingsByDistrict}"><div class="bar-label">No district data for current filters.</div></c:if>
                </div>
            </article>

            <article class="report-card">
                <div class="report-card-head">
                    <div>
                        <h3>Bookings by Station Manager</h3>
                        <p>Staff performance based on completed charge sessions</p>
                    </div>
                </div>
                <c:set var="managerMax" value="${empty bookingsByManager ? 1 : bookingsByManager[0].count}"/>
                <div class="bar-chart">
                    <c:forEach var="row" items="${bookingsByManager}">
                        <div class="bar-row">
                            <div class="bar-label">${row.name}</div>
                            <div class="bar-track"><div class="bar-fill blue" style="width: ${(row.count * 100.0) / managerMax}%;"></div></div>
                            <div class="bar-value">${row.count}</div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty bookingsByManager}"><div class="bar-label">No manager data for current filters.</div></c:if>
                </div>
            </article>
        </section>

        <section class="reports-grid-bottom">
            <article class="report-card">
                <div class="report-card-head">
                    <div>
                        <h3>Bookings by Station</h3>
                        <p>Station-wise booking volume snapshot</p>
                    </div>
                </div>
                <div class="table-shell">
                    <table class="report-table">
                        <thead>
                        <tr>
                            <th>Station</th>
                            <th>Bookings</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="row" items="${bookingsByStation}">
                            <tr>
                                <td>${row.name}</td>
                                <td>${row.count}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty bookingsByStation}">
                            <tr><td colspan="2">No station booking data for current filters.</td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </article>

            <article class="report-card">
                <div class="report-card-head">
                    <div>
                        <h3>Payment Summary</h3>
                        <p>Transaction state distribution</p>
                    </div>
                </div>
                <div class="table-shell">
                    <table class="report-table">
                        <thead>
                        <tr>
                            <th>Status</th>
                            <th>Count</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr><td>Paid</td><td>${paidPayments}</td></tr>
                        <tr><td>Pending</td><td>${pendingPayments}</td></tr>
                        <tr><td>Failed</td><td>${failedPayments}</td></tr>
                        <tr><td>Refunded</td><td>${refundedPayments}</td></tr>
                        </tbody>
                    </table>
                </div>
            </article>
        </section>

        <section class="report-card" style="margin-top: 14px;">
            <div class="report-card-head">
                <div>
                    <h3>Station Activity Summary</h3>
                    <p>Detailed usage and revenue metrics for top performing stations</p>
                </div>
                <a class="link-btn" href="${pageContext.request.contextPath}/admin/stations">View All Stations</a>
            </div>
            <div class="table-shell">
                <table class="report-table">
                    <thead>
                    <tr>
                        <th>Station Name</th>
                        <th>District</th>
                        <th>Manager</th>
                        <th>Bookings</th>
                        <th>Utilization Rate</th>
                        <th>Revenue Generated</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="row" items="${stationActivityRows}">
                        <tr>
                            <td>${row.stationName}</td>
                            <td>${row.district}</td>
                            <td>${row.manager}</td>
                            <td>${row.bookings}</td>
                            <td>
                                <span class="util-track"><span class="util-fill" style="width: ${row.utilization}%;"></span></span>
                                    ${row.utilization}%
                            </td>
                            <td>Rs. ${row.revenue}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty stationActivityRows}">
                        <tr><td colspan="6">No station activity data for selected filters.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>

<script>
    const trendLabels = [<c:forEach var="x" items="${paymentTrendLabels}" varStatus="s">"${x}"${s.last ? '' : ','}</c:forEach>];
    const trendRevenue = [<c:forEach var="x" items="${paymentTrendRevenue}" varStatus="s">${x}${s.last ? '' : ','}</c:forEach>];
    const trendBookings = [<c:forEach var="x" items="${paymentTrendBookings}" varStatus="s">${x}${s.last ? '' : ','}</c:forEach>];

    const regLabels = [<c:forEach var="x" items="${registrationMonths}" varStatus="s">"${x}"${s.last ? '' : ','}</c:forEach>];
    const regValues = [<c:forEach var="x" items="${registrationValues}" varStatus="s">${x}${s.last ? '' : ','}</c:forEach>];

    function drawLineChart(canvasId, labels, datasets) {
        const canvas = document.getElementById(canvasId);
        if (!canvas) return;
        const parent = canvas.parentElement;
        const dpr = window.devicePixelRatio || 1;
        const width = parent.clientWidth - 2;
        const height = 260;
        canvas.width = width * dpr;
        canvas.height = height * dpr;
        canvas.style.width = width + 'px';
        canvas.style.height = height + 'px';
        const ctx = canvas.getContext('2d');
        ctx.scale(dpr, dpr);
        ctx.clearRect(0, 0, width, height);

        const pad = { left: 40, right: 12, top: 14, bottom: 28 };
        const plotW = width - pad.left - pad.right;
        const plotH = height - pad.top - pad.bottom;
        const allValues = datasets.flatMap((d) => d.values);
        const maxValue = Math.max(1, ...allValues);

        ctx.strokeStyle = '#E5E7EB';
        ctx.lineWidth = 1;
        for (let i = 0; i <= 4; i++) {
            const y = pad.top + (plotH * i / 4);
            ctx.beginPath();
            ctx.moveTo(pad.left, y);
            ctx.lineTo(width - pad.right, y);
            ctx.stroke();
        }

        labels.forEach((label, idx) => {
            const x = pad.left + (plotW * (labels.length === 1 ? 0.5 : idx / (labels.length - 1)));
            ctx.fillStyle = '#6B7280';
            ctx.font = '12px sans-serif';
            ctx.textAlign = 'center';
            ctx.fillText(label, x, height - 8);
        });

        datasets.forEach((set) => {
            ctx.strokeStyle = set.color;
            ctx.fillStyle = set.color;
            ctx.lineWidth = 2.4;
            ctx.beginPath();
            set.values.forEach((v, idx) => {
                const x = pad.left + (plotW * (set.values.length === 1 ? 0.5 : idx / (set.values.length - 1)));
                const y = pad.top + plotH - ((v / maxValue) * plotH);
                if (idx === 0) ctx.moveTo(x, y);
                else ctx.lineTo(x, y);
            });
            ctx.stroke();

            set.values.forEach((v, idx) => {
                const x = pad.left + (plotW * (set.values.length === 1 ? 0.5 : idx / (set.values.length - 1)));
                const y = pad.top + plotH - ((v / maxValue) * plotH);
                ctx.beginPath();
                ctx.arc(x, y, 3, 0, Math.PI * 2);
                ctx.fill();
            });
        });
    }

    function drawAreaChart(canvasId, labels, values, lineColor, fillColor) {
        const canvas = document.getElementById(canvasId);
        if (!canvas) return;
        const parent = canvas.parentElement;
        const dpr = window.devicePixelRatio || 1;
        const width = parent.clientWidth - 2;
        const height = 260;
        canvas.width = width * dpr;
        canvas.height = height * dpr;
        canvas.style.width = width + 'px';
        canvas.style.height = height + 'px';
        const ctx = canvas.getContext('2d');
        ctx.scale(dpr, dpr);
        ctx.clearRect(0, 0, width, height);

        const pad = { left: 38, right: 12, top: 14, bottom: 28 };
        const plotW = width - pad.left - pad.right;
        const plotH = height - pad.top - pad.bottom;
        const maxValue = Math.max(1, ...values);

        ctx.strokeStyle = '#E5E7EB';
        ctx.lineWidth = 1;
        for (let i = 0; i <= 4; i++) {
            const y = pad.top + (plotH * i / 4);
            ctx.beginPath();
            ctx.moveTo(pad.left, y);
            ctx.lineTo(width - pad.right, y);
            ctx.stroke();
        }

        const points = values.map((v, idx) => {
            const x = pad.left + (plotW * (values.length === 1 ? 0.5 : idx / (values.length - 1)));
            const y = pad.top + plotH - ((v / maxValue) * plotH);
            return { x, y };
        });

        ctx.beginPath();
        points.forEach((p, idx) => {
            if (idx === 0) ctx.moveTo(p.x, p.y);
            else ctx.lineTo(p.x, p.y);
        });
        ctx.lineTo(points[points.length - 1].x, pad.top + plotH);
        ctx.lineTo(points[0].x, pad.top + plotH);
        ctx.closePath();
        ctx.fillStyle = fillColor;
        ctx.fill();

        ctx.beginPath();
        points.forEach((p, idx) => {
            if (idx === 0) ctx.moveTo(p.x, p.y);
            else ctx.lineTo(p.x, p.y);
        });
        ctx.strokeStyle = lineColor;
        ctx.lineWidth = 2.2;
        ctx.stroke();

        labels.forEach((label, idx) => {
            const x = pad.left + (plotW * (labels.length === 1 ? 0.5 : idx / (labels.length - 1)));
            ctx.fillStyle = '#6B7280';
            ctx.font = '12px sans-serif';
            ctx.textAlign = 'center';
            ctx.fillText(label, x, height - 8);
        });
    }

    function renderCharts() {
        drawLineChart('paymentTrendChart', trendLabels, [
            { values: trendRevenue, color: '#2E7D32' },
            { values: trendBookings, color: '#1976D2' }
        ]);
        drawAreaChart('userGrowthChart', regLabels, regValues, '#FF9800', 'rgba(255, 152, 0, 0.2)');
    }

    renderCharts();
    window.addEventListener('resize', renderCharts);
</script>
</body>
</html>
