package com.myspring.mall.member.dao;

import java.util.List;

import org.springframework.dao.DataAccessException;

import com.myspring.mall.member.vo.MemberVO;


public interface MemberDAO {
	public MemberVO login(String userId, String userPw);
	public int insertMember(MemberVO member);
}
