package com.myspring.mall.oneday.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("oneDayDAO")
public class OneDayDAOImpl implements OneDayDAO{
	@Autowired
	private SqlSession sqlSession;
	
}
