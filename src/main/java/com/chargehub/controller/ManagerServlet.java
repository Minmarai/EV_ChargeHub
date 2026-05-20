package com.chargehub.controller;

import com.chargehub.dao.UserDAO;
import com.chargehub.model.Payment;
import com.chargehub.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/station-manager/*")
/**
 * Author: Imtiyaz Ansari
 */
public class ManagerServlet extends HttpServlet {
    private int uid(HttpServletRequest request) {
        return (int) request.getSession().getAttribute("userId");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();
        if (path == null) path = "/dashboard";
        int managerId = uid(request);
        StationDAO stationDAO = new StationDAO();

        switch (path) {
            case "/dashboard":
                loadDashboardData(request, managerId, stationDAO);
                forward(request, response, "manager/dashboard.jsp");
                break;
            case "/stations":
                List<Station> stations = stationDAO.findByManager(managerId);
                request.setAttribute("stations", stations);
                SlotDAO slotDAO = new SlotDAO();
                Map<Integer, Integer> availablePortsMap = new HashMap<>();
                for (Station s : stations) {
                    int booked = slotDAO.countBookedPortsByStation(s.getStationId());
                    int available = Math.max(0, s.getTotalPorts() - booked);
                    availablePortsMap.put(s.getStationId(), available);
                }
                request.setAttribute("availablePortsMap", availablePortsMap);
                if (!stations.isEmpty()) {
                    request.setAttribute("firstStationId", stations.get(0).getStationId());
                }
                forward(request, response, "manager/stations.jsp");
                break;
            case "/station-form":
                request.setAttribute("districts", new DistrictDAO().findAll());
                int stationFormId = Integer.parseInt(request.getParameter("id"));
                Station stationForm = stationDAO.findById(stationFormId);
                if (stationForm == null || stationForm.getManagerId() != managerId) {
                    response.sendRedirect(request.getContextPath() + "/error");
                    break;
                }
                request.setAttribute("station", stationForm);
                forward(request, response, "manager/station-form.jsp");
                break;
            case "/slots":
                request.setAttribute("stations", stationDAO.findByManager(managerId));
                request.setAttribute("slots", new SlotDAO().findByManager(managerId));
                forward(request, response, "manager/slots.jsp");
                break;
            case "/slot-form":
                request.setAttribute("stations", stationDAO.findByManager(managerId));
                if (request.getParameter("id") != null) {
                    int slotId = Integer.parseInt(request.getParameter("id"));
                    Slot slot = new SlotDAO().findById(slotId);
                    if (slot == null || !managerOwnsStation(managerId, slot.getStationId(), stationDAO)) {
                        response.sendRedirect(request.getContextPath() + "/error");
                        break;
                    }
                    request.setAttribute("slot", slot);
                }
                forward(request, response, "manager/slot-form.jsp");
                break;
            case "/bookings":
                request.setAttribute("bookings", new BookingDAO().findByManager(managerId));
                forward(request, response, "manager/bookings.jsp");
                break;
            case "/booking":
                Booking booking = new BookingDAO().findById(Integer.parseInt(request.getParameter("id")));
                if (booking == null || !managerOwnsStation(managerId, booking.getStationId(), stationDAO)) {
                    response.sendRedirect(request.getContextPath() + "/error");
                    break;
                }
                request.setAttribute("booking", booking);
                User user = new UserDAO().findById(booking.getUserId());
                request.setAttribute("bookingUser", user);
                forward(request, response, "manager/booking-details.jsp");
                break;
            case "/payments":
                List<Payment> payments = new PaymentDAO().findByManager(managerId);
                request.setAttribute("payments", payments);
                BigDecimal paymentsTotal = BigDecimal.ZERO;
                int paidCount = 0;
                int pendingCount = 0;
                int failedCount = 0;
                for (Payment payment : payments) {
                    if (payment.getAmount() != null) {
                        paymentsTotal = paymentsTotal.add(payment.getAmount());
                    }
                    if ("paid".equalsIgnoreCase(payment.getPaymentStatus())) paidCount++;
                    else if ("pending".equalsIgnoreCase(payment.getPaymentStatus())) pendingCount++;
                    else if ("failed".equalsIgnoreCase(payment.getPaymentStatus())) failedCount++;
                }
                request.setAttribute("paymentsTotal", paymentsTotal);
                request.setAttribute("paidCount", paidCount);
                request.setAttribute("pendingCount", pendingCount);
                request.setAttribute("failedCount", failedCount);
                forward(request, response, "manager/payments.jsp");
                break;
            case "/schedule":
                response.sendRedirect(request.getContextPath() + "/station-manager/slots");
                break;
            case "/payment":
                Payment paymentDetail = new PaymentDAO().findById(Integer.parseInt(request.getParameter("id")));
                if (paymentDetail == null) {
                    response.sendRedirect(request.getContextPath() + "/error");
                    break;
                }
                Booking paymentDetailBooking = new BookingDAO().findById(paymentDetail.getBookingId());
                if (paymentDetailBooking == null || !managerOwnsStation(managerId, paymentDetailBooking.getStationId(), stationDAO)) {
                    response.sendRedirect(request.getContextPath() + "/error");
                    break;
                }
                request.setAttribute("payment", paymentDetail);
                forward(request, response, "manager/payment-details.jsp");
                break;
            case "/reports":
                List<Booking> reportBookings = new BookingDAO().findByManager(managerId);
                List<Payment> reportPayments = new PaymentDAO().findByManager(managerId);
                List<Station> reportStations = stationDAO.findByManager(managerId);

                if ("csv".equalsIgnoreCase(request.getParameter("export"))) {
                    response.setContentType("text/csv;charset=UTF-8");
                    response.setHeader("Content-Disposition", "attachment; filename=station-manager-reports.csv");

                    Map<Integer, Integer> csvStationBookingCount = new HashMap<>();
                    Map<Integer, BigDecimal> csvStationRevenue = new HashMap<>();
                    Map<Integer, Station> stationById = new HashMap<>();
                    Map<String, Integer> stationIdByName = new HashMap<>();
                    for (Station station : reportStations) {
                        csvStationBookingCount.put(station.getStationId(), 0);
                        csvStationRevenue.put(station.getStationId(), BigDecimal.ZERO);
                        stationById.put(station.getStationId(), station);
                        stationIdByName.put(station.getStationName(), station.getStationId());
                    }

                    for (Booking reportBooking : reportBookings) {
                        Integer stationId = stationIdByName.get(reportBooking.getStationName());
                        if (stationId != null) {
                            csvStationBookingCount.put(stationId, csvStationBookingCount.getOrDefault(stationId, 0) + 1);
                        }
                    }

                    for (Payment payment : reportPayments) {
                        Integer stationId = stationIdByName.get(payment.getStationName());
                        if (stationId != null && payment.getAmount() != null) {
                            csvStationRevenue.put(stationId, csvStationRevenue.getOrDefault(stationId, BigDecimal.ZERO).add(payment.getAmount()));
                        }
                    }

                    List<Integer> stationIds = new ArrayList<>(csvStationBookingCount.keySet());
                    stationIds.sort(Integer::compareTo);

                    StringBuilder csv = new StringBuilder();
                    csv.append("Station ID,Station Name,District,Revenue (NPR),Bookings,Utilization (%),Status\n");
                    for (Integer stationId : stationIds) {
                        Station station = stationById.get(stationId);
                        if (station == null) continue;
                        int bookings = csvStationBookingCount.getOrDefault(stationId, 0);
                        int utilization = Math.min(100, bookings * 7);
                        BigDecimal revenue = csvStationRevenue.getOrDefault(stationId, BigDecimal.ZERO);

                        csv.append(csvValue(String.valueOf(station.getStationId()))).append(',');
                        csv.append(csvValue(station.getStationName())).append(',');
                        csv.append(csvValue(station.getDistrictName())).append(',');
                        csv.append(csvValue(revenue.toPlainString())).append(',');
                        csv.append(csvValue(String.valueOf(bookings))).append(',');
                        csv.append(csvValue(String.valueOf(utilization))).append(',');
                        csv.append(csvValue(station.getStatus())).append('\n');
                    }

                    response.getWriter().write(csv.toString());
                    break;
                }

                BigDecimal totalRevenue = BigDecimal.ZERO;
                for (Payment payment : reportPayments) {
                    if (payment.getAmount() != null) {
                        totalRevenue = totalRevenue.add(payment.getAmount());
                    }
                }

                int completedBookings = 0;
                int cancelledBookings = 0;
                int noShowBookings = 0;
                Map<String, Integer> slotUsage = new HashMap<>();
                for (Booking reportBooking : reportBookings) {
                    String bookingStatus = reportBooking.getBookingStatus() == null ? "" : reportBooking.getBookingStatus().toLowerCase();
                    if ("completed".equals(bookingStatus)) completedBookings++;
                    else if ("cancelled".equals(bookingStatus)) cancelledBookings++;
                    else if ("no-show".equals(bookingStatus) || "noshow".equals(bookingStatus)) noShowBookings++;

                    String slot = (reportBooking.getSlotInfo() == null || reportBooking.getSlotInfo().isBlank()) ? "09:00 - 10:00" : reportBooking.getSlotInfo();
                    slotUsage.put(slot, slotUsage.getOrDefault(slot, 0) + 1);
                }

                String mostUsedSlot = "09:00 - 10:00";
                int mostUsedSlotCount = 0;
                for (Map.Entry<String, Integer> entry : slotUsage.entrySet()) {
                    if (entry.getValue() > mostUsedSlotCount) {
                        mostUsedSlot = entry.getKey();
                        mostUsedSlotCount = entry.getValue();
                    }
                }

                int totalBookings = reportBookings.size();
                int completionRate = totalBookings == 0 ? 0 : (completedBookings * 100 / totalBookings);
                int avgUtilization = reportStations.isEmpty() ? 0 : Math.min(100, (totalBookings * 100) / (reportStations.size() * 20));

                Map<Integer, Integer> stationBookingCount = new HashMap<>();
                Map<Integer, BigDecimal> stationRevenue = new HashMap<>();
                Map<String, Integer> stationIdByName = new HashMap<>();
                for (Station station : reportStations) {
                    stationBookingCount.put(station.getStationId(), 0);
                    stationRevenue.put(station.getStationId(), BigDecimal.ZERO);
                    stationIdByName.put(station.getStationName(), station.getStationId());
                }

                for (Booking reportBooking : reportBookings) {
                    Integer stationId = stationIdByName.get(reportBooking.getStationName());
                    if (stationId != null) {
                        stationBookingCount.put(stationId, stationBookingCount.getOrDefault(stationId, 0) + 1);
                    }
                }
                for (Payment payment : reportPayments) {
                    Integer stationId = stationIdByName.get(payment.getStationName());
                    if (stationId != null && payment.getAmount() != null) {
                        stationRevenue.put(stationId, stationRevenue.getOrDefault(stationId, BigDecimal.ZERO).add(payment.getAmount()));
                    }
                }

                request.setAttribute("reportBookings", reportBookings);
                request.setAttribute("reportPayments", reportPayments);
                request.setAttribute("reportStations", reportStations);
                request.setAttribute("totalRevenue", totalRevenue);
                request.setAttribute("totalBookings", totalBookings);
                request.setAttribute("completionRate", completionRate);
                request.setAttribute("avgUtilization", avgUtilization);
                request.setAttribute("completedBookings", completedBookings);
                request.setAttribute("cancelledBookings", cancelledBookings);
                request.setAttribute("noShowBookings", noShowBookings);
                request.setAttribute("mostUsedSlot", mostUsedSlot);
                request.setAttribute("mostUsedSlotCount", mostUsedSlotCount);
                request.setAttribute("stationBookingCount", stationBookingCount);
                request.setAttribute("stationRevenue", stationRevenue);
                forward(request, response, "manager/reports.jsp");
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/station-manager/dashboard");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("saveSlot".equals(action)) {
            int managerId = uid(request);
            int stationId = Integer.parseInt(request.getParameter("stationId"));
            StationDAO stationDAO = new StationDAO();
            if (!managerOwnsStation(managerId, stationId, stationDAO)) {
                response.sendRedirect(request.getContextPath() + "/error");
                return;
            }

            Slot slot = new Slot();
            if (request.getParameter("slotId") != null && !request.getParameter("slotId").isBlank()) {
                int slotId = Integer.parseInt(request.getParameter("slotId"));
                Slot existing = new SlotDAO().findById(slotId);
                if (existing == null || !managerOwnsStation(managerId, existing.getStationId(), stationDAO)) {
                    response.sendRedirect(request.getContextPath() + "/error");
                    return;
                }
                slot.setSlotId(slotId);
            }
            slot.setStationId(stationId);
            slot.setSlotDate(Date.valueOf(request.getParameter("slotDate")));
            slot.setStartTime(Time.valueOf(request.getParameter("startTime") + ":00"));
            slot.setEndTime(Time.valueOf(request.getParameter("endTime") + ":00"));
            slot.setAvailabilityStatus(request.getParameter("status"));
            if (slot.getSlotId() > 0) new SlotDAO().update(slot);
            else new SlotDAO().save(slot);
            response.sendRedirect(request.getContextPath() + "/station-manager/slots");
        } else if ("saveStation".equals(action)) {
            int managerId = uid(request);
            int stationId = Integer.parseInt(request.getParameter("stationId"));
            StationDAO stationDAO = new StationDAO();
            Station existing = stationDAO.findById(stationId);
            if (existing == null || existing.getManagerId() != managerId) {
                response.sendRedirect(request.getContextPath() + "/error");
                return;
            }

            Station station = new Station();
            station.setStationId(stationId);
            station.setManagerId(managerId);
            station.setStationName(request.getParameter("stationName"));
            station.setDistrictId(Integer.parseInt(request.getParameter("districtId")));
            station.setAddress(request.getParameter("address"));
            station.setContactNumber(request.getParameter("contactNumber"));
            station.setChargerType(request.getParameter("chargerType"));
            station.setTotalPorts(Integer.parseInt(request.getParameter("totalPorts")));
            station.setOpeningTime(Time.valueOf(request.getParameter("openingTime") + ":00"));
            station.setClosingTime(Time.valueOf(request.getParameter("closingTime") + ":00"));
            station.setPricePerHour(new BigDecimal(request.getParameter("pricePerHour")));
            station.setStatus(request.getParameter("status"));

            stationDAO.update(station);
            response.sendRedirect(request.getContextPath() + "/station-manager/stations");
        } else if ("createStation".equals(action)) {
            int managerId = uid(request);
            Station s = new Station();
            s.setManagerId(managerId);
            s.setStationName("New Station");
            s.setDistrictId(1);
            s.setAddress("");
            s.setContactNumber("");
            s.setChargerType("Type 2");
            s.setTotalPorts(2);
            s.setOpeningTime(Time.valueOf("06:00:00"));
            s.setClosingTime(Time.valueOf("22:00:00"));
            s.setPricePerHour(new BigDecimal("100"));
            s.setStatus("inactive");
            new StationDAO().save(s);
            StationDAO newStationDAO = new StationDAO();
            List<Station> managerStations = newStationDAO.findByManager(managerId);
            if (!managerStations.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/station-manager/station-form?id=" + managerStations.get(0).getStationId());
            } else {
                response.sendRedirect(request.getContextPath() + "/station-manager/stations");
            }
        } else if ("deleteStation".equals(action)) {
            int managerId = uid(request);
            int stationId = Integer.parseInt(request.getParameter("stationId"));
            Station station = new StationDAO().findById(stationId);
            if (station != null && station.getManagerId() == managerId) {
                new StationDAO().delete(stationId);
            }
            response.sendRedirect(request.getContextPath() + "/station-manager/stations");
        } else if ("saveSchedule".equals(action) || "discardSchedule".equals(action)) {
            response.sendRedirect(request.getContextPath() + "/station-manager/slots");
        } else if ("disableSlot".equals(action)) {
            int managerId = uid(request);
            int slotId = Integer.parseInt(request.getParameter("slotId"));
            Slot slot = new SlotDAO().findById(slotId);
            if (slot != null && managerOwnsStation(managerId, slot.getStationId(), new StationDAO())) {
                new SlotDAO().updateStatus(slotId, "inactive");
            }
            response.sendRedirect(request.getContextPath() + "/station-manager/slots");
        } else if ("enableSlot".equals(action)) {
            int managerId = uid(request);
            int slotId = Integer.parseInt(request.getParameter("slotId"));
            Slot slot = new SlotDAO().findById(slotId);
            if (slot != null && managerOwnsStation(managerId, slot.getStationId(), new StationDAO())) {
                new SlotDAO().updateStatus(slotId, "available");
            }
            response.sendRedirect(request.getContextPath() + "/station-manager/slots");
        } else if ("bulkDisableSlots".equals(action)) {
            int managerId = uid(request);
            String[] slotIds = request.getParameterValues("slotIds");
            if (slotIds != null) {
                SlotDAO slotDAO = new SlotDAO();
                for (String slotId : slotIds) {
                    Slot slot = slotDAO.findById(Integer.parseInt(slotId));
                    if (slot != null && managerOwnsStation(managerId, slot.getStationId(), new StationDAO())) {
                        slotDAO.updateStatus(Integer.parseInt(slotId), "inactive");
                    }
                }
            }
            response.sendRedirect(request.getContextPath() + "/station-manager/slots");
        } else if ("bulkDeleteSlots".equals(action)) {
            int managerId = uid(request);
            String[] slotIds = request.getParameterValues("slotIds");
            if (slotIds != null) {
                SlotDAO slotDAO = new SlotDAO();
                for (String slotId : slotIds) {
                    Slot slot = slotDAO.findById(Integer.parseInt(slotId));
                    if (slot != null && managerOwnsStation(managerId, slot.getStationId(), new StationDAO())) {
                        slotDAO.delete(Integer.parseInt(slotId));
                    }
                }
            }
            response.sendRedirect(request.getContextPath() + "/station-manager/slots");
        } else if ("deleteSlot".equals(action)) {
            int managerId = uid(request);
            int slotId = Integer.parseInt(request.getParameter("slotId"));
            Slot slot = new SlotDAO().findById(slotId);
            if (slot != null && managerOwnsStation(managerId, slot.getStationId(), new StationDAO())) {
                new SlotDAO().delete(slotId);
            }
            response.sendRedirect(request.getContextPath() + "/station-manager/slots");
        } else if ("bookingStatus".equals(action)) {
            int managerId = uid(request);
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            Booking booking = new BookingDAO().findById(bookingId);
            if (booking != null && managerOwnsStation(managerId, booking.getStationId(), new StationDAO())) {
                new BookingDAO().updateStatus(bookingId, request.getParameter("status"));
            }
            response.sendRedirect(request.getContextPath() + "/station-manager/bookings");
        } else if ("paymentStatus".equals(action)) {
            int managerId = uid(request);
            int paymentId = Integer.parseInt(request.getParameter("paymentId"));
            Payment payment = new PaymentDAO().findById(paymentId);
            if (payment != null) {
                Booking booking = new BookingDAO().findById(payment.getBookingId());
                if (booking != null && managerOwnsStation(managerId, booking.getStationId(), new StationDAO())) {
                    new PaymentDAO().updateStatus(paymentId, request.getParameter("status"));
                }
            }
            response.sendRedirect(request.getContextPath() + "/station-manager/payments");
        }
    }

