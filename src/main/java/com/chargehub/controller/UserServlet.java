package com.chargehub.controller;

import com.chargehub.dao.*;import com.chargehub.model.*;
import com.chargehub.util.PasswordUtil;
import jakarta.servlet.*;import jakarta.servlet.annotation.WebServlet;import jakarta.servlet.http.*;import java.io.IOException;import java.math.BigDecimal;import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.Duration;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet("/user/*")
/**
 * Author: Kirti Dahal
 */
public class UserServlet extends HttpServlet {
 private int uid(HttpServletRequest r){return (int)r.getSession().getAttribute("userId");}
 protected void doGet(HttpServletRequest r,HttpServletResponse resp)throws ServletException,IOException{
  String p=r.getPathInfo(); if(p==null)p="/dashboard"; int userId=uid(r);
  switch(p){
   case "/dashboard":
    r.setAttribute("activePage","dashboard");
    BookingDAO bookingDAO=new BookingDAO();
    PaymentDAO paymentDAO=new PaymentDAO();
    List<Booking> userBookings=bookingDAO.findByUser(userId);
    List<Payment> userPayments=paymentDAO.findByUser(userId);
    int upcomingBookings=0;
    LocalDate today=LocalDate.now();
    BigDecimal totalPaymentAmount=BigDecimal.ZERO;

    for(Booking booking:userBookings){
     if(isUpcomingBooking(booking,today)) upcomingBookings++;
    }
    for(Payment payment:userPayments){
     if(payment.getAmount()!=null&&"paid".equalsIgnoreCase(payment.getPaymentStatus())) totalPaymentAmount=totalPaymentAmount.add(payment.getAmount());
    }

    r.setAttribute("bookings",userBookings);
    r.setAttribute("bookingCount",userBookings.size());
    r.setAttribute("upcomingBookings",upcomingBookings);
    r.setAttribute("payments",userPayments);
    r.setAttribute("paymentCount",userPayments.size());
    r.setAttribute("totalPaymentAmount",totalPaymentAmount);
    r.setAttribute("favCount",new FavoriteDAO().countByUser(userId));
    f(r,resp,"user/dashboard.jsp");
    break;
    case "/stations":
     r.setAttribute("activePage","stations");
      DistrictDAO districtDAO=new DistrictDAO();
      StationDAO stationDAO=new StationDAO();
      r.setAttribute("districts",districtDAO.findWithStations());
      r.setAttribute("chargerTypes",stationDAO.findActiveChargerTypes());
      r.setAttribute("stationStatuses",stationDAO.findAvailableStatuses());
     Integer did=null;
     try{did=Integer.parseInt(r.getParameter("districtId"));}catch(Exception ignored){}
     String chargerType=r.getParameter("chargerType");
     String status=r.getParameter("status");
     String keyword=r.getParameter("q");
     r.setAttribute("selectedDistrictId",did);
     r.setAttribute("selectedChargerType",chargerType);
     r.setAttribute("selectedStatus",status);
     r.setAttribute("searchKeyword",keyword);
      r.setAttribute("stations",stationDAO.search(did,chargerType,status,keyword));
      f(r,resp,"user/stations.jsp");
      break;
    case "/station-list":
     r.setAttribute("activePage","station-list");
     r.setAttribute("stations",new StationDAO().search(null,null,"active",null));
     r.setAttribute("favoriteStationIds",new FavoriteDAO().findStationIdsByUser(userId));
     f(r,resp,"user/station-list.jsp");
     break;
     case "/station":
      r.setAttribute("activePage","station-list".equals(r.getParameter("from"))?"station-list":"stations");
      int stationId=Integer.parseInt(r.getParameter("id"));
     Set<Integer> favoriteStationIds=new FavoriteDAO().findStationIdsByUser(userId);
     List<Slot> stationSlots=new SlotDAO().findByStation(stationId);
     int availableSlotCount=0;
     for(Slot slot:stationSlots){
      if(slot!=null&&slot.getAvailabilityStatus()!=null&&"available".equalsIgnoreCase(slot.getAvailabilityStatus())) availableSlotCount++;
     }
     r.setAttribute("isFavorite",favoriteStationIds.contains(stationId));
     r.setAttribute("station",new StationDAO().findById(stationId));
     r.setAttribute("slots",stationSlots);
     r.setAttribute("availableSlotCount",availableSlotCount);
      r.setAttribute("reviews",new ReviewDAO().findByStation(stationId));
      f(r,resp,"user/station-details.jsp");
      break;
     case "/book-slot":
       String fromPage=r.getParameter("from");
      r.setAttribute("activePage","station-list".equals(fromPage)?"station-list":"stations");
      int bookStationId=Integer.parseInt(r.getParameter("stationId"));
      List<Slot> availableSlots=new SlotDAO().findAvailableByStation(bookStationId);
      String selectedBookingDate=r.getParameter("bookingDate");
      if(selectedBookingDate!=null) selectedBookingDate=selectedBookingDate.trim();
      boolean selectedDateHasSlot=false;
      if(selectedBookingDate!=null&&!selectedBookingDate.isEmpty()){
       for(Slot slot:availableSlots){
        if(slot!=null&&slot.getSlotDate()!=null&&selectedBookingDate.equals(slot.getSlotDate().toString())){
         selectedDateHasSlot=true;
         break;
        }
       }
      }
      if(!selectedDateHasSlot) selectedBookingDate=null;
      if((selectedBookingDate==null||selectedBookingDate.trim().isEmpty())&&!availableSlots.isEmpty()&&availableSlots.get(0).getSlotDate()!=null){
       selectedBookingDate=availableSlots.get(0).getSlotDate().toString();
      }
      r.setAttribute("fromPage",fromPage);
      r.setAttribute("station",new StationDAO().findById(bookStationId));
      r.setAttribute("availableSlots",availableSlots);
      r.setAttribute("selectedBookingDate",selectedBookingDate);
       r.setAttribute("minBookingDate",LocalDate.now().toString());
       f(r,resp,"user/book-slot.jsp");
       break;
    case "/booking-confirmation":
      Integer bookingId=parseInt(r.getParameter("bookingId"));
      if(bookingId==null){resp.sendRedirect(r.getContextPath()+"/user/bookings"); break;}
      Booking booked=new BookingDAO().findById(bookingId);
      if(booked==null||booked.getUserId()!=userId){resp.sendRedirect(r.getContextPath()+"/user/bookings"); break;}
      String bookingFromPage=r.getParameter("fromPage");
      r.setAttribute("activePage","station-list".equals(bookingFromPage)?"station-list":"stations");
      Station bookedStation=new StationDAO().findById(booked.getStationId());
      Slot bookedSlot=new SlotDAO().findById(booked.getSlotId());
      String slotDateFormatted="-";
      String slotTimeFormatted="-";
      String durationLabel="-";
      BigDecimal estimatedCost=booked.getAmount();
      if(bookedSlot!=null&&bookedSlot.getSlotDate()!=null){
       slotDateFormatted=bookedSlot.getSlotDate().toLocalDate().format(DateTimeFormatter.ofPattern("MMMM d, yyyy"));
      }
      if(bookedSlot!=null&&bookedSlot.getStartTime()!=null&&bookedSlot.getEndTime()!=null){
       slotTimeFormatted=bookedSlot.getStartTime().toLocalTime().format(DateTimeFormatter.ofPattern("HH:mm"))+" - "+bookedSlot.getEndTime().toLocalTime().format(DateTimeFormatter.ofPattern("HH:mm"));
       long minutes=Duration.between(bookedSlot.getStartTime().toLocalTime(),bookedSlot.getEndTime().toLocalTime()).toMinutes();
       if(minutes>0){
        BigDecimal durationHours=BigDecimal.valueOf(minutes).divide(BigDecimal.valueOf(60),1,RoundingMode.HALF_UP);
        durationLabel=durationHours.stripTrailingZeros().toPlainString()+" hrs";
        if(estimatedCost==null&&bookedStation!=null&&bookedStation.getPricePerHour()!=null){
         estimatedCost=bookedStation.getPricePerHour().multiply(durationHours).setScale(2,RoundingMode.HALF_UP);
        }
       }
      }
      if(estimatedCost==null&&bookedStation!=null&&bookedStation.getPricePerHour()!=null) estimatedCost=bookedStation.getPricePerHour().setScale(2,RoundingMode.HALF_UP);
      if(estimatedCost==null) estimatedCost=BigDecimal.ZERO.setScale(2,RoundingMode.HALF_UP);
      r.setAttribute("booking",booked);
      r.setAttribute("station",bookedStation);
      r.setAttribute("slot",bookedSlot);
      r.setAttribute("slotDateFormatted",slotDateFormatted);
      r.setAttribute("slotTimeFormatted",slotTimeFormatted);
      r.setAttribute("durationLabel",durationLabel);
      r.setAttribute("estimatedCost",estimatedCost);
      f(r,resp,"user/booking-confirmation.jsp");
      break;
    case "/bookings":
      r.setAttribute("activePage","bookings");
      new BookingDAO().syncUserBookings(userId);
      String filterDateRaw=r.getParameter("bookingDate");
      String filterStatusRaw=r.getParameter("status");
      String searchRaw=r.getParameter("q");
      String filterDate=filterDateRaw!=null?filterDateRaw.trim():"";
      String filterStatus=filterStatusRaw!=null?filterStatusRaw.trim().toLowerCase():"";
      String searchTerm=searchRaw!=null?searchRaw.trim().toLowerCase():"";
      List<Booking> allBookings=new BookingDAO().findByUser(userId);
      List<Booking> filteredBookings=new ArrayList<>();
      Map<Integer,String> bookingStatusLabels=new HashMap<>();
      Map<Integer,String> bookingSlotDates=new HashMap<>();
      Map<Integer,String> bookingSlotTimes=new HashMap<>();
      LocalDate todayForStatus=LocalDate.now();
      for(Booking entry:allBookings){
       String slotDateKey=slotDateKey(entry.getSlotInfo());
       String slotDate=slotDate(entry.getSlotInfo());
       String slotTime=slotTime(entry.getSlotInfo());
       String displayStatus=displayStatus(entry,todayForStatus);
       String stationName=entry.getStationName()!=null?entry.getStationName().toLowerCase():"";
       String slotInfo=entry.getSlotInfo()!=null?entry.getSlotInfo().toLowerCase():"";
       String bookingLabel=("chn-"+entry.getBookingId()).toLowerCase();
       bookingStatusLabels.put(entry.getBookingId(),displayStatus);
       bookingSlotDates.put(entry.getBookingId(),slotDate);
       bookingSlotTimes.put(entry.getBookingId(),slotTime);
       boolean matchesDate=filterDate.isEmpty()||filterDate.equals(slotDateKey);
       boolean matchesStatus=filterStatus.isEmpty()||filterStatus.equals(displayStatus.toLowerCase());
       boolean matchesSearch=searchTerm.isEmpty()||bookingLabel.contains(searchTerm)||stationName.contains(searchTerm)||slotInfo.contains(searchTerm)||displayStatus.toLowerCase().contains(searchTerm);
       if(matchesDate&&matchesStatus&&matchesSearch) filteredBookings.add(entry);
      }
      if("csv".equalsIgnoreCase(r.getParameter("export"))){
       resp.setContentType("text/csv;charset=UTF-8");
       resp.setHeader("Content-Disposition","attachment; filename=booking-history.csv");
       StringBuilder csv=new StringBuilder();
       csv.append("Booking ID,Station,Date,Slot,Status\n");
       for(Booking entry:filteredBookings){
        csv.append(csvValue("CHN-"+entry.getBookingId())).append(',');
        csv.append(csvValue(entry.getStationName())).append(',');
        csv.append(csvValue(slotDate(entry.getSlotInfo()))).append(',');
        csv.append(csvValue(slotTime(entry.getSlotInfo()))).append(',');
        csv.append(csvValue(displayStatus(entry,todayForStatus))).append('\n');
       }
       resp.getWriter().write(csv.toString());
       break;
      }
      r.setAttribute("bookings",filteredBookings);
      r.setAttribute("bookingDateFilter",filterDate);
      r.setAttribute("bookingStatusFilter",filterStatus);
      r.setAttribute("bookingSearchFilter",searchRaw!=null?searchRaw.trim():"");
      r.setAttribute("totalBookingCount",allBookings.size());
      r.setAttribute("bookingStatusLabels",bookingStatusLabels);
      r.setAttribute("bookingSlotDates",bookingSlotDates);
      r.setAttribute("bookingSlotTimes",bookingSlotTimes);
      f(r,resp,"user/bookings.jsp");
      break;
    case "/booking":
      r.setAttribute("activePage","bookings");
      Integer detailBookingId=parseInt(r.getParameter("id"));
      if(detailBookingId==null){resp.sendRedirect(r.getContextPath()+"/user/bookings"); break;}
      Booking detailBooking=new BookingDAO().findById(detailBookingId);
      if(detailBooking==null||detailBooking.getUserId()!=userId){resp.sendRedirect(r.getContextPath()+"/user/bookings"); break;}
      Station detailStation=new StationDAO().findById(detailBooking.getStationId());
      Slot detailSlot=new SlotDAO().findById(detailBooking.getSlotId());
      String detailSlotDate="-";
      String detailSlotTime="-";
      String detailDuration="-";
      if(detailSlot!=null&&detailSlot.getSlotDate()!=null){
       detailSlotDate=detailSlot.getSlotDate().toLocalDate().format(DateTimeFormatter.ofPattern("MMMM d, yyyy"));
      }
      if(detailSlot!=null&&detailSlot.getStartTime()!=null&&detailSlot.getEndTime()!=null){
       detailSlotTime=detailSlot.getStartTime().toLocalTime().format(DateTimeFormatter.ofPattern("HH:mm"))+" - "+detailSlot.getEndTime().toLocalTime().format(DateTimeFormatter.ofPattern("HH:mm"));
       long mins=Duration.between(detailSlot.getStartTime().toLocalTime(),detailSlot.getEndTime().toLocalTime()).toMinutes();
       if(mins>0){
        long hours=mins/60;
        long minutes=mins%60;
        detailDuration=(hours>0?hours+"h ":"")+minutes+"m";
       }
      }
      String bookedOn="-";
      if(detailBooking.getBookingDate()!=null){
       bookedOn=detailBooking.getBookingDate().toLocalDateTime().format(DateTimeFormatter.ofPattern("MMM d, yyyy, hh:mm a"));
      }
      String detailDisplayStatus=displayStatus(detailBooking,LocalDate.now());
      BigDecimal detailAmount=detailBooking.getAmount();
      if(detailAmount==null&&detailStation!=null&&detailStation.getPricePerHour()!=null&&detailSlot!=null&&detailSlot.getStartTime()!=null&&detailSlot.getEndTime()!=null){
       long mins=Duration.between(detailSlot.getStartTime().toLocalTime(),detailSlot.getEndTime().toLocalTime()).toMinutes();
       if(mins>0){
        BigDecimal hrs=BigDecimal.valueOf(mins).divide(BigDecimal.valueOf(60),2,RoundingMode.HALF_UP);
        detailAmount=detailStation.getPricePerHour().multiply(hrs).setScale(2,RoundingMode.HALF_UP);
       }
      }
      if(detailAmount==null) detailAmount=BigDecimal.ZERO.setScale(2,RoundingMode.HALF_UP);
      r.setAttribute("booking",detailBooking);
      r.setAttribute("station",detailStation);
      r.setAttribute("slot",detailSlot);
      r.setAttribute("detailSlotDate",detailSlotDate);
      r.setAttribute("detailSlotTime",detailSlotTime);
      r.setAttribute("detailDuration",detailDuration);
      r.setAttribute("bookedOn",bookedOn);
      r.setAttribute("detailDisplayStatus",detailDisplayStatus);
      r.setAttribute("detailAmount",detailAmount);
      f(r,resp,"user/booking-details.jsp");
      break;
    case "/payment":
      r.setAttribute("activePage","bookings");
      Integer paymentBookingId=parseInt(r.getParameter("bookingId"));
      if(paymentBookingId==null){resp.sendRedirect(r.getContextPath()+"/user/bookings"); break;}
      Booking paymentBooking=new BookingDAO().findById(paymentBookingId);
      if(paymentBooking==null||paymentBooking.getUserId()!=userId){resp.sendRedirect(r.getContextPath()+"/user/bookings"); break;}
      Station paymentStation=new StationDAO().findById(paymentBooking.getStationId());
      Slot paymentSlot=new SlotDAO().findById(paymentBooking.getSlotId());
      String paymentDate="-";
      String paymentTime="-";
      String paymentDuration="-";
      if(paymentSlot!=null&&paymentSlot.getSlotDate()!=null){
       paymentDate=paymentSlot.getSlotDate().toLocalDate().format(DateTimeFormatter.ofPattern("MMM d, yyyy"));
      }
      long paymentMinutes=0;
      if(paymentSlot!=null&&paymentSlot.getStartTime()!=null&&paymentSlot.getEndTime()!=null){
       paymentTime=paymentSlot.getStartTime().toLocalTime().format(DateTimeFormatter.ofPattern("hh:mm a"))+" - "+paymentSlot.getEndTime().toLocalTime().format(DateTimeFormatter.ofPattern("hh:mm a"));
       paymentMinutes=Duration.between(paymentSlot.getStartTime().toLocalTime(),paymentSlot.getEndTime().toLocalTime()).toMinutes();
       if(paymentMinutes>0){
        long hrs=paymentMinutes/60;
        long mins=paymentMinutes%60;
        paymentDuration=(hrs>0?hrs+"h ":"")+mins+"m";
       }
      }
      BigDecimal paymentAmount=paymentBooking.getAmount();
      BigDecimal paymentRate=BigDecimal.ZERO.setScale(2,RoundingMode.HALF_UP);
      if(paymentStation!=null&&paymentStation.getPricePerHour()!=null) paymentRate=paymentStation.getPricePerHour().setScale(2,RoundingMode.HALF_UP);
      if(paymentAmount==null&&paymentMinutes>0&&paymentStation!=null&&paymentStation.getPricePerHour()!=null){
       BigDecimal hrs=BigDecimal.valueOf(paymentMinutes).divide(BigDecimal.valueOf(60),2,RoundingMode.HALF_UP);
       paymentAmount=paymentStation.getPricePerHour().multiply(hrs).setScale(2,RoundingMode.HALF_UP);
      }
      if(paymentAmount==null) paymentAmount=BigDecimal.ZERO.setScale(2,RoundingMode.HALF_UP);
      r.setAttribute("booking",paymentBooking);
      r.setAttribute("station",paymentStation);
      r.setAttribute("slot",paymentSlot);
      r.setAttribute("paymentDate",paymentDate);
      r.setAttribute("paymentTime",paymentTime);
      r.setAttribute("paymentDuration",paymentDuration);
      r.setAttribute("paymentAmount",paymentAmount);
      r.setAttribute("paymentRate",paymentRate);
      f(r,resp,"user/payment.jsp");
      break;
    case "/payments":
      r.setAttribute("activePage","payments");
      String paymentSearchRaw=r.getParameter("q");
      String paymentStatusRaw=r.getParameter("status");
      Integer paymentPageParam=parseInt(r.getParameter("page"));
      String paymentSearch=paymentSearchRaw!=null?paymentSearchRaw.trim().toLowerCase():"";
      String paymentStatusFilter=paymentStatusRaw!=null?paymentStatusRaw.trim().toLowerCase():"";
      if("paid".equals(paymentStatusFilter)) paymentStatusFilter="success";
      String paymentStatusDbFilter="";
      if("success".equals(paymentStatusFilter)) paymentStatusDbFilter="paid";
      else if("pending".equals(paymentStatusFilter)) paymentStatusDbFilter="pending";
      List<Payment> allPayments=new PaymentDAO().findByUser(userId);
      List<Payment> filteredPayments=new ArrayList<>();
      Map<Integer,String> paymentDateLabels=new HashMap<>();
      for(Payment pmt:allPayments){
        String paymentStatusValue=pmt.getPaymentStatus()!=null?pmt.getPaymentStatus().trim().toLowerCase():"pending";
       String paymentDateLabel="-";
       if(pmt.getPaymentDate()!=null){
        paymentDateLabel=pmt.getPaymentDate().toLocalDateTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
       }
       paymentDateLabels.put(pmt.getPaymentId(),paymentDateLabel);
       String paymentIdLabel=("pay-"+pmt.getPaymentId()).toLowerCase();
        String bookingIdLabel=("chn-"+pmt.getBookingId()).toLowerCase();
        String methodLabel=pmt.getPaymentMethod()!=null?pmt.getPaymentMethod().toLowerCase():"";
        String stationLabel=pmt.getStationName()!=null?pmt.getStationName().toLowerCase():"";
        boolean matchesSearch=paymentSearch.isEmpty()||paymentIdLabel.contains(paymentSearch)||bookingIdLabel.contains(paymentSearch)||methodLabel.contains(paymentSearch)||stationLabel.contains(paymentSearch);
        boolean matchesStatus=paymentStatusDbFilter.isEmpty()||paymentStatusValue.equals(paymentStatusDbFilter);
        if(matchesSearch&&matchesStatus) filteredPayments.add(pmt);
      }
      if("csv".equalsIgnoreCase(r.getParameter("export"))){
       resp.setContentType("text/csv;charset=UTF-8");
       resp.setHeader("Content-Disposition","attachment; filename=payment-history.csv");
       StringBuilder csv=new StringBuilder();
       csv.append("Payment ID,Booking ID,Amount,Payment Method,Status,Payment Date\n");
       for(Payment pmt:filteredPayments){
        csv.append(csvValue("PAY-"+pmt.getPaymentId())).append(',');
        csv.append(csvValue("CHN-"+pmt.getBookingId())).append(',');
        csv.append(csvValue(pmt.getAmount()!=null?pmt.getAmount().toString():"0.00")).append(',');
        csv.append(csvValue(pmt.getPaymentMethod())).append(',');
        csv.append(csvValue(pmt.getPaymentStatus())).append(',');
        csv.append(csvValue(paymentDateLabels.get(pmt.getPaymentId()))).append('\n');
       }
       resp.getWriter().write(csv.toString());
       break;
      }
      int pageSize=8;
      int currentPage=paymentPageParam!=null&&paymentPageParam>0?paymentPageParam:1;
      int totalFilteredCount=filteredPayments.size();
      int totalPages=totalFilteredCount==0?1:(int)Math.ceil((double)totalFilteredCount/pageSize);
      if(currentPage>totalPages) currentPage=totalPages;
      int startIndex=(currentPage-1)*pageSize;
      int endIndex=Math.min(startIndex+pageSize,totalFilteredCount);
      List<Payment> pagedPayments=totalFilteredCount==0?new ArrayList<>():filteredPayments.subList(startIndex,endIndex);
      r.setAttribute("payments",pagedPayments);
      r.setAttribute("paymentDateLabels",paymentDateLabels);
      r.setAttribute("paymentSearchFilter",paymentSearchRaw!=null?paymentSearchRaw.trim():"");
      r.setAttribute("paymentStatusFilter",paymentStatusFilter);
      r.setAttribute("totalPaymentCount",totalFilteredCount);
      r.setAttribute("currentPage",currentPage);
      r.setAttribute("totalPages",totalPages);
      r.setAttribute("pageSize",pageSize);
      r.setAttribute("startResult",totalFilteredCount==0?0:startIndex+1);
      r.setAttribute("endResult",endIndex);
      r.setAttribute("hasPrev",currentPage>1);
      r.setAttribute("hasNext",currentPage<totalPages);
      r.setAttribute("prevPage",currentPage-1);
      r.setAttribute("nextPage",currentPage+1);
      f(r,resp,"user/payments.jsp");
      break;
    case "/favorites": r.setAttribute("activePage","favorites"); r.setAttribute("favorites",new FavoriteDAO().findByUser(userId)); f(r,resp,"user/favorites.jsp"); break;
    case "/reviews":
      r.setAttribute("activePage","reviews");
      r.setAttribute("stations",new StationDAO().search(null,null,"active",null));
      r.setAttribute("userReviews",new ReviewDAO().findByUser(userId));
      f(r,resp,"user/reviews.jsp");
      break;
    case "/profile":
      r.setAttribute("activePage","profile");
      User profileUser=new UserDAO().findById(userId);
      List<Booking> profileBookings=new BookingDAO().findByUser(userId);
      List<Payment> profilePayments=new PaymentDAO().findByUser(userId);
      int upcomingCount=0;
      LocalDate profileToday=LocalDate.now();
      BigDecimal profileSpent=BigDecimal.ZERO;
      for(Booking booking:profileBookings){
       if(isUpcomingBooking(booking,profileToday)) upcomingCount++;
      }
      for(Payment payment:profilePayments){
       if(payment.getAmount()!=null&&"paid".equalsIgnoreCase(payment.getPaymentStatus())) profileSpent=profileSpent.add(payment.getAmount());
      }
      int favoriteCount=new FavoriteDAO().countByUser(userId);
      int reviewCount=new ReviewDAO().findByUser(userId).size();
      r.setAttribute("user",profileUser);
      r.setAttribute("bookingCount",profileBookings.size());
      r.setAttribute("upcomingCount",upcomingCount);
      r.setAttribute("profileSpent",profileSpent);
      r.setAttribute("favoriteCount",favoriteCount);
      r.setAttribute("reviewCount",reviewCount);
      r.setAttribute("profileUpdated", "1".equals(r.getParameter("updated")) ? "true" : "false");
      r.setAttribute("passwordUpdated", "1".equals(r.getParameter("pwdUpdated")) ? "true" : "false");
      r.setAttribute("passwordError", r.getParameter("pwdError"));
      f(r,resp,"user/profile.jsp");
      break;
   default: resp.sendRedirect(r.getContextPath()+"/user/dashboard");
  }
 }
 protected void doPost(HttpServletRequest r,HttpServletResponse resp)throws ServletException,IOException{
  String action=r.getParameter("action"); int userId=uid(r);
  if("book".equals(action)){
   int stationId=Integer.parseInt(r.getParameter("stationId"));
   int slotId=Integer.parseInt(r.getParameter("slotId"));
   Slot selectedSlot=new SlotDAO().findById(slotId);
   LocalDate today=LocalDate.now();
   boolean slotDateValid=selectedSlot!=null&&selectedSlot.getSlotDate()!=null&&!selectedSlot.getSlotDate().toLocalDate().isBefore(today);
   if(selectedSlot==null||selectedSlot.getStationId()!=stationId||!"available".equalsIgnoreCase(selectedSlot.getAvailabilityStatus())||!slotDateValid){
    resp.sendRedirect(r.getContextPath()+"/user/bookings");
    return;
   }
   Booking b=new Booking();
   b.setUserId(userId);
   b.setStationId(stationId);
   b.setSlotId(slotId);
   b.setVehicleNumber(r.getParameter("vehicleNumber"));
   b.setNotes(r.getParameter("notes"));
   Integer bookingId=new BookingDAO().createAndReturnId(b);
    if(bookingId!=null){
     resp.sendRedirect(r.getContextPath()+"/user/payment?bookingId="+bookingId);
    } else resp.sendRedirect(r.getContextPath()+"/user/bookings");
   }
  else if("cancelBooking".equals(action)){
   int bookingId=Integer.parseInt(r.getParameter("bookingId"));
   Booking booking=new BookingDAO().findById(bookingId);
   if(booking!=null&&booking.getUserId()==userId){
    new BookingDAO().cancel(bookingId);
   }
   resp.sendRedirect(r.getContextPath()+"/user/bookings");
  }
  else if("pay".equals(action)){
   int bookingId=Integer.parseInt(r.getParameter("bookingId"));
   Booking booking=new BookingDAO().findById(bookingId);
   if(booking==null||booking.getUserId()!=userId){
    resp.sendRedirect(r.getContextPath()+"/user/bookings");
    return;
   }
Payment p=new Payment();
    p.setBookingId(bookingId);
    p.setUserId(userId);
    p.setAmount(new BigDecimal(r.getParameter("amount")));
    p.setPaymentMethod(r.getParameter("paymentMethod"));
    p.setPaymentStatus("paid");
    p.setTransactionReference(r.getParameter("transactionReference"));
    p.setRemarks(r.getParameter("remarks"));
    new PaymentDAO().create(p);
    new BookingDAO().updateStatus(bookingId, "completed");
    resp.sendRedirect(r.getContextPath()+"/user/payments");
  }
  else if("favorite".equals(action)){ new FavoriteDAO().add(userId,Integer.parseInt(r.getParameter("stationId"))); String back=r.getHeader("Referer"); resp.sendRedirect(back!=null?back:r.getContextPath()+"/user/station-list"); }
  else if("removeFavorite".equals(action)){ new FavoriteDAO().remove(userId,Integer.parseInt(r.getParameter("stationId"))); String back=r.getHeader("Referer"); resp.sendRedirect(back!=null?back:r.getContextPath()+"/user/favorites"); }
  else if("review".equals(action)){ new ReviewDAO().add(userId,Integer.parseInt(r.getParameter("stationId")),Integer.parseInt(r.getParameter("rating")),r.getParameter("comment")); String redirectToReviews=r.getParameter("redirectToReviews"); if("true".equalsIgnoreCase(redirectToReviews)) resp.sendRedirect(r.getContextPath()+"/user/reviews?submitted=1"); else resp.sendRedirect(r.getContextPath()+"/user/station?id="+r.getParameter("stationId")+"&submitted=1"); }
  else if("profile".equals(action)){ User u=new User();u.setUserId(userId);u.setFullName(r.getParameter("fullName"));u.setEmail(r.getParameter("email"));u.setPhone(r.getParameter("phone"));u.setVehicleNumber(r.getParameter("vehicleNumber"));u.setAddress(r.getParameter("address"));new UserDAO().updateProfileWithEmail(u); r.getSession().setAttribute("fullName",u.getFullName()); resp.sendRedirect(r.getContextPath()+"/user/profile?updated=1"); }
  else if("changePassword".equals(action)){ String current=r.getParameter("currentPassword"); String next=r.getParameter("newPassword"); String confirm=r.getParameter("confirmPassword"); User existing=new UserDAO().findById(userId); if(existing==null){ resp.sendRedirect(r.getContextPath()+"/user/profile?pwdError=user"); } else if(current==null||next==null||confirm==null||current.trim().isEmpty()||next.trim().isEmpty()||confirm.trim().isEmpty()){ resp.sendRedirect(r.getContextPath()+"/user/profile?pwdError=blank"); } else if(!PasswordUtil.checkPassword(current,existing.getPasswordHash())){ resp.sendRedirect(r.getContextPath()+"/user/profile?pwdError=current"); } else if(next.length()<8){ resp.sendRedirect(r.getContextPath()+"/user/profile?pwdError=length"); } else if(!next.equals(confirm)){ resp.sendRedirect(r.getContextPath()+"/user/profile?pwdError=match"); } else { new UserDAO().updatePasswordHash(userId,PasswordUtil.hashPassword(next)); resp.sendRedirect(r.getContextPath()+"/user/profile?pwdUpdated=1"); } }
 }
 private void f(HttpServletRequest r,HttpServletResponse resp,String page)throws ServletException,IOException{r.getRequestDispatcher("/WEB-INF/views/"+page).forward(r,resp);} 

