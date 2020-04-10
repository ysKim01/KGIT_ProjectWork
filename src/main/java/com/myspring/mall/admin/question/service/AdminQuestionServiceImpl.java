package com.myspring.mall.admin.question.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.myspring.mall.admin.question.dao.AdminQuestionDAO;
import com.myspring.mall.admin.question.vo.AdminQuestionFilterVO;
import com.myspring.mall.common.ControllData;
import com.myspring.mall.question.vo.QuestionVO;

@Service("adminQuestionService")
@Transactional(propagation=Propagation.REQUIRED)
public class AdminQuestionServiceImpl implements AdminQuestionService{
	@Autowired
	private AdminQuestionDAO adminQuestionDAO;
	
	static private ControllData conData = new ControllData();
	
	@Override
	public List<QuestionVO> listQuestionByFiltered(AdminQuestionFilterVO searchInfo) {
		List<QuestionVO> qList = null;
		int maxNum = 0;
		
		String searchFilter = searchInfo.getSearchFilter();		// ID
		String searchContent = searchInfo.getSearchContent();	// not null
		String questionClass = searchInfo.getQuestionClass();	// All, 예약문의, 원데이클레스문의, 환불문의, 기타문의
		String isAnswered = searchInfo.getIsAnswered();			// All, 완료, 미완료
		
		Map searchMap = new HashMap();
		searchMap.put("page", searchInfo.getPage());
		searchMap.put("questionClass", questionClass);
		searchMap.put("isAnswered", isAnswered);
		
		if(!conData.isEmpty(searchContent)) {
			if(searchFilter.equals("userId")) {
				searchMap.put("userId", searchContent);
				
				qList = adminQuestionDAO.listQuestionByFilter_Id(searchMap);
				maxNum = adminQuestionDAO.countQuestionByFilter_Id(searchMap);
				searchInfo.setMaxNum(maxNum);
			}
			else {
				qList = adminQuestionDAO.listQuestionByFilter_None(searchMap);
				maxNum = adminQuestionDAO.countQuestionByFilter_None(searchMap);
				searchInfo.setMaxNum(maxNum);
			}
		}else {
			qList = adminQuestionDAO.listQuestionByFilter_None(searchMap);
			maxNum = adminQuestionDAO.countQuestionByFilter_None(searchMap);
			searchInfo.setMaxNum(maxNum);
		}
		return qList;
	}

}
