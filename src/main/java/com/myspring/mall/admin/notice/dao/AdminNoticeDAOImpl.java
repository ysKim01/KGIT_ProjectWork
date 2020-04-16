package com.myspring.mall.admin.notice.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.myspring.mall.admin.notice.vo.NoticeVO;

@Repository("adminNoticeDAO")
public class AdminNoticeDAOImpl implements AdminNoticeDAO{
	@Autowired
	private SqlSession sqlSession;

	@Override
	public List<NoticeVO> listTopNotice() {
		List<NoticeVO> list = null;
		list = sqlSession.selectList("mapper.notice.listTopNotice");
		return list;
	}

	@Override
	public List<NoticeVO> listNoticeByFilter_Title(Map searchMap) {
		List<NoticeVO> list = null;
		list = sqlSession.selectList("mapper.notice.listNoticeByFilter_Title", searchMap);
		return list;
	}

	@Override
	public int countNoticeionByFilter_Title(Map searchMap) {
		int result = 0;
		result = sqlSession.selectOne("mapper.notice.countNoticeByFilter_Title", searchMap);
		return result;
	}

	@Override
	public List<NoticeVO> listNoticeByFilter_None(Map searchMap) {
		List<NoticeVO> list = null;
		list = sqlSession.selectList("mapper.notice.listNoticeByFilter_None", searchMap);
		return list;
	}

	@Override
	public int countNoticeionByFilter_None(Map searchMap) {
		int result = 0;
		result = sqlSession.selectOne("mapper.notice.countNoticeByFilter_None", searchMap);
		return result;
	}

	@Override
	public NoticeVO selectNotice(Integer keyNum) {
		NoticeVO notice = null;
		notice = sqlSession.selectOne("mapper.notice.selectNotice", keyNum);
		return notice;
	}

	@Override
	public int updateNotice(NoticeVO notice) {
		int result = 0;
		result = sqlSession.update("mapper.notice.updateNotice", notice);
		return result;
	}

	@Override
	public int insertNotice(NoticeVO notice) {
		int result = 0;
		result = sqlSession.insert("mapper.notice.insertNotice", notice);
		return result;
	}

	@Override
	public int deleteNotice(Integer keyNum) {
		int result = 0;
		result = sqlSession.delete("mapper.notice.deleteNotice", keyNum);
		return result;
	}

}
