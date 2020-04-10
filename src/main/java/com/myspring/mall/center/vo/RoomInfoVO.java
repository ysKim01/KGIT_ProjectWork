package com.myspring.mall.center.vo;

import org.springframework.stereotype.Component;

@Component("RoomInfoVO")
public class RoomInfoVO {
	private String roomCode;
	private String roomName;
	private String centerCode;
	private int scale;
	
	// Getter & Setter
	public String getRoomCode() {
		return roomCode;
	}
	public void setRoomCode(String roomCode) {
		this.roomCode = roomCode;
	}
	public String getRoomName() {
		return roomName;
	}
	public void setRoomName(String roomName) {
		this.roomName = roomName;
	}
	public String getCenterCode() {
		return centerCode;
	}
	public void setCenterCode(String centerCode) {
		this.centerCode = centerCode;
	}
	public int getScale() {
		return scale;
	}
	public void setScale(int scale) {
		this.scale = scale;
	}
	
	public String toString() {
		String out = "";
		out += "1. roomCode : " + roomCode + "\n";
		out += "2. roomName : " + roomName + "\n";
		out += "3. centerCode : " + centerCode + "\n";
		out += "4. scale : " + scale + "\n";
		return out;
	}
}
