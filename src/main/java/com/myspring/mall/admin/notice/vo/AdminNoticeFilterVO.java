package com.myspring.mall.admin.notice.vo;

import org.springframework.stereotype.Component;

@Component("adminNoticeFilterVO")
public class AdminNoticeFilterVO {
	private String searchContent;
	private Integer page;
	private Integer maxNum;
	
	// Getter & Setter
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
		String out = "[AdminNoticeFilter]\n";
		out += "1. searchContent : " + searchContent + "\n";
		out += "2. page : " + page + "\n";
		out += "3. maxNum : " + maxNum + "\n";
		return out;
	}
}
