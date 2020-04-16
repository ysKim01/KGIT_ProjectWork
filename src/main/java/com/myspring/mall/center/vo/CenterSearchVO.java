package com.myspring.mall.center.vo;

import org.springframework.stereotype.Component;

@Component("centerSearchVO")
public class CenterSearchVO {
	// CenterInfo
	private String centerCode;
	private String centerName;
	private String centerTel;
	private int unitPrice;
	private int operTimeStart;
	private int operTimeEnd;
	private int unitTime;
	private float ratingScore;
	private int ratingNum;
	private String centerAdd1;
	private String centerAdd2;
	private String centerAdd3;
	private int minTime;
	private int premiumRate;
	private int surchageTime;
	// CenterContents
	private String centerPhoto;
	// Facility
	private Integer locker;
	private Integer projector;
	private Integer printer;
	private Integer noteBook;
	private Integer whiteBoard;
	
	// Getter & Setter
	public String getCenterCode() {
		return centerCode;
	}
	public void setCenterCode(String centerCode) {
		this.centerCode = centerCode;
	}
	public String getCenterName() {
		return centerName;
	}
	public void setCenterName(String centerName) {
		this.centerName = centerName;
	}
	public String getCenterTel() {
		return centerTel;
	}
	public void setCenterTel(String centerTel) {
		this.centerTel = centerTel;
	}
	public int getUnitPrice() {
		return unitPrice;
	}
	public void setUnitPrice(int unitPrice) {
		this.unitPrice = unitPrice;
	}
	public int getOperTimeStart() {
		return operTimeStart;
	}
	public void setOperTimeStart(int operTimeStart) {
		this.operTimeStart = operTimeStart;
	}
	public int getOperTimeEnd() {
		return operTimeEnd;
	}
	public void setOperTimeEnd(int operTimeEnd) {
		this.operTimeEnd = operTimeEnd;
	}
	public int getUnitTime() {
		return unitTime;
	}
	public void setUnitTime(int unitTime) {
		this.unitTime = unitTime;
	}
	public float getRatingScore() {
		return ratingScore;
	}
	public void setRatingScore(float ratingScore) {
		this.ratingScore = ratingScore;
	}
	public int getRatingNum() {
		return ratingNum;
	}
	public void setRatingNum(int ratingNum) {
		this.ratingNum = ratingNum;
	}
	public String getCenterAdd1() {
		return centerAdd1;
	}
	public void setCenterAdd1(String centerAdd1) {
		this.centerAdd1 = centerAdd1;
	}
	public String getCenterAdd2() {
		return centerAdd2;
	}
	public void setCenterAdd2(String centerAdd2) {
		this.centerAdd2 = centerAdd2;
	}
	public String getCenterAdd3() {
		return centerAdd3;
	}
	public void setCenterAdd3(String centerAdd3) {
		this.centerAdd3 = centerAdd3;
	}
	public int getMinTime() {
		return minTime;
	}
	public void setMinTime(int minTime) {
		this.minTime = minTime;
	}
	public int getPremiumRate() {
		return premiumRate;
	}
	public void setPremiumRate(int premiumRate) {
		this.premiumRate = premiumRate;
	}
	public int getSurchageTime() {
		return surchageTime;
	}
	public void setSurchageTime(int surchageTime) {
		this.surchageTime = surchageTime;
	}
	public String getCenterPhoto() {
		return centerPhoto;
	}
	public void setCenterPhoto(String centerPhoto) {
		this.centerPhoto = centerPhoto;
	}
	public Integer getLocker() {
		return locker;
	}
	public void setLocker(Integer locker) {
		this.locker = locker;
	}
	public Integer getProjector() {
		return projector;
	}
	public void setProjector(Integer projector) {
		this.projector = projector;
	}
	public Integer getPrinter() {
		return printer;
	}
	public void setPrinter(Integer printer) {
		this.printer = printer;
	}
	public Integer getNoteBook() {
		return noteBook;
	}
	public void setNoteBook(Integer noteBook) {
		this.noteBook = noteBook;
	}
	public Integer getWhiteBoard() {
		return whiteBoard;
	}
	public void setWhiteBoard(Integer whiteBoard) {
		this.whiteBoard = whiteBoard;
	}
	
	@Override
	public String toString() {
		String out = "[CenterSearchVO] : { ";
		out += "( centerCode : " + centerCode + " ) , ";
		out += "( centerName : " + centerName + " ) , ";
		out += "( centerTel : " + centerTel + " ) , ";
		out += "( unitPrice : " + unitPrice + " ) , ";
		out += "( operTimeStart : " + operTimeStart + " ) , ";
		out += "( operTimeEnd : " + operTimeEnd + " ) , ";
		out += "( unitTime : " + unitTime + " ) , ";
		out += "( ratingScore : " + ratingScore + " ) , ";
		out += "( ratingNum : " + ratingNum + " ) , ";
		out += "( centerAdd1 : " + centerAdd1 + " ) , ";
		out += "( centerAdd2 : " + centerAdd2 + " ) , ";
		out += "( centerAdd3 : " + centerAdd3 + " ) , ";
		out += "( minTime : " + minTime + " ) , ";
		out += "( premiumRate : " + premiumRate + " ) , ";
		out += "( surchageTime : " + surchageTime + " ) , ";
		out += "( centerPhoto : " + centerPhoto + " ) , ";
		out += "( locker : " + locker + " ) , ";
		out += "( projector : " + projector + " ) , ";
		out += "( printer : " + printer + " ) , ";
		out += "( noteBook : " + noteBook + " ) , ";
		out += "( whiteBoard : " + whiteBoard + " )  ";
		out += " }";
		return out;
	}
}
