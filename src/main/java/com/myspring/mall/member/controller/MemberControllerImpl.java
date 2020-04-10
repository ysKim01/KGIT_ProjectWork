package com.myspring.mall.member.controller;

import java.net.URLDecoder;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Iterator;
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
import org.springframework.web.servlet.DispatcherServlet;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.myspring.mall.admin.member.service.AdminMemberService;
import com.myspring.mall.admin.member.vo.MemberFilterVO;
import com.myspring.mall.common.ControllData;
import com.myspring.mall.member.service.MemberService;
import com.myspring.mall.member.vo.MemberVO;

import net.sf.json.JSONObject;
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
	@Autowired
	private AdminMemberService adminMemberService;
	
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
				System.out.println("[로그인]");
				System.out.println("- userId : " + member.getUserId());
				System.out.println("- userPw : " + member.getUserPw());
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
	 * 3. 로그아웃
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
		session.removeAttribute("logonId");
		session.removeAttribute("isAdmin");
		
		ModelAndView mav = new ModelAndView("redirect:/lastPage.do");
		return mav;
	}
	
	/* ===========================================================================
	 * 3-2. 로그아웃 & 메인
	 * ---------------------------------------------------------------------------
	 * > 입력 : userId, userPw
	 * > 출력 : -
	 * > 이동 페이지 : /member/loginForm.do (로그인 창)
	 * > 설명 : 
	 * 		- 로그인 창
	 ===========================================================================*/
	@RequestMapping(value= {"/logoutAndMain.do"}, method={RequestMethod.GET, RequestMethod.POST})
	public ModelAndView logoutAndMain(HttpServletRequest request, HttpServletResponse response) throws Exception {
		conData.setLastPage(request);
		
		HttpSession session = request.getSession();
		session.removeAttribute("logon");
		session.removeAttribute("logonId");
		session.removeAttribute("isAdmin");
		
		ModelAndView mav = new ModelAndView("/main");
		return mav;
	}
	
	/* ===========================================================================
	 * 4. 회원가입 창 
	 * ---------------------------------------------------------------------------
	 * > 입력 : -
	 * > 출력 : -
	 * > 이동 페이지 : /member/AddMemberForm.jsp (회원가입창)
	 * > 설명 : 
	 * 		- 조건에 맞는 회원 목록 불러오기 
	 ===========================================================================*/
	@RequestMapping(value= {"/addMemberForm.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView addMemberForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String)request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView(viewName);
		return mav;
	}
	
	/* ===========================================================================
	 * 5. 회원 등록 
	 * ---------------------------------------------------------------------------
	 * > 입력 : member (ajax/post)
	 * > 출력 : boolean
	 * > 이동 페이지 : -
	 * > 설명 : 
	 * 		- 회원 등록
	 ===========================================================================*/
	@RequestMapping(value= {"/addMember.do"}, method=RequestMethod.POST)
	public ResponseEntity<Boolean> addMember(HttpServletRequest request, HttpServletResponse response) throws Exception {
		boolean result = false;
		
		String jsonData = request.getParameter("member");
		if(jsonData != null) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println(jsonData);
			JSONObject jsonObj = JSONObject.fromObject(jsonData);
			MemberVO member = JSONtoMember(jsonObj);
			// 회원 등록
			result = memberService.addMember(member);
		}else {
			System.out.println("[warning] 회원가입 입력 정보를 가져오는데 실패했습니다.");
			result = false;
		}
		
		try {
			return new ResponseEntity<Boolean>(result, HttpStatus.OK);
		}catch(Exception e) {
			return new ResponseEntity(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
	}

	/* ===========================================================================
	 * 6. 회원수정 창
	 * ---------------------------------------------------------------------------
	 * > 입력 : - 
	 * > 출력 : member
	 * > 이동 페이지 : 회원 수정 창(/member/modMemberForm.jsp)
	 * > 설명 : 회원 수정 창 
	 ===========================================================================*/
	@RequestMapping(value={"/modMemberForm.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView modMemberForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		
		HttpSession session=request.getSession();
		String userId = (String)session.getAttribute("logonId");
		if(userId == null) {
			System.out.println("[warning] 로그인 되지 않았습니다.");
			return mav;
		}
		
		MemberVO member = adminMemberService.getMemberById(userId);
		
		mav.addObject("member", member);
		return mav;
	}
	
	/* ===========================================================================
	 * 7. 회원 수정 
	 * ---------------------------------------------------------------------------
	 * > 입력 : member (ajax/post)
	 * > 출력 : boolean
	 * > 이동 페이지 : -
	 * > 설명 : 
	 * 		- 회원 수정
	 ===========================================================================*/
	@RequestMapping(value= {"/modMember.do"}, method=RequestMethod.POST)
	public ResponseEntity<Boolean> modMember(HttpServletRequest request, HttpServletResponse response) throws Exception {
		boolean result = false;
		
		String jsonData = request.getParameter("member");
		if(jsonData != null) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println(jsonData);
			JSONObject jsonObj = JSONObject.fromObject(jsonData);
			MemberVO member = JSONtoMember(jsonObj);
			// 회원 수정
			int num = adminMemberService.modMember(member);
			if(num >= 1) result = true;
		}else {
			System.out.println("[warning] 회원수정 입력 정보를 가져오는데 실패했습니다.");
			result = false;
		}
		
		try {
			return new ResponseEntity<Boolean>(result, HttpStatus.OK);
		}catch(Exception e) {
			return new ResponseEntity(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
	}
		
	/* ===========================================================================
	 * 8. 회원 탈퇴 창
	 * ---------------------------------------------------------------------------
	 * > 입력 : - 
	 * > 출력 : member
	 * > 이동 페이지 : 회원 탈퇴 창(/member/delMemberForm.jsp)
	 * > 설명 : 
	 * 		- 회원 탈퇴 창
	 ===========================================================================*/
	@RequestMapping(value={"/delMemberForm.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView delMemberForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		
		HttpSession session=request.getSession();
		String userId = (String)session.getAttribute("logonId");
		if(userId == null) {
			System.out.println("[warning] 로그인 되지 않았습니다.");
			return mav;
		}
		
		MemberVO member = adminMemberService.getMemberById(userId);
		
		mav.addObject("member", member);
		return mav;
	}
	
	/* ===========================================================================
	 * 9. 회원 탈퇴 
	 * ---------------------------------------------------------------------------
	 * > 입력 : -
	 * > 출력 : boolean
	 * > 이동 페이지 : -
	 * > 설명 : 
	 * 		- 회원 탈퇴 및 로그 아웃
	 ===========================================================================*/
	@RequestMapping(value= {"/delMember.do"}, method=RequestMethod.POST)
	public ResponseEntity<Boolean> delMember(HttpServletRequest request, HttpServletResponse response) throws Exception {
		boolean result = false;
		
		HttpSession session=request.getSession();
		String userId = (String)session.getAttribute("logonId");
		if(userId == null) {
			System.out.println("[warning] 로그인 되지 않았습니다.");
			return new ResponseEntity("로그인 실패", HttpStatus.BAD_REQUEST);
		}
		
		String userPw = request.getParameter("userPw");
		if(userPw == null) {
			System.out.println("[warning] userPw를 받아오는데 실패했습니다.");
			return new ResponseEntity("userPw 받아오는데 실패", HttpStatus.BAD_REQUEST);
		}
		
		MemberVO member = adminMemberService.getMemberById(userId);
		if(member == null) {
			System.out.println("[warning] MemberVO 를 불러오는데 실패했습니다.");
			return new ResponseEntity("MemberVO 불러오기 실패", HttpStatus.BAD_REQUEST);
		}
		
		// 회원 삭제
		if(userPw.equals(member.getUserPw())) {
			int num = adminMemberService.delMembersList(member);
			if(num >= 1) {
				result = true;
			}else {
				System.out.println("[warning] member 삭제 적용 실패.");
				return new ResponseEntity("member 삭제 적용 실패.", HttpStatus.BAD_REQUEST);
			}
		}
		
		try {
			return new ResponseEntity<Boolean>(result, HttpStatus.OK);
		}catch(Exception e) {
			return new ResponseEntity(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
	}
	
	/* ===========================================================================
	 *                                   기타
	 ===========================================================================*/
	// JSON to MemberVO for addMember
	private MemberVO JSONtoMember(JSONObject obj) {
		MemberVO member = new MemberVO();
		// 1. userId
		// 2. userPw
		// 3. userName
		// 4. userEmail
		// 5. userBirth
		// 6. userTel1
		// 7. userTel2
		// 8. userTel3
		// 9. userAdd1
		// 10. userAdd2
		// 11. userAdd3
		// 12. userAdd4
		if(obj.size() < 12) {
			System.out.println("[warning] MemberVO 입력 파라메터 수(12) 불일치");
			return null;
		}
		// null 값  예외처리 
		Iterator<String> keys = obj.keys();
		while(keys.hasNext()) {
			String param = (String)obj.get(keys.next());
			if(conData.isEmpty(param)) {
				System.out.println("[warning] MemberVO 입력 파라메터 중 null 값 존재");
				return null;
			}
		}
		
		
		// 값 등록
		member.setUserId((String)obj.get("userId"));
		member.setUserPw((String)obj.get("userPw"));
		member.setUserName((String)obj.get("userName"));
		member.setUserEmail((String)obj.get("userEmail"));
		member.setUserTel1((String)obj.get("userTel1"));
		member.setUserTel2((String)obj.get("userTel2"));
		member.setUserTel3((String)obj.get("userTel3"));
		member.setUserAdd1((String)obj.get("userAdd1"));
		member.setUserAdd2((String)obj.get("userAdd2"));
		member.setUserAdd3((String)obj.get("userAdd3"));
		member.setUserAdd4((String)obj.get("userAdd4"));
		member.setAdminMode(0);	// 일반 회원가입은 관리자 무조건 0
		try {
			String strBirth = (String)obj.get("userBirth");
			SimpleDateFormat dateForm = new SimpleDateFormat("yyyy-MM-dd");
			Date userBirth = new Date(dateForm.parse(strBirth).getTime());
			member.setUserBirth(userBirth);
		} catch(Exception e) {
			System.out.println("[warning] userBirth 입력 시 문제 발생");
			return null;
		}
		
		return member;
	}
}
