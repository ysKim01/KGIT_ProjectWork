package com.myspring.mall.center.vo;

import java.sql.Date;

import org.springframework.stereotype.Component;

@Component("mainSearchFilterVO")
public class MainSearchFilterVO {
	private Date searchDate;
	private String searchAdd1;
	private String searchAdd2;
	private Integer scale;
	private Integer sort; // 0:이름순, 1: 낮은가격순, 2: 인기순
	private Integer page;
	private Integer maxNum;
	
	// Getter & Setter
	public Date getSearchDate() {
		return searchDate;
	}
	public void setSearchDate(Date searchDate) {
		this.searchDate = searchDate;
	}
	public String getSearchAdd1() {
		return searchAdd1;
	}
	public void setSearchAdd1(String searchAdd1) {
		this.searchAdd1 = searchAdd1;
	}
	public String getSearchAdd2() {
		return searchAdd2;
	}
	public void setSearchAdd2(String searchAdd2) {
		this.searchAdd2 = searchAdd2;
	}
	public Integer getScale() {
		return scale;
	}
	public void setScale(Integer scale) {
		this.scale = scale;
	}
	public Integer getSort() {
		return sort;
	}
	public void setSort(Integer sort) {
		this.sort = sort;
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
		String out = "[MainSearchFilter] : { ";
		if(searchDate != null)
			out += "( searchDate : " + searchDate.toString() + " ) , ";
		out += "( searchAdd1 : " + searchAdd1 + " ) , ";
		out += "( searchAdd2 : " + searchAdd2 + " ) , ";
		out += "( scale : " + scale + " ) , ";
		out += "( sort : " + sort + " ) , ";
		out += "( page : " + page + " ) , ";
		out += "( maxNum : " + maxNum + " ) ";
		out += " } \n";
		return super.toString();
	}
}
