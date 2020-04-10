package com.myspring.mall.question.vo;

import java.sql.Date;

import org.springframework.stereotype.Component;

@Component("questionVO")
public class QuestionVO {
	private Integer keyNum;
	private String userId;
	private String questionClass;
	private String questionTitle;
	private String questionContent;
	private String questionAnswer;
	private Date questionDate;
	private Date answerDate;
	private Integer mailMode;
	
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
	public String getQuestionClass() {
		return questionClass;
	}
	public void setQuestionClass(String questionClass) {
		this.questionClass = questionClass;
	}
	public String getQuestionTitle() {
		return questionTitle;
	}
	public void setQuestionTitle(String questionTitle) {
		this.questionTitle = questionTitle;
	}
	public String getQuestionContent() {
		return questionContent;
	}
	public void setQuestionContent(String questionContent) {
		this.questionContent = questionContent;
	}
	public String getQuestionAnswer() {
		return questionAnswer;
	}
	public void setQuestionAnswer(String questionAnswer) {
		this.questionAnswer = questionAnswer;
	}
	public Date getQuestionDate() {
		return questionDate;
	}
	public void setQuestionDate(Date questionDate) {
		this.questionDate = questionDate;
	}
	public Date getAnswerDate() {
		return answerDate;
	}
	public void setAnswerDate(Date answerDate) {
		this.answerDate = answerDate;
	}
	public Integer getMailMode() {
		return mailMode;
	}
	public void setMailMode(Integer mailMode) {
		this.mailMode = mailMode;
	}
	
	@Override
	public String toString() {
		String out = "[Question] { ";
		out += "( keyNum : " + keyNum + "), ";
		out += "( userId : " + userId + "), ";
		out += "( questionClass : " + questionClass + "), ";
		out += "( questionTitle : " + questionTitle + "), ";
		out += "( questionContent : " + questionContent + "), ";
		out += "( questionAnswer : " + questionAnswer + "), ";
		out += "( mailMoe : " + mailMode + "), ";
		if(questionDate != null)
			out += "( qWriteDate : " + questionDate.toString() + "), ";
		if(answerDate != null)
			out += "( qAnswerDate : " + answerDate.toString() + "), ";
		out += " }";
		return out;
	}
}
