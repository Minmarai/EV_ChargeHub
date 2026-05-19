package com.chargehub.controller;

import com.chargehub.dao.PaymentDAO;
import com.chargehub.dao.UserDAO;
import com.chargehub.model.Payment;
import com.chargehub.model.User;
import com.chargehub.util.DBConnection;
import com.chargehub.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalDate;
import java.time.format.TextStyle;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

@WebServlet("/admin/*")
/**
 * Author: Minma Rai
 */
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
                r.setAttribute("paymentCount", allPayments.size());
                f(r, resp, "admin/dashboard.jsp");
                break;

            case "/users":
                String q = n(r.getParameter("q"));
                String role = n(r.getParameter("role"));
                String status = n(r.getParameter("status"));
                int userPage = pi(r.getParameter("page"), 1);
                int userPageSize = pi(r.getParameter("pageSize"), 10);
                if (userPageSize <= 0) userPageSize = 10;
                boolean reset = "1".equals(r.getParameter("reset"));
                if (reset) {
                    q = "";
                    role = "";
                    status = "";
                    userPage = 1;
                }

                List<User> filteredUsers = new ArrayList<>();
                for (User user : ud.findAll()) {
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

                int usersTotalCount = filteredUsers.size();
                int usersTotalPages = usersTotalCount == 0 ? 1 : (int) Math.ceil(usersTotalCount / (double) userPageSize);
                if (userPage > usersTotalPages) userPage = usersTotalPages;
                int usersFrom = usersTotalCount == 0 ? 0 : ((userPage - 1) * userPageSize) + 1;
                int usersStartIndex = usersFrom == 0 ? 0 : usersFrom - 1;
                int usersEndIndex = Math.min(usersStartIndex + userPageSize, usersTotalCount);
                List<User> pagedUsers = filteredUsers.subList(usersStartIndex, usersEndIndex);

                r.setAttribute("q", q);
                r.setAttribute("role", role);
                r.setAttribute("status", status);
                r.setAttribute("users", pagedUsers);
                r.setAttribute("usersCount", pagedUsers.size());
                r.setAttribute("usersTotalCount", usersTotalCount);
                r.setAttribute("usersFrom", usersFrom);
                r.setAttribute("usersTo", usersEndIndex);
                r.setAttribute("page", userPage);
                r.setAttribute("pageSize", userPageSize);
                r.setAttribute("totalPages", usersTotalPages);
                f(r, resp, "admin/users.jsp");
                break;
            case "/managers":
                String mq = n(r.getParameter("q"));
                String mStatus = n(r.getParameter("status"));
                String mRegion = n(r.getParameter("region"));
                boolean managersReset = "1".equals(r.getParameter("reset"));
                if (managersReset) {
                    mq = "";
                    mStatus = "";
                    mRegion = "";
                }

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
                boolean stationsReset = "1".equals(r.getParameter("reset"));
                if (stationsReset) {
                    sq = "";
                    sDistrict = "";
                    sType = "";
                    sStatus = "";
                }

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
                String bookingExport = n(r.getParameter("export"));
                int bookingPage = pi(r.getParameter("page"), 1);
                int bookingPageSize = pi(r.getParameter("pageSize"), 10);
                if (bookingPageSize <= 0) bookingPageSize = 10;

                List<Station> bookingStations = sd.findAll();
                List<User> allManagers = ud.findByRole("station_manager");
                List<Booking> bookingRecords = new BookingDAO().findAll();
                List<Slot> bookingSlots = new SlotDAO().findAll();
                List<Payment> bookingPayments = new PaymentDAO().findAll();
                List<Booking> filteredBookings = new ArrayList<>();
                Map<Integer, String> stationManagerMap = new HashMap<>();
                Map<Integer, Station> bookingStationById = new HashMap<>();
                Map<Integer, Slot> slotById = new HashMap<>();
                Map<Integer, Payment> paymentByBookingId = new HashMap<>();

                for (Station station : bookingStations) {
                    stationManagerMap.put(station.getStationId(), v(station.getManagerName()));
                    bookingStationById.put(station.getStationId(), station);
                }

                for (Slot slot : bookingSlots) {
                    slotById.put(slot.getSlotId(), slot);
                }

                for (Payment payment : bookingPayments) {
                    paymentByBookingId.put(payment.getBookingId(), payment);
                }

                for (Booking booking : bookingRecords) {
                    Station bookingStation = bookingStationById.get(booking.getStationId());
                    if (v(booking.getStationName()).isBlank() && bookingStation != null) {
                        booking.setStationName(bookingStation.getStationName());
                    }
                    if (v(booking.getManagerName()).isBlank() && bookingStation != null) {
                        booking.setManagerName(bookingStation.getManagerName());
                    }

                    if (v(booking.getSlotInfo()).isBlank()) {
                        Slot slot = slotById.get(booking.getSlotId());
                        if (slot != null && slot.getSlotDate() != null && slot.getStartTime() != null && slot.getEndTime() != null) {
                            booking.setSlotInfo(slot.getSlotDate() + " " + slot.getStartTime() + "-" + slot.getEndTime());
                        }
                    }

                    Payment payment = paymentByBookingId.get(booking.getBookingId());
                    if (payment != null) {
                        if (booking.getAmount() == null && payment.getAmount() != null) {
                            booking.setAmount(payment.getAmount());
                        }
                        if (v(booking.getPaymentStatus()).isBlank()) {
                            booking.setPaymentStatus(payment.getPaymentStatus());
                        }
                    }

                    if (!bookingStationFilter.isBlank() && !bookingStationFilter.equals(String.valueOf(booking.getStationId()))) continue;

                    if (!bookingManagerFilter.isBlank()) {
                        boolean managerMatches = false;
                        for (Station managerStation : bookingStations) {
                            if (managerStation.getStationId() == booking.getStationId()
                                    && bookingManagerFilter.equals(String.valueOf(managerStation.getManagerId()))) {
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

                if ("csv".equalsIgnoreCase(bookingExport)) {
                    resp.setContentType("text/csv;charset=UTF-8");
                    resp.setHeader("Content-Disposition", "attachment; filename=bookings.csv");
                    java.io.PrintWriter out = resp.getWriter();
                    out.println("Booking ID,User,Station,Booking Date,Slot,Amount,Payment Status,Booking Status,Manager");
                    for (Booking booking : filteredBookings) {
                        String managerName = "";
                        for (Station station : bookingStations) {
                            if (station.getStationId() == booking.getStationId()) {
                                managerName = station.getManagerName();
                                break;
                            }
                        }
                        out.println(csv("BK-" + booking.getBookingId()) + ","
                                + csv(booking.getUserName()) + ","
                                + csv(booking.getStationName()) + ","
                                + csv(booking.getBookingDate()) + ","
                                + csv(booking.getSlotInfo()) + ","
                                + csv(booking.getAmount()) + ","
                                + csv(booking.getPaymentStatus()) + ","
                                + csv(booking.getBookingStatus()) + ","
                                + csv(managerName));
                    }
                    return;
                }

                int bookingsFilteredCount = filteredBookings.size();
                int bookingsTotalPages = bookingsFilteredCount == 0 ? 1 : (int) Math.ceil(bookingsFilteredCount / (double) bookingPageSize);
                if (bookingPage > bookingsTotalPages) bookingPage = bookingsTotalPages;
                int bookingsFrom = bookingsFilteredCount == 0 ? 0 : ((bookingPage - 1) * bookingPageSize) + 1;
                int bookingsStartIndex = bookingsFrom == 0 ? 0 : bookingsFrom - 1;
                int bookingsTo = Math.min(bookingsStartIndex + bookingPageSize, bookingsFilteredCount);
                List<Booking> pagedBookings = filteredBookings.subList(bookingsStartIndex, bookingsTo);

                r.setAttribute("q", bookingQ);
                r.setAttribute("stationId", bookingStationFilter);
                r.setAttribute("managerId", bookingManagerFilter);
                r.setAttribute("bookingDate", bookingDateFilter);
                r.setAttribute("status", bookingStatusFilter);
                r.setAttribute("stations", bookingStations);
                r.setAttribute("managers", allManagers);
                r.setAttribute("bookings", pagedBookings);
                r.setAttribute("stationManagerMap", stationManagerMap);
                r.setAttribute("bookingsCount", pagedBookings.size());
                r.setAttribute("bookingsFilteredCount", bookingsFilteredCount);
                r.setAttribute("bookingsFrom", bookingsFrom);
                r.setAttribute("bookingsTo", bookingsTo);
                r.setAttribute("page", bookingPage);
                r.setAttribute("pageSize", bookingPageSize);
                r.setAttribute("totalPages", bookingsTotalPages);
                f(r, resp, "admin/bookings.jsp");
                break;
            case "/booking":
                r.setAttribute("booking", new BookingDAO().findById(Integer.parseInt(r.getParameter("id"))));
                f(r, resp, "admin/booking-details.jsp");
                break;
            case "/payments":
                String paymentQ = n(r.getParameter("q"));
                String paymentStatusFilter = n(r.getParameter("status"));
                String paymentMethodFilter = n(r.getParameter("method"));
                String paymentDateFilter = n(r.getParameter("paymentDate"));
                String paymentExport = n(r.getParameter("export"));
                int paymentPage = pi(r.getParameter("page"), 1);
                int paymentPageSize = pi(r.getParameter("pageSize"), 10);
                if (paymentPageSize <= 0) paymentPageSize = 10;

                List<Payment> allPaymentRows = new PaymentDAO().findAll();
                List<Payment> filteredPayments = new ArrayList<>();
                List<String> paymentMethods = new ArrayList<>();

                int paidCount = 0;
                int pendingCount = 0;
                int failedCount = 0;
                int refundedCount = 0;
                BigDecimal paymentsRevenue = BigDecimal.ZERO;

                for (Payment payment : allPaymentRows) {
                    String method = v(payment.getPaymentMethod());
                    String statusText = v(payment.getPaymentStatus());

                    if (!method.isBlank()) {
                        boolean exists = false;
                        for (String existing : paymentMethods) {
                            if (existing.equalsIgnoreCase(method)) {
                                exists = true;
                                break;
                            }
                        }
                        if (!exists) paymentMethods.add(method);
                    }

                    if ("paid".equalsIgnoreCase(statusText)) {
                        paidCount++;
                        if (payment.getAmount() != null) {
                            paymentsRevenue = paymentsRevenue.add(payment.getAmount());
                        }
                    } else if ("pending".equalsIgnoreCase(statusText)) {
                        pendingCount++;
                    } else if ("failed".equalsIgnoreCase(statusText)) {
                        failedCount++;
                    } else if ("refunded".equalsIgnoreCase(statusText)) {
                        refundedCount++;
                    }

                    if (!paymentStatusFilter.isBlank() && !paymentStatusFilter.equalsIgnoreCase(statusText)) continue;
                    if (!paymentMethodFilter.isBlank() && !paymentMethodFilter.equalsIgnoreCase(method)) continue;

                    if (!paymentDateFilter.isBlank()) {
                        if (payment.getPaymentDate() == null
                                || !paymentDateFilter.equals(payment.getPaymentDate().toLocalDateTime().toLocalDate().toString())) {
                            continue;
                        }
                    }

                    if (!paymentQ.isBlank()) {
                        String key = paymentQ.toLowerCase(Locale.ENGLISH);
                        String row = ("TRX-" + payment.getPaymentId() + " "
                                + "BK-" + payment.getBookingId() + " "
                                + v(payment.getUserName()) + " "
                                + v(payment.getStationName()) + " "
                                + v(payment.getTransactionReference()))
                                .toLowerCase(Locale.ENGLISH);
                        if (!row.contains(key)) continue;
                    }

                    filteredPayments.add(payment);
                }

                if ("csv".equalsIgnoreCase(paymentExport)) {
                    resp.setContentType("text/csv;charset=UTF-8");
                    resp.setHeader("Content-Disposition", "attachment; filename=payments.csv");
                    java.io.PrintWriter out = resp.getWriter();
                    out.println("Payment ID,Transaction Ref,Booking ID,User,Station,Amount,Method,Payment Date,Status");
                    for (Payment payment : filteredPayments) {
                        out.println(csv(payment.getPaymentId()) + ","
                                + csv(payment.getTransactionReference()) + ","
                                + csv("BK-" + payment.getBookingId()) + ","
                                + csv(payment.getUserName()) + ","
                                + csv(payment.getStationName()) + ","
                                + csv(payment.getAmount()) + ","
                                + csv(payment.getPaymentMethod()) + ","
                                + csv(payment.getPaymentDate()) + ","
                                + csv(payment.getPaymentStatus()));
                    }
                    return;
                }

                int paymentsFilteredCount = filteredPayments.size();
                int paymentsTotalPages = paymentsFilteredCount == 0 ? 1 : (int) Math.ceil(paymentsFilteredCount / (double) paymentPageSize);
                if (paymentPage > paymentsTotalPages) paymentPage = paymentsTotalPages;
                int paymentsFrom = paymentsFilteredCount == 0 ? 0 : ((paymentPage - 1) * paymentPageSize) + 1;
                int paymentsStartIndex = paymentsFrom == 0 ? 0 : paymentsFrom - 1;
                int paymentsTo = Math.min(paymentsStartIndex + paymentPageSize, paymentsFilteredCount);
                List<Payment> pagedPayments = filteredPayments.subList(paymentsStartIndex, paymentsTo);

                r.setAttribute("q", paymentQ);
                r.setAttribute("status", paymentStatusFilter);
                r.setAttribute("method", paymentMethodFilter);
                r.setAttribute("paymentDate", paymentDateFilter);
                r.setAttribute("methods", paymentMethods);
                r.setAttribute("payments", pagedPayments);
                r.setAttribute("paymentsCount", pagedPayments.size());
                r.setAttribute("paymentsFilteredCount", paymentsFilteredCount);
                r.setAttribute("paymentsFrom", paymentsFrom);
                r.setAttribute("paymentsTo", paymentsTo);
                r.setAttribute("page", paymentPage);
                r.setAttribute("pageSize", paymentPageSize);
                r.setAttribute("totalPages", paymentsTotalPages);
                r.setAttribute("allPaymentsCount", allPaymentRows.size());
                r.setAttribute("paidCount", paidCount);
                r.setAttribute("pendingCount", pendingCount);
                r.setAttribute("failedCount", failedCount);
                r.setAttribute("refundedCount", refundedCount);
                r.setAttribute("paymentsRevenue", paymentsRevenue);
                f(r, resp, "admin/payments.jsp");
                break;
            case "/payment":
                Payment paymentRecord = new PaymentDAO().findById(Integer.parseInt(r.getParameter("id")));
                r.setAttribute("payment", paymentRecord);
                if (paymentRecord != null) {
                    r.setAttribute("booking", new BookingDAO().findById(paymentRecord.getBookingId()));
                    r.setAttribute("paymentUser", ud.findById(paymentRecord.getUserId()));
                }
                f(r, resp, "admin/payment-details.jsp");
                break;
            case "/reviews":
                String reviewQ = n(r.getParameter("q"));
                String reviewStationFilter = n(r.getParameter("station"));
                String reviewRatingFilter = n(r.getParameter("rating"));
                String reviewStatusFilter = n(r.getParameter("status"));
                String reviewExport = n(r.getParameter("export"));
                int reviewPage = pi(r.getParameter("page"), 1);
                int reviewPageSize = pi(r.getParameter("pageSize"), 10);
                if (reviewPageSize <= 0) reviewPageSize = 10;

                List<Map<String, Object>> allReviews = new ReviewDAO().findAll();
                List<Map<String, Object>> filteredReviews = new ArrayList<>();
                List<String> reviewStations = new ArrayList<>();
                int visibleReviews = 0;
                int hiddenReviews = 0;

                for (Map<String, Object> row : allReviews) {
                    Object stationObj = row.get("station_name");
                    String stationName = stationObj == null ? "" : String.valueOf(stationObj).trim();
                    if (!stationName.isBlank()) {
                        boolean stationExists = false;
                        for (String station : reviewStations) {
                            if (station.equalsIgnoreCase(stationName)) {
                                stationExists = true;
                                break;
                            }
                        }
                        if (!stationExists) reviewStations.add(stationName);
                    }

                    Object statusObj = row.get("status");
                    String rowStatus = statusObj == null ? "" : String.valueOf(statusObj).trim();
                    if ("visible".equalsIgnoreCase(rowStatus)) visibleReviews++;
                    else if ("hidden".equalsIgnoreCase(rowStatus)) hiddenReviews++;

                    Object ratingObj = row.get("rating");
                    String rowRating = ratingObj == null ? "" : String.valueOf(ratingObj).trim();

                    if (!reviewStationFilter.isBlank() && !reviewStationFilter.equalsIgnoreCase(stationName)) continue;
                    if (!reviewRatingFilter.isBlank() && !reviewRatingFilter.equals(rowRating)) continue;
                    if (!reviewStatusFilter.isBlank() && !reviewStatusFilter.equalsIgnoreCase(rowStatus)) continue;

                    if (!reviewQ.isBlank()) {
                        String key = reviewQ.toLowerCase(Locale.ENGLISH);
                        String rowText = (String.valueOf(row.get("review_id")) + " "
                                + String.valueOf(row.get("full_name")) + " "
                                + stationName + " "
                                + String.valueOf(row.get("comment")) + " "
                                + rowRating)
                                .toLowerCase(Locale.ENGLISH);
                        if (!rowText.contains(key)) continue;
                    }

                    filteredReviews.add(row);
                }

                if ("csv".equalsIgnoreCase(reviewExport)) {
                    resp.setContentType("text/csv;charset=UTF-8");
                    resp.setHeader("Content-Disposition", "attachment; filename=reviews.csv");
                    java.io.PrintWriter out = resp.getWriter();
                    out.println("Review ID,Station,User ID,User Name,Rating,Status,Comment,Created At");
                    for (Map<String, Object> row : filteredReviews) {
                        out.println(csv(row.get("review_id")) + ","
                                + csv(row.get("station_name")) + ","
                                + csv(row.get("user_id")) + ","
                                + csv(row.get("full_name")) + ","
                                + csv(row.get("rating")) + ","
                                + csv(row.get("status")) + ","
                                + csv(row.get("comment")) + ","
                                + csv(row.get("created_at")));
                    }
                    return;
                }

                int reviewsFilteredCount = filteredReviews.size();
                int reviewsTotalPages = reviewsFilteredCount == 0 ? 1 : (int) Math.ceil(reviewsFilteredCount / (double) reviewPageSize);
                if (reviewPage > reviewsTotalPages) reviewPage = reviewsTotalPages;
                int reviewsFrom = reviewsFilteredCount == 0 ? 0 : ((reviewPage - 1) * reviewPageSize) + 1;
                int reviewsStartIndex = reviewsFrom == 0 ? 0 : reviewsFrom - 1;
                int reviewsTo = Math.min(reviewsStartIndex + reviewPageSize, reviewsFilteredCount);
                List<Map<String, Object>> pagedReviews = filteredReviews.subList(reviewsStartIndex, reviewsTo);

                r.setAttribute("q", reviewQ);
                r.setAttribute("station", reviewStationFilter);
                r.setAttribute("rating", reviewRatingFilter);
                r.setAttribute("status", reviewStatusFilter);
                r.setAttribute("stations", reviewStations);
                r.setAttribute("reviews", pagedReviews);
                r.setAttribute("reviewsCount", pagedReviews.size());
                r.setAttribute("reviewsFilteredCount", reviewsFilteredCount);
                r.setAttribute("reviewsFrom", reviewsFrom);
                r.setAttribute("reviewsTo", reviewsTo);
                r.setAttribute("page", reviewPage);
                r.setAttribute("pageSize", reviewPageSize);
                r.setAttribute("totalPages", reviewsTotalPages);
                r.setAttribute("allReviewsCount", allReviews.size());
                r.setAttribute("visibleReviews", visibleReviews);
                r.setAttribute("hiddenReviews", hiddenReviews);
                f(r, resp, "admin/reviews.jsp");
                break;
            case "/messages":
                String messageQ = n(r.getParameter("q"));
                String messageStatus = n(r.getParameter("status"));
                String messageDate = n(r.getParameter("sentDate"));
                String messageExport = n(r.getParameter("export"));
                int messagePage = pi(r.getParameter("page"), 1);
                int messagePageSize = pi(r.getParameter("pageSize"), 10);
                if (messagePageSize <= 0) messagePageSize = 10;

                List<Map<String, Object>> allMessages = new ContactDAO().findAll();
                List<Map<String, Object>> filteredMessages = new ArrayList<>();
                int unreadCount = 0;
                int readCount = 0;

                for (Map<String, Object> row : allMessages) {
                    String rowStatus = String.valueOf(row.get("status") == null ? "" : row.get("status")).trim();
                    if ("unread".equalsIgnoreCase(rowStatus)) unreadCount++;
                    else if ("read".equalsIgnoreCase(rowStatus)) readCount++;

                    if (!messageStatus.isBlank() && !messageStatus.equalsIgnoreCase(rowStatus)) continue;

                    if (!messageDate.isBlank()) {
                        String sentAt = "";
                        Object createdAt = row.get("created_at");
                        if (createdAt != null) sentAt = String.valueOf(createdAt);
                        if (sentAt.isBlank()) {
                            Object submittedAt = row.get("submitted_at");
                            if (submittedAt != null) sentAt = String.valueOf(submittedAt);
                        }
                        if (sentAt.length() < 10 || !messageDate.equals(sentAt.substring(0, 10))) continue;
                    }

                    if (!messageQ.isBlank()) {
                        String key = messageQ.toLowerCase(Locale.ENGLISH);
                        String rowText = (String.valueOf(row.get("name")) + " "
                                + String.valueOf(row.get("email")) + " "
                                + String.valueOf(row.get("subject")) + " "
                                + String.valueOf(row.get("message")))
                                .toLowerCase(Locale.ENGLISH);
                        if (!rowText.contains(key)) continue;
                    }

                    filteredMessages.add(row);
                }

                if ("csv".equalsIgnoreCase(messageExport)) {
                    resp.setContentType("text/csv;charset=UTF-8");
                    resp.setHeader("Content-Disposition", "attachment; filename=messages.csv");
                    java.io.PrintWriter out = resp.getWriter();
                    out.println("Message ID,Sender,Email,Subject,Message,Status,Created At");
                    for (Map<String, Object> row : filteredMessages) {
                        out.println(csv(row.get("message_id")) + ","
                                + csv(row.get("name")) + ","
                                + csv(row.get("email")) + ","
                                + csv(row.get("subject")) + ","
                                + csv(row.get("message")) + ","
                                + csv(row.get("status")) + ","
                                + csv(row.get("created_at")));
                    }
                    return;
                }

                int messagesFilteredCount = filteredMessages.size();
                int messagesTotalPages = messagesFilteredCount == 0 ? 1 : (int) Math.ceil(messagesFilteredCount / (double) messagePageSize);
                if (messagePage > messagesTotalPages) messagePage = messagesTotalPages;
                int messagesFrom = messagesFilteredCount == 0 ? 0 : ((messagePage - 1) * messagePageSize) + 1;
                int messagesStartIndex = messagesFrom == 0 ? 0 : messagesFrom - 1;
                int messagesTo = Math.min(messagesStartIndex + messagePageSize, messagesFilteredCount);
                List<Map<String, Object>> pagedMessages = filteredMessages.subList(messagesStartIndex, messagesTo);

                r.setAttribute("q", messageQ);
                r.setAttribute("status", messageStatus);
                r.setAttribute("sentDate", messageDate);
                r.setAttribute("messages", pagedMessages);
                r.setAttribute("messagesCount", pagedMessages.size());
                r.setAttribute("messagesFilteredCount", messagesFilteredCount);
                r.setAttribute("messagesFrom", messagesFrom);
                r.setAttribute("messagesTo", messagesTo);
                r.setAttribute("page", messagePage);
                r.setAttribute("pageSize", messagePageSize);
                r.setAttribute("totalPages", messagesTotalPages);
                r.setAttribute("allMessagesCount", allMessages.size());
                r.setAttribute("unreadCount", unreadCount);
                r.setAttribute("readCount", readCount);
                f(r, resp, "admin/messages.jsp");
                break;
            case "/reports":
                String period = n(r.getParameter("period"));
                if (period.isBlank()) period = "30d";
                String districtFilter = n(r.getParameter("district"));
                String stationFilterText = n(r.getParameter("stationId"));
                String fromDateText = n(r.getParameter("fromDate"));
                String toDateText = n(r.getParameter("toDate"));

                LocalDate todayDate = LocalDate.now();
                LocalDate rangeStart = null;
                LocalDate rangeEnd = todayDate;

                switch (period.toLowerCase(Locale.ENGLISH)) {
                    case "today":
                        rangeStart = todayDate;
                        break;
                    case "7d":
                        rangeStart = todayDate.minusDays(6);
                        break;
                    case "ytd":
                        rangeStart = LocalDate.of(todayDate.getYear(), 1, 1);
                        break;
                    case "custom":
                        rangeStart = p(fromDateText);
                        rangeEnd = p(toDateText);
                        if (rangeStart == null) rangeStart = todayDate.minusDays(29);
                        if (rangeEnd == null) rangeEnd = todayDate;
                        break;
                    case "30d":
                    default:
                        period = "30d";
                        rangeStart = todayDate.minusDays(29);
                        break;
                }

                if (rangeStart != null && rangeEnd != null && rangeStart.isAfter(rangeEnd)) {
                    LocalDate temp = rangeStart;
                    rangeStart = rangeEnd;
                    rangeEnd = temp;
                }

                int stationFilterId = 0;
                if (!stationFilterText.isBlank()) {
                    try {
                        stationFilterId = Integer.parseInt(stationFilterText);
                    } catch (NumberFormatException ignore) {
                        stationFilterId = 0;
                    }
                }

                List<Station> reportStations = sd.findAll();
                List<Booking> reportBookings = new BookingDAO().findAll();
                List<Payment> reportPayments = new PaymentDAO().findAll();

                Map<Integer, Station> stationById = new HashMap<>();
                List<String> reportDistricts = new ArrayList<>();
                for (Station station : reportStations) {
                    stationById.put(station.getStationId(), station);
                    String districtName = v(station.getDistrictName());
                    if (!districtName.isBlank()) {
                        boolean exists = false;
                        for (String district : reportDistricts) {
                            if (district.equalsIgnoreCase(districtName)) {
                                exists = true;
                                break;
                            }
                        }
                        if (!exists) reportDistricts.add(districtName);
                    }
                }

                Map<Integer, Booking> bookingById = new HashMap<>();
                for (Booking booking : reportBookings) {
                    bookingById.put(booking.getBookingId(), booking);
                }

                List<Booking> reportFilteredBookings = new ArrayList<>();
                for (Booking booking : reportBookings) {
                    LocalDate bookingDate = booking.getBookingDate() == null ? null : booking.getBookingDate().toLocalDateTime().toLocalDate();
                    if (!m(bookingDate, rangeStart, rangeEnd)) continue;

                    Station station = stationById.get(booking.getStationId());
                    String districtName = station == null ? "" : v(station.getDistrictName());
                    if (!districtFilter.isBlank() && !districtFilter.equalsIgnoreCase(districtName)) continue;
                    if (stationFilterId > 0 && stationFilterId != booking.getStationId()) continue;

                    reportFilteredBookings.add(booking);
                }

                Set<Integer> filteredBookingIds = new HashSet<>();
                for (Booking booking : reportFilteredBookings) filteredBookingIds.add(booking.getBookingId());

                List<Payment> reportFilteredPayments = new ArrayList<>();
                for (Payment reportPayment : reportPayments) {
                    LocalDate paymentDate = reportPayment.getPaymentDate() == null ? null : reportPayment.getPaymentDate().toLocalDateTime().toLocalDate();
                    if (!m(paymentDate, rangeStart, rangeEnd)) continue;

                    Booking paymentBooking = bookingById.get(reportPayment.getBookingId());
                    if (paymentBooking == null) continue;

                    Station paymentStation = stationById.get(paymentBooking.getStationId());
                    String districtName = paymentStation == null ? "" : v(paymentStation.getDistrictName());

                    if (!districtFilter.isBlank() && !districtFilter.equalsIgnoreCase(districtName)) continue;
                    if (stationFilterId > 0 && stationFilterId != paymentBooking.getStationId()) continue;

                    if (!filteredBookingIds.contains(reportPayment.getBookingId())) continue;
                    reportFilteredPayments.add(reportPayment);
                }

                int totalBookings = reportFilteredBookings.size();
                BigDecimal totalRevenue = BigDecimal.ZERO;
                int paidPayments = 0;
                int pendingPayments = 0;
                int failedPayments = 0;
                int refundedPayments = 0;

                for (Payment reportPayment : reportFilteredPayments) {
                    String statusText = v(reportPayment.getPaymentStatus());
                    if ("paid".equalsIgnoreCase(statusText)) {
                        paidPayments++;
                        if (reportPayment.getAmount() != null) totalRevenue = totalRevenue.add(reportPayment.getAmount());
                    } else if ("pending".equalsIgnoreCase(statusText)) {
                        pendingPayments++;
                    } else if ("failed".equalsIgnoreCase(statusText)) {
                        failedPayments++;
                    } else if ("refunded".equalsIgnoreCase(statusText)) {
                        refundedPayments++;
                    }
                }

                int activeStations = 0;
                for (Station station : reportStations) {
                    if (stationFilterId > 0 && station.getStationId() != stationFilterId) continue;
                    if (!districtFilter.isBlank() && !districtFilter.equalsIgnoreCase(v(station.getDistrictName()))) continue;
                    if ("active".equalsIgnoreCase(v(station.getStatus()))) activeStations++;
                }

                List<LocalDate> registeredUserDates = new ArrayList<>();
                try (Connection c = DBConnection.getConnection();
                     PreparedStatement ps = c.prepareStatement(
                             "SELECT DATE(created_at) AS created_date FROM users " +
                                     "WHERE LOWER(TRIM(role))='user' AND created_at IS NOT NULL")) {
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
                        java.sql.Date createdDate = rs.getDate("created_date");
                        if (createdDate == null) continue;
                        LocalDate registeredDate = createdDate.toLocalDate();
                        if (m(registeredDate, rangeStart, rangeEnd)) {
                            registeredUserDates.add(registeredDate);
                        }
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                int newUsers = registeredUserDates.size();

                Map<String, Integer> districtBookingsMap = new HashMap<>();
                Map<String, Integer> stationBookingsMap = new HashMap<>();
                Map<String, Integer> managerBookingsMap = new HashMap<>();

                for (Booking booking : reportFilteredBookings) {
                    Station station = stationById.get(booking.getStationId());
                    String districtName = station == null ? "Unknown" : (v(station.getDistrictName()).isBlank() ? "Unknown" : v(station.getDistrictName()));
                    String stationName = station == null ? "Station #" + booking.getStationId() : (v(station.getStationName()).isBlank() ? "Station #" + booking.getStationId() : v(station.getStationName()));
                    String managerName = station == null ? "Unassigned" : (v(station.getManagerName()).isBlank() ? "Unassigned" : v(station.getManagerName()));

                    districtBookingsMap.put(districtName, districtBookingsMap.getOrDefault(districtName, 0) + 1);
                    stationBookingsMap.put(stationName, stationBookingsMap.getOrDefault(stationName, 0) + 1);
                    managerBookingsMap.put(managerName, managerBookingsMap.getOrDefault(managerName, 0) + 1);
                }

                Map<Integer, Integer> stationBookingsCountMap = new HashMap<>();
                Map<Integer, BigDecimal> stationRevenueMap = new HashMap<>();
                for (Booking booking : reportFilteredBookings) {
                    int stationId = booking.getStationId();
                    stationBookingsCountMap.put(stationId, stationBookingsCountMap.getOrDefault(stationId, 0) + 1);
                }

                for (Payment reportPayment : reportFilteredPayments) {
                    if (!"paid".equalsIgnoreCase(v(reportPayment.getPaymentStatus()))) continue;
                    Booking paymentBooking = bookingById.get(reportPayment.getBookingId());
                    if (paymentBooking == null) continue;
                    int stationId = paymentBooking.getStationId();
                    BigDecimal amount = reportPayment.getAmount() == null ? BigDecimal.ZERO : reportPayment.getAmount();
                    stationRevenueMap.put(stationId, stationRevenueMap.getOrDefault(stationId, BigDecimal.ZERO).add(amount));
                }

                List<Map<String, Object>> bookingsByDistrict = new ArrayList<>();
                for (Map.Entry<String, Integer> entry : districtBookingsMap.entrySet()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("name", entry.getKey());
                    row.put("count", entry.getValue());
                    bookingsByDistrict.add(row);
                }
                bookingsByDistrict.sort((a, b) -> Integer.compare((Integer) b.get("count"), (Integer) a.get("count")));

                List<Map<String, Object>> bookingsByStation = new ArrayList<>();
                for (Map.Entry<String, Integer> entry : stationBookingsMap.entrySet()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("name", entry.getKey());
                    row.put("count", entry.getValue());
                    bookingsByStation.add(row);
                }
                bookingsByStation.sort((a, b) -> Integer.compare((Integer) b.get("count"), (Integer) a.get("count")));

                List<Map<String, Object>> bookingsByManager = new ArrayList<>();
                for (Map.Entry<String, Integer> entry : managerBookingsMap.entrySet()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("name", entry.getKey());
                    row.put("count", entry.getValue());
                    bookingsByManager.add(row);
                }
                bookingsByManager.sort((a, b) -> Integer.compare((Integer) b.get("count"), (Integer) a.get("count")));

                int maxStationBookings = 0;
                for (Integer count : stationBookingsCountMap.values()) {
                    if (count > maxStationBookings) maxStationBookings = count;
                }
                if (maxStationBookings <= 0) maxStationBookings = 1;

                List<Map<String, Object>> stationActivityRows = new ArrayList<>();
                for (Station station : reportStations) {
                    int stationId = station.getStationId();
                    if (stationFilterId > 0 && stationId != stationFilterId) continue;
                    if (!districtFilter.isBlank() && !districtFilter.equalsIgnoreCase(v(station.getDistrictName()))) continue;

                    int bookingCount = stationBookingsCountMap.getOrDefault(stationId, 0);
                    BigDecimal revenue = stationRevenueMap.getOrDefault(stationId, BigDecimal.ZERO);
                    int utilization = Math.min(100, (int) Math.round((bookingCount * 100.0) / maxStationBookings));

                    Map<String, Object> row = new HashMap<>();
                    row.put("stationId", stationId);
                    row.put("stationName", v(station.getStationName()).isBlank() ? "Station #" + stationId : station.getStationName());
                    row.put("district", v(station.getDistrictName()).isBlank() ? "-" : station.getDistrictName());
                    row.put("manager", v(station.getManagerName()).isBlank() ? "Unassigned" : station.getManagerName());
                    row.put("bookings", bookingCount);
                    row.put("utilization", utilization);
                    row.put("revenue", revenue);
                    stationActivityRows.add(row);
                }

                stationActivityRows.sort((a, b) -> Integer.compare((Integer) b.get("bookings"), (Integer) a.get("bookings")));
                if (stationActivityRows.size() > 5) stationActivityRows = new ArrayList<>(stationActivityRows.subList(0, 5));

                List<String> paymentTrendLabels = new ArrayList<>();
                List<Integer> paymentTrendRevenue = new ArrayList<>();
                List<Integer> paymentTrendBookings = new ArrayList<>();
                List<String> registrationMonths = new ArrayList<>();
                List<Integer> registrationValues = new ArrayList<>();
                long rangeDays = Math.max(1, ChronoUnit.DAYS.between(rangeStart, rangeEnd) + 1);
                int bucketCount = (int) Math.min(6, rangeDays);
                if (bucketCount <= 0) bucketCount = 1;
                long bucketDays = Math.max(1, (long) Math.ceil(rangeDays / (double) bucketCount));
                for (int i = 0; i < bucketCount; i++) {
                    LocalDate bucketStart = rangeStart.plusDays(i * bucketDays);
                    if (bucketStart.isAfter(rangeEnd)) bucketStart = rangeEnd;
                    LocalDate bucketEnd = bucketStart.plusDays(bucketDays - 1);
                    if (bucketEnd.isAfter(rangeEnd)) bucketEnd = rangeEnd;
                    String bucketLabel = bucketStart.getMonth().getDisplayName(TextStyle.SHORT, Locale.ENGLISH) + " " + bucketStart.getDayOfMonth();
                    paymentTrendLabels.add(bucketLabel);
                    registrationMonths.add(bucketLabel);

                    int bucketBookingCount = 0;
                    for (Booking booking : reportFilteredBookings) {
                        if (booking.getBookingDate() == null) continue;
                        LocalDate bookingDate = booking.getBookingDate().toLocalDateTime().toLocalDate();
                        if (!bookingDate.isBefore(bucketStart) && !bookingDate.isAfter(bucketEnd)) bucketBookingCount++;
                    }

                    BigDecimal bucketRevenue = BigDecimal.ZERO;
                    for (Payment reportPayment : reportFilteredPayments) {
                        if (reportPayment.getPaymentDate() == null) continue;
                        if (!"paid".equalsIgnoreCase(v(reportPayment.getPaymentStatus()))) continue;
                        LocalDate paymentDate = reportPayment.getPaymentDate().toLocalDateTime().toLocalDate();
                        if (!paymentDate.isBefore(bucketStart) && !paymentDate.isAfter(bucketEnd)) {
                            bucketRevenue = bucketRevenue.add(reportPayment.getAmount() == null ? BigDecimal.ZERO : reportPayment.getAmount());
                        }
                    }

                    int bucketRegistrationCount = 0;
                    for (LocalDate registeredDate : registeredUserDates) {
                        if (!registeredDate.isBefore(bucketStart) && !registeredDate.isAfter(bucketEnd)) {
                            bucketRegistrationCount++;
                        }
                    }

                    paymentTrendBookings.add(bucketBookingCount);
                    paymentTrendRevenue.add(bucketRevenue.setScale(0, java.math.RoundingMode.HALF_UP).intValue());
                    registrationValues.add(bucketRegistrationCount);
                }

                if ("csv".equalsIgnoreCase(n(r.getParameter("export")))) {
                    resp.setContentType("text/csv;charset=UTF-8");
                    resp.setHeader("Content-Disposition", "attachment; filename=reports-analytics.csv");
                    java.io.PrintWriter out = resp.getWriter();
                    out.println("Metric,Value");
                    out.println("Total Bookings," + totalBookings);
                    out.println("Total Revenue," + totalRevenue);
                    out.println("New Users," + newUsers);
                    out.println("Active Stations," + activeStations);
                    out.println("Paid Payments," + paidPayments);
                    out.println("Pending Payments," + pendingPayments);
                    out.println("Failed Payments," + failedPayments);
                    out.println("Refunded Payments," + refundedPayments);
                    out.println();
                    out.println("Station Activity Summary");
                    out.println("Station,District,Manager,Bookings,Utilization,Revenue");
                    for (Map<String, Object> row : stationActivityRows) {
                        out.println("\"" + row.get("stationName") + "\",\"" + row.get("district") + "\",\"" + row.get("manager") + "\"," + row.get("bookings") + "," + row.get("utilization") + "%," + row.get("revenue"));
                    }
                    return;
                }

                r.setAttribute("period", period);
                r.setAttribute("district", districtFilter);
                r.setAttribute("stationId", stationFilterText);
                r.setAttribute("fromDate", rangeStart == null ? "" : rangeStart.toString());
                r.setAttribute("toDate", rangeEnd == null ? "" : rangeEnd.toString());
                r.setAttribute("districts", reportDistricts);
                r.setAttribute("stations", reportStations);

                r.setAttribute("totalBookings", totalBookings);
                r.setAttribute("totalRevenue", totalRevenue);
                r.setAttribute("newUsers", newUsers);
                r.setAttribute("activeStations", activeStations);
                r.setAttribute("paidPayments", paidPayments);
                r.setAttribute("pendingPayments", pendingPayments);
                r.setAttribute("failedPayments", failedPayments);
                r.setAttribute("refundedPayments", refundedPayments);

                r.setAttribute("bookingsByDistrict", bookingsByDistrict);
                r.setAttribute("bookingsByStation", bookingsByStation);
                r.setAttribute("bookingsByManager", bookingsByManager);
                r.setAttribute("stationActivityRows", stationActivityRows);

                r.setAttribute("registrationMonths", registrationMonths);
                r.setAttribute("registrationValues", registrationValues);
                r.setAttribute("paymentTrendLabels", paymentTrendLabels);
                r.setAttribute("paymentTrendRevenue", paymentTrendRevenue);
                r.setAttribute("paymentTrendBookings", paymentTrendBookings);
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
        } else if ("deleteBooking".equals(a)) {
            String bookingId = n(r.getParameter("bookingId"));
            if (!bookingId.isBlank()) {
                new BookingDAO().cancel(Integer.parseInt(bookingId));
            }
            resp.sendRedirect(r.getHeader("Referer") != null ? r.getHeader("Referer") : (r.getContextPath() + "/admin/bookings"));
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

    private LocalDate p(String value) {
        if (value == null || value.trim().isEmpty()) return null;
        try {
            return LocalDate.parse(value.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private boolean m(LocalDate date, LocalDate start, LocalDate end) {
        if (date == null) return false;
        if (start != null && date.isBefore(start)) return false;
        if (end != null && date.isAfter(end)) return false;
        return true;
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

    private int pi(String value, int fallback) {
        if (value == null || value.trim().isEmpty()) return fallback;
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return fallback;
        }
    }

    private String csv(Object value) {
        if (value == null) return "\"\"";
        String text = String.valueOf(value).replace("\"", "\"\"");
        return "\"" + text + "\"";
    }
}
