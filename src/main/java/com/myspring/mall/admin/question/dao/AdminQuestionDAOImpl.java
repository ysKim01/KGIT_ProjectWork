package com.myspring.mall.admin.question.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.myspring.mall.question.vo.QuestionVO;

@Repository("adminQuestionDAO")
public class AdminQuestionDAOImpl implements AdminQuestionDAO{
	@Autowired
	private SqlSession sqlSession;

	@Override
	public List<QuestionVO> listQuestionByFilter_Id(Map searchMap) {
		List<QuestionVO> qList = null;
		qList = sqlSession.selectList("mapper.question.listQuestionByFilter_Id", searchMap);
		return qList;
	}

	@Override
	public List<QuestionVO> listQuestionByFilter_None(Map searchMap) {
		List<QuestionVO> qList = null;
		qList = sqlSession.selectList("mapper.question.listQuestionByFilter_None", searchMap);
		return qList;
	}

	@Override
	public int countQuestionByFilter_Id(Map searchMap) {
		int result = 0;
		result = sqlSession.selectOne("mapper.question.countQuestionByFilter_Id", searchMap);
		return result;
	}

	@Override
	public int countQuestionByFilter_None(Map searchMap) {
		int result = 0;
		result = sqlSession.selectOne("mapper.question.countQuestionByFilter_None", searchMap);
		return result;
	}
	
}
