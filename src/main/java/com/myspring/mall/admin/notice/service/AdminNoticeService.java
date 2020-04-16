package com.myspring.mall.admin.notice.service;

import java.util.List;

import com.myspring.mall.admin.notice.vo.AdminNoticeFilterVO;
import com.myspring.mall.admin.notice.vo.NoticeVO;

public interface AdminNoticeService {

	List<NoticeVO> listTopNotice();

	List<NoticeVO> listNoticeByFilter(AdminNoticeFilterVO searchInfo);

	NoticeVO selectNotice(Integer keyNum);

	boolean updateNotice(NoticeVO notice);

	boolean insertNotice(NoticeVO notice);

	boolean deleteNotice(Integer keyNum);

}
