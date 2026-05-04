<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Manage Stations</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="admin-dashboard-page">
<div class="admin-shell">
    <jsp:include page="../common/admin-sidebar.jsp"/>

    <main class="admin-content">
        <section class="admin-topbar">
            <div class="admin-breadcrumb">
                <strong>Manage Stations</strong>
                <i class="fa-solid fa-chevron-right"></i>
                <span>ChargeHub Nepal Admin Portal</span>
            </div>
            <div class="admin-topbar-actions">
                <label class="admin-search"><i class="fa-solid fa-magnifying-glass"></i><input type="text" placeholder="Search stations or ports..."></label>
                <i class="fa-regular fa-bell"></i>
                <div class="admin-user-chip">
                    <div>
                        <strong>Admin User</strong>
                        <small>System Admin</small>
                    </div>
                    <span>A</span>
                </div>
            </div>
        </section>

        <section class="admin-stations-head">
            <h1>Manage Stations</h1>
            <p>Monitor and manage electric vehicle charging stations across the national network.</p>
        </section>

        <section class="admin-stations-stats">
            <article><label>Total Stations</label><h3>${stationsCount}</h3><small>Across districts</small></article>
            <article><label>Active Ports</label><h3>${stationsCount * 4}</h3><small>Estimated live ports</small></article>
            <article><label>Daily Energy</label><h3>${stationsCount * 2} MWh</h3><small>Last 24 hours</small></article>
            <article><label>Revenue Today</label><h3>NPR ${stationsCount * 360}</h3><small>Station network total</small></article>
        </section>

        <section class="admin-stations-filters-card">
            <form method="get" action="${pageContext.request.contextPath}/admin/stations" class="admin-stations-filters">
                <div class="admin-users-search-wrap">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" name="q" value="${q}" placeholder="Search station name...">
                </div>
                <div class="admin-users-filter-select">
                    <select name="district">
                        <option value="">All Districts</option>
                        <c:forEach var="d" items="${districts}">
                            <option value="${d}" ${district == d ? 'selected' : ''}>${d}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="admin-users-filter-select">
                    <select name="type">
                        <option value="">All Types</option>
                        <c:forEach var="t" items="${types}">
                            <option value="${t}" ${type == t ? 'selected' : ''}>${t}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="admin-users-filter-select">
                    <select name="status">
                        <option value="">All Status</option>
                        <option value="active" ${status == 'active' ? 'selected' : ''}>Active</option>
                        <option value="maintenance" ${status == 'maintenance' ? 'selected' : ''}>Maintenance</option>
                        <option value="offline" ${status == 'offline' ? 'selected' : ''}>Offline</option>
                    </select>
                </div>
                <button class="admin-outline-btn" type="submit"><i class="fa-solid fa-filter"></i></button>
                <a class="admin-primary-btn" href="${pageContext.request.contextPath}/admin/station-form"><i class="fa-solid fa-plus"></i>Add Station</a>
            </form>
        </section>

        <section class="admin-stations-table-card">
            <div class="admin-stations-selected-row">
                <span>0 of ${stationsCount} stations selected</span>
                <i class="fa-solid fa-ellipsis"></i>
            </div>
            <table class="admin-users-table admin-stations-table">
                <thead>
                <tr>
                    <th><input type="checkbox" disabled></th>
                    <th>Station Name</th>
                    <th>District</th>
                    <th>Assigned Manager</th>
                    <th>Type</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="s" items="${stations}">
                    <tr>
                        <td><input type="checkbox"></td>
                        <td>
                            <strong>${s.stationName}</strong>
                            <small>CH-${s.stationId} • ${s.totalPorts} Ports</small>
                        </td>
                        <td><i class="fa-solid fa-location-dot"></i> ${s.districtName}</td>
                        <td>
                            <div class="manager-cell">
                                <span class="manager-avatar">${s.managerName != null && !s.managerName.isEmpty() ? s.managerName.substring(0,1) : 'N'}</span>
                                <strong>${empty s.managerName ? 'Not Assigned' : s.managerName}</strong>
                            </div>
                        </td>
                        <td><span class="region-pill">${s.chargerType}</span></td>
                        <td><span class="admin-user-status ${s.status eq 'active' ? 'active' : (s.status eq 'maintenance' ? 'pending' : 'suspended')}">${s.status}</span></td>
                        <td>
                            <div class="admin-user-actions">
                                <a class="icon-btn edit" title="Edit" href="${pageContext.request.contextPath}/admin/station-form?id=${s.stationId}"><i class="fa-regular fa-pen-to-square"></i></a>
                                <form method="post">
                                    <input type="hidden" name="action" value="deleteStation">
                                    <input type="hidden" name="stationId" value="${s.stationId}">
                                    <button class="icon-btn delete" title="Delete"><i class="fa-regular fa-trash-can"></i></button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty stations}">
                    <tr><td colspan="7" class="empty-row">No stations matched the selected filters.</td></tr>
                </c:if>
                </tbody>
            </table>
            <div class="admin-users-footer">
                <span>Showing 1 to ${stationsCount} of ${stationsCount} stations</span>
                <div class="admin-users-pager">
                    <button type="button" disabled><i class="fa-solid fa-chevron-left"></i> Previous</button>
                    <button type="button" class="active">1</button>
                    <button type="button">2</button>
                    <button type="button">3</button>
                    <button type="button">Next <i class="fa-solid fa-chevron-right"></i></button>
                </div>
            </div>
        </section>
    </main>
</div>
</body>
</html>
