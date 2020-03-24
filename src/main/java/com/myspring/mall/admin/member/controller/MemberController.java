package com.myspring.mall.admin.member.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.myspring.mall.member.vo.MemberVO;

public interface MemberController {
	public ModelAndView main(HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView membershipForm(HttpServletRequest request, HttpServletResponse response) throws Exception;
	public ModelAndView addMember(HttpServletRequest request, HttpServletResponse response, @RequestBody MemberVO member) throws Exception;
	public ModelAndView listMembers(HttpServletRequest request, HttpServletResponse response) throws Exception;
} 
