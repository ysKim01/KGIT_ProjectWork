package com.myspring.mall.admin.oneday.vo;

import org.springframework.stereotype.Component;

@Component("adminOneDayFilterVO")
public class AdminOneDayFilterVO {
	private String searchContent;
	private Integer classStatus;
	private Integer page;
	private Integer maxNum;
	
	// Getter & Setter
	public String getSearchContent() {
		return searchContent;
	}
	public void setSearchContent(String searchContent) {
		this.searchContent = searchContent;
	}
	public Integer getClassStatus() {
		return classStatus;
	}
	public void setClassStatus(Integer classStatus) {
		this.classStatus = classStatus;
	}
	public Integer getPage() {
		return page;
	}
	public void setPage(Integer page) {
		this.page = page;
	}
	public Integer getMaxNum() {
		return maxNum;
	}
	public void setMaxNum(Integer maxNum) {
		this.maxNum = maxNum;
	}
	
	@Override
	public String toString() {
		String out = "[AdminOneDayFilter]\n";
		out += "1.searchContent : " + searchContent + "\n";
		out += "2.classStatus : " + classStatus + "\n";
		out += "3.page : " + page + "\n";
		out += "4.maxNum : " + maxNum + "\n";
		return out;
	}
}
