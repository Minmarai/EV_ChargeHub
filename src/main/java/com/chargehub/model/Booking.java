package com.chargehub.model;
import java.math.BigDecimal; import java.sql.Timestamp;

/**
 * Author: Kirti Dahal
 */
public class Booking {
    private int bookingId,userId,stationId,slotId; private String userName,userPhone,stationName,managerName,vehicleNumber,bookingStatus,slotInfo,notes,paymentStatus; private Timestamp bookingDate; private BigDecimal amount;
    public int getBookingId(){return bookingId;} public void setBookingId(int bookingId){this.bookingId=bookingId;}
    public int getUserId(){return userId;} public void setUserId(int userId){this.userId=userId;}
    public int getStationId(){return stationId;} public void setStationId(int stationId){this.stationId=stationId;}
    public int getSlotId(){return slotId;} public void setSlotId(int slotId){this.slotId=slotId;}
    public String getUserName(){return userName;} public void setUserName(String userName){this.userName=userName;}
    public String getUserPhone(){return userPhone;} public void setUserPhone(String userPhone){this.userPhone=userPhone;}
    public String getStationName(){return stationName;} public void setStationName(String stationName){this.stationName=stationName;}
    public String getManagerName(){return managerName;} public void setManagerName(String managerName){this.managerName=managerName;}
    public String getVehicleNumber(){return vehicleNumber;} public void setVehicleNumber(String vehicleNumber){this.vehicleNumber=vehicleNumber;}
    public String getBookingStatus(){return bookingStatus;} public void setBookingStatus(String bookingStatus){this.bookingStatus=bookingStatus;}
    public String getSlotInfo(){return slotInfo;} public void setSlotInfo(String slotInfo){this.slotInfo=slotInfo;}
    public String getNotes(){return notes;} public void setNotes(String notes){this.notes=notes;}
    public Timestamp getBookingDate(){return bookingDate;} public void setBookingDate(Timestamp bookingDate){this.bookingDate=bookingDate;}
    public String getPaymentStatus(){return paymentStatus;} public void setPaymentStatus(String paymentStatus){this.paymentStatus=paymentStatus;}
    public BigDecimal getAmount(){return amount;} public void setAmount(BigDecimal amount){this.amount=amount;}
}
