package com.myspring.mall.admin.member.controller;

import java.net.URLDecoder;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Enumeration;
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
		String viewName = (String)request.getAttribute("viewName");
		System.out.println("[info] viewName : " + viewName);
		ModelAndView mav = new ModelAndView(viewName);
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
		String viewName = (String)request.getAttribute("viewName");
		System.out.println("[info] viewName : " + viewName);
		ModelAndView mav = new ModelAndView(viewName);

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
	public ResponseEntity<Boolean> isValidId(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ResponseEntity<Boolean> resEntity = null;
		String userId = request.getParameter("userId");
		boolean isValidId = false;
		
		if(!conData.isEmpty(userId)) {
			isValidId = adminMemberService.overlapped(userId);
		}
		
		try {
			resEntity = new ResponseEntity<Boolean>(isValidId, HttpStatus.OK);
		}catch(Exception e) {
			resEntity = new ResponseEntity(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
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
		String nextPage = "/admin/listMembers.do";
		
		System.out.println("[등록회원정보] \n" + member.toString());
		int result = adminMemberService.addMember(member);
		
		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		dispatcher.forward(request, response);
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
		String viewName = (String)request.getAttribute("viewName"); 
		System.out.println("viewName : "+viewName);
		
		List<MemberVO> membersList = new ArrayList<MemberVO>();
		SearchInfoVO searchInfo = (SearchInfoVO)request.getAttribute("searchInfo");
		if(searchInfo == null)
			searchInfo = new SearchInfoVO();
		
		membersList = adminMemberService.listMembersByFiltered(searchInfo);
		int maxPage = adminMemberService.getMaxPageByBiltered(searchInfo);
		searchInfo.setMaxPage(maxPage);

//		// Test
//		if(membersList!=null) {
//			for(MemberVO member : membersList){
//			System.out.println(member.toString());
//			}
//		}else {
//			System.out.println("리스트에 값이 없음");
//		}
		
		ModelAndView mav = new ModelAndView(viewName);
		mav.addObject("membersList",membersList);
		mav.addObject("searchInfo",searchInfo);
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
	public void searchMembers(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String nextPage = "/admin/listMembers.do";
		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		
		SearchInfoVO searchInfo = new SearchInfoVO();
		String jsonData = request.getParameter("searchInfo");

		if(jsonData != null) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println(jsonData);
			JSONObject jsonObj = JSONObject.fromObject(jsonData);
			searchInfo = JSONtoSearchInfo(jsonObj);
		}
		
		request.setAttribute("searchInfo", searchInfo);
		dispatcher.forward(request, response);
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
	public ResponseEntity<Boolean> delMember(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String jsonData = request.getParameter("member");
		
		if(jsonData != null) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println(jsonData);
			JSONObject jsonObj = JSONObject.fromObject(jsonData);
			
			MemberVO member = JSONtoMember(jsonObj);
			int result = adminMemberService.delMembersList(member);
		}
		
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
	public ResponseEntity<Boolean> delMembersList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List<MemberVO> membersList = new ArrayList<MemberVO>();
		
		String jsonData = request.getParameter("list");
		if(jsonData != null) {
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
		}
		
		return new ResponseEntity<Boolean>(true, HttpStatus.OK);
	}
	
	/* ===========================================================================
	 * 9. 회원수정 창
	 * ---------------------------------------------------------------------------
	 * > 입력 : MemberVO, Filter (submit)
	 * > 출력 : filter 
	 * > 이동 페이지 : 회원 수정 창(/admin/modMemberForm.jsp)
	 * 
	 * > 설명 : 회원 수정 창 
	 ===========================================================================*/
	@RequestMapping(value={"/modMemberForm.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView modMemberForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String)request.getAttribute("viewName"); // 잠시
		System.out.println("viewName : "+viewName);
		boolean result = true;
		
		// Member
		MemberVO member = null;
		String userId = request.getParameter("userId");
		if(!conData.isEmpty(userId)) {
			member = adminMemberService.getMemberById(userId);
			if(member==null) {result = false;}
		}else {
			result = false;
		}
		
		// SearchInfo
		SearchInfoVO searchInfo = new SearchInfoVO();
		String jsonDataSearch = request.getParameter("searchInfo");
		if(!conData.isEmpty(jsonDataSearch)) {
			jsonDataSearch = URLDecoder.decode(jsonDataSearch,"utf-8");
			System.out.println(jsonDataSearch);
			JSONObject jsonObjSearch = JSONObject.fromObject(jsonDataSearch);
			searchInfo = JSONtoSearchInfo(jsonObjSearch);
		}else {
			result = false;
		}
		
		ModelAndView mav = new ModelAndView(viewName);
		mav.addObject("member",member);
		mav.addObject("searchInfo",searchInfo);
		return mav;
	}
	
	/* ===========================================================================
	 * 10. 회원수정
	 * ---------------------------------------------------------------------------
	 * > 입력 : MemberVO (ajax/post)
	 * > 출력 : boolean 
	 * > 이동 페이지 : - 
	 * 
	 * > 설명 : 회원수정
	 ===========================================================================*/
	@RequestMapping(value={"/modMember.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Boolean> modMember(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ResponseEntity<Boolean> resEntity = null;
		boolean result = false;
		
		String jsonData = request.getParameter("member");
		System.out.println("json : " + jsonData);
		if(jsonData != null) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			//System.out.println(jsonData);
			JSONObject jsonObj = JSONObject.fromObject(jsonData);
			
			MemberVO member = JSONtoMember(jsonObj);
			if(member != null) {
				System.out.println(member.toString());
				Integer num = adminMemberService.modMember(member);
				if(num!=null && num>0)
					result = true;
			}
		}
		
		try {
			resEntity = new ResponseEntity<Boolean>(result, HttpStatus.OK);
		}catch(Exception e) {
			resEntity = new ResponseEntity(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
		return resEntity;
	}
	
	// ===========================================================================
	//                                    기타 
	// ===========================================================================
	
	// JSONObject to MemberVO
	private MemberVO JSONtoMember(JSONObject obj) {
		MemberVO member = new MemberVO();

		// 파라메터 개수 예외처리
		if(obj.size() != 13) {
			System.out.println("[warning] MemberVO 입력 파라메터 수(13) 불일치");
		}
		// null 값  예외처리 -> 
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
		
		Integer adminMode = conData.StringtoInteger(obj.getString("adminMode"));
		if(adminMode == null) {
			System.out.println("[warning] MemberVO > insert adminMode Error");
			return null;
		}
		member.setAdminMode(adminMode);
		
		try {
			String strBirth = (String)obj.get("userBirth");
			SimpleDateFormat dateForm = new SimpleDateFormat("yyyy-MM-dd");
			Date userBirth = new Date(dateForm.parse(strBirth).getTime());
			member.setUserBirth(userBirth);
		} catch(Exception e) {
			return null;
		}
		
		return member;
	}
	
	// JSONObject to SearchInfoVO
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
}
