package com.myspring.mall.common.interceptor;

import java.util.Collections;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class ViewNameInterceptor extends HandlerInterceptorAdapter{

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		try {
			String viewName = getViewName(request);
			request.setAttribute("viewName", viewName);
			System.out.println("\n[info]" + viewName + " > Start =======================");
		}catch(Exception e) {
			e.printStackTrace();
		}
		return true;
	}
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		try {
			String lastRequest = getRequstName(request);
			HttpSession session=request.getSession();
			session.setAttribute("lastRequest", lastRequest);
			System.out.println("lastRequest : " + lastRequest);
			
			String viewName = getViewName(request);
			System.out.println("[info]" + viewName + " > End =========================\n");
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private String getViewName(HttpServletRequest request)  throws Exception{
		String contextPath = request.getContextPath();
		String uri = (String)request.getAttribute("javax.servlet.include.request_uri");
		
		if (uri == null || uri.trim().equals("")) {
			uri = request.getRequestURI();
		}
		
		int begin = 0;
		if(!((contextPath==null)|| ("".equals(contextPath)))) {
			begin = contextPath.length();
		}
		
		int end;
		if(uri.indexOf(";") != -1) {
			end = uri.indexOf(";");
		} else if (uri.indexOf("?") != -1) {
			end = uri.indexOf("?");
		} else {
			end = uri.length();
		}
		
		String viewName = uri.substring(begin, end);
		if(viewName.indexOf(".") != -1) {
			viewName=viewName.substring(0,viewName.lastIndexOf("."));
		}
		if(viewName.lastIndexOf("/") != -1) {
			viewName=viewName.substring(viewName.lastIndexOf("/",1), viewName.length());
		}
		
		return viewName;
	}
	
	private String getRequstName(HttpServletRequest request) throws Exception {
		String lastRequest = "";
		
		// request name
		String contextPath = request.getContextPath();
		String uri = request.getRequestURI();
		lastRequest = uri.substring(contextPath.length(), uri.length());
		
		// request param
		if(request.getMethod().equals("GET")) {
			String requestParam = "?";
			List<String> names = Collections.list(request.getParameterNames());
			for(String name : names) {
				String param = request.getParameter(name);
				requestParam += name + "=" + param + "&";
			}
			lastRequest += requestParam;
		}
		
		return lastRequest;
	}
	
}
