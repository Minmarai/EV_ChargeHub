package com.chargehub.model;
import java.math.BigDecimal; import java.sql.Timestamp;
public class Payment {
    private int paymentId, bookingId, userId; private BigDecimal amount; private String paymentMethod,paymentStatus,transactionReference,remarks,userName,stationName; private Timestamp paymentDate;
    public int getPaymentId(){return paymentId;} public void setPaymentId(int paymentId){this.paymentId=paymentId;}
    public int getBookingId(){return bookingId;} public void setBookingId(int bookingId){this.bookingId=bookingId;}
    public int getUserId(){return userId;} public void setUserId(int userId){this.userId=userId;}
    public BigDecimal getAmount(){return amount;} public void setAmount(BigDecimal amount){this.amount=amount;}
    public String getPaymentMethod(){return paymentMethod;} public void setPaymentMethod(String paymentMethod){this.paymentMethod=paymentMethod;}
    public String getPaymentStatus(){return paymentStatus;} public void setPaymentStatus(String paymentStatus){this.paymentStatus=paymentStatus;}
    public String getTransactionReference(){return transactionReference;} public void setTransactionReference(String transactionReference){this.transactionReference=transactionReference;}
    public String getRemarks(){return remarks;} public void setRemarks(String remarks){this.remarks=remarks;}
    public Timestamp getPaymentDate(){return paymentDate;} public void setPaymentDate(Timestamp paymentDate){this.paymentDate=paymentDate;}
    public String getUserName(){return userName;} public void setUserName(String userName){this.userName=userName;}
    public String getStationName(){return stationName;} public void setStationName(String stationName){this.stationName=stationName;}
}


