package com.myspring.mall.admin.notice.vo;

import java.sql.Date;

import org.springframework.stereotype.Component;

@Component("noticeVO")
public class NoticeVO {
	private Integer keyNum;
	private String noticeTitle;
	private String noticeContent;
	private Date noticeWriteDate;
	private Integer noticeTop;
	
	// Getter & Setter
	public Integer getKeyNum() {
		return keyNum;
	}
	public void setKeyNum(Integer keyNum) {
		this.keyNum = keyNum;
	}
	public String getNoticeTitle() {
		return noticeTitle;
	}
	public void setNoticeTitle(String noticeTitle) {
		this.noticeTitle = noticeTitle;
	}
	public String getNoticeContent() {
		return noticeContent;
	}
	public void setNoticeContent(String noticeContent) {
		this.noticeContent = noticeContent;
	}
	public Date getNoticeWriteDate() {
		return noticeWriteDate;
	}
	public void setNoticeWriteDate(Date noticeWriteDate) {
		this.noticeWriteDate = noticeWriteDate;
	}
	public Integer getNoticeTop() {
		return noticeTop;
	}
	public void setNoticeTop(Integer noticeTop) {
		this.noticeTop = noticeTop;
	}
	
	@Override
	public String toString() {
		String out = "[NoticeVO] { ";
		out += "(keyNum : " + keyNum + "), ";
		out += "(noticeTitle : " + noticeTitle + "), ";
		out += "(noticeContent : " + noticeContent + "), ";
		if(noticeWriteDate != null)
			out += "(noticeWriteDate : " + noticeWriteDate.toString() + "), ";
		out += "(noticeTop : " + noticeTop + "), ";
		out += " }";
		return out;
	}
}
