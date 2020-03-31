package com.myspring.mall.member.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
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

import com.myspring.mall.member.vo.MemberVO;

import net.sf.json.JSONObject;



@Repository("memberDAO")
public class MemberDAOImpl implements MemberDAO{
	@Autowired
	private SqlSession sqlSession;

	@Override
	public MemberVO login(String userId, String userPw) {
		Map loginInfo = new HashMap();
		loginInfo.put("userId", userId);
		loginInfo.put("userPw", userPw);
		
		MemberVO member = (MemberVO)sqlSession.selectOne("mapper.member.selectMemberByIdPw", loginInfo);
		return member;
	}

}

