    private boolean managerOwnsStation(int managerId, int stationId, StationDAO stationDAO) {
        Station station = stationDAO.findById(stationId);
        return station != null && station.getManagerId() == managerId;
    }

    private void loadDashboardData(HttpServletRequest request, int managerId, StationDAO stationDAO) {
        BookingDAO bookingDAO = new BookingDAO();
        PaymentDAO paymentDAO = new PaymentDAO();
        
        bookingDAO.syncCompletedFromPayments(managerId);

        List<Booking> managerBookings = bookingDAO.findByManager(managerId);
        List<Payment> managerPayments = paymentDAO.findByManager(managerId);

        int totalBookings = managerBookings.size();
        int todayBookings = 0;
        LocalDate today = LocalDate.now();
        for (Booking booking : managerBookings) {
            if (booking.getBookingDate() != null && booking.getBookingDate().toLocalDateTime().toLocalDate().equals(today)) {
                todayBookings++;
            }
        }

        BigDecimal pendingAmount = BigDecimal.ZERO;
        for (Payment payment : managerPayments) {
            if ("pending".equalsIgnoreCase(payment.getPaymentStatus()) && payment.getAmount() != null) {
                pendingAmount = pendingAmount.add(payment.getAmount());
            }
        }

        request.setAttribute("stationCount", stationDAO.findByManager(managerId).size());
        request.setAttribute("slotCount", new SlotDAO().countByManager(managerId));
        request.setAttribute("bookingCount", totalBookings);
        request.setAttribute("todayBookings", todayBookings);
        request.setAttribute("pendingAmount", pendingAmount);
        request.setAttribute("recentBookings", managerBookings.subList(0, Math.min(5, managerBookings.size())));
        request.setAttribute("dashboardDate", today.format(DateTimeFormatter.ofPattern("EEEE, MMM d, yyyy")));
    }

    private void forward(HttpServletRequest request, HttpServletResponse response, String page) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/" + page).forward(request, response);
    }

    private String csvValue(String input) {
        if (input == null) return "";
        String escaped = input.replace("\"", "\"\"");
        if (escaped.contains(",") || escaped.contains("\n")) return '"' + escaped + '"';
        return escaped;
    }
}
