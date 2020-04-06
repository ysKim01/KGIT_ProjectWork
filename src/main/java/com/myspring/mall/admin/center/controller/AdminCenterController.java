package com.myspring.mall.admin.center.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.servlet.ModelAndView;


public interface AdminCenterController {
	public ModelAndView listCenter(HttpServletRequest request, HttpServletResponse response) throws Exception;
	public void searchCenter(HttpServletRequest request, HttpServletResponse response) throws Exception;
}
