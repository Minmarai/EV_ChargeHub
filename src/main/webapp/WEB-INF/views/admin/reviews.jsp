<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>${empty slot.slotId ? 'Add Slot' : 'Edit Slot'}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="admin-dashboard-page admin-slot-form-page">
<div class="admin-shell">
    <jsp:include page="../common/admin-sidebar.jsp"/>
    <main class="admin-content">
        <section class="admin-topbar">
            <div class="admin-breadcrumb">
                <strong>${empty slot.slotId ? 'Add New Slot' : 'Edit Slot'}</strong>
                <i class="fa-solid fa-chevron-right"></i>
                <span>ChargeHub Nepal Admin Portal</span>
            </div>
        </section>

        <section class="admin-slots-head">
            <div>
                <h1>${empty slot.slotId ? 'Add New Slot' : 'Edit Slot'}</h1>
                <p>${empty slot.slotId ? 'Create a charging slot for a station.' : 'Update this charging slot schedule and status.'}</p>
            </div>
        </section>

        <section class="admin-station-form-layout admin-slot-form-layout-single">
            <form method="post" class="admin-station-form-card admin-slot-form-card-centered">
                <input type="hidden" name="action" value="saveSlot">
                <input type="hidden" name="slotId" value="${slot.slotId}">
                <section class="station-form-section">
                    <h2><i class="fa-regular fa-calendar"></i> Slot Details</h2>
                    <div class="station-form-grid">
                        <div>
                            <label>Station *</label>
                            <select class="station-input" name="stationId" id="slotStationId" required>
                                <option value="" disabled ${empty slot.stationId ? 'selected' : ''}>Select Station</option>
                                <c:forEach var="st" items="${stations}">
                                    <option value="${st.stationId}" data-charger-type="${st.chargerType}" ${slot.stationId == st.stationId ? 'selected' : ''}>${st.stationName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div>
                            <label>Status *</label>
                            <select class="station-input" name="availabilityStatus" required>
                                <option value="available" ${slot.availabilityStatus == 'available' ? 'selected' : ''}>Available</option>
                                <option value="booked" ${slot.availabilityStatus == 'booked' ? 'selected' : ''}>Occupied</option>
                                <option value="maintenance" ${slot.availabilityStatus == 'maintenance' ? 'selected' : ''}>Maintenance</option>
                                <option value="offline" ${slot.availabilityStatus == 'offline' ? 'selected' : ''}>Offline</option>
                            </select>
                        </div>
                        <div>
                            <label>Slot Date *</label>
                            <input class="station-input" type="date" name="slotDate" value="${slot.slotDate}" required>
                        </div>
                        <div>
                            <label>Start Time *</label>
                            <input class="station-input" type="time" name="startTime" value="${slot.startTime}" required>
                        </div>
                        <div>
                            <label>End Time *</label>
                            <input class="station-input" type="time" name="endTime" value="${slot.endTime}" required>
                        </div>
                        <div>
                            <label>Charger Type *</label>
                            <select class="station-input" name="chargerType" id="slotChargerType" required>
                                <option value="" disabled>Select Charger Type</option>
                                <option value="CCS2">CCS2</option>
                                <option value="DC Fast">DC Fast</option>
                                <option value="Type 2">Type 2</option>
                                <option value="GB/T">GB/T</option>
                            </select>
                        </div>
                    </div>
                </section>

                <footer class="admin-station-form-footer">
                    <a href="${pageContext.request.contextPath}/admin/slots" class="admin-outline-btn">Cancel</a>
                    <button type="submit" class="admin-primary-btn">${empty slot.slotId ? 'Save Slot' : 'Update Slot'}</button>
                </footer>
            </form>
        </section>
    </main>
</div>
<script>
    (function () {
        const stationSelect = document.getElementById('slotStationId');
        const chargerSelect = document.getElementById('slotChargerType');
        if (!stationSelect || !chargerSelect) return;

        function syncChargerFromStation() {
            const selectedOpt = stationSelect.options[stationSelect.selectedIndex];
            if (!selectedOpt) return;
            const t = selectedOpt.getAttribute('data-charger-type');
            if (!t) return;
            const match = Array.from(chargerSelect.options).find(o => o.value === t);
            if (match) chargerSelect.value = t;
        }

        stationSelect.addEventListener('change', syncChargerFromStation);
        syncChargerFromStation();
    })();
</script>
</body>
</html>
