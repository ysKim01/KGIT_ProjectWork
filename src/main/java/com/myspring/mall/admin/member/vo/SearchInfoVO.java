package com.myspring.mall.admin.member.vo;

import java.sql.Date;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Component;

@Component("searchInfoVO")
public class SearchInfoVO {
	private String searchFilter;
	private String searchContent;
	@DateTimeFormat(pattern = "yyyyMMdd")
	private Date joinStart;
	@DateTimeFormat(pattern = "yyyyMMdd")
	private Date joinEnd;
	private Integer adminMode;
	private Integer page;
	
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

	@Override
	public String toString() {
		String out = "[SearchInfo]\n";
		out += "1. searchFilter : " + searchFilter + "\n";
		out += "2. searchContent : " + searchContent + "\n";
		if(joinStart != null)
			out += "3. joinStart : " + joinStart.toString() + "\n";
		if(joinEnd != null)	
			out += "4. joinEnd : " + joinEnd.toString() + "\n";
		out += "5. adminMode : " + adminMode + "\n";
		out += "6. page : " + page + "\n";
		return out;
	}
}
