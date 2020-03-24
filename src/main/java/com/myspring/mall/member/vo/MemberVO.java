package com.myspring.mall.member.vo;

import java.sql.Date;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Component;

@Component("memberVO")
public class MemberVO {
	private String userId;
	private String userPw;
	private String userName;
	private String userEmail;
	private Date userBirth;
	private String userTel1;
	private String userTel2;
	private String userTel3;
	private String userAdd1;
	private String userAdd2;
	private String userAdd3;
	@DateTimeFormat(pattern = "yyyyMMdd")
	private Date joinDate;
	private int adminMode;
	
	// Setter & Getter
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserPw() {
		return userPw;
	}
	public void setUserPw(String userPw) {
		this.userPw = userPw;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserEmail() {
		return userEmail;
	}
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	public Date getUserBirth() {
		return userBirth;
	}
	public void setUserBirth(Date userBirth) {
		this.userBirth = userBirth;
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
	public String getUserAdd1() {
		return userAdd1;
	}
	public void setUserAdd1(String userAdd1) {
		this.userAdd1 = userAdd1;
	}
	public String getUserAdd2() {
		return userAdd2;
	}
	public void setUserAdd2(String userAdd2) {
		this.userAdd2 = userAdd2;
	}
	public String getUserAdd3() {
		return userAdd3;
	}
	public void setUserAdd3(String userAdd3) {
		this.userAdd3 = userAdd3;
	}
	public Date getJoinDate() {
		return joinDate;
	}
	public void setJoinDate(Date joinDate) {
		this.joinDate = joinDate;
	}
	public int getAdminMode() {
		return adminMode;
	}
	public void setAdminMode(int adminMode) {
		this.adminMode = adminMode;
	}
	
	@Override
	public String toString() {
		String out = "";
		out += "1. userId : " + userId + "\n";
		out += "2. userPw : " + userPw + "\n";
		out += "3. userName : " + userName + "\n";
		out += "4. userEmail : " + userEmail + "\n";
		out += "5. userBirth : " + userBirth.toString() + "\n";
		out += "6. userTel : " + userTel1 + " - " + userTel2 + " - " + userTel3 + "\n";
		out += "7. userAdd : " + userAdd1 + " - " + userAdd2 + " - " + userAdd3 + "\n";
		out += "8. joinDate : " + joinDate.toString() + "\n";
		out += "9. adminMode : " + adminMode + "\n";
		return out;
	}
}
