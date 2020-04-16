package com.myspring.mall.admin.notice.dao;

import java.util.List;
import java.util.Map;

import com.myspring.mall.admin.notice.vo.NoticeVO;

public interface AdminNoticeDAO {

	List<NoticeVO> listTopNotice();

	List<NoticeVO> listNoticeByFilter_Title(Map searchMap);

	int countNoticeionByFilter_Title(Map searchMap);

	List<NoticeVO> listNoticeByFilter_None(Map searchMap);

	int countNoticeionByFilter_None(Map searchMap);

	NoticeVO selectNotice(Integer keyNum);

	int updateNotice(NoticeVO notice);

	int insertNotice(NoticeVO notice);

	int deleteNotice(Integer keyNum);

}
