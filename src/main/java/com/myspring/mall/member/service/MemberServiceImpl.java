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
	
	public List listMembers() throws DataAccessException {
		List membersList = null;
		membersList = memberDAO.selectAllMembers();
		
		return membersList;
	}
}
