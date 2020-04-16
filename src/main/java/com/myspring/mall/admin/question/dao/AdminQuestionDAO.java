package com.myspring.mall.admin.question.dao;

import java.util.List;
import java.util.Map;

import com.myspring.mall.question.vo.QuestionVO;

public interface AdminQuestionDAO {

	List<QuestionVO> listQuestionByFilter_Id(Map searchMap);

	List<QuestionVO> listQuestionByFilter_None(Map searchMap);

	int countQuestionByFilter_Id(Map searchMap);

	int countQuestionByFilter_None(Map searchMap);

	int updateAnswer(Map map);

	int deleteQuestion(Integer keyNum);

}
