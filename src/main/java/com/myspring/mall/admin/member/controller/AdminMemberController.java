package com.myspring.mall.admin.member.controller;

import java.sql.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.myspring.mall.admin.member.vo.MemberFilterVO;
import com.myspring.mall.member.vo.MemberVO;

public interface AdminMemberController {
	// 1. admin main
	public ModelAndView main(HttpServletRequest request, HttpServletResponse response) throws Exception;
	// 2. 회원 등록 창
	public ModelAndView membershipForm(HttpServletRequest request, HttpServletResponse response) throws Exception;
	// 3. 아이디 중복확인
	public ResponseEntity<Boolean> isValidId(HttpServletRequest request, HttpServletResponse response) throws Exception;
	// 4. 회원 등록
	public void addMember(HttpServletRequest request, HttpServletResponse response, @RequestBody MemberVO member) throws Exception;
	// 5. 회원 목록
	public ModelAndView listMembers(HttpServletRequest request, HttpServletResponse response) throws Exception;
	// 6. 회원 검색
	public void searchMembers(HttpServletRequest request, HttpServletResponse response) throws Exception;
	// 7. 회원 삭제
	public ResponseEntity<Boolean> delMember(HttpServletRequest request, HttpServletResponse response) throws Exception; 
	// 8. 다중 회원 삭제
	public ResponseEntity<Boolean> delMembersList(HttpServletRequest request, HttpServletResponse response) throws Exception;
	
} 
