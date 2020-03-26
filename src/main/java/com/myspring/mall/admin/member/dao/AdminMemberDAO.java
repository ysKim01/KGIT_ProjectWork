package com.myspring.mall.admin.member.dao;

import java.sql.Date;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.myspring.mall.member.vo.MemberVO;


public interface AdminMemberDAO {
	public List selectAllMembers() throws DataAccessException;
	public List selectMemberById(String userId);
	public int insertMember(MemberVO member);
	public List selectMemberByFilter_Id(Map searchMap);
	public List selectMemberByFilter_Name(Map searchMap);
	public List selectMemberByFilter_Tel(Map searchMap);
	public List selectMemberByFilter_None(Map searchMap);
	public int modMember(MemberVO member);
}
