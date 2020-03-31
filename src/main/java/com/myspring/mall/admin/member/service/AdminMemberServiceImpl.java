package com.myspring.mall.admin.member.service;

import java.sql.Date;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.myspring.mall.admin.member.dao.AdminMemberDAO;
import com.myspring.mall.admin.member.vo.SearchInfoVO;
import com.myspring.mall.common.ControllData;
import com.myspring.mall.member.vo.MemberVO;


@Service("adminMemberService")
@Transactional(propagation=Propagation.REQUIRED)
public class AdminMemberServiceImpl implements AdminMemberService{
	@Autowired
	private AdminMemberDAO adminMemberDAO;
	
	private static ControllData conData = new ControllData();
	
	@Override
	public boolean overlapped(String userId) {
		// 중복 : true, 중복안됨 : false;
		boolean result = false;
		List membersList = null;
		membersList = adminMemberDAO.selectMemberById(userId);
		if(membersList!=null && membersList.size()!=0) {
			result = true;
		}
		
		return result;
	}
	
	@Override
	public int addMember(MemberVO member) {
		return adminMemberDAO.insertMember(member);
	}
	
	@Override
	public List listMembers() throws DataAccessException {
		List membersList = null;
		membersList = adminMemberDAO.selectAllMembers();
		return membersList;
	}
	
	@Override
	public List listMembersByFiltered(SearchInfoVO searchInfo) {
		List membersList = null;
		
		String searchFilter = searchInfo.getSearchFilter();		// not null
		String searchContent = searchInfo.getSearchContent();	// all
		Date joinStart = searchInfo.getJoinStart();				// all
		Date joinEnd = searchInfo.getJoinEnd();					// all
		Integer adminMode = searchInfo.getAdminMode();			// null, 0, 1
		Integer page = searchInfo.getPage();					// not null, 양수
		
		// 예외처리
		if(searchFilter==null) {
			searchFilter = "";
		}
		if(adminMode != null) {
			if(adminMode!=0 && adminMode!=1) {
				adminMode = null;
			}
		}
		if(page==null || page<=0) {
			page = 1;
		}
		
		Map searchMap = new HashMap();
		searchMap.put("joinStart", joinStart);
		searchMap.put("joinEnd", joinEnd);
		searchMap.put("adminMode", adminMode);
		searchMap.put("page", page);
		
		if(!conData.isEmpty(searchContent)) { // 검색내용 있을 경우
			if(searchFilter.equals("userId")) {
				searchMap.put("userId", searchContent);
				membersList = adminMemberDAO.selectMemberByFilter_Id(searchMap);
			}
			else if(searchFilter.equals("userName")) {
				searchMap.put("userName", searchContent);
				membersList = adminMemberDAO.selectMemberByFilter_Name(searchMap);
			}
			else if(searchFilter.equals("userTel")) {
				Map userTel = conData.TelDivThree(searchContent);
				if(userTel!=null) {
					searchMap.put("userTel", userTel);
					membersList = adminMemberDAO.selectMemberByFilter_Tel(searchMap);
				}else {
					System.out.println("[Warning] admin / service / listMembersByFiltered > "
							+ "전화번호가 10자리가 아닙니다.");
					membersList = null;
				}
			}
			else {
				System.out.println("[Warning] admin / service / listMembersByFiltered > "
						+ "계정 검색 필터값이 정확하지 않습니다.");
				membersList = adminMemberDAO.selectMemberByFilter_None(searchMap);
			}
		}
		else { // 검색내용 없을 경우
			membersList = adminMemberDAO.selectMemberByFilter_None(searchMap);
		}
		
		return membersList;
	}
	
	@Override
	public int modMember(MemberVO member) {
		return adminMemberDAO.modMember(member);
	}

	@Override
	public int delMembersList(List<MemberVO> membersList) {
		int result = 0;
		for(int i=0;i<membersList.size();i++) {
			String userId = membersList.get(i).getUserId();
			result += adminMemberDAO.delMemberById(userId);
		}
		return result;
	}

	@Override
	public int delMembersList(MemberVO member) {
		int result = 0; 
		
		String userId = member.getUserId();
		result = adminMemberDAO.delMemberById(userId);
		
		return result;
	}

	@Override
	public int getMaxPageByBiltered(SearchInfoVO searchInfo) {
		int result = 0;
		
		String searchFilter = searchInfo.getSearchFilter();		// not null
		String searchContent = searchInfo.getSearchContent();	// all
		Date joinStart = searchInfo.getJoinStart();				// all
		Date joinEnd = searchInfo.getJoinEnd();					// all
		Integer adminMode = searchInfo.getAdminMode();			// null, 0, 1
		Integer page = searchInfo.getPage();					// not null, 양수
		// 예외처리
		if(searchFilter==null) {
			searchFilter = "";
		}
		if(adminMode != null) {
			if(adminMode!=0 && adminMode!=1) {
				adminMode = null;
			}
		}
		if(page==null || page<=0) {
			page = 1;
		}
		
		Map searchMap = new HashMap();
		searchMap.put("joinStart", joinStart);
		searchMap.put("joinEnd", joinEnd);
		searchMap.put("adminMode", adminMode);
		searchMap.put("page", page);
		
		if(!conData.isEmpty(searchContent)) { // 검색내용 있을 경우
			if(searchFilter.equals("userId")) {
				searchMap.put("userId", searchContent);
				result = adminMemberDAO.countMemberByFilter_Id(searchMap);
			}
			else if(searchFilter.equals("userName")) {
				searchMap.put("userName", searchContent);
				result = adminMemberDAO.countMemberByFilter_Name(searchMap);
			}
			else if(searchFilter.equals("userTel")) {
				Map userTel = conData.TelDivThree(searchContent);
				if(userTel!=null) {
					searchMap.put("userTel", userTel);
					result = adminMemberDAO.countMemberByFilter_Tel(searchMap);
				}else {
					System.out.println("[Warning] admin / service / listMembersByFiltered > "
							+ "전화번호가 10자리가 아닙니다.");
				}
			}
			else {
				System.out.println("[Warning] admin / service / listMembersByFiltered > "
						+ "계정 검색 필터값이 정확하지 않습니다.");
				result = adminMemberDAO.countMemberByFilter_None(searchMap);
			}
		}
		else { // 검색내용 없을 경우
			result = adminMemberDAO.countMemberByFilter_None(searchMap);
		}
		
		return result;
	}

	@Override
	public MemberVO getMemberById(String userId) {
		MemberVO member = (MemberVO) adminMemberDAO.selectMemberById(userId).get(0);
		return member;
	}
	
}
