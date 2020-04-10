package com.myspring.mall.admin.question.vo;

import org.springframework.stereotype.Component;

@Component("adminQuestionFilterVO")
public class AdminQuestionFilterVO {
	private String searchFilter;
	private String searchContent;
	private String questionClass;
	private String isAnswered;
	private Integer page;
	private Integer maxNum;
	
	// Getter & Setter
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
	public String getQuestionClass() {
		return questionClass;
	}
	public void setQuestionClass(String questionClass) {
		this.questionClass = questionClass;
	}
	public String getIsAnswered() {
		return isAnswered;
	}
	public void setIsAnswered(String isAnswered) {
		this.isAnswered = isAnswered;
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
		String out = "[AdminQuestionFilter]\n";
		out += "1. searchFilter : " + searchFilter + "\n";
		out += "2. searchContent : " + searchContent + "\n";
		out += "3. questionClass : " + questionClass + "\n";
		out += "4. isAnswered : " + isAnswered + "\n";
		out += "5. page : " + page + "\n";
		out += "6. maxNum : " + maxNum + "\n";
		out += "\n";
		return out;
	}
}
