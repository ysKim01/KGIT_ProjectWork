package com.myspring.mall.admin.reserve.vo;

import java.sql.Date;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.annotation.JsonFormat;

@Component("adminReserveSearchVO")
public class AdminReserveSearchVO {
	// Study_Reserve
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
	// Study_CenterInfo
	private String centerName;
	// Study_RoomInfo
	private String roomName;
	private Integer scale;
	// Study_Member
	private String userName;
	private String userTel1;
	private String userTel2;
	private String userTel3;
	
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
	public String getCenterName() {
		return centerName;
	}
	public void setCenterName(String centerName) {
		this.centerName = centerName;
	}
	public String getRoomName() {
		return roomName;
	}
	public void setRoomName(String roomName) {
		this.roomName = roomName;
	}
	public Integer getScale() {
		return scale;
	}
	public void setScale(Integer scale) {
		this.scale = scale;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserTel1() {
		return userTel1;
	}
	public void setUserTel1(String userTel1) {
		this.userTel1 = userTel1;
	}
	public String getUserTel2() {
		return userTel2;
	}
	public void setUserTel2(String userTel2) {
		this.userTel2 = userTel2;
	}
	public String getUserTel3() {
		return userTel3;
	}
	public void setUserTel3(String userTel3) {
		this.userTel3 = userTel3;
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
		out += "11. centerName : " + centerName + "\n";
		out += "12. roomName : " + roomName + "\n";
		out += "13. scale : " + scale + "\n";
		out += "14. userName : " + userName + "\n";
		out += "15. userTel1 : " + userTel1 + "\n";
		out += "16. userTel2 : " + userTel2 + "\n";
		out += "17. userTel3 : " + userTel3 + "\n";
		return out;
	}
}
