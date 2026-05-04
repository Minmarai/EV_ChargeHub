package com.chargehub.controller;

import com.chargehub.dao.BookingDAO;
import com.chargehub.dao.ContactDAO;
import com.chargehub.dao.DistrictDAO;
import com.chargehub.dao.PaymentDAO;
import com.chargehub.dao.ReviewDAO;
import com.chargehub.dao.SlotDAO;
import com.chargehub.dao.StationDAO;
import com.chargehub.dao.UserDAO;
import com.chargehub.model.Booking;
import com.chargehub.model.Payment;
import com.chargehub.model.Slot;
import com.chargehub.model.Station;
import com.chargehub.model.User;
import com.chargehub.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Time;
import java.time.YearMonth;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
    protected void doGet(HttpServletRequest r, HttpServletResponse resp) throws ServletException, IOException {
        String p = r.getPathInfo();
        if (p == null) p = "/dashboard";

        UserDAO ud = new UserDAO();
        StationDAO sd = new StationDAO();

        switch (p) {
            case "/dashboard":
                r.setAttribute("userCount", ud.countByRole("user"));
                r.setAttribute("managerCount", ud.countByRole("station_manager"));
                r.setAttribute("stationCount", sd.count());
                r.setAttribute("bookingCount", new BookingDAO().count());
                r.setAttribute("totalPaid", new PaymentDAO().totalPaid());

                List<Map<String, Object>> rv = new ReviewDAO().findAll();
                int pendingReviews = 0;
                for (Map<String, Object> row : rv) {
                    Object s = row.get("status");
                    if (s != null && "hidden".equalsIgnoreCase(String.valueOf(s))) pendingReviews++;
                }

                List<Map<String, Object>> msgs = new ContactDAO().findAll();
                int pendingMessages = 0;
                for (Map<String, Object> row : msgs) {
                    Object s = row.get("status");
                    if (s != null && "unread".equalsIgnoreCase(String.valueOf(s))) pendingMessages++;
                }
                r.setAttribute("pendingReviews", pendingReviews);
                r.setAttribute("pendingMessages", pendingMessages);

                List<Payment> allPayments = new PaymentDAO().findAll();
                List<Booking> allBookings = new BookingDAO().findAll();
                r.setAttribute("paymentCount", allPayments.size());

                List<String> chartLabels = new ArrayList<>();
                List<BigDecimal> chartRevenue = new ArrayList<>();
                List<BigDecimal> chartTarget = new ArrayList<>();

                YearMonth thisMonth = YearMonth.now();
                for (int i = 5; i >= 0; i--) {
                    YearMonth ym = thisMonth.minusMonths(i);
                    chartLabels.add(ym.getMonth().getDisplayName(TextStyle.SHORT, Locale.ENGLISH));

                    BigDecimal monthRevenue = BigDecimal.ZERO;
                    int monthBookings = 0;
                    for (Payment payment : allPayments) {
                        if (payment.getPaymentDate() != null) {
                            YearMonth pym = YearMonth.from(payment.getPaymentDate().toLocalDateTime());
                            if (ym.equals(pym) && payment.getAmount() != null) {
                                monthRevenue = monthRevenue.add(payment.getAmount());
                            }
                        }
                    }
                    for (Booking booking : allBookings) {
                        if (booking.getBookingDate() != null) {
                            YearMonth bym = YearMonth.from(booking.getBookingDate().toLocalDateTime());
                            if (ym.equals(bym)) monthBookings++;
                        }
                    }

                    BigDecimal target = monthRevenue.multiply(new BigDecimal("0.90"))
                            .add(new BigDecimal(monthBookings * 8L));
                    chartRevenue.add(monthRevenue);
                    chartTarget.add(target);
                }

                r.setAttribute("chartLabels", chartLabels);
                r.setAttribute("chartRevenue", chartRevenue);
                r.setAttribute("chartTarget", chartTarget);
                f(r, resp, "admin/dashboard.jsp");
                break;

            case "/users":
                String q = n(r.getParameter("q"));
                String role = n(r.getParameter("role"));
                String status = n(r.getParameter("status"));
                boolean reset = "1".equals(r.getParameter("reset"));
                if (reset) {
                    q = "";
                    role = "";
                    status = "";
                }

                List<User> filteredUsers = new ArrayList<>();
                for (User user : ud.findAll()) {
                    if ("station_manager".equalsIgnoreCase(user.getRole())) continue;
                    if (!role.isBlank() && !role.equalsIgnoreCase(v(user.getRole()))) continue;
                    if (!status.isBlank() && !status.equalsIgnoreCase(v(user.getStatus()))) continue;

                    if (!q.isBlank()) {
                        String key = q.toLowerCase(Locale.ENGLISH);
                        String row = (user.getUserId() + " " + v(user.getFullName()) + " " + v(user.getEmail()) + " " + v(user.getPhone()))
                                .toLowerCase(Locale.ENGLISH);
                        if (!row.contains(key)) continue;
                    }
                    filteredUsers.add(user);
                }

                r.setAttribute("q", q);
                r.setAttribute("role", role);
                r.setAttribute("status", status);
                r.setAttribute("usersCount", filteredUsers.size());
                r.setAttribute("users", filteredUsers);
                f(r, resp, "admin/users.jsp");
                break;
            case "/managers":
                String mq = n(r.getParameter("q"));
                String mStatus = n(r.getParameter("status"));
                String mRegion = n(r.getParameter("region"));

                List<User> managers = ud.findByRole("station_manager");
                List<Station> allStations = sd.findAll();

                int activeManagers = 0;
                int inactiveManagers = 0;
                for (User m : managers) {
                    if ("active".equalsIgnoreCase(v(m.getStatus()))) activeManagers++;
                    else inactiveManagers++;
                }

                List<Map<String, Object>> managerRows = new ArrayList<>();
                for (User m : managers) {
                    Station assigned = null;
                    for (Station st : allStations) {
                        if (st.getManagerId() == m.getUserId()) {
                            assigned = st;
                            break;
                        }
                    }

                    String region = assigned == null ? "-" : v(assigned.getDistrictName());
                    String stationName = assigned == null ? "Not Assigned" : v(assigned.getStationName());

                    if (!mStatus.isBlank() && !mStatus.equalsIgnoreCase(v(m.getStatus()))) continue;
                    if (!mRegion.isBlank() && !mRegion.equalsIgnoreCase(region)) continue;

                    if (!mq.isBlank()) {
                        String key = mq.toLowerCase(Locale.ENGLISH);
                        String row = (m.getUserId() + " " + v(m.getFullName()) + " " + v(m.getEmail()) + " " + v(m.getPhone()) + " " + stationName + " " + region)
                                .toLowerCase(Locale.ENGLISH);
                        if (!row.contains(key)) continue;
                    }

                    Map<String, Object> row = new java.util.HashMap<>();
                    row.put("manager", m);
                    row.put("stationName", stationName);
                    row.put("region", region);
                    row.put("performance", String.format(Locale.ENGLISH, "%.1f", 3.5 + ((m.getUserId() % 16) / 10.0)));
                    managerRows.add(row);
                }

                List<String> regions = new ArrayList<>();
                for (Station st : allStations) {
                    String d = v(st.getDistrictName());
                    if (!d.isBlank() && !regions.contains(d)) regions.add(d);
                }

                r.setAttribute("q", mq);
                r.setAttribute("status", mStatus);
                r.setAttribute("region", mRegion);
                r.setAttribute("regions", regions);
                r.setAttribute("managersCount", managers.size());
                r.setAttribute("activeManagers", activeManagers);
                r.setAttribute("inactiveManagers", inactiveManagers);
                r.setAttribute("managerRows", managerRows);
                f(r, resp, "admin/managers.jsp");
                break;
            case "/user-form":
                if (r.getParameter("id") != null) r.setAttribute("user", ud.findById(Integer.parseInt(r.getParameter("id"))));
                f(r, resp, "admin/user-form.jsp");
                break;
            case "/manager-form":
                if (r.getParameter("id") != null) r.setAttribute("user", ud.findById(Integer.parseInt(r.getParameter("id"))));
                f(r, resp, "admin/manager-form.jsp");
                break;
            case "/stations":
                String sq = n(r.getParameter("q"));
                String sDistrict = n(r.getParameter("district"));
                String sType = n(r.getParameter("type"));
                String sStatus = n(r.getParameter("status"));

                List<Station> allStationRows = sd.findAll();
                List<Station> filteredStations = new ArrayList<>();
                List<String> stationDistricts = new ArrayList<>();
                List<String> stationTypes = new ArrayList<>();

                for (Station st : allStationRows) {
                    String districtName = v(st.getDistrictName());
                    String chargerType = v(st.getChargerType());
                    if (!districtName.isBlank() && !stationDistricts.contains(districtName)) stationDistricts.add(districtName);
                    if (!chargerType.isBlank() && !stationTypes.contains(chargerType)) stationTypes.add(chargerType);

                    if (!sDistrict.isBlank() && !sDistrict.equalsIgnoreCase(districtName)) continue;
                    if (!sType.isBlank() && !sType.equalsIgnoreCase(chargerType)) continue;
                    if (!sStatus.isBlank() && !sStatus.equalsIgnoreCase(v(st.getStatus()))) continue;

                    if (!sq.isBlank()) {
                        String key = sq.toLowerCase(Locale.ENGLISH);
                        String row = (v(st.getStationName()) + " " + districtName + " " + v(st.getManagerName()) + " " + chargerType + " " + st.getStationId())
                                .toLowerCase(Locale.ENGLISH);
                        if (!row.contains(key)) continue;
                    }
                    filteredStations.add(st);
                }

                r.setAttribute("q", sq);
                r.setAttribute("district", sDistrict);
                r.setAttribute("type", sType);
                r.setAttribute("status", sStatus);
                r.setAttribute("districts", stationDistricts);
                r.setAttribute("types", stationTypes);
                r.setAttribute("stationsCount", filteredStations.size());
                r.setAttribute("stations", filteredStations);
                f(r, resp, "admin/stations.jsp");
                break;
            case "/station-form":
                r.setAttribute("districts", new DistrictDAO().findAll());
                r.setAttribute("managers", ud.findByRole("station_manager"));
                if (r.getParameter("id") != null) r.setAttribute("station", sd.findById(Integer.parseInt(r.getParameter("id"))));
                f(r, resp, "admin/station-form.jsp");
                break;
            case "/slots":
                String slotQ = n(r.getParameter("q"));
                String stationFilter = n(r.getParameter("stationId"));
                String statusFilter = n(r.getParameter("status"));
                String dateFilter = n(r.getParameter("slotDate"));
                String statusFilterDb = toDbSlotStatus(statusFilter);

                SlotDAO slotDAO = new SlotDAO();
                List<Slot> allSlots = slotDAO.findAll();
                List<Station> stations = sd.findAll();
                List<Slot> filteredSlots = new ArrayList<>();

                for (Slot slot : allSlots) {
                    if (!stationFilter.isBlank() && !stationFilter.equals(String.valueOf(slot.getStationId()))) continue;
                    if (!statusFilterDb.isBlank() && !statusFilterDb.equalsIgnoreCase(v(slot.getAvailabilityStatus()))) continue;
                    if (!dateFilter.isBlank() && slot.getSlotDate() != null && !dateFilter.equals(slot.getSlotDate().toString())) continue;
                    if (!dateFilter.isBlank() && slot.getSlotDate() == null) continue;

                    if (!slotQ.isBlank()) {
                        String key = slotQ.toLowerCase(Locale.ENGLISH);
                        String row = ("SLT-" + slot.getSlotId() + " " + v(slot.getStationName()) + " " + slot.getStationId())
                                .toLowerCase(Locale.ENGLISH);
                        if (!row.contains(key)) continue;
                    }
                    filteredSlots.add(slot);
                }

                long availableCount = filteredSlots.stream()
                        .filter(s -> "available".equalsIgnoreCase(v(s.getAvailabilityStatus())))
                        .count();
                long occupiedCount = filteredSlots.stream()
                        .filter(s -> "booked".equalsIgnoreCase(v(s.getAvailabilityStatus())) || "occupied".equalsIgnoreCase(v(s.getAvailabilityStatus())))
                        .count();
                long maintenanceCount = filteredSlots.stream()
                        .filter(s -> "maintenance".equalsIgnoreCase(v(s.getAvailabilityStatus())))
                        .count();

                r.setAttribute("q", slotQ);
                r.setAttribute("stationId", stationFilter);
                r.setAttribute("status", statusFilter);
                r.setAttribute("slotDate", dateFilter);
                r.setAttribute("stations", stations);
                r.setAttribute("slots", filteredSlots);
                r.setAttribute("slotsCount", filteredSlots.size());
                r.setAttribute("availableCount", availableCount);
                r.setAttribute("occupiedCount", occupiedCount);
                r.setAttribute("maintenanceCount", maintenanceCount);
                f(r, resp, "admin/slots.jsp");
                break;
            case "/slot-form":
                r.setAttribute("stations", sd.findAll());
                if (r.getParameter("id") != null && !r.getParameter("id").isBlank()) {
                    r.setAttribute("slot", new SlotDAO().findById(Integer.parseInt(r.getParameter("id"))));
                }
                f(r, resp, "admin/slot-form.jsp");
                break;
            case "/bookings":
                String bookingQ = n(r.getParameter("q"));
                String bookingStationFilter = n(r.getParameter("stationId"));
                String bookingManagerFilter = n(r.getParameter("managerId"));
                String bookingDateFilter = n(r.getParameter("bookingDate"));
                String bookingStatusFilter = n(r.getParameter("status"));

                List<Station> bookingStations = sd.findAll();
                List<User> allManagers = ud.findByRole("station_manager");
                List<Booking> bookingRecords = new BookingDAO().findAll();
                List<Booking> filteredBookings = new ArrayList<>();

                for (Booking booking : bookingRecords) {
                    if (!bookingStationFilter.isBlank() && !bookingStationFilter.equals(String.valueOf(booking.getStationId()))) continue;

                    if (!bookingManagerFilter.isBlank()) {
                        boolean managerMatches = false;
                        for (Station station : bookingStations) {
                            if (station.getStationId() == booking.getStationId()
                                    && bookingManagerFilter.equals(String.valueOf(station.getManagerId()))) {
                                managerMatches = true;
                                break;
                            }
                        }
                        if (!managerMatches) continue;
                    }

                    if (!bookingDateFilter.isBlank()) {
                        if (booking.getBookingDate() == null
                                || !bookingDateFilter.equals(booking.getBookingDate().toLocalDateTime().toLocalDate().toString())) {
                            continue;
                        }
                    }

                    if (!bookingStatusFilter.isBlank()
                            && !bookingStatusFilter.equalsIgnoreCase(v(booking.getBookingStatus()))) continue;

                    if (!bookingQ.isBlank()) {
                        String key = bookingQ.toLowerCase(Locale.ENGLISH);
                        String row = ("BK-" + booking.getBookingId() + " "
                                + v(booking.getUserName()) + " "
                                + v(booking.getStationName()) + " "
                                + v(booking.getVehicleNumber()) + " "
                                + v(booking.getSlotInfo()))
                                .toLowerCase(Locale.ENGLISH);
                        if (!row.contains(key)) continue;
                    }
                    filteredBookings.add(booking);
                }

                r.setAttribute("q", bookingQ);
                r.setAttribute("stationId", bookingStationFilter);
                r.setAttribute("managerId", bookingManagerFilter);
                r.setAttribute("bookingDate", bookingDateFilter);
                r.setAttribute("status", bookingStatusFilter);
                r.setAttribute("stations", bookingStations);
                r.setAttribute("managers", allManagers);
                r.setAttribute("bookings", filteredBookings);
                r.setAttribute("bookingsCount", filteredBookings.size());
                f(r, resp, "admin/bookings.jsp");
                break;
            case "/booking":
                r.setAttribute("booking", new BookingDAO().findById(Integer.parseInt(r.getParameter("id"))));
                f(r, resp, "admin/booking-details.jsp");
                break;
            case "/payments":
                r.setAttribute("payments", new PaymentDAO().findAll());
                f(r, resp, "admin/payments.jsp");
                break;
            case "/payment":
                r.setAttribute("payment", new PaymentDAO().findById(Integer.parseInt(r.getParameter("id"))));
                f(r, resp, "admin/payment-details.jsp");
                break;
            case "/reviews":
                r.setAttribute("reviews", new ReviewDAO().findAll());
                f(r, resp, "admin/reviews.jsp");
                break;
            case "/messages":
                r.setAttribute("messages", new ContactDAO().findAll());
                f(r, resp, "admin/messages.jsp");
                break;
            case "/reports":
                r.setAttribute("users", ud.findAll());
                r.setAttribute("stations", sd.findAll());
                r.setAttribute("bookings", new BookingDAO().findAll());
                r.setAttribute("payments", new PaymentDAO().findAll());
                f(r, resp, "admin/reports.jsp");
                break;
            default:
                resp.sendRedirect(r.getContextPath() + "/admin/dashboard");
        }
    }

    protected void doPost(HttpServletRequest r, HttpServletResponse resp) throws ServletException, IOException {
        String a = r.getParameter("action");
        if ("saveUser".equals(a) || "saveManager".equals(a)) {
            User u = new User();
            String id = r.getParameter("userId");
            String stationIdParam = n(r.getParameter("stationId"));
            if (id != null && !id.isBlank()) u.setUserId(Integer.parseInt(id));
            u.setFullName(r.getParameter("fullName"));
            u.setEmail(r.getParameter("email"));
            u.setPhone(r.getParameter("phone"));
            u.setVehicleNumber(r.getParameter("vehicleNumber"));
            u.setAddress(r.getParameter("address"));
            u.setRole("saveManager".equals(a) ? "station_manager" : r.getParameter("role"));
            u.setStatus(r.getParameter("status"));
            UserDAO dao = new UserDAO();
            if ("saveManager".equals(a) && !stationIdParam.isBlank()) {
                int stationId = Integer.parseInt(stationIdParam);
                String rawPassword = n(r.getParameter("password"));
                if (!rawPassword.isBlank()) {
                    u.setPasswordHash(PasswordUtil.hashPassword(rawPassword));
                } else {
                    User existing = u.getUserId() > 0 ? dao.findById(u.getUserId()) : null;
                    if (existing != null && existing.getPasswordHash() != null && !existing.getPasswordHash().isBlank()) {
                        u.setPasswordHash(existing.getPasswordHash());
                    } else {
                        u.setPasswordHash(PasswordUtil.hashPassword("ChangeMe123!"));
                    }
                }
                int managerId = dao.registerAndGetId(u);
                if (managerId > 0) {
                    new StationDAO().updateManager(stationId, managerId);
                }
                resp.sendRedirect(r.getContextPath() + "/admin/stations");
                return;
            } else {
                if (u.getUserId() > 0) {
                    String newPassword = n(r.getParameter("password"));
                    if (!newPassword.isBlank()) {
                        u.setPasswordHash(PasswordUtil.hashPassword(newPassword));
                        dao.updateWithPassword(u);
                    } else {
                        dao.update(u);
                    }
                }
                else {
                    u.setPasswordHash(PasswordUtil.hashPassword(r.getParameter("password")));
                    dao.register(u);
                }
                resp.sendRedirect(r.getContextPath() + ("saveManager".equals(a) ? "/admin/managers" : "/admin/users"));
            }
        } else if ("deleteUser".equals(a)) {
            new UserDAO().delete(Integer.parseInt(r.getParameter("userId")));
            resp.sendRedirect(r.getHeader("Referer"));
        } else if ("userStatus".equals(a)) {
            new UserDAO().changeStatus(Integer.parseInt(r.getParameter("userId")), r.getParameter("status"));
            resp.sendRedirect(r.getHeader("Referer"));
        } else if ("saveStation".equals(a)) {
            Station s = new Station();
            String id = r.getParameter("stationId");
            if (id != null && !id.isBlank()) s.setStationId(Integer.parseInt(id));
            s.setStationName(r.getParameter("stationName"));
            s.setDistrictId(Integer.parseInt(r.getParameter("districtId")));
            s.setManagerId(Integer.parseInt(r.getParameter("managerId")));
            s.setAddress(r.getParameter("address"));
            s.setContactNumber(r.getParameter("contactNumber"));
            s.setChargerType(r.getParameter("chargerType"));
            s.setTotalPorts(Integer.parseInt(r.getParameter("totalPorts")));
            s.setOpeningTime(Time.valueOf(r.getParameter("openingTime") + ":00"));
            s.setClosingTime(Time.valueOf(r.getParameter("closingTime") + ":00"));
            s.setPricePerHour(new BigDecimal(r.getParameter("pricePerHour")));
            s.setStatus(r.getParameter("status"));
            if (s.getStationId() > 0) new StationDAO().update(s);
            else new StationDAO().save(s);
            resp.sendRedirect(r.getContextPath() + "/admin/stations");
        } else if ("deleteStation".equals(a)) {
            new StationDAO().delete(Integer.parseInt(r.getParameter("stationId")));
            resp.sendRedirect(r.getContextPath() + "/admin/stations");
        } else if ("saveSlot".equals(a)) {
            Slot slot = new Slot();
            String id = n(r.getParameter("slotId"));
            if (!id.isBlank()) slot.setSlotId(Integer.parseInt(id));
            slot.setStationId(Integer.parseInt(r.getParameter("stationId")));
            slot.setSlotDate(java.sql.Date.valueOf(r.getParameter("slotDate")));
            slot.setStartTime(Time.valueOf(r.getParameter("startTime") + ":00"));
            slot.setEndTime(Time.valueOf(r.getParameter("endTime") + ":00"));
            slot.setAvailabilityStatus(n(r.getParameter("availabilityStatus")).isBlank() ? "available" : toDbSlotStatus(r.getParameter("availabilityStatus")));
            if (slot.getSlotId() > 0) new SlotDAO().update(slot);
            else new SlotDAO().save(slot);
            resp.sendRedirect(r.getContextPath() + "/admin/slots");
        } else if ("deleteSlot".equals(a)) {
            new SlotDAO().delete(Integer.parseInt(r.getParameter("slotId")));
            resp.sendRedirect(r.getHeader("Referer") != null ? r.getHeader("Referer") : (r.getContextPath() + "/admin/slots"));
        } else if ("slotStatus".equals(a)) {
            new SlotDAO().updateStatus(Integer.parseInt(r.getParameter("slotId")), toDbSlotStatus(r.getParameter("status")));
            resp.sendRedirect(r.getHeader("Referer") != null ? r.getHeader("Referer") : (r.getContextPath() + "/admin/slots"));
        } else if ("batchSlotStatus".equals(a)) {
            String[] selected = r.getParameterValues("slotIds");
            String nextStatus = toDbSlotStatus(r.getParameter("status"));
            if (!nextStatus.isBlank() && selected != null && selected.length > 0) {
                SlotDAO slotDAO = new SlotDAO();
                for (String s : selected) {
                    if (s != null && !s.isBlank()) {
                        slotDAO.updateStatus(Integer.parseInt(s), nextStatus);
                    }
                }
            }
            resp.sendRedirect(r.getHeader("Referer") != null ? r.getHeader("Referer") : (r.getContextPath() + "/admin/slots"));
        } else if ("bookingStatus".equals(a)) {
            new BookingDAO().updateStatus(Integer.parseInt(r.getParameter("bookingId")), r.getParameter("status"));
            resp.sendRedirect(r.getHeader("Referer"));
        } else if ("paymentStatus".equals(a)) {
            new PaymentDAO().updateStatus(Integer.parseInt(r.getParameter("paymentId")), r.getParameter("status"));
            resp.sendRedirect(r.getHeader("Referer"));
        } else if ("reviewStatus".equals(a)) {
            new ReviewDAO().updateStatus(Integer.parseInt(r.getParameter("reviewId")), r.getParameter("status"));
            resp.sendRedirect(r.getContextPath() + "/admin/reviews");
        } else if ("deleteReview".equals(a)) {
            new ReviewDAO().delete(Integer.parseInt(r.getParameter("reviewId")));
            resp.sendRedirect(r.getContextPath() + "/admin/reviews");
        } else if ("readMessage".equals(a)) {
            new ContactDAO().markRead(Integer.parseInt(r.getParameter("messageId")));
            resp.sendRedirect(r.getContextPath() + "/admin/messages");
        } else if ("deleteMessage".equals(a)) {
            new ContactDAO().delete(Integer.parseInt(r.getParameter("messageId")));
            resp.sendRedirect(r.getContextPath() + "/admin/messages");
        }
    }

    private void f(HttpServletRequest r, HttpServletResponse resp, String page) throws ServletException, IOException {
        r.getRequestDispatcher("/WEB-INF/views/" + page).forward(r, resp);
    }

    private String n(String value) {
        return value == null ? "" : value.trim();
    }

    private String v(String value) {
        return value == null ? "" : value;
    }

    private String toDbSlotStatus(String status) {
        String normalized = n(status).toLowerCase(Locale.ENGLISH);
        switch (normalized) {
            case "maintenance":
            case "offline":
            case "inactive":
                return "inactive";
            case "booked":
            case "occupied":
                return "booked";
            case "available":
                return "available";
            default:
                return normalized;
        }
    }
}
