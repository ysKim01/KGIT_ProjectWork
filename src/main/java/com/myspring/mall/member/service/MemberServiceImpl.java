package com.myspring.mall.member.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.myspring.mall.member.dao.MemberDAO;
import com.myspring.mall.member.vo.MemberVO;


@Service("memberService")
@Transactional(propagation=Propagation.REQUIRED)
public class MemberServiceImpl implements MemberService{
	@Autowired
	private MemberDAO memberDAO;

	@Override
	public MemberVO login(String userId, String userPw) {
		MemberVO member = memberDAO.login(userId,userPw);
		return member;
	}

	@Override
	public boolean addMember(MemberVO member) {
		boolean result = false;
		int num = memberDAO.insertMember(member);

		if(num >= 1) { result = true; }
		else { result = false; }
		
		return result;
	}
	
}
