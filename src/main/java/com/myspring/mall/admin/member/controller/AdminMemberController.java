package com.myspring.mall.admin.member.controller;

import java.sql.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.myspring.mall.member.vo.MemberVO;

public interface AdminMemberController {
	public ModelAndView main(HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView membershipForm(HttpServletRequest request, HttpServletResponse response) throws Exception;
	public void addMember(HttpServletRequest request, HttpServletResponse response, @RequestBody MemberVO member) throws Exception;
	public ModelAndView listMembers(HttpServletRequest request, HttpServletResponse response,
			@RequestParam("searchFilter") String searchFilter,
			@RequestParam("searchContent") String searchContent,
			@RequestParam("adminMode") Integer adminMode,
			@RequestParam("joinStart") @DateTimeFormat(pattern="yyyyMMdd") Date joinStart,
			@RequestParam("joinEnd") @DateTimeFormat(pattern="yyyyMMdd") Date joinEnd,
			@RequestParam("page") Integer page) throws Exception;
	public void modMember(HttpServletRequest request, HttpServletResponse response, @RequestBody MemberVO member) throws Exception;
} 
