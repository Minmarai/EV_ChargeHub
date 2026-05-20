package com.chargehub.model;

import java.math.BigDecimal;
import java.sql.Time;

/**
 * Author: Imtiyaz Ansari IIC
 */
public class Station {
    private int stationId, districtId, managerId, totalPorts;
    private String stationName, districtName, managerName, address, contactNumber, chargerType, status, activeDays;
    private Time openingTime, closingTime;
    private BigDecimal pricePerHour;
    public int getStationId() { return stationId; }
    public void setStationId(int stationId) { this.stationId = stationId; }
    public int getDistrictId() { return districtId; }
    public void setDistrictId(int districtId) { this.districtId = districtId; }
    public int getManagerId() { return managerId; }
    public void setManagerId(int managerId) { this.managerId = managerId; }
    public int getTotalPorts() { return totalPorts; }
    public void setTotalPorts(int totalPorts) { this.totalPorts = totalPorts; }
    public String getStationName() { return stationName; }
    public void setStationName(String stationName) { this.stationName = stationName; }
    public String getDistrictName() { return districtName; }
    public void setDistrictName(String districtName) { this.districtName = districtName; }
    public String getManagerName() { return managerName; }
    public void setManagerName(String managerName) { this.managerName = managerName; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }
    public String getChargerType() { return chargerType; }
    public void setChargerType(String chargerType) { this.chargerType = chargerType; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getActiveDays() { return activeDays; }
    public void setActiveDays(String activeDays) { this.activeDays = activeDays; }
    public Time getOpeningTime() { return openingTime; }
    public void setOpeningTime(Time openingTime) { this.openingTime = openingTime; }
    public Time getClosingTime() { return closingTime; }
    public void setClosingTime(Time closingTime) { this.closingTime = closingTime; }
    public BigDecimal getPricePerHour() { return pricePerHour; }
    public void setPricePerHour(BigDecimal pricePerHour) { this.pricePerHour = pricePerHour; }
}
