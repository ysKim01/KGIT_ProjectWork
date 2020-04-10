package com.myspring.mall.question.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.myspring.mall.question.dao.QuestionDAO;
import com.myspring.mall.question.vo.QuestionVO;

@Service("questionService")
@Transactional(propagation=Propagation.REQUIRED)
public class QuestionServiceImpl implements QuestionService{
	@Autowired
	private QuestionDAO questionDAO;
	
	
	@Override
	public List<QuestionVO> listQuestionById(String userId) {
		List<QuestionVO> qList = null;
		qList = questionDAO.listQuestionById(userId);
		return qList;
	}


	@Override
	public boolean addQuestion(QuestionVO question) {
		boolean result = false;
		
		int num = questionDAO.insertQuestion(question);
		if(num >= 1) {
			result = true;
		}
		
		return false;
	}


	@Override
	public QuestionVO selectQuestion(Integer keyNum) {
		QuestionVO question = null;
		question = questionDAO.selectQuestion(keyNum);
		return question;
	}


	@Override
	public boolean updateQuestion(QuestionVO question) {
		boolean result = false;
		int num = questionDAO.updateQuestion(question);
		if(num >= 1) {
			result = true;
		}
		return result;
	}

}
