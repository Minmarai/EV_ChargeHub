<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Minma Rai IIC --%>
<html>
<head>
    <title>Edit User Profile</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="admin-dashboard-page">
<div class="admin-shell">
    <jsp:include page="../common/admin-sidebar.jsp"/>
    <c:set var="resolvedUserId" value="${not empty user.userId ? user.userId : param.id}"/>

    <main class="admin-content">
        <section class="admin-topbar">
            <div class="admin-breadcrumb">
                <strong>Edit User Profile</strong>
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

        <section class="admin-edit-user-head">
            <div class="admin-edit-user-title">
                <a class="admin-back-btn" href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-arrow-left"></i></a>
                <div>
                    <h1>Edit User #CH-${empty resolvedUserId ? '--' : resolvedUserId}</h1>
                    <p>Modify user credentials and account permissions.</p>
                </div>
            </div>
            <div class="admin-edit-user-actions">
                <button type="reset" form="editUserForm" class="admin-outline-btn"><i class="fa-solid fa-rotate-left"></i>Reset Fields</button>
                <button type="submit" form="editUserForm" class="admin-primary-btn"><i class="fa-regular fa-floppy-disk"></i>Update Profile</button>
            </div>
        </section>

        <section class="admin-edit-user-grid">
            <form id="editUserForm" class="admin-edit-user-main-card" method="post" action="${pageContext.request.contextPath}/admin">
                <input type="hidden" name="action" value="saveUser">
                <input type="hidden" name="userId" value="${resolvedUserId}">
                <input type="hidden" name="vehicleNumber" value="${user.vehicleNumber}">
                <h2>Account Information</h2>
                <p>Essential details for identifying the user and contacting them.</p>

                <div class="admin-edit-user-section">
                    <h3>Personal Details</h3>
                    <div class="admin-edit-user-two-col">
                        <label>
                            Full Name
                            <span class="admin-edit-input"><i class="fa-regular fa-user"></i><input name="fullName" value="${user.fullName}" required></span>
                        </label>
                        <label>
                            Email Address
                            <span class="admin-edit-input"><i class="fa-regular fa-envelope"></i><input type="email" name="email" value="${user.email}" required></span>
                        </label>
                    </div>
                    <div class="admin-edit-user-two-col">
                        <label>
                            Phone Number
                            <span class="admin-edit-input"><i class="fa-solid fa-phone"></i><input name="phone" value="${user.phone}" required></span>
                        </label>
                        <span></span>
                    </div>
                </div>

                <div class="admin-edit-user-section">
                    <h3>Access &amp; Security</h3>
                    <div class="admin-edit-user-two-col">
                        <label>
                            Account Role
                            <span class="admin-edit-input no-icon admin-user-role-field">
                <select name="role">
                  <option value="user" ${user.role == 'user' ? 'selected' : ''}>Customer</option>
                  <option value="staff" ${user.role == 'staff' ? 'selected' : ''}>Staff</option>
                  <option value="admin" ${user.role == 'admin' ? 'selected' : ''}>Admin</option>
                  <option value="station_manager" ${user.role == 'station_manager' ? 'selected' : ''}>Station Manager</option>
                </select>
              </span>
                        </label>
                        <label class="admin-status-toggle-card">
                            <span class="top">Account Status</span>
                            <span class="sub">Toggle to enable or disable system access.</span>
                            <span class="inline">
                <strong id="statusLabel">${user.status}</strong>
                <span class="admin-switch">
                  <input id="statusSwitch" type="checkbox" ${user.status == 'Active' ? 'checked' : ''}>
                  <span></span>
                </span>
              </span>
                            <input id="statusInput" type="hidden" name="status" value="${empty user.status ? 'Pending' : user.status}">
                        </label>
                    </div>
                </div>

                <div class="admin-edit-user-section">
                    <h3>Location Information</h3>
                    <label>
                        Full Address
                        <span class="admin-edit-input no-icon admin-user-address-field"><textarea name="address" rows="3" required>${user.address}</textarea></span>
                    </label>
                </div>
            </form>

            <aside class="admin-edit-user-side">
                <article class="admin-profile-card">
                    <div class="cover"></div>
                    <div class="avatar-wrap">
                        <span class="avatar">${fn:substring(user.fullName, 0, 1)}</span>
                        <i class="online"></i>
                    </div>
                    <h3>${user.fullName}</h3>
                    <p>${user.email}</p>
                    <div class="chips">
                        <span class="role">${user.role == 'user' ? 'customer' : user.role}</span>
                        <span class="id">ID: CH-${empty resolvedUserId ? '--' : resolvedUserId}</span>
                    </div>
                </article>
            </aside>
        </section>
    </main>
</div>

<script>
    (function () {
        var sw = document.getElementById("statusSwitch");
        var input = document.getElementById("statusInput");
        var label = document.getElementById("statusLabel");
        if (!sw || !input || !label) return;
        function syncStatus() {
            var value = sw.checked ? "Active" : "Deactivated";
            input.value = value;
            label.textContent = value.toUpperCase();
        }
        sw.addEventListener("change", syncStatus);
        if (!input.value) syncStatus();
        else label.textContent = input.value.toUpperCase();
    })();
</script>
</body>
</html>
