package com.myspring.mall.question.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.myspring.mall.question.vo.QuestionVO;
import com.myspring.mall.reserve.vo.ReserveVO;

@Repository("questionDAO")
public class QuestionDAOImpl implements QuestionDAO{
	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public List<QuestionVO> listQuestionById(String userId) {
		List<QuestionVO> qList = null;
		qList = sqlSession.selectList("mapper.question.listQuestionById", userId);
		return qList;
	}

	@Override
	public int insertQuestion(QuestionVO question) {
		int result = 0;
		result = sqlSession.insert("mapper.question.insertQuestion", question);
		return result;
	}

	@Override
	public QuestionVO selectQuestion(Integer keyNum) {
		QuestionVO question = null;
		question = (QuestionVO)sqlSession.selectOne("mapper.question.selectQuestion", keyNum);
		return question;
	}

	@Override
	public int updateQuestion(QuestionVO question) {
		int result = 0;
		result = sqlSession.update("mapper.question.updateQuestion", question);
		return result;
	}

}
