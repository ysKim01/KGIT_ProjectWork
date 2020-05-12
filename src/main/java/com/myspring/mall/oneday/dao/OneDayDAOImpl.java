package com.myspring.mall.oneday.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.myspring.mall.admin.oneday.vo.OneDayVO;

@Repository("oneDayDAO")
public class OneDayDAOImpl implements OneDayDAO{
	@Autowired
	private SqlSession sqlSession;

	@Override
	public List<OneDayVO> listNew5OneDay() {
		List<OneDayVO> list = null;
		list = sqlSession.selectList("mapper.oneday.listNew5OneDay");
		return list;
	}
	
}
