<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Manage Slots</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="admin-dashboard-page">
<div class="admin-shell">
  <jsp:include page="../common/admin-sidebar.jsp"/>

  <main class="admin-content">
    <section class="admin-topbar">
      <div class="admin-breadcrumb">
        <strong>Manage Slots</strong>
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

    <section class="admin-slots-head">
      <div>
        <h1>Manage Slots</h1>
        <p>Monitor and control individual charging port status across all stations.</p>
      </div>
      <a class="admin-primary-btn black" href="${pageContext.request.contextPath}/admin/slot-form">
        <i class="fa-solid fa-plus"></i> Add New Slot
      </a>
    </section>

    <section class="admin-slots-filters-card">
      <form method="get" action="${pageContext.request.contextPath}/admin/slots" class="admin-slots-filters">
        <div class="admin-users-search-wrap">
          <i class="fa-solid fa-magnifying-glass"></i>
          <input type="text" name="q" value="${q}" placeholder="Filter by Slot ID or Port...">
        </div>
        <div class="admin-users-filter-select">
          <select name="stationId">
            <option value="">All Stations</option>
            <c:forEach var="st" items="${stations}">
              <option value="${st.stationId}" ${stationId == st.stationId ? 'selected' : ''}>${st.stationName}</option>
            </c:forEach>
          </select>
        </div>
        <div class="admin-users-filter-select">
          <select name="status">
            <option value="">All Statuses</option>
            <option value="available" ${status == 'available' ? 'selected' : ''}>Available</option>
            <option value="booked" ${status == 'booked' ? 'selected' : ''}>Occupied</option>
            <option value="maintenance" ${status == 'maintenance' ? 'selected' : ''}>Maintenance</option>
            <option value="offline" ${(status == 'offline' || status == 'inactive') ? 'selected' : ''}>Offline</option>
          </select>
        </div>
        <label class="admin-slots-date-wrap">
          <i class="fa-regular fa-calendar"></i>
          <input type="date" name="slotDate" value="${slotDate}">
        </label>
        <button class="admin-outline-btn" type="submit"><i class="fa-solid fa-filter"></i> Apply</button>
        <a class="admin-outline-btn" href="${pageContext.request.contextPath}/admin/slots"><i class="fa-solid fa-rotate-left"></i> Reset</a>
      </form>
    </section>

    <section class="admin-slots-batch-row">
      <form method="post" class="admin-slots-batch-form" id="slotBatchForm">
        <input type="hidden" name="action" value="batchSlotStatus">
        <span>BATCH OPERATIONS:</span>
        <label class="batch-operation-select-wrap">
          <i class="fa-solid fa-list-check"></i>
          <select id="batchStatusSelect" name="status" disabled required>
            <option value="">Choose operation</option>
            <option value="available">Set Available</option>
            <option value="maintenance">Set Maintenance</option>
            <option value="offline">Set Offline</option>
          </select>
        </label>
        <button class="batch-save-btn" type="submit" id="batchSaveBtn" disabled>
          <i class="fa-solid fa-floppy-disk"></i> Save Status
        </button>
      </form>
      <strong id="slotCountText">Showing ${slotsCount} slots</strong>
    </section>

    <section class="admin-slots-table-card">
      <table class="admin-users-table admin-slots-table">
        <thead>
        <tr>
          <th><input type="checkbox" id="slotsSelectAll"></th>
          <th>Slot ID</th>
          <th>Station Name</th>
          <th>Port #</th>
          <th>Charger Type</th>
          <th>Status</th>
          <th>Last Used</th>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="s" items="${slots}">
          <tr>
            <td><input type="checkbox" class="slot-row-check" value="${s.slotId}"></td>
            <td><strong>SLT-${s.slotId}</strong></td>
            <td>${s.stationName}</td>
            <td><span class="port-pill">P-${s.slotId % 10 + 1 < 10 ? '0' : ''}${s.slotId % 10 + 1}</span></td>
            <td><span class="dot"></span> ${s.stationId % 2 == 0 ? 'CCS2' : (s.stationId % 3 == 0 ? 'GB/T' : 'Type 2')}</td>
            <td>
              <span class="slot-status-badge ${s.availabilityStatus}">
                <c:choose>
                  <c:when test="${s.availabilityStatus == 'booked'}">Occupied</c:when>
                  <c:when test="${s.availabilityStatus == 'inactive'}">Offline</c:when>
                  <c:otherwise>${s.availabilityStatus}</c:otherwise>
                </c:choose>
              </span>
            </td>
            <td>${s.availabilityStatus == 'booked' ? 'Current' : '1 hour ago'}</td>
            <td>
              <div class="admin-slot-actions">
                <a class="icon-btn edit" href="${pageContext.request.contextPath}/admin/slot-form?id=${s.slotId}" title="Edit"><i class="fa-regular fa-pen-to-square"></i></a>
                <form method="post">
                  <input type="hidden" name="action" value="slotStatus">
                  <input type="hidden" name="slotId" value="${s.slotId}">
                  <input type="hidden" name="status" value="${s.availabilityStatus == 'inactive' ? 'available' : 'offline'}">
                  <button class="icon-btn" title="Toggle Status"><i class="fa-solid fa-power-off"></i></button>
                </form>
                <form method="post" onsubmit="return confirm('Delete this slot?');">
                  <input type="hidden" name="action" value="deleteSlot">
                  <input type="hidden" name="slotId" value="${s.slotId}">
                  <button class="icon-btn delete" title="Delete"><i class="fa-regular fa-trash-can"></i></button>
                </form>
              </div>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty slots}">
          <tr><td colspan="8" class="empty-row">No slots matched your filters.</td></tr>
        </c:if>
        </tbody>
      </table>
      <div class="admin-users-footer">
        <span>Page 1 of 1</span>
        <div class="admin-users-pager">
          <button type="button" disabled><i class="fa-solid fa-chevron-left"></i> Previous</button>
          <button type="button" class="active">1</button>
          <button type="button">Next <i class="fa-solid fa-chevron-right"></i></button>
        </div>
      </div>
    </section>

    <section class="admin-slots-bottom-stats">
      <article class="healthy">
        <label>Healthy Ports</label>
        <h3>${slotsCount > 0 ? (availableCount * 100 / slotsCount) : 0}%</h3>
        <small>+2.1% from last month</small>
      </article>
      <article class="peak">
        <label>Peak Usage Time</label>
        <h3>06:00 PM - 09:00 PM</h3>
        <small>Based on weekly avg</small>
      </article>
      <article class="repair">
        <label>Avg Repair Time</label>
        <h3>${maintenanceCount > 0 ? '4.2 Hours' : '3.1 Hours'}</h3>
        <small>SLA target: 6.0 Hours</small>
      </article>
    </section>
  </main>
