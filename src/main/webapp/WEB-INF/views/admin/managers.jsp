<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Author: Minma Rai --%>
<html>
<head>
    <title>Station Managers</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="admin-dashboard-page">
<div class="admin-shell">
    <jsp:include page="../common/admin-sidebar.jsp"/>

    <main class="admin-content">
        <section class="admin-topbar">
            <div class="admin-breadcrumb">
                <strong>Station Managers</strong>
                <i class="fa-solid fa-chevron-right"></i>
                <span>ChargeHub Nepal Admin Module</span>
            </div>
            <div class="admin-topbar-actions">
                <label class="admin-search"><i class="fa-solid fa-magnifying-glass"></i><input type="text" placeholder="Search records..."></label>
                <div class="admin-user-chip">
                    <div>
                        <strong>Admin User</strong>
                        <small>Super Admin</small>
                    </div>
                    <span>A</span>
                </div>
            </div>
        </section>

        <section class="admin-manager-stats">
            <article><label>Total Managers</label><h3>${managersCount}</h3></article>
            <article class="soft-green"><label>Active Operators</label><h3>${activeManagers}</h3></article>
            <article class="soft-blue"><label>Inactive/Off-duty</label><h3>${inactiveManagers}</h3></article>
            <article><label>Avg Performance</label><h3>4.6</h3></article>
        </section>

        <section class="admin-manager-card">
            <div class="admin-manager-head">
                <div>
                    <h2>Operational Fleet</h2>
                    <p>View and manage all active station operators across Nepal</p>
                </div>
                <a class="admin-primary-btn" href="${pageContext.request.contextPath}/admin/manager-form"><i class="fa-solid fa-plus"></i>Add New Manager</a>
            </div>

            <form class="admin-manager-filters" method="get" action="${pageContext.request.contextPath}/admin/managers">
                <div class="admin-users-search-wrap">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" name="q" value="${q}" placeholder="Search by name, email or station...">
                </div>
                <button type="submit" class="admin-apply-btn">Apply</button>
                <button type="submit" class="admin-reset-link" name="reset" value="1">Reset Filters</button>
                <div class="admin-users-filter-select">
                    <select name="region">
                        <option value="">Region</option>
                        <c:forEach var="rg" items="${regions}">
                            <option value="${rg}" ${region == rg ? 'selected' : ''}>${rg}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="admin-users-filter-select">
                    <select name="status">
                        <option value="">Status</option>
                        <option value="Active" ${status == 'Active' ? 'selected' : ''}>Active</option>
                        <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Pending</option>
                        <option value="Deactivated" ${status == 'Deactivated' ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>
            </form>

            <div class="admin-manager-table-wrap">
                <table class="admin-users-table admin-managers-table">
                    <thead>
                    <tr>
                        <th>Manager Details</th>
                        <th>Station Assigned</th>
                        <th>Region</th>
                        <th>Performance</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="row" items="${managerRows}">
                        <c:set var="m" value="${row.manager}"/>
                        <tr>
                            <td>
                                <div class="manager-cell">
                                    <span class="manager-avatar">${m.fullName != null && !m.fullName.isEmpty() ? m.fullName.substring(0,1) : 'M'}</span>
                                    <div>
                                        <strong>${m.fullName}</strong>
                                        <small>${m.email}</small>
                                    </div>
                                </div>
                            </td>
                            <td>${row.stationName}</td>
                            <td><span class="region-pill">${row.region}</span></td>
                            <td>
                                <span class="stars">★★★★★</span>
                                <strong class="score">${row.performance}</strong>
                            </td>
                            <td>
                                <span class="admin-user-status ${m.status eq 'Active' ? 'active' : (m.status eq 'Pending' ? 'pending' : 'suspended')}">${m.status eq 'Deactivated' ? 'Inactive' : m.status}</span>
                            </td>
                            <td>
                                <div class="admin-user-actions">
                                    <a class="icon-btn edit" href="${pageContext.request.contextPath}/admin/manager-form?id=${m.userId}" title="Edit"><i class="fa-regular fa-pen-to-square"></i></a>
                                    <form method="post">
                                        <input type="hidden" name="action" value="deleteUser">
                                        <input type="hidden" name="userId" value="${m.userId}">
                                        <button class="icon-btn delete" title="Delete"><i class="fa-regular fa-trash-can"></i></button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty managerRows}">
                        <tr><td colspan="6" class="empty-row">No station managers found.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <div class="admin-users-footer">
                <span></span>
                <div class="admin-users-pager">
                    <button type="button" disabled><i class="fa-solid fa-chevron-left"></i> Previous</button>
                    <button type="button" class="active">1</button>
                    <button type="button">2</button>
                    <button type="button">3</button>
                    <button type="button">4</button>
                    <button type="button">Next <i class="fa-solid fa-chevron-right"></i></button>
                </div>
            </div>
        </section>
    </main>
</div>
</body>
</html>
