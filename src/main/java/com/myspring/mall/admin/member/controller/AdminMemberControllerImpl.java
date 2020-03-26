package com.myspring.mall.admin.member.controller;

import java.sql.Date;
import java.util.ArrayList;
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
import org.springframework.format.annotation.DateTimeFormat;
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
import com.myspring.mall.admin.member.service.AdminMemberService;
import com.myspring.mall.member.vo.MemberVO;

import oracle.jdbc.proxy.annotation.GetProxy;

@RestController
@Controller("adminMemberController")
@EnableAspectJAutoProxy
@RequestMapping("/admin")
public class AdminMemberControllerImpl extends MultiActionController implements AdminMemberController{
	private static final Logger logger = LoggerFactory.getLogger(AdminMemberControllerImpl.class);
	@Autowired
	private AdminMemberService adminMemberService;
	@Autowired
	private MemberVO memberVO;
	
	private static ControllData conData = new ControllData();
	
	// ===========================================================================
	//                                    메인
	// ===========================================================================
	@RequestMapping(value= {"", "/main.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView main(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("[info] admin > main Start ==================");
		String viewName = (String)request.getAttribute("viewName");
		System.out.println("[info] viewName : " + viewName);
		ModelAndView mav = new ModelAndView(viewName);
		System.out.println("[info] admin > main End ====================\n");
		return mav;
	}
	
	// ===========================================================================
	//                                   회원가입 
	// ===========================================================================
	// 회원가입 창
	@RequestMapping(value= {"/membershipForm.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView membershipForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("[info] admin > memberShipForm Start ==================");
		
		String viewName = (String)request.getAttribute("viewName");
		System.out.println("[info] viewName : " + viewName);
		ModelAndView mav = new ModelAndView(viewName);

		// Object 등록
		Map mavMap = new HashMap();
		mav.addAllObjects(mavMap);
		
		System.out.println("[info] admin > memberShipForm End ====================\n");
		return mav;
	}
	// 아이디 중복확인
	@RequestMapping(value= {"/overlapped.do"}, method=RequestMethod.POST)
	public ResponseEntity<Boolean> isValidId(@RequestParam("userId") String userId) throws Exception {
		System.out.println("[info] admin > isValidId Start ==================");
		ResponseEntity<Boolean> resEntity = null;
		boolean isValidId = adminMemberService.overlapped(userId);
		
		try {
			resEntity = new ResponseEntity<Boolean>(isValidId, HttpStatus.OK);
		}catch(Exception e) {
			resEntity = new ResponseEntity(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
		System.out.println("[info] admin > isValidId End ====================\n");
		return resEntity;
	}
	// 회원등록
	@RequestMapping(value= {"/addMember.do"}, method=RequestMethod.POST)
	public void addMember(HttpServletRequest request, HttpServletResponse response,
			@RequestBody MemberVO member) throws Exception {
		System.out.println("[info] admin > addMember Start ==================");
		String nextPage = "/admin/main.do";
		
		System.out.println(member.toString());
		int result = adminMemberService.addMember(member);
		
		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		dispatcher.forward(request, response);
		System.out.println("[info] admin > addMember End ====================\n");
	}
	
	// ===========================================================================
	//                                   회원조회 
	// ===========================================================================
	@RequestMapping(value="/listMembers.do", method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView listMembers(HttpServletRequest request, HttpServletResponse response,
			@RequestParam("searchFilter") String searchFilter,
			@RequestParam("searchContent") String searchContent,
			@RequestParam("adminMode") Integer adminMode,
			@RequestParam("joinStart") @DateTimeFormat(pattern="yyyyMMdd") Date joinStart,
			@RequestParam("joinEnd") @DateTimeFormat(pattern="yyyyMMdd") Date joinEnd,
			@RequestParam("page") Integer page) throws Exception 
	{
		System.out.println("[info] admin > listMembers Start ==================");
		String viewName = (String)request.getAttribute("viewName"); 
		System.out.println("viewName : "+viewName);

		Map map = new HashMap();
		map.put("searchFilter", searchFilter);
		map.put("searchContent", searchContent);
		map.put("adminMode", adminMode);
		map.put("joinStart", joinStart);
		map.put("joinEnd", joinEnd);
		map.put("page", page);
		
		List membersList = adminMemberService.listMembersByFiltered(map);
		
		ModelAndView mav = new ModelAndView(viewName);
		mav.addObject("membersList",membersList);
		System.out.println("[info] admin > listMembers End ====================\n");
		return mav;
	}
	
	// ===========================================================================
	//                                   회원수정 
	// ===========================================================================
	// 회원수정
	@RequestMapping(value= {"/addMember.do"}, method=RequestMethod.POST)
	public void modMember(HttpServletRequest request, HttpServletResponse response,
			@RequestBody MemberVO member) throws Exception {
		System.out.println("[info] admin/controller/modMember> Start ==================");
		String nextPage = "/admin/main.do";
		
		System.out.println("(수정된 회원 정보)\n" + member.toString());
		int result = adminMemberService.modMember(member);
		
		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		dispatcher.forward(request, response);
		System.out.println("[info] admin/controller/modMember> End ====================\n");
	}
	
	// ===========================================================================
	//                                   회원삭제 
	// ===========================================================================
	// 다중삭제 기능
	// 관련 테이블 모두 삭제 필요 >
	// 	- Study_Member
	// 	- Study_Reserve
	// 	- Study_Favorite
	// 	- Study_CustomerService
	
	
	// ===========================================================================
	//                                    기타 
	// ===========================================================================
	// view 이름 불러오기
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
