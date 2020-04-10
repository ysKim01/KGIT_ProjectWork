package com.myspring.mall.question.dao;

import java.util.List;

import com.myspring.mall.question.vo.QuestionVO;

public interface QuestionDAO {

	List<QuestionVO> listQuestionById(String userId);

	int insertQuestion(QuestionVO question);

	QuestionVO selectQuestion(Integer keyNum);

	int updateQuestion(QuestionVO question);

}
