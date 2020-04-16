package com.myspring.mall.admin.oneday.vo;

import java.sql.Date;

import org.springframework.stereotype.Component;

@Component("oneDayVO")
public class OneDayVO {
	private Integer keyNum;
	private String classTitle;
	private String lector;
	private String lectorTel;
	private String classContent;
	private Integer classStatus;
	private String classTime;
	private Date classDate;
	private Date classWriteDate;
	private String classPhoto1;
	private String classPhoto2;
	private String classPhoto3;
	private String classPhoto4;
	private String classPhoto5;
	
	// Getter & Setter
	public Integer getKeyNum() {
		return keyNum;
	}
	public void setKeyNum(Integer keyNum) {
		this.keyNum = keyNum;
	}
	public String getClassTitle() {
		return classTitle;
	}
	public void setClassTitle(String classTitle) {
		this.classTitle = classTitle;
	}
	public String getLector() {
		return lector;
	}
	public void setLector(String lector) {
		this.lector = lector;
	}
	public String getLectorTel() {
		return lectorTel;
	}
	public void setLectorTel(String lectorTel) {
		this.lectorTel = lectorTel;
	}
	public String getClassContent() {
		return classContent;
	}
	public void setClassContent(String classContent) {
		this.classContent = classContent;
	}
	public Integer getClassStatus() {
		return classStatus;
	}
	public void setClassStatus(Integer classStatus) {
		this.classStatus = classStatus;
	}
	public String getClassTime() {
		return classTime;
	}
	public void setClassTime(String classTime) {
		this.classTime = classTime;
	}
	public Date getClassDate() {
		return classDate;
	}
	public void setClassDate(Date classDate) {
		this.classDate = classDate;
	}
	public Date getClassWriteDate() {
		return classWriteDate;
	}
	public void setClassWriteDate(Date classWriteDate) {
		this.classWriteDate = classWriteDate;
	}
	public String getClassPhoto1() {
		return classPhoto1;
	}
	public void setClassPhoto1(String classPhoto1) {
		this.classPhoto1 = classPhoto1;
	}
	public String getClassPhoto2() {
		return classPhoto2;
	}
	public void setClassPhoto2(String classPhoto2) {
		this.classPhoto2 = classPhoto2;
	}
	public String getClassPhoto3() {
		return classPhoto3;
	}
	public void setClassPhoto3(String classPhoto3) {
		this.classPhoto3 = classPhoto3;
	}
	public String getClassPhoto4() {
		return classPhoto4;
	}
	public void setClassPhoto4(String classPhoto4) {
		this.classPhoto4 = classPhoto4;
	}
	public String getClassPhoto5() {
		return classPhoto5;
	}
	public void setClassPhoto5(String classPhoto5) {
		this.classPhoto5 = classPhoto5;
	}


	@Override
	public String toString() {
		String out = "[OneDay] { ";
		out += "( keyNum : " + keyNum + "), ";
		out += "( classTitle : " + classTitle + "), ";
		out += "( lector : " + lector + "), ";
		out += "( lectorTel : " + lectorTel + "), ";
		out += "( classContent : " + classContent + "), ";
		out += "( classStatus : " + classStatus + "), ";
		out += "( classTime : " + classTime + "), ";
		if(classDate != null)
			out += "( classDate : " + classDate.toString() + "), ";
		if(classWriteDate != null)
			out += "( classWriteDate : " + classWriteDate.toString() + "), ";
		out += "( classPhoto1 : " + classPhoto1 + "), ";
		out += "( classPhoto2 : " + classPhoto2 + "), ";
		out += "( classPhoto3 : " + classPhoto3 + "), ";
		out += "( classPhoto4 : " + classPhoto4 + "), ";
		out += "( classPhoto5 : " + classPhoto5 + "), ";
		out += " } ";
		return out;
	}
}
