package com.myspring.mall.notice.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.myspring.mall.admin.notice.vo.NoticeVO;
import com.myspring.mall.notice.dao.NoticeDAO;

@Service("noticeService")
@Transactional(propagation=Propagation.REQUIRED)
public class NoticeServiceImpl implements NoticeService{
	@Autowired
	private NoticeDAO noticeDAO;
	
	@Override
	public List<NoticeVO> listNewNotice() {
		List<NoticeVO> list = null;
		list = noticeDAO.listNewNotice();
		return list;
	}

}
