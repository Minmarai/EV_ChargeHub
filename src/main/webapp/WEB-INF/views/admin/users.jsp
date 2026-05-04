<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>User Management</title>
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
        <div class="admin-users-search-wrap">
          <i class="fa-solid fa-magnifying-glass"></i>
          <input type="text" name="q" value="${q}" placeholder="Search by name, email, or user ID...">
        </div>
        <div class="admin-users-filter-select">
          <i class="fa-solid fa-filter"></i>
          <select name="role">
            <option value="">Filter: Role</option>
            <option value="user" ${role == 'user' ? 'selected' : ''}>Customer</option>
            <option value="staff" ${role == 'staff' ? 'selected' : ''}>Staff</option>
            <option value="admin" ${role == 'admin' ? 'selected' : ''}>Admin</option>
          </select>
        </div>
        <div class="admin-users-filter-select">
          <i class="fa-solid fa-filter"></i>
          <select name="status">
            <option value="">Filter: Status</option>
            <option value="active" ${status == 'active' ? 'selected' : ''}>Active</option>
            <option value="pending" ${status == 'pending' ? 'selected' : ''}>Pending</option>
            <option value="suspended" ${status == 'suspended' ? 'selected' : ''}>Suspended</option>
            <option value="deactivated" ${status == 'deactivated' ? 'selected' : ''}>Deactivated</option>
          </select>
        </div>
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
              <span class="admin-user-role ${u.role == 'staff' ? 'staff' : (u.role == 'admin' ? 'admin' : 'customer')}">
                  ${u.role == 'staff' ? 'Staff' : (u.role == 'admin' ? 'Admin' : 'Customer')}
              </span>
            </td>
            <td>
              <span class="admin-user-status ${u.status eq 'Active' ? 'active' : (u.status eq 'Pending' ? 'pending' : 'suspended')}">${u.status}</span>
            </td>
            <td>
              <div class="admin-user-actions">
                <form method="post">
                  <input type="hidden" name="action" value="userStatus">
                  <input type="hidden" name="userId" value="${u.userId}">
                  <input type="hidden" name="status" value="Active">
                  <button type="submit" class="icon-btn approve" title="Approve"><i class="fa-solid fa-check"></i></button>
                </form>
                <form method="post">
                  <input type="hidden" name="action" value="userStatus">
                  <input type="hidden" name="userId" value="${u.userId}">
                  <input type="hidden" name="status" value="Deactivated">
                  <button type="submit" class="icon-btn deactivate" title="Deactivate"><i class="fa-solid fa-ban"></i></button>
                </form>
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
        <span>Showing 1-${usersCount} of ${usersCount} users</span>
        <div class="admin-users-pager">
          <button type="button" disabled><i class="fa-solid fa-chevron-left"></i> Prev</button>
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
