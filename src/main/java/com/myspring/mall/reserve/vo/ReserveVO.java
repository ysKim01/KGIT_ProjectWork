package com.myspring.mall.reserve.vo;

import java.sql.Date;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.annotation.JsonFormat;

@Component("reserveVO")
public class ReserveVO {
	private Integer keyNum;
	private String userId;
	private String centerCode;
	private String roomCode;
	private Date reserveApplyDate;
	private Date reserveDate;
	private Integer reservePrice;
	private String reserveStatus;
	private String usingTime;
	private String extraCode;
	
	// Getter & Setter
	public Integer getKeyNum() {
		return keyNum;
	}
	public void setKeyNum(Integer keyNum) {
		this.keyNum = keyNum;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getCenterCode() {
		return centerCode;
	}
	public void setCenterCode(String centerCode) {
		this.centerCode = centerCode;
	}
	public String getRoomCode() {
		return roomCode;
	}
	public void setRoomCode(String roomCode) {
		this.roomCode = roomCode;
	}
	public Date getReserveApplyDate() {
		return reserveApplyDate;
	}
	public void setReserveApplyDate(Date reserveApplyDate) {
		this.reserveApplyDate = reserveApplyDate;
	}
	public Date getReserveDate() {
		return reserveDate;
	}
	public void setReserveDate(Date reserveDate) {
		this.reserveDate = reserveDate;
	}
	public Integer getReservePrice() {
		return reservePrice;
	}
	public void setReservePrice(Integer reservePrice) {
		this.reservePrice = reservePrice;
	}
	public String getReserveStatus() {
		return reserveStatus;
	}
	public void setReserveStatus(String reserveStatus) {
		this.reserveStatus = reserveStatus;
	}
	public String getUsingTime() {
		return usingTime;
	}
	public void setUsingTime(String usingTime) {
		this.usingTime = usingTime;
	}
	public String getExtraCode() {
		return extraCode;
	}
	public void setExtraCode(String extraCode) {
		this.extraCode = extraCode;
	}
	
	@Override
	public String toString() {
		String out = "";
		out += "1. keyNum : " + keyNum + "\n";
		out += "2. userId : " + userId + "\n";
		out += "3. centerCode : " + centerCode + "\n";
		out += "4. roomCode : " + roomCode + "\n";
		if(reserveApplyDate != null)
			out += "5. reserveApplyDate : " + reserveApplyDate.toString() + "\n";
		if(reserveDate != null)
			out += "6. reserveDate : " + reserveDate.toString() + "\n";
		out += "7. reservePrice : " + reservePrice + "\n";
		out += "8. reserveStatus : " + reserveStatus + "\n";
		out += "9. usingTime  : " + usingTime + "\n";
		out += "10. extraCode : " + extraCode + "\n";
		return out;
	}
}
