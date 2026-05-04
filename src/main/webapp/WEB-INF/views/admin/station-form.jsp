<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>${empty station.stationId ? 'Add New Station' : 'Edit Station'}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="admin-dashboard-page">
<div class="admin-shell">
    <jsp:include page="../common/admin-sidebar.jsp"/>

    <main class="admin-content">
        <section class="admin-topbar">
            <div class="admin-breadcrumb">
                <strong>${empty station.stationId ? 'Add New Station' : 'Edit Station'}</strong>
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

        <section class="admin-station-form-head">
            <div>
                <h1>${empty station.stationId ? 'Add New Station' : 'Edit Station Details'}</h1>
                <p>${empty station.stationId ? 'Register a new EV charging location to the ChargeHub Nepal network.' : 'Update EV charging station information and operating configuration.'}</p>
            </div>
            <div class="admin-station-form-head-actions">
                <a class="admin-outline-btn" href="${pageContext.request.contextPath}/admin/stations">Cancel</a>
                <button form="stationForm" type="submit" class="admin-primary-btn"><i class="fa-regular fa-floppy-disk"></i>${empty station.stationId ? 'Save Station' : 'Update Station'}</button>
            </div>
        </section>

        <section class="admin-station-form-layout">
            <form id="stationForm" method="post" action="${pageContext.request.contextPath}/admin" class="admin-station-form-card">
                <input type="hidden" name="action" value="saveStation">
                <input type="hidden" name="stationId" value="${station.stationId}">

                <section class="station-form-section">
                    <h2><i class="fa-solid fa-location-dot"></i> General Information</h2>
                    <div class="station-form-grid">
                        <div>
                            <label>Station Name *</label>
                            <input class="station-input" required name="stationName" id="stationNameInput" value="${station.stationName}" placeholder="Enter station name">
                        </div>
                        <div>
                            <label>District *</label>
                            <select class="station-input" required name="districtId">
                                <option value="" disabled ${empty station.stationId ? 'selected' : ''}>Select district</option>
                                <c:forEach var="d" items="${districts}">
                                    <option value="${d.districtId}" ${station.districtId == d.districtId ? 'selected' : ''}>${d.districtName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="full">
                            <label>Address *</label>
                            <input class="station-input" required name="address" value="${station.address}" placeholder="e.g. Ward No. 4, Opposite Civil Bank, Durbar Marg">
                        </div>

                        <div>
                            <label>Station Manager *</label>
                            <select class="station-input" required name="managerId">
                                <option value="" disabled ${empty station.managerId ? 'selected' : ''}>Assign a Manager</option>
                                <c:forEach var="m" items="${managers}">
                                    <option value="${m.userId}" ${station.managerId == m.userId ? 'selected' : ''}>${m.fullName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div>
                            <label>Contact Number *</label>
                            <input class="station-input" required name="contactNumber" value="${station.contactNumber}" placeholder="+977-98XXXXXXXX">
                        </div>
                    </div>
                </section>

                <section class="station-form-section">
                    <h2><i class="fa-solid fa-microchip"></i> Technical Specifications</h2>
                    <div class="station-form-grid">
                        <div>
                            <label>Charger Type *</label>
                            <select class="station-input" required name="chargerType">
                                <option value="CCS2 (DC Fast Charge)" ${station.chargerType == 'CCS2 (DC Fast Charge)' ? 'selected' : ''}>CCS2 (DC Fast Charge)</option>
                                <option value="Fast Charger" ${station.chargerType == 'Fast Charger' ? 'selected' : ''}>Fast Charger</option>
                                <option value="DC Charger" ${station.chargerType == 'DC Charger' ? 'selected' : ''}>DC Charger</option>
                                <option value="AC Charger" ${station.chargerType == 'AC Charger' ? 'selected' : ''}>AC Charger</option>
                                <option value="Hybrid" ${station.chargerType == 'Hybrid' ? 'selected' : ''}>Hybrid</option>
                            </select>
                        </div>
                        <div>
                            <label>Total Ports *</label>
                            <input class="station-input" required min="1" type="number" name="totalPorts" value="${empty station.totalPorts ? '' : station.totalPorts}" placeholder="e.g. 4">
                        </div>
                        <div>
                            <label>Price per Hour (NPR) *</label>
                            <input class="station-input" required type="number" min="0" step="0.01" name="pricePerHour" value="${station.pricePerHour}" placeholder="e.g. 150">
                        </div>
                        <div>
                            <label>Status *</label>
                            <select class="station-input" required name="status" id="statusInput">
                                <option value="active" ${station.status == 'active' ? 'selected' : ''}>Active / Online</option>
                                <option value="maintenance" ${station.status == 'maintenance' ? 'selected' : ''}>Maintenance</option>
                                <option value="offline" ${station.status == 'offline' ? 'selected' : ''}>Offline</option>
                            </select>
                        </div>
                    </div>
                </section>

                <section class="station-form-section">
                    <h2><i class="fa-regular fa-clock"></i> Operational Schedule</h2>
                    <div class="station-form-grid">
                        <div>
                            <label>Opening Time *</label>
                            <input class="station-input" required type="time" name="openingTime" value="${station.openingTime}">
                        </div>
                        <div>
                            <label>Closing Time *</label>
                            <input class="station-input" required type="time" name="closingTime" value="${station.closingTime}">
                        </div>
                    </div>
                </section>

                <footer class="station-edit-actions admin-station-form-footer">
                    <span>Note: New stations are created with provided status and manager assignment.</span>
                    <div>
                        <a class="admin-outline-btn" href="${pageContext.request.contextPath}/admin/stations">Discard Changes</a>
                        <button class="admin-primary-btn" type="submit">${empty station.stationId ? 'Complete Setup' : 'Save Changes'}</button>
                    </div>
                </footer>
            </form>

            <aside class="admin-station-form-side">
                <article class="admin-side-card admin-station-checklist">
                    <h4><i class="fa-regular fa-circle-check"></i> Setup Checklist</h4>
                    <p>Ensure all details are verified before publishing to public map.</p>
                    <ul>
                        <li><span>1</span> Station must have at least one verified manager assigned.</li>
                        <li><span>2</span> Pricing must follow latest NEA directives.</li>
                        <li><span>3</span> Coordinates will be auto-detected from full address after save.</li>
                    </ul>
                </article>

                <article class="admin-side-card admin-station-help">
                    <i class="fa-solid fa-circle-info"></i>
                    <h4>Need help?</h4>
                    <p>Detailed documentation for station networking and hardware configuration is available in the help center.</p>
                    <a href="${pageContext.request.contextPath}/admin/reports">View Configuration Guide</a>
                </article>

                <article class="admin-side-card admin-station-preview">
                    <label>Live Preview Status</label>
                    <div class="preview-row">
                        <span class="bolt"><i class="fa-solid fa-bolt"></i></span>
                        <div>
                            <strong id="previewStationName">${empty station.stationName ? 'Draft Station' : station.stationName}</strong>
                            <small id="previewStationState">${empty station.status ? 'Pending Approval' : station.status}</small>
                        </div>
                    </div>
                </article>
            </aside>
        </section>
    </main>
</div>

<script>
    (function () {
        var nameInput = document.getElementById("stationNameInput");
        var statusInput = document.getElementById("statusInput");
        var previewName = document.getElementById("previewStationName");
        var previewState = document.getElementById("previewStationState");
        if (!nameInput || !statusInput || !previewName || !previewState) return;

        function syncPreview() {
            previewName.textContent = nameInput.value.trim() || "Draft Station";
            previewState.textContent = statusInput.options[statusInput.selectedIndex].text;
        }
        nameInput.addEventListener("input", syncPreview);
        statusInput.addEventListener("change", syncPreview);
        syncPreview();
    })();
</script>
</body>
</html>