 private Integer parseInt(String value){
  try{return Integer.parseInt(value);}catch(Exception ignored){return null;}
 }

 private String slotDate(String slotInfo){
  String dateKey=slotDateKey(slotInfo);
  if("-".equals(dateKey)) return "-";
  try{
   return LocalDate.parse(dateKey).format(DateTimeFormatter.ofPattern("dd MMM yyyy"));
  }catch(Exception ignored){
   return dateKey;
  }
 }

 private String slotDateKey(String slotInfo){
  if(slotInfo==null) return "-";
  String clean=slotInfo.trim();
  if(clean.isEmpty()) return "-";
  int firstSpace=clean.indexOf(' ');
  return firstSpace<=0?clean:clean.substring(0,firstSpace);
 }

 private String slotTime(String slotInfo){
  if(slotInfo==null) return "-";
  String clean=slotInfo.trim();
  if(clean.isEmpty()) return "-";
  int firstSpace=clean.indexOf(' ');
  if(firstSpace<0||firstSpace>=clean.length()-1) return "-";
  String timePart=clean.substring(firstSpace+1).trim();
  String[] range=timePart.split("-");
  if(range.length!=2) return timePart;
  return formatTimeLabel(range[0])+" - "+formatTimeLabel(range[1]);
 }

 private String formatTimeLabel(String value){
  String raw=value!=null?value.trim():"";
  if(raw.isEmpty()) return "-";
  String candidate=raw;
  if(candidate.length()>=8&&candidate.charAt(2)==':'&&candidate.charAt(5)==':') candidate=candidate.substring(0,8);
  try{
   LocalTime t=LocalTime.parse(candidate);
   return t.format(DateTimeFormatter.ofPattern("hh:mm a"));
  }catch(Exception ignored){
   if(raw.length()>=5&&raw.charAt(2)==':') return raw.substring(0,5);
   return raw;
  }
 }

