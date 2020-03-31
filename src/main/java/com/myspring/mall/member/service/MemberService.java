package com.myspring.mall.member.service;

import java.util.List;

import org.springframework.dao.DataAccessException;

import com.myspring.mall.member.vo.MemberVO;

public interface MemberService {
	public MemberVO login(String userId, String userPw);
}
