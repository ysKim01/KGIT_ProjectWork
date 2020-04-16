package com.myspring.mall.admin.notice.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.myspring.mall.admin.notice.dao.AdminNoticeDAO;
import com.myspring.mall.admin.notice.vo.AdminNoticeFilterVO;
import com.myspring.mall.admin.notice.vo.NoticeVO;
import com.myspring.mall.common.ControllData;
import com.myspring.mall.question.vo.QuestionVO;

@Service("adminNoticeService")
@Transactional(propagation=Propagation.REQUIRED)
public class AdminNoticeServiceImpl implements AdminNoticeService{
	@Autowired
	private AdminNoticeDAO adminNoticeDAO;
	
	static private ControllData conData = new ControllData();
	
	@Override
	public List<NoticeVO> listTopNotice() {
		List<NoticeVO> list = null;
		list = adminNoticeDAO.listTopNotice();
		return list;
	}

	@Override
	public List<NoticeVO> listNoticeByFilter(AdminNoticeFilterVO searchInfo) {
		List<NoticeVO> nList = null;
		int maxNum = 0;
		
		String searchContent = searchInfo.getSearchContent();	// not null
		
		Map searchMap = new HashMap();
		searchMap.put("page", searchInfo.getPage());
		
		if(!conData.isEmpty(searchContent)) {
			searchMap.put("noticeTitle", searchContent);
			nList = adminNoticeDAO.listNoticeByFilter_Title(searchMap);
			maxNum = adminNoticeDAO.countNoticeionByFilter_Title(searchMap);
			searchInfo.setMaxNum(maxNum);
		}else {
			nList = adminNoticeDAO.listNoticeByFilter_None(searchMap);
			maxNum = adminNoticeDAO.countNoticeionByFilter_None(searchMap);
			searchInfo.setMaxNum(maxNum);
		}
		return nList;
	}

	@Override
	public NoticeVO selectNotice(Integer keyNum) {
		NoticeVO notice = null;
		notice = adminNoticeDAO.selectNotice(keyNum);
		return notice;
	}

	@Override
	public boolean updateNotice(NoticeVO notice) {
		boolean result = false;
		
		int num = adminNoticeDAO.updateNotice(notice);
		if(num >= 1) {
			result = true;
		}
		
		return result;
	}

	@Override
	public boolean insertNotice(NoticeVO notice) {
		boolean result = false;
		
		int num = adminNoticeDAO.insertNotice(notice);
		if(num >= 1) {
			result = true;
		}
		
		return result;
	}

	@Override
	public boolean deleteNotice(Integer keyNum) {
		boolean result = false;
		
		int num = adminNoticeDAO.deleteNotice(keyNum);
		if(num >= 1) {
			result = true;
		}
		
		return result;
	}

}
