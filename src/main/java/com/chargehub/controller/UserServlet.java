package com.chargehub.controller;

import com.chargehub.dao.*;import com.chargehub.model.*;
import jakarta.servlet.*;import jakarta.servlet.annotation.WebServlet;import jakarta.servlet.http.*;import java.io.IOException;import java.math.BigDecimal;

@WebServlet("/user/*")
public class UserServlet extends HttpServlet {
 private int uid(HttpServletRequest r){return (int)r.getSession().getAttribute("userId");}
 protected void doGet(HttpServletRequest r,HttpServletResponse resp)throws ServletException,IOException{
  String p=r.getPathInfo(); if(p==null)p="/dashboard"; int userId=uid(r);
  switch(p){
   case "/dashboard": r.setAttribute("bookings",new BookingDAO().findByUser(userId)); r.setAttribute("favCount",new FavoriteDAO().countByUser(userId)); f(r,resp,"user/dashboard.jsp"); break;
   case "/stations": r.setAttribute("districts",new DistrictDAO().findAll()); Integer did=null; try{did=Integer.parseInt(r.getParameter("districtId"));}catch(Exception ignored){} r.setAttribute("stations",new StationDAO().search(did,r.getParameter("chargerType"))); f(r,resp,"user/stations.jsp"); break;
   case "/station": int stationId=Integer.parseInt(r.getParameter("id")); r.setAttribute("station",new StationDAO().findById(stationId)); r.setAttribute("slots",new SlotDAO().findAvailableByStation(stationId)); r.setAttribute("reviews",new ReviewDAO().findByStation(stationId)); f(r,resp,"user/station-details.jsp"); break;
   case "/bookings": r.setAttribute("bookings",new BookingDAO().findByUser(userId)); f(r,resp,"user/bookings.jsp"); break;
   case "/booking": r.setAttribute("booking",new BookingDAO().findById(Integer.parseInt(r.getParameter("id")))); f(r,resp,"user/booking-details.jsp"); break;
   case "/payment": r.setAttribute("booking",new BookingDAO().findById(Integer.parseInt(r.getParameter("bookingId")))); f(r,resp,"user/payment.jsp"); break;
   case "/payments": r.setAttribute("payments",new PaymentDAO().findByUser(userId)); f(r,resp,"user/payments.jsp"); break;
   case "/favorites": r.setAttribute("favorites",new FavoriteDAO().findByUser(userId)); f(r,resp,"user/favorites.jsp"); break;
   case "/profile": r.setAttribute("user",new UserDAO().findById(userId)); f(r,resp,"user/profile.jsp"); break;
   default: resp.sendRedirect(r.getContextPath()+"/user/dashboard");
  }
 }
 protected void doPost(HttpServletRequest r,HttpServletResponse resp)throws ServletException,IOException{
  String action=r.getParameter("action"); int userId=uid(r);
  if("book".equals(action)){ Booking b=new Booking(); b.setUserId(userId);b.setStationId(Integer.parseInt(r.getParameter("stationId")));b.setSlotId(Integer.parseInt(r.getParameter("slotId")));b.setVehicleNumber(r.getParameter("vehicleNumber"));b.setNotes(r.getParameter("notes"));new BookingDAO().create(b); resp.sendRedirect(r.getContextPath()+"/user/bookings"); }
  else if("cancelBooking".equals(action)){ new BookingDAO().cancel(Integer.parseInt(r.getParameter("bookingId"))); resp.sendRedirect(r.getContextPath()+"/user/bookings"); }
  else if("pay".equals(action)){ Payment p=new Payment(); p.setBookingId(Integer.parseInt(r.getParameter("bookingId")));p.setUserId(userId);p.setAmount(new BigDecimal(r.getParameter("amount")));p.setPaymentMethod(r.getParameter("paymentMethod"));p.setPaymentStatus("paid");p.setTransactionReference(r.getParameter("transactionReference"));p.setRemarks(r.getParameter("remarks"));new PaymentDAO().create(p); resp.sendRedirect(r.getContextPath()+"/user/payments"); }
  else if("favorite".equals(action)){ new FavoriteDAO().add(userId,Integer.parseInt(r.getParameter("stationId"))); resp.sendRedirect(r.getHeader("Referer")); }
  else if("removeFavorite".equals(action)){ new FavoriteDAO().remove(userId,Integer.parseInt(r.getParameter("stationId"))); resp.sendRedirect(r.getContextPath()+"/user/favorites"); }
  else if("review".equals(action)){ new ReviewDAO().add(userId,Integer.parseInt(r.getParameter("stationId")),Integer.parseInt(r.getParameter("rating")),r.getParameter("comment")); resp.sendRedirect(r.getContextPath()+"/user/station?id="+r.getParameter("stationId")); }
  else if("profile".equals(action)){ User u=new User();u.setUserId(userId);u.setFullName(r.getParameter("fullName"));u.setPhone(r.getParameter("phone"));u.setVehicleNumber(r.getParameter("vehicleNumber"));u.setAddress(r.getParameter("address"));new UserDAO().updateProfile(u); resp.sendRedirect(r.getContextPath()+"/user/profile"); }
 }
 private void f(HttpServletRequest r,HttpServletResponse resp,String page)throws ServletException,IOException{r.getRequestDispatcher("/WEB-INF/views/"+page).forward(r,resp);} 
}
