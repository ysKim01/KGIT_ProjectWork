package com.myspring.mall.admin.center.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.servlet.ModelAndView;


public interface AdminCenterController {
	// 스터디룸 목록
	public ModelAndView listCenter(HttpServletRequest request, HttpServletResponse response) throws Exception;
	// 스터디룸 검색
	public void searchCenter(HttpServletRequest request, HttpServletResponse response) throws Exception;
	// 스터디룸 등록
	public void addCenter(HttpServletRequest request, HttpServletResponse response) throws Exception;
}
