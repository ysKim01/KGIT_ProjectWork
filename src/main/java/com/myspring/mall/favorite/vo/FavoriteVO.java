package com.myspring.mall.favorite.vo;

import org.springframework.stereotype.Component;

@Component("favoriteVO")
public class FavoriteVO {
	private Integer keyNum;
	private String userId;
	private String centerCode;
	
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
	
	@Override
	public String toString() {
		String out = "[Favorite] { ";
		out += "(keyNum : " + keyNum + "), ";
		out += "(userId : " + userId + "), ";
		out += "(centerCode : " + centerCode + ") ";
		out += "}";
		return out;
	}
}
