package com.myspring.mall.admin.member.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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



@Repository("adminMemberDAO")
public class MemberDAOImpl implements MemberDAO{
	@Autowired
	private SqlSession sqlSession;

	@Override
	public List selectAllMembers() throws DataAccessException {
		List<MemberVO> membersList = null;
		membersList = sqlSession.selectList("mapper.member.selectAllMemberList");
		return membersList;
	}

	@Override
	public List selectMemberById(String userId) {
		List<MemberVO> membersList = null;
		membersList = sqlSession.selectList("mapper.member.selectMemberById", userId);
		return membersList;
	}

	@Override
	public int insertMember(MemberVO member) {
		int result = 0;
		result = sqlSession.insert("mapper.member.insertMember");
		return 0;
	}

}

























