package com.myspring.mall.center.vo;

import org.springframework.stereotype.Component;

@Component("CenterContentsVO")
public class CenterContentsVO {
	private String centerCode;
	private String centerPhoto;
	private String centerIntroduce;
	private String centerFareInfo;
	private String centerUseInfo;
	private String roomPhoto1;
	private String roomPhoto2;
	private String roomPhoto3;
	private String roomPhoto4;
	private String roomPhoto5;
	private String roomPhoto6;
	private String roomPhoto7;
	private String roomPhoto8;
	private String roomPhoto9;
	private String roomPhoto10;
	
	// Getter & Setter
	public String getCenterCode() {
		return centerCode;
	}
	public void setCenterCode(String centerCode) {
		this.centerCode = centerCode;
	}
	public String getCenterPhoto() {
		return centerPhoto;
	}
	public void setCenterPhoto(String centerPhoto) {
		this.centerPhoto = centerPhoto;
	}
	public String getCenterIntroduce() {
		return centerIntroduce;
	}
	public void setCenterIntroduce(String centerIntroduce) {
		this.centerIntroduce = centerIntroduce;
	}
	public String getCenterFareInfo() {
		return centerFareInfo;
	}
	public void setCenterFareInfo(String centerFareInfo) {
		this.centerFareInfo = centerFareInfo;
	}
	public String getCenterUseInfo() {
		return centerUseInfo;
	}
	public void setCenterUseInfo(String centerUseInfo) {
		this.centerUseInfo = centerUseInfo;
	}
	public String getRoomPhoto1() {
		return roomPhoto1;
	}
	public void setRoomPhoto1(String roomPhoto1) {
		this.roomPhoto1 = roomPhoto1;
	}
	public String getRoomPhoto2() {
		return roomPhoto2;
	}
	public void setRoomPhoto2(String roomPhoto2) {
		this.roomPhoto2 = roomPhoto2;
	}
	public String getRoomPhoto3() {
		return roomPhoto3;
	}
	public void setRoomPhoto3(String roomPhoto3) {
		this.roomPhoto3 = roomPhoto3;
	}
	public String getRoomPhoto4() {
		return roomPhoto4;
	}
	public void setRoomPhoto4(String roomPhoto4) {
		this.roomPhoto4 = roomPhoto4;
	}
	public String getRoomPhoto5() {
		return roomPhoto5;
	}
	public void setRoomPhoto5(String roomPhoto5) {
		this.roomPhoto5 = roomPhoto5;
	}
	public String getRoomPhoto6() {
		return roomPhoto6;
	}
	public void setRoomPhoto6(String roomPhoto6) {
		this.roomPhoto6 = roomPhoto6;
	}
	public String getRoomPhoto7() {
		return roomPhoto7;
	}
	public void setRoomPhoto7(String roomPhoto7) {
		this.roomPhoto7 = roomPhoto7;
	}
	public String getRoomPhoto8() {
		return roomPhoto8;
	}
	public void setRoomPhoto8(String roomPhoto8) {
		this.roomPhoto8 = roomPhoto8;
	}
	public String getRoomPhoto9() {
		return roomPhoto9;
	}
	public void setRoomPhoto9(String roomPhoto9) {
		this.roomPhoto9 = roomPhoto9;
	}
	public String getRoomPhoto10() {
		return roomPhoto10;
	}
	public void setRoomPhoto10(String roomPhoto10) {
		this.roomPhoto10 = roomPhoto10;
	}
	
	public String toString() {
		String out = "";
			out +=	"centerCode : "	+	centerCode	+	"\n";
			out +=	"centerPhoto : "	+	centerPhoto	+	"\n";
			out +=	"centerIntroduce : "	+	centerIntroduce	+	"\n";
			out +=	"centerFareInfo : "	+	centerFareInfo	+	"\n";
			out +=	"centerUseInfo : "	+	centerUseInfo	+	"\n";
			out +=	"roomPhoto1 : "	+	roomPhoto1	+	"\n";
			out +=	"roomPhoto2 : "	+	roomPhoto2	+	"\n";
			out +=	"roomPhoto3 : "	+	roomPhoto3	+	"\n";
			out +=	"roomPhoto4 : "	+	roomPhoto4	+	"\n";
			out +=	"roomPhoto5 : "	+	roomPhoto5	+	"\n";
			out +=	"roomPhoto6 : "	+	roomPhoto6	+	"\n";
			out +=	"roomPhoto7 : "	+	roomPhoto7	+	"\n";
			out +=	"roomPhoto8 : "	+	roomPhoto8	+	"\n";
			out +=	"roomPhoto9 : "	+	roomPhoto9	+	"\n";
			out +=	"roomPhoto10 : "+	roomPhoto10	+	"\n";
			
			
		return out;
	}
}
