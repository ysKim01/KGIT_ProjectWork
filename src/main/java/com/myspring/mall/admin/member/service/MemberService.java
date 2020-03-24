package com.myspring.mall.admin.member.service;

import java.util.List;

import org.springframework.dao.DataAccessException;

import com.myspring.mall.member.vo.MemberVO;

public interface MemberService {
	public List listMembers() throws DataAccessException;
	public boolean isValidId(String userId);
	public int addMember(MemberVO member);
}
