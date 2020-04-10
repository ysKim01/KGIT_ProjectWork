package com.myspring.mall.admin.center.vo;

import org.springframework.stereotype.Component;

@Component("adminCenterFilterVO")
public class AdminCenterFilterVO {

	private String searchFilter;
	private String searchContents;
	private Integer adminMode;
	private Integer page;
	private Integer maxPage;
	
	public String getSearchFilter() {
		return searchFilter;
	}
	public void setSearchFilter(String searchFilter) {
		this.searchFilter = searchFilter;
	}
	public String getSearchContents() {
		return searchContents;
	}
	public void setSearchContents(String searchContents) {
		this.searchContents = searchContents;
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
	public Integer getMaxPage() {
		return maxPage;
	}
	public void setMaxPage(Integer maxPage) {
		this.maxPage = maxPage;
	}
	
	@Override
	public String toString() {
		String out = "[CenterSearch]\n";
		out += "1. searchFilter : " + searchFilter + "\n";
		out += "2. page : " + page + "\n";
		return out;
	}
	
}
