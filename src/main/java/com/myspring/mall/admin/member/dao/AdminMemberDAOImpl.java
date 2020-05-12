package com.myspring.mall.admin.member.dao;

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

import com.myspring.mall.admin.member.vo.MemberFilterVO;
import com.myspring.mall.member.vo.MemberVO;



@Repository("adminMemberDAO")
public class AdminMemberDAOImpl implements AdminMemberDAO{
	@Autowired
	private SqlSession sqlSession;

	@Override
	public List selectMemberById(String userId) {
		List<MemberVO> membersList = null;
		membersList = sqlSession.selectList("mapper.member.selectMemberById", userId);
		return membersList;
	}

	@Override
	public int insertMember(MemberVO member) {
		int result = 0;
		result = sqlSession.insert("mapper.member.insertMember", member);
		return 0;
	}
	
	@Override
	public List selectAllMembers() throws DataAccessException {
		List<MemberVO> membersList = null;
		membersList = sqlSession.selectList("mapper.member.selectAllMemberList");
		return membersList;
	}

	
	@Override
	public List selectMemberByFilter_Id(Map searchMap) {
		List<MemberVO> membersList = null;
		membersList = sqlSession.selectList("mapper.member.selectMemberByFilter_Id", searchMap);
		return membersList;
	}
	@Override
	public List selectMemberByFilter_Name(Map searchMap) {
		List<MemberVO> membersList = null;
		membersList = sqlSession.selectList("mapper.member.selectMemberByFilter_Name", searchMap);
		return membersList;
	}
	@Override
	public List selectMemberByFilter_Tel(Map searchMap) {
		List<MemberVO> membersList = null;
		membersList = sqlSession.selectList("mapper.member.selectMemberByFilter_Tel", searchMap);
		return membersList;
	}
	@Override
	public List selectMemberByFilter_None(Map searchMap) {
		List<MemberVO> membersList = null;
		membersList = sqlSession.selectList("mapper.member.selectMemberByFilter_None", searchMap);
		return membersList;
	}

	@Override
	public int modMember(MemberVO member) {
		int result = 0;
		result = sqlSession.update("mapper.member.modMember", member);
		return result;
	}

	@Override
	public int delMemberById(String userId) {
		int result = 0;
		result = sqlSession.delete("mapper.member.delMemberById", userId);
		return result;
	}

	@Override
	public int countMemberByFilter_Id(Map searchMap) {
		int result = 0;
		result = (Integer)sqlSession.selectOne("mapper.member.countMemberByFilter_Id", searchMap);
		return result;
	}
	@Override
	public int countMemberByFilter_Name(Map searchMap) {
		int result = 0;
		result = (Integer)sqlSession.selectOne("mapper.member.countMemberByFilter_Name", searchMap);
		return result;
	}
	@Override
	public int countMemberByFilter_Tel(Map searchMap) {
		int result = 0;
		result = (Integer)sqlSession.selectOne("mapper.member.countMemberByFilter_Tel", searchMap);
		return result;
	}
	@Override
	public int countMemberByFilter_None(Map searchMap) {
		int result = 0;
		result = (Integer)sqlSession.selectOne("mapper.member.countMemberByFilter_None", searchMap);
		return result;
	}

	@Override
	public Integer countAdminMember() {
		Integer cnt = 0;
		cnt = sqlSession.selectOne("mapper.member.countAdminMember");
		return cnt;
	}

	@Override
	public Integer countMember() {
		Integer cnt = 0;
		cnt = sqlSession.selectOne("mapper.member.countMember");
		return cnt;
	}


}

























