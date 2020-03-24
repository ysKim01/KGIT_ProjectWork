package com.myspring.mall.admin.member.controller;

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
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.DispatcherServlet;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.myspring.mall.common.ControllData;
import com.myspring.mall.admin.member.service.MemberService;
import com.myspring.mall.member.vo.MemberVO;

import oracle.jdbc.proxy.annotation.GetProxy;

@RestController
@Controller("adminMemberController")
@EnableAspectJAutoProxy
@RequestMapping("/admin")
public class MemberControllerImpl extends MultiActionController implements MemberController{
	private static final Logger logger = LoggerFactory.getLogger(MemberControllerImpl.class);
	@Autowired
	private MemberService memberService;
	@Autowired
	private MemberVO memberVO;
	
	private static ControllData conData = new ControllData();
	
	// 메인 화면
	@RequestMapping(value= {"", "/main.do"}, method=RequestMethod.GET)
	public ModelAndView main(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String)request.getAttribute("viewName");
		//String viewName = getViewName(request);
		System.out.println("viewName : "+viewName);
		ModelAndView mav = new ModelAndView(viewName);
		return mav;
	}
	
	// ================================== 회원가입 ==================================
	// 회원가입 창
	@RequestMapping(value= {"/membershipForm.do"}, method=RequestMethod.GET)
	public ModelAndView membershipForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String)request.getAttribute("viewName");
		System.out.println("viewName : "+viewName);
		ModelAndView mav = new ModelAndView(viewName);

		// Object 등록
		Map mavMap = new HashMap();
		mav.addAllObjects(mavMap);
		
		return mav;
	}
	// 아이디 중복확인
	@RequestMapping(value= {"/overlapped.do"}, method=RequestMethod.POST)
	public ResponseEntity<Boolean> isValidId(@RequestBody String userId) throws Exception {
		System.out.println("isValidId Call");
		ResponseEntity<Boolean> resEntity = null;
		System.out.println("userId는 이거 " + userId);
		boolean isValidId = memberService.isValidId("aa");
		
		try {
			resEntity = new ResponseEntity<Boolean>(isValidId, HttpStatus.OK);
		}catch(Exception e) {
			resEntity = new ResponseEntity(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
		
		return resEntity;
	}
	// 회원 추가
	@RequestMapping(value= {"/addMember.do"}, method=RequestMethod.POST)
	public ModelAndView addMember(HttpServletRequest request, HttpServletResponse response,
			@RequestBody MemberVO member) throws Exception {
		ModelAndView mav = new ModelAndView();
		String viewName = null;
		
		System.out.println(member.toString());
		int result = memberService.addMember(member);
		
		viewName = "/main";
		System.out.println("viewName : "+viewName);
		mav.setViewName(viewName);
		return mav;
	}
	// 회원조회
	@RequestMapping(value="/listMembers.do", method=RequestMethod.GET)
	public ModelAndView listMembers(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String)request.getAttribute("viewName"); 
		System.out.println("viewName : "+viewName);
		List membersList = memberService.listMembers();
		ModelAndView mav = new ModelAndView(viewName);
		
		mav.addObject("membersList",membersList);
		
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