</div>
<script>
  (function () {
    const selectAll = document.getElementById('slotsSelectAll');
    const rowChecks = Array.from(document.querySelectorAll('.slot-row-check'));
    const batchForm = document.getElementById('slotBatchForm');
    const batchSaveBtn = document.getElementById('batchSaveBtn');
    const batchStatusSelect = document.getElementById('batchStatusSelect');
    const countText = document.getElementById('slotCountText');

    function selectedChecks() {
      return rowChecks.filter(c => c.checked);
    }

    function syncUI() {
      const selected = selectedChecks();
      const selectedCount = selected.length;
      if (selectAll) {
        selectAll.checked = rowChecks.length > 0 && selectedCount === rowChecks.length;
        selectAll.indeterminate = selectedCount > 0 && selectedCount < rowChecks.length;
      }
      batchStatusSelect.disabled = selectedCount === 0;
      batchSaveBtn.disabled = selectedCount === 0 || !batchStatusSelect.value;
      countText.textContent = selectedCount > 0
              ? ('Showing ' + selectedCount + ' selected slots')
              : ('Showing ${slotsCount} slots');
    }

    if (selectAll) {
      selectAll.addEventListener('change', function () {
        rowChecks.forEach(c => { c.checked = selectAll.checked; });
        syncUI();
      });
    }

    rowChecks.forEach(c => c.addEventListener('change', syncUI));
    batchStatusSelect.addEventListener('change', syncUI);

    batchForm.addEventListener('submit', function (e) {
      Array.from(batchForm.querySelectorAll('input[name="slotIds"]')).forEach(node => node.remove());
      const selected = selectedChecks();
      if (selected.length === 0) {
        e.preventDefault();
        alert('Please select at least one slot.');
        return;
      }
      if (!batchStatusSelect.value) {
        e.preventDefault();
        alert('Please choose a batch operation.');
        return;
      }
      selected.forEach(c => {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'slotIds';
        input.value = c.value;
        batchForm.appendChild(input);
      });
    });

    syncUI();
  })();
</script>
</body>
</html>
