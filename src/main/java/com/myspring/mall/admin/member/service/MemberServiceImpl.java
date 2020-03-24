package com.myspring.mall.admin.member.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.myspring.mall.admin.member.dao.MemberDAO;
import com.myspring.mall.member.vo.MemberVO;


@Service("adminMemberService")
@Transactional(propagation=Propagation.REQUIRED)
public class MemberServiceImpl implements MemberService{
	@Autowired
	private MemberDAO memberDAO;
	
	public List listMembers() throws DataAccessException {
		List membersList = null;
		membersList = memberDAO.selectAllMembers();
		
		return membersList;
	}
	@Override
	public boolean isValidId(String userId) {
		boolean result = false;
		List membersList = null;
		membersList = memberDAO.selectMemberById(userId);
		if(membersList==null || membersList.size()==0) {
			result = true;
		}
		
		return result;
	}
	@Override
	public int addMember(MemberVO member) {
		return memberDAO.insertMember(member);
	}
}
