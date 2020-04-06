package com.myspring.mall.member.controller;

import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.DispatcherServlet;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.myspring.mall.common.ControllData;
import com.myspring.mall.member.service.MemberService;
import com.myspring.mall.member.vo.MemberVO;

import oracle.jdbc.proxy.annotation.GetProxy;

@Controller("memberController")
@EnableAspectJAutoProxy
@RequestMapping("/member")
public class MemberControllerImpl extends MultiActionController implements MemberController{
	private static final Logger logger = LoggerFactory.getLogger(MemberControllerImpl.class);
	@Autowired
	private MemberService memberService;
	@Autowired
	private MemberVO memberVO;
	
	private static ControllData conData = new ControllData();
	
	
	/* ===========================================================================
	 * 1. 로그인 창
	 * ---------------------------------------------------------------------------
	 * > 입력 : -
	 * > 출력 : -
	 * > 이동 페이지 : /member/loginForm.do (로그인 창)
	 * > 설명 : 
	 * 		- 로그인 창
	 ===========================================================================*/
	@RequestMapping(value= {"/loginForm.do"}, method={RequestMethod.GET, RequestMethod.POST})
	public ModelAndView loginForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String)request.getAttribute("viewName");
		
		HttpSession session = request.getSession();
		String logon = (String)session.getAttribute("logon");
		if(logon!=null) {
			if(logon.equals("true"))
				viewName = "redirect:" + conData.getLastPage(request);
		} else {
			conData.setLastPage(request);
		}
		
		ModelAndView mav = new ModelAndView(viewName);
		return mav;
	}
	
	/* ===========================================================================
	 * 2. 로그인
	 * ---------------------------------------------------------------------------
	 * > 입력 : userId, userPw
	 * > 출력 : -
	 * > 이동 페이지 : /member/loginForm.do (로그인 창)
	 * > 설명 : 
	 * 		- 로그인 창
	 ===========================================================================*/
	@RequestMapping(value= {"/login.do"}, method={RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Boolean> login(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String)request.getAttribute("viewName");
		System.out.println("viewName : "+viewName);
		ResponseEntity<Boolean> resEntity = null;
		boolean logon = false;
		
		String userId = request.getParameter("userId");
		String userPw = request.getParameter("userPw");
		if(!conData.isEmpty(userId) && !conData.isEmpty(userPw)) {
			MemberVO member = memberService.login(userId, userPw);
			//System.out.println(member.toString());
			if(member != null) {
				logon = true;
				HttpSession session = request.getSession();
				session.removeAttribute("logon");
				session.removeAttribute("logonId");
				session.removeAttribute("isAdmin");
				session.setAttribute("logon", "true");
				session.setAttribute("logonId", member.getUserId());
				session.setAttribute("isAdmin", member.getAdminMode());
			}
		}
		
		try {
			resEntity = new ResponseEntity<Boolean>(logon, HttpStatus.OK);
		}catch(Exception e) {
			resEntity = new ResponseEntity(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
		return resEntity;
	}
	
	/* ===========================================================================
	 * 2. 로그아웃
	 * ---------------------------------------------------------------------------
	 * > 입력 : userId, userPw
	 * > 출력 : -
	 * > 이동 페이지 : /member/loginForm.do (로그인 창)
	 * > 설명 : 
	 * 		- 로그인 창
	 ===========================================================================*/
	@RequestMapping(value= {"/logout.do"}, method={RequestMethod.GET, RequestMethod.POST})
	public ModelAndView logout(HttpServletRequest request, HttpServletResponse response) throws Exception {
		conData.setLastPage(request);
		
		HttpSession session = request.getSession();
		session.removeAttribute("logon");
		session.removeAttribute("logonMember");
		
		ModelAndView mav = new ModelAndView("redirect:/lastPage.do");
		return mav;
	}
	
	
	/* ===========================================================================
	 *                                   기타
	 ===========================================================================*/
}