 private String displayStatus(Booking booking,LocalDate today){
  if(booking==null) return "Pending";
  if("cancelled".equalsIgnoreCase(booking.getBookingStatus())) return "Cancelled";
  if("paid".equalsIgnoreCase(booking.getPaymentStatus())) return "Completed";
  String datePart=slotDateKey(booking.getSlotInfo());
  try{
   LocalDate bookingSlotDate=LocalDate.parse(datePart);
   if(!bookingSlotDate.isBefore(today)) return "Upcoming";
  }catch(Exception ignored){
  }
  if(booking.getPaymentStatus()==null||booking.getPaymentStatus().trim().isEmpty()) return "Pending Payment";
  return "Pending";
 }

 private String csvValue(String input){
  if(input==null) return "";
  String escaped=input.replace("\"","\"\"");
  if(escaped.contains(",")||escaped.contains("\n")) return '"'+escaped+'"';
  return escaped;
 }

 private boolean isUpcomingBooking(Booking booking,LocalDate today){
  if(booking==null||booking.getSlotInfo()==null) return false;
  if("cancelled".equalsIgnoreCase(booking.getBookingStatus())) return false;
  String slotInfo=booking.getSlotInfo().trim();
  if(slotInfo.isEmpty()) return false;
  String[] parts=slotInfo.split(" ");
  if(parts.length==0) return false;
  try{
   LocalDate slotDate=LocalDate.parse(parts[0]);
   return !slotDate.isBefore(today);
  }catch(Exception ignored){
   return false;
  }
 }
}
