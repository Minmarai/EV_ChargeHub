<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Author: Minma Rai IIC --%>
<html>
<head>
  <title>User Management</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="admin-dashboard-page">
<div class="admin-shell">
  <jsp:include page="../common/admin-sidebar.jsp"/>

  <main class="admin-content">
    <section class="admin-topbar">
      <div class="admin-breadcrumb">
        <strong>User Management</strong>
        <i class="fa-solid fa-chevron-right"></i>
        <span>ChargeHub Nepal Admin module</span>
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

    <section class="admin-users-head">
      <div>
        <h1>System Users</h1>
        <p>View and manage all registered customers and internal staff members.</p>
      </div>
      <div class="admin-users-head-actions">
        <a class="admin-primary-btn" href="${pageContext.request.contextPath}/admin/user-form"><i class="fa-solid fa-plus"></i>Add New User</a>
      </div>
    </section>

    <section class="admin-users-filters">
      <form method="get" action="${pageContext.request.contextPath}/admin/users" class="admin-users-filter-form">
        <input type="hidden" name="pageSize" value="${pageSize}">
        <div class="admin-users-search-wrap">
          <i class="fa-solid fa-magnifying-glass"></i>
          <input type="text" name="q" value="${q}" placeholder="Search by name, email, or user ID...">
        </div>
        <div class="admin-users-filter-select">
          <select name="role">
            <option value="">Role</option>
            <option value="user" ${role == 'user' ? 'selected' : ''}>Customer</option>
            <option value="station_manager" ${role == 'station_manager' ? 'selected' : ''}>Station Manager</option>
            <option value="admin" ${role == 'admin' ? 'selected' : ''}>Admin</option>
          </select>
        </div>
        <div class="admin-users-filter-select">
          <select name="status">
            <option value="">Status</option>
            <option value="active" ${status == 'active' ? 'selected' : ''}>Active</option>
            <option value="pending" ${status == 'pending' ? 'selected' : ''}>Pending</option>
            <option value="suspended" ${status == 'suspended' ? 'selected' : ''}>Suspended</option>
            <option value="deactivated" ${status == 'deactivated' ? 'selected' : ''}>Deactivated</option>
          </select>
        </div>
        <button type="submit" class="admin-apply-btn">Apply</button>
        <button class="admin-reset-link" name="reset" value="1">Reset Filters</button>
      </form>
    </section>

    <section class="admin-users-table-card">
      <table class="admin-users-table">
        <thead>
        <tr>
          <th><input type="checkbox" disabled></th>
          <th>User ID</th>
          <th>Full Name</th>
          <th>Contact Details</th>
          <th>Role</th>
          <th>Status</th>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="u" items="${users}">
          <tr>
            <td><input type="checkbox"></td>
            <td class="muted">CH-${u.userId}</td>
            <td>${u.fullName}</td>
            <td>
              <div>${u.email}</div>
              <small>${u.phone}</small>
            </td>
            <td>
              <span class="admin-user-role ${u.role == 'station_manager' ? 'manager' : (u.role == 'admin' ? 'admin' : 'customer')}">
                  ${u.role == 'station_manager' ? 'Station Manager' : (u.role == 'admin' ? 'Admin' : 'Customer')}
              </span>
            </td>
            <td>
              <span class="admin-user-status ${u.status eq 'Active' ? 'active' : (u.status eq 'Pending' ? 'pending' : 'suspended')}">${u.status}</span>
            </td>
            <td>
              <div class="admin-user-actions">
                <a class="icon-btn edit" title="Edit" href="${pageContext.request.contextPath}/admin/user-form?id=${u.userId}"><i class="fa-regular fa-pen-to-square"></i></a>
                <form method="post">
                  <input type="hidden" name="action" value="deleteUser">
                  <input type="hidden" name="userId" value="${u.userId}">
                  <button type="submit" class="icon-btn delete" title="Delete"><i class="fa-regular fa-trash-can"></i></button>
                </form>
              </div>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty users}">
          <tr>
            <td colspan="7" class="empty-row">No users matched the selected filters.</td>
          </tr>
        </c:if>
        </tbody>
      </table>
      <div class="admin-users-footer">
        <span>Showing ${usersFrom}-${usersTo} of ${usersTotalCount} users</span>
        <div class="admin-users-pager">
          <form method="get" action="${pageContext.request.contextPath}/admin/users" style="display:inline">
            <input type="hidden" name="q" value="${q}">
            <input type="hidden" name="role" value="${role}">
            <input type="hidden" name="status" value="${status}">
            <input type="hidden" name="pageSize" value="${pageSize}">
            <input type="hidden" name="page" value="${page - 1}">
            <button type="submit" ${page <= 1 ? 'disabled' : ''}><i class="fa-solid fa-chevron-left"></i> Prev</button>
          </form>

          <c:forEach begin="1" end="${totalPages}" var="pNum">
            <form method="get" action="${pageContext.request.contextPath}/admin/users" style="display:inline">
              <input type="hidden" name="q" value="${q}">
              <input type="hidden" name="role" value="${role}">
              <input type="hidden" name="status" value="${status}">
              <input type="hidden" name="pageSize" value="${pageSize}">
              <input type="hidden" name="page" value="${pNum}">
              <button type="submit" class="${pNum == page ? 'active' : ''}">${pNum}</button>
            </form>
          </c:forEach>

          <form method="get" action="${pageContext.request.contextPath}/admin/users" style="display:inline">
            <input type="hidden" name="q" value="${q}">
            <input type="hidden" name="role" value="${role}">
            <input type="hidden" name="status" value="${status}">
            <input type="hidden" name="pageSize" value="${pageSize}">
            <input type="hidden" name="page" value="${page + 1}">
            <button type="submit" ${page >= totalPages ? 'disabled' : ''}>Next <i class="fa-solid fa-chevron-right"></i></button>
          </form>
        </div>
      </div>
    </section>
  </main>
</div>
</body>
</html>
