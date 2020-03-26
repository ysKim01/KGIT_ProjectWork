package com.myspring.mall.admin.member.service;

import java.sql.Date;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.myspring.mall.member.vo.MemberVO;

public interface AdminMemberService {
	public List listMembers() throws DataAccessException;
	public boolean overlapped(String userId);
	public int addMember(MemberVO member);
	public List listMembersByFiltered(Map searchInfo);
	public int modMember(MemberVO member);
}
