package com.myspring.mall.admin.reserve.vo;

import java.sql.Date;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.annotation.JsonFormat;

@Component("reserveFilterVO")
public class ReserveFilterVO {
	private String searchFilter;
	private String searchContent;
	private String reserveStatus;
	private Integer page;
	private Integer maxNum;
	
	// Getter & Setter
	public String getReserveStatus() {
		return reserveStatus;
	}
	public void setReserveStatus(String reserveStatus) {
		this.reserveStatus = reserveStatus;
	}
	public String getSearchFilter() {
		return searchFilter;
	}
	public void setSearchFilter(String searchFilter) {
		this.searchFilter = searchFilter;
	}
	public String getSearchContent() {
		return searchContent;
	}
	public void setSearchContent(String searchContent) {
		this.searchContent = searchContent;
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
		String out = "[ReserveFilter] \n";
		out += "1. searchFilter : " + searchFilter + " / ";
		out += "2. searchContent : " + searchContent + " / ";
		out += "3. reserveStatus : " + reserveStatus + " / ";
		out += "4. page : " + page + "\n";
		return out;
	}
}
