package com.myspring.mall.admin.member.controller;

import java.net.URLDecoder;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Enumeration;
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
import com.fasterxml.jackson.core.io.JsonStringEncoder;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonArrayFormatVisitor;
import com.myspring.mall.admin.member.service.AdminMemberService;
import com.myspring.mall.admin.member.vo.SearchInfoVO;
import com.myspring.mall.member.vo.MemberVO;

import net.sf.ezmorph.MorpherRegistry;
import net.sf.ezmorph.object.DateMorpher;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONString;
import net.sf.json.util.JSONUtils;
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
	// 1. 메인
	// ===========================================================================
	@RequestMapping(value= {"", "/main.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView main(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("[info] admin/controller/main> Start ==================");
		String viewName = (String)request.getAttribute("viewName");
		System.out.println("[info] viewName : " + viewName);
		ModelAndView mav = new ModelAndView(viewName);
		System.out.println("[info] admin/controller/main> End ====================\n");
		return mav;
	}
	
	/* ===========================================================================
	 * 2. 회원등록 창 
	 * ---------------------------------------------------------------------------
	 * > 입력 : -
	 * > 출력 : List<MemberVO>
	 * > 이동 페이지 : /admin/listMembersForm.do (회원목록창)
	 * > 설명 : 
	 * 		- 조건에 맞는 회원 목록 불러오기 
	 ===========================================================================*/
	@RequestMapping(value= {"/membershipForm.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView membershipForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("[info] admin/controller/membershipForm> Start ==================");
		String viewName = (String)request.getAttribute("viewName");
		System.out.println("[info] viewName : " + viewName);
		ModelAndView mav = new ModelAndView(viewName);

		System.out.println("[info] admin/controller/membershipForm> End ====================\n");
		return mav;
	}
	
	/* ===========================================================================
	 * 3. 아이디 중복 확인 
	 * ---------------------------------------------------------------------------
	 * > 입력 : userId
	 * > 출력 : boolean
	 * > 이동 페이지 : -
	 * > 설명 : 
	 * 		- 입력받은 아이디 중복여부 확인 
	 ===========================================================================*/
	@RequestMapping(value= {"/overlapped.do"}, method=RequestMethod.POST)
	public ResponseEntity<Boolean> isValidId(@RequestParam("userId") String userId) throws Exception {
		System.out.println("[info] admin/controller/isValidId> Start ==================");
		ResponseEntity<Boolean> resEntity = null;
		boolean isValidId = adminMemberService.overlapped(userId);
		
		try {
			resEntity = new ResponseEntity<Boolean>(isValidId, HttpStatus.OK);
		}catch(Exception e) {
			resEntity = new ResponseEntity(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
		System.out.println("[info] admin/controller/isValidId> End ====================\n");
		return resEntity;
	}
	
	/* ===========================================================================
	 * 4. 회원 등록 
	 * ---------------------------------------------------------------------------
	 * > 입력 : userId
	 * > 출력 : boolean
	 * > 이동 페이지 : 회원목록(/admin/listMembers.do)
	 * > 설명 : 
	 * 		- 입력받은 아이디 중복여부 확인 
	 ===========================================================================*/
	@RequestMapping(value= {"/addMember.do"}, method=RequestMethod.POST)
	public void addMember(HttpServletRequest request, HttpServletResponse response,
			@RequestBody MemberVO member) throws Exception {
		System.out.println("[info] admin/controller/addMember> Start ==================");
		String nextPage = "/admin/listMembers.do";
		
		System.out.println("[등록회원정보] \n" + member.toString());
		int result = adminMemberService.addMember(member);
		
		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		dispatcher.forward(request, response);
		System.out.println("[info] admin/controller/addMember> End ====================\n");
	}
	
	/* ===========================================================================
	 * 5. 회원목록 
	 * ---------------------------------------------------------------------------
	 * > 입력 :	/listMembers.do -> -(aTag/get)
	 * 		 	/searchResult.do -> List<MemberVO>(redirect)
	 * > 출력 : List<MemberVO>
	 * > 이동 페이지 : /admin/adminMembers.jsp (회원목록 창 - 실제페이지)
	 * > 설명 : 
	 * 		- 회원 목록 전달
	 ===========================================================================*/
	@RequestMapping(value={"/listMembers.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView listMembers(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("[info] admin/controll/listMembers> Start ==================");
		String viewName = (String)request.getAttribute("viewName"); 
		System.out.println("viewName : "+viewName);
		
		List<MemberVO> membersList = new ArrayList<MemberVO>();
		SearchInfoVO searchInfo = (SearchInfoVO)request.getAttribute("searchInfo");
		if(searchInfo == null)
			searchInfo = new SearchInfoVO();
		
		membersList = adminMemberService.listMembersByFiltered(searchInfo);
//		// Test
//		if(membersList!=null) {
//			for(MemberVO member : membersList){
//			System.out.println(member.toString());
//			}
//		}else {
//			System.out.println("리스트에 값이 없음");
//		}
		
		searchInfo.setJoinStart(conData.Date9999toNull(searchInfo.getJoinStart()));
		searchInfo.setJoinEnd(conData.Date9999toNull(searchInfo.getJoinEnd()));
		
		ModelAndView mav = new ModelAndView(viewName);
		mav.addObject("membersList",membersList);
		mav.addObject("searchInfo",searchInfo);
		System.out.println("[info] admin/controll/listMembers> End ====================\n");
		return mav;
	}
	
	/* ===========================================================================
	 * 6. 회원검색 
	 * ---------------------------------------------------------------------------
	 * > 입력 : SearchInfo (submit/get)
	 * > 출력 : SearchInfo
	 * > 이동 페이지 : /admin/searchResult.do (회원목록)
	 * > 설명 : 
	 * 		- 조건에 맞는 회원 검색 후,회원 목록 전달
	 ===========================================================================*/
	@RequestMapping(value={"/searchMembers.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public void searchMembers(HttpServletRequest request, HttpServletResponse response,
			@RequestParam("searchInfo") String jsonData) throws Exception {
		System.out.println("[info] admin/controll/searchMembers> Start ==================");
		String nextPage = "/admin/listMembers.do";
		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		
		jsonData = URLDecoder.decode(jsonData,"utf-8");
		System.out.println(jsonData);
		JSONObject jsonObj = JSONObject.fromObject(jsonData);
		
		SearchInfoVO searchInfo = JSONtoSearchInfo(jsonObj);
		request.setAttribute("searchInfo", searchInfo);
		
		System.out.println("[info] admin/controll/searchMembers> End ====================\n");
		dispatcher.forward(request, response);
	}
	private SearchInfoVO JSONtoSearchInfo(JSONObject obj) {
		SearchInfoVO info = new SearchInfoVO();

		info.setSearchFilter((String)obj.get("searchFilter"));
		info.setSearchContent((String)obj.get("searchContent"));
		info.setAdminMode(conData.StringtoInteger((String)obj.get("adminMode")));
		info.setPage(conData.StringtoInteger((String)obj.get("page")));
		try {
			String strJoinStart = (String)obj.get("joinStart");
			String strJoinEnd = (String)obj.get("joinEnd");
			SimpleDateFormat dateForm = new SimpleDateFormat("yyyy-MM-dd");
			Date joinStart = null;
			Date joinEnd = null;
			if(!conData.isEmpty(strJoinStart))
				joinStart = new Date(dateForm.parse(strJoinStart).getTime());
			if(!conData.isEmpty(strJoinEnd))
				joinEnd = new Date(dateForm.parse(strJoinEnd).getTime());
			info.setJoinStart(joinStart);
			info.setJoinEnd(joinEnd);
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return info;
	}
	
	/* ===========================================================================
	 * 7. 회원삭제 
	 * ---------------------------------------------------------------------------
	 * > 입력 : MemberVO, Filter (ajax/???)
	 * > 출력 : filter 
	 * > 이동 페이지 : 회원 리스트(/admin/listMembers.do))
	 * 
	 * > 설명 : 삭제할 회원을 받아 삭제
	 * 		관련 테이블 (cascade 제약 자동 연계삭제)
	 *		- Study_Member
	 *		- Study_Reserve
	 *		- Study_Favorite
	 *		- Study_CustomerService
	 ===========================================================================*/
	@RequestMapping(value={"/delMember.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Boolean> delMember(HttpServletRequest request, HttpServletResponse response,
			@RequestParam("member") String jsonData) throws Exception {
		System.out.println("[info] admin/controller/delMember> Start ==================");
		List<MemberVO> membersList = new ArrayList<MemberVO>();
		
		jsonData = URLDecoder.decode(jsonData,"utf-8");
		System.out.println(jsonData);
		JSONObject jsonObj = JSONObject.fromObject(jsonData);
		
		MemberVO member = JSONtoMember(jsonObj);
		int result = adminMemberService.delMembersList(member);
		
		System.out.println("[info] admin/controller/delMember> End ====================\n");
		return new ResponseEntity<Boolean>(true, HttpStatus.OK);
	}
	
	/* ===========================================================================
	 * 8. 다중회원삭제 
	 * ---------------------------------------------------------------------------
	 * > 입력 : List<MemberVO>, Filter (ajax/???)
	 * > 출력 : filter 
	 * > 이동 페이지 : 회원 리스트(/admin/listMembers.do))
	 * 
	 * > 설명 : 삭제할 회원을 받아 삭제
	 * 		관련 테이블 (cascade 제약 자동 연계삭제)
	 *		- Study_Member
	 *		- Study_Reserve
	 *		- Study_Favorite
	 *		- Study_CustomerService
	 ===========================================================================*/
	@RequestMapping(value={"/delMembersList.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Boolean> delMembersList(HttpServletRequest request, HttpServletResponse response,
			@RequestParam("list") String jsonData) throws Exception {
		System.out.println("[info] admin/controller/delMembersList> Start ==================");
		List<MemberVO> membersList = new ArrayList<MemberVO>();

		jsonData = URLDecoder.decode(jsonData,"utf-8");
		JSONArray array = JSONArray.fromObject(jsonData);
		for(int i=0;i<array.size();i++) {
			JSONObject obj = (JSONObject)array.get(i);
			MemberVO member = JSONtoMember(obj);
			System.out.println(member.toString());
			membersList.add(member);
		}
		
		int result = adminMemberService.delMembersList(membersList);
		System.out.println("삭제된 열 : " + result);
		
		System.out.println("[info] admin/controller/delMembersList> End ====================\n");
		return new ResponseEntity<Boolean>(true, HttpStatus.OK);
	}
	private MemberVO JSONtoMember(JSONObject obj) {
		MemberVO member = new MemberVO();
		
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
		member.setAdminMode(Integer.parseInt((String)obj.get("adminMode")));
		try {
			String strBirth = (String)obj.get("userBirth");
			String strJoin = (String)obj.get("joinDate");
			SimpleDateFormat dateForm = new SimpleDateFormat("yyyy-MM-dd");
			Date userBirth = new Date(dateForm.parse(strBirth).getTime());
			Date joinDate = new Date(dateForm.parse(strJoin).getTime());
			member.setUserBirth(userBirth);
			member.setJoinDate(joinDate);
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return member;
	}
	
//	/* ===========================================================================
//	 * 6. 회원 정보 수정 창
//	 * ---------------------------------------------------------------------------
//	 * > 입력 : MemberVO, Filter값 (post)
//	 * > 출력 : MemberVO, Filter값
//	 * > 이동 페이지 : /admin/modMemberForm.jsp (회원정보 수정창 - 실제페이지)
//	 * > 설명 : 
//	 * 		- 수정할 회원 정보를 전달
//	 * 		- 이전 검색필터 전달
//	 ===========================================================================*/
//	@RequestMapping(value="/modMemberForm.do", method= {RequestMethod.GET, RequestMethod.POST})
//	public ModelAndView modMemberForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
//		System.out.println("[info] admin/controller/modMemberForm> Start ==================");
//		String viewName = (String)request.getAttribute("viewName"); 
//		System.out.println("viewName : "+viewName);
//
//		String searchFilter = (String)request.getAttribute("searchFilter");
//		String searchContent = (String)request.getAttribute("searchContent");
//		Integer adminMode = (Integer)request.getAttribute("adminMode");
//		Date joinStart = (Date)request.getAttribute("joinStart");
//		Date joinEnd = (Date)request.getAttribute("joinEnd");
//		Integer page = (Integer)request.getAttribute("page");
//		MemberVO member = (MemberVO)request.getAttribute("member");
//		
//		ModelAndView mav = new ModelAndView(viewName);
//		mav.addObject("searchFilter", searchFilter);
//		mav.addObject("searchContent", searchContent);
//		mav.addObject("adminMod", adminMode);
//		mav.addObject("joinStart", joinStart);
//		mav.addObject("joinEnd", joinEnd);
//		mav.addObject("page", page);
//		mav.addObject("member", member);
//		
//		System.out.println("[info] admin/controller/modMember> End ====================\n");
//		return mav;
//	}
//	
//	/* ===========================================================================
//	 *                                   회원수정 
//	 * ---------------------------------------------------------------------------
//	 * > 입력 : MemberVO, Filter값 / submit
//	 * > 출력 : List<MemberVO>
//	 * > 이동 페이지 : /admin/listMembersForm.do (회원목록창)
//	 * > 설명 : 
//	 * 		- 수정할 회원 정보를 받아 해당id와 맞는 column을 수정 
//	 * 		- 조건에 맞는 회원 목록 불러오기 
//	 ===========================================================================*/
//	@RequestMapping(value="/modMembers.do", method= {RequestMethod.GET, RequestMethod.POST})
//	public void modMember(HttpServletRequest request, HttpServletResponse response,
//			@RequestParam(value="searchFilter", required=false) String searchFilter,
//			@RequestParam(value="searchContent", required=false) String searchContent,
//			@RequestParam(value="adminMode", required=false) Integer adminMode,
//			@RequestParam(value="joinStart", required=false) @DateTimeFormat(pattern="yyyyMMdd") Date joinStart,
//			@RequestParam(value="joinEnd", required=false) @DateTimeFormat(pattern="yyyyMMdd") Date joinEnd,
//			@RequestParam(value="page", required=false) Integer page,
//			@ModelAttribute(value="") MemberVO member) throws Exception 
//	{
//		System.out.println("[info] admin/controller/modMember> Start ==================");
//		String nextPage = "/admin/listMembers.do";
//		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
//		
//		// 회원 정보 수정
//		System.out.println("(수정된 회원 정보)\n" + member.toString());
//		int result = adminMemberService.modMember(member);
//		
//		// 조건에 맞는 회원리스트 재 검색
//		Map map = new HashMap();
//		map.put("searchFilter", searchFilter);
//		map.put("searchContent", searchContent);
//		map.put("adminMode", adminMode);
//		map.put("joinStart", joinStart);
//		map.put("joinEnd", joinEnd);
//		map.put("page", page);
//		List membersList = adminMemberService.listMembersByFiltered(map);
//		request.setAttribute("membersList", membersList);
//		
//		dispatcher.forward(request, response);
//		System.out.println("[info] admin/controller/modMember> End ====================\n");
//	}
//	
//	/* ===========================================================================
//	 *                                   회원삭제 
//	 * ---------------------------------------------------------------------------
//	 * > 입력 : MemberVO(ajax/json)
//	 * > 출력 : - 
//	 * > 이동 페이지 : 회원 리스트(/admin/listMembers.do))
//	 * 
//	 * > 설명 : 수정할 회원 정보를 받아 해당id와 맞는 column을 수정 
//	 ===========================================================================*/
//	public void delMember(HttpServletRequest request, HttpServletResponse response,
//			@ModelAttribute(value="") MemberVO member) throws Exception {
//		System.out.println("[info] admin/controller/delMember> Start ==================");
//		String nextPage = "/admin/main.do";
//		
//		int result = adminMemberService.modMember(member);
//		
//		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
//		dispatcher.forward(request, response);
//		System.out.println("[info] admin/controller/delMember> End ====================\n");
//	}

	

	
	
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
