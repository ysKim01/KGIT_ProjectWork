package com.myspring.mall.admin.reserve.dao;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;


@Repository("adminReserveDAO")
public class AdminReserveDAOImpl implements AdminReserveDAO{
	@Autowired
	private SqlSession sqlSession;

	@Override
	public List<String> listUsingTimeForUsable(Map searchMap) {
		List<String> usingTimeList = null;
		usingTimeList = sqlSession.selectList("mapper.reserve.listUsingTimeForUsable", searchMap);
		return usingTimeList;
	}

	
}

























