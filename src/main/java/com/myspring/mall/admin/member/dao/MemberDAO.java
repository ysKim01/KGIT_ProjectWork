package com.myspring.mall.admin.member.dao;

import java.util.List;

import org.springframework.dao.DataAccessException;

import com.myspring.mall.member.vo.MemberVO;


public interface MemberDAO {
	public List selectAllMembers() throws DataAccessException;
	public List selectMemberById(String userId);
	public int insertMember(MemberVO member);
}
