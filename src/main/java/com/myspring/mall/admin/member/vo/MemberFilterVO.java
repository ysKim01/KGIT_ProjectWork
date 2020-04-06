package com.myspring.mall.admin.member.vo;

import java.sql.Date;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.annotation.JsonFormat;

@Component("memberFilterVO")
public class MemberFilterVO {
	private String searchFilter;
	private String searchContent;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "GMT+9")
	private Date joinStart;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "GMT+9")
	private Date joinEnd;
	private Integer adminMode;
	private Integer page;
	private Integer maxNum;
	
	// Setter & Getter
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
	public Date getJoinStart() {
		return joinStart;
	}
	public void setJoinStart(Date joinStart) {
		this.joinStart = joinStart;
	}
	public Date getJoinEnd() {
		return joinEnd;
	}
	public void setJoinEnd(Date joinEnd) {
		this.joinEnd = joinEnd;
	}
	public Integer getAdminMode() {
		return adminMode;
	}
	public void setAdminMode(Integer adminMode) {
		this.adminMode = adminMode;
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
		String out = "[SearchInfo]\n";
		out += "1. searchFilter : " + searchFilter + "\n";
		out += "2. searchContent : " + searchContent + "\n";
		out += "3. adminMode : " + adminMode + "\n";
		out += "4. page : " + page + "\n";
		if(joinStart != null)
			out += "5. joinStart : " + joinStart.toString() + "\n";
		if(joinEnd != null)	
			out += "6. joinEnd : " + joinEnd.toString() + "\n";
		return out;
	}
}
