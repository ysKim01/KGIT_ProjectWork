package com.myspring.mall.member.controller;

import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.DispatcherServlet;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.myspring.mall.member.service.MemberService;
import com.myspring.mall.member.vo.MemberVO;

import oracle.jdbc.proxy.annotation.GetProxy;

@Controller("memberController")
@EnableAspectJAutoProxy
public class MemberControllerImpl extends MultiActionController implements MemberController{
	private static final Logger logger = LoggerFactory.getLogger(MemberControllerImpl.class);
	@Autowired
	private MemberService memberService;
	@Autowired
	private MemberVO memberVO;
	
	@RequestMapping(value="/member/listMembers.do", method=RequestMethod.GET)
	public ModelAndView listMembers(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String)request.getAttribute("viewName"); 
		System.out.println("viewName : "+viewName);
		List membersList = memberService.listMembers();
		ModelAndView mav = new ModelAndView(viewName);
		
		mav.addObject("membersList",membersList);
		
		return mav;
	}
	
	
	@RequestMapping(value= {"/", "/main.do"}, method=RequestMethod.GET)
	public ModelAndView main(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String)request.getAttribute("viewName");
		//String viewName = getViewName(request);
		System.out.println("viewName : "+viewName);
		ModelAndView mav = new ModelAndView(viewName);
		return mav;
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
		
		//viewName = viewName.replace("/", "");
		return viewName;
	}
}
