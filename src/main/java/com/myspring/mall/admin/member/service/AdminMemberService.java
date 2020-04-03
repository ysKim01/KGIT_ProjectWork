package com.myspring.mall.admin.member.service;

import java.sql.Date;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.myspring.mall.admin.member.vo.MemberFilterVO;
import com.myspring.mall.member.vo.MemberVO;

public interface AdminMemberService {
	public List listMembers() throws DataAccessException;
	public boolean overlapped(String userId);
	public int addMember(MemberVO member);
	public List listMembersByFiltered(MemberFilterVO searchInfo);
	public int modMember(MemberVO member);
	public int delMembersList(List<MemberVO> membersList);
	public int delMembersList(MemberVO member);
	public int getMaxPageByBiltered(MemberFilterVO searchInfo);
	public MemberVO getMemberById(String userId);
}
