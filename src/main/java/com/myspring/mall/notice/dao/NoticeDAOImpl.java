package com.myspring.mall.notice.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.myspring.mall.admin.notice.vo.NoticeVO;
import com.myspring.mall.center.vo.CenterSearchVO;

@Repository("noticeDAO")
public class NoticeDAOImpl implements NoticeDAO{
	@Autowired
	private SqlSession sqlSession;

	@Override
	public List<NoticeVO> listNewNotice() {
		List<NoticeVO> list = new ArrayList<NoticeVO>();
		list = sqlSession.selectList("mapper.notice.listNewNotice");
		return list;
	}
	
}
