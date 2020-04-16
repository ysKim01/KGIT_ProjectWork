package com.myspring.mall.admin.question.service;

import java.util.List;

import com.myspring.mall.admin.question.vo.AdminQuestionFilterVO;
import com.myspring.mall.question.vo.QuestionVO;

public interface AdminQuestionService {

	List<QuestionVO> listQuestionByFiltered(AdminQuestionFilterVO searchInfo);

	boolean updateAnswer(Integer keyNum, String answer);

	boolean deleteQuestion(Integer keyNum);

}
