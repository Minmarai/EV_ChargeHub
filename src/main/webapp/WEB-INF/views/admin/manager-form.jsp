<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Minma Rai --%>
<html>
<head>
  <title>Configure Manager</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="admin-dashboard-page">
<div class="admin-shell">
  <jsp:include page="../common/admin-sidebar.jsp"/>

  <main class="admin-content">
    <section class="admin-topbar">
      <div class="admin-breadcrumb">
        <strong>Configure Manager</strong>
        <i class="fa-solid fa-chevron-right"></i>
        <span>ChargeHub Nepal Admin module</span>
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

    <section class="admin-manager-form-wrap">
      <form id="managerForm" method="post" action="${pageContext.request.contextPath}/admin" class="admin-manager-form-card">
        <input type="hidden" name="action" value="saveManager">
        <input type="hidden" name="userId" value="${user.userId}">
        <input type="hidden" name="stationId" value="${param.stationId}">
        <input type="hidden" name="vehicleNumber" value="${user.vehicleNumber}">

        <header class="admin-manager-form-header">
          <h1>Station Manager Profile</h1>
          <p>Enter details to create or update a manager account</p>
        </header>

        <section class="admin-manager-section">
          <h2>Personal Information</h2>
          <p>Primary identity and contact details for the manager.</p>
          <div class="admin-edit-user-two-col">
            <label>
              Full Name
              <span class="admin-edit-input"><i class="fa-regular fa-user"></i><input required name="fullName" value="${user.fullName}"></span>
            </label>
            <label>
              Contact Email
              <span class="admin-edit-input"><i class="fa-regular fa-envelope"></i><input type="email" required name="email" value="${user.email}"></span>
            </label>
          </div>
          <div class="admin-edit-user-two-col">
            <label>
              Contact Phone
              <span class="admin-edit-input"><i class="fa-solid fa-phone"></i><input required name="phone" value="${user.phone}"></span>
            </label>
            <span></span>
          </div>
        </section>

        <section class="admin-manager-section">
          <h2>Account Security</h2>
          <p>Credentials for system access and administrative privileges.</p>
          <label>
            Login Password
            <span class="admin-edit-input"><i class="fa-solid fa-shield-halved"></i><input type="password" name="password" placeholder="${empty user.userId ? 'Enter password' : 'Leave blank to keep current password'}"></span>
          </label>
          <small class="hint"><i class="fa-regular fa-circle-info"></i> Password should be strong and updated regularly.</small>
        </section>

        <section class="admin-manager-section">
          <h2>Assignment &amp; Visibility</h2>
          <p>Manage geographical assignment and account status.</p>
          <label>
            Physical Address
            <span class="admin-edit-input admin-manager-address-field no-icon"><textarea name="address" rows="3" required>${user.address}</textarea></span>
          </label>
          <label class="admin-status-toggle-card">
            <span class="top">Active Account Status</span>
            <span class="sub">When disabled, the manager cannot log in to the dashboard.</span>
            <span class="inline">
              <strong id="managerStatusLabel">${empty user.status ? 'PENDING' : fn:toUpperCase(user.status)}</strong>
              <span class="admin-switch">
                <input id="managerStatusSwitch" type="checkbox" ${user.status == 'Active' ? 'checked' : ''}>
                <span></span>
              </span>
            </span>
            <input id="managerStatusInput" type="hidden" name="status" value="${empty user.status ? 'Pending' : user.status}">
          </label>
        </section>

        <footer class="admin-manager-footer">
          <a href="${pageContext.request.contextPath}/admin/managers" class="admin-outline-btn"><i class="fa-solid fa-xmark"></i>Discard Changes</a>
          <button type="reset" class="admin-outline-btn">Reset Form</button>
          <button type="submit" class="admin-primary-btn"><i class="fa-regular fa-floppy-disk"></i>${empty user.userId ? 'Save Manager Profile' : 'Update Manager Profile'}</button>
        </footer>
      </form>

      <aside class="admin-manager-side">
        <article class="admin-side-card audit">
          <h4><i class="fa-solid fa-shield-halved"></i> Security Audit</h4>
          <ul>
            <li><i class="fa-regular fa-circle-check"></i> Full Name verified</li>
            <li><i class="fa-regular fa-circle-check"></i> Email format correct</li>
            <li><i class="fa-regular fa-circle-check"></i> Password strength (High)</li>
            <li><i class="fa-regular fa-circle-check"></i> Address details provided</li>
            <li><i class="fa-regular fa-circle-check"></i> Role assignment confirmed</li>
          </ul>
        </article>

        <article class="admin-side-card">
          <h4>Need Help?</h4>
          <p>If you're having trouble configuring this manager, please check the internal guide or contact support.</p>
          <a href="${pageContext.request.contextPath}/admin/reports">View Access Logs</a>
        </article>
      </aside>
    </section>
  </main>
</div>

<script>
  (function () {
    var sw = document.getElementById("managerStatusSwitch");
    var input = document.getElementById("managerStatusInput");
    var label = document.getElementById("managerStatusLabel");
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
