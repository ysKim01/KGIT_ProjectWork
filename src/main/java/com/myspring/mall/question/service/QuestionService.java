package com.myspring.mall.question.service;

import java.util.List;

import com.myspring.mall.question.vo.QuestionVO;

public interface QuestionService {

	List<QuestionVO> listQuestionById(String userId);

	boolean addQuestion(QuestionVO question);

	QuestionVO selectQuestion(Integer keyNum);

	boolean updateQuestion(QuestionVO question);

}
