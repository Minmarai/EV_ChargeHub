package com.chargehub.model;
import java.sql.Date; import java.sql.Time;

/**
 * Author: Imtiyaz Ansari
 */
public class Slot {
    private int slotId, stationId; private String stationName, availabilityStatus; private Date slotDate; private Time startTime,endTime;
    public int getSlotId(){return slotId;} public void setSlotId(int slotId){this.slotId=slotId;}
    public int getStationId(){return stationId;} public void setStationId(int stationId){this.stationId=stationId;}
    public String getStationName(){return stationName;} public void setStationName(String stationName){this.stationName=stationName;}
    public String getAvailabilityStatus(){return availabilityStatus;} public void setAvailabilityStatus(String availabilityStatus){this.availabilityStatus=availabilityStatus;}
    public Date getSlotDate(){return slotDate;} public void setSlotDate(Date slotDate){this.slotDate=slotDate;}
    public Time getStartTime(){return startTime;} public void setStartTime(Time startTime){this.startTime=startTime;}
    public Time getEndTime(){return endTime;} public void setEndTime(Time endTime){this.endTime=endTime;}
}
