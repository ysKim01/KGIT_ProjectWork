package com.myspring.mall.admin.reserve.controller;

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
import com.myspring.mall.common.mail.MailService;
import com.fasterxml.jackson.core.io.JsonStringEncoder;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonArrayFormatVisitor;
import com.myspring.mall.admin.center.service.AdminCenterService;
import com.myspring.mall.admin.member.service.AdminMemberService;
import com.myspring.mall.admin.member.vo.MemberFilterVO;
import com.myspring.mall.admin.reserve.service.AdminReserveService;
import com.myspring.mall.admin.reserve.vo.AdminReserveSearchVO;
import com.myspring.mall.admin.reserve.vo.ReserveFilterVO;
import com.myspring.mall.center.vo.CenterInfoVO;
import com.myspring.mall.center.vo.RoomInfoVO;
import com.myspring.mall.member.vo.MemberVO;
import com.myspring.mall.reserve.vo.ReserveVO;

import net.sf.ezmorph.MorpherRegistry;
import net.sf.ezmorph.object.DateMorpher;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONString;
import net.sf.json.util.JSONUtils;
import oracle.jdbc.proxy.annotation.GetProxy;

@RestController
@Controller("adminReserveController")
@EnableAspectJAutoProxy
@RequestMapping("/admin")
public class AdminReserveControllerImpl extends MultiActionController implements AdminReserveController{
	private static final Logger logger = LoggerFactory.getLogger(AdminReserveControllerImpl.class);
	@Autowired
	private AdminReserveService adminReserveService;
	@Autowired
	private AdminCenterService adminCenterService;
	@Autowired
	private AdminMemberService adminMemberService;
	@Autowired
	private MailService mailService;
	
	private static ControllData conData = new ControllData();
	
	
	/* ===========================================================================
	 * 1. 예약등록 창 
	 * ---------------------------------------------------------------------------
	 * > 입력 : centerCode
	 * > 출력 : centerCode, roomInfo-List, 
	 * 			
	 * > 이동 페이지 : /admin/adminAddReserve.jsp (예약등록창)
	 * > 설명 : 
	 * 		- 조건에 맞는 회원 목록 불러오기 
	 ===========================================================================*/
	@RequestMapping(value= {"/addReserveForm.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView addReserveForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// Center Code
		String centerCode = request.getParameter("centerCode");
		CenterInfoVO centerInfo = adminCenterService.selectCenterByCenterCode(centerCode);
		
		// RoomInfo List
		List<RoomInfoVO> roomList = new ArrayList<RoomInfoVO>();
		if(!conData.isEmpty(centerCode)) {
			roomList = adminCenterService.listRoomsByCenter(centerCode);
		}
		
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		mav.addObject("centerInfo", centerInfo);
		mav.addObject("roomList", roomList);
		return mav;
	}
	
	/* ===========================================================================
	 * 2. 예약가능 시간  
	 * ---------------------------------------------------------------------------
	 * > 입력 : centerCode, roomCode, reserveDate (ajax/post)
	 * > 출력 : usingTime(&) 
	 * 			
	 * > 이동 페이지 : - 
	 * > 설명 : 
	 * 		- 방 사용시간 정보 리턴 
	 ===========================================================================*/
	@RequestMapping(value= {"/usableTime.do"}, method=RequestMethod.POST)
	public ResponseEntity<String> usableTime(HttpServletRequest request, HttpServletResponse response) throws Exception {
		SimpleDateFormat dateForm = new SimpleDateFormat("yyyy-MM-dd");
		
		// 예외처리
		int paramCnt = 0;
		Enumeration<String> names = request.getParameterNames();
		while(names.hasMoreElements()) {
			String name = names.nextElement();
			String param = request.getParameter(name);
			System.out.println(name+" : " +param);
			if(conData.isEmpty(param) && !name.equals("keyNum")) {
				return new ResponseEntity(param + " : null 값 전송", HttpStatus.BAD_REQUEST);
			}
			paramCnt++;
		}
		if(paramCnt < 3) {
			return new ResponseEntity("파라미터 수 불일치(3~4)", HttpStatus.BAD_REQUEST);
		}
		
		// param 값 받아오기
		String centerCode = request.getParameter("centerCode");
		String roomCode = request.getParameter("roomCode");
		Date reserveDate = new Date(dateForm.parse(request.getParameter("reserveDate")).getTime());
		
		// usableTime
		String usableTime = adminReserveService.getUsableTime(centerCode, roomCode, reserveDate);
		System.out.println("usableTime : " + usableTime);
		
		// 수정 시
		Integer keyNum = conData.StringtoInteger(request.getParameter("keyNum"));
		if(keyNum != null) {
			ReserveVO oldReserve = adminReserveService.selectReserve(keyNum);
			System.out.println("oldUsingTime : " + oldReserve.getUsingTime());
			if(reserveDate.equals(oldReserve.getReserveDate())) {
				usableTime = delOldUsingTime(usableTime, oldReserve.getUsingTime());
				System.out.println("newUsingTime : " + usableTime);
			}
		}
		
		if(conData.isEmpty(usableTime)) {
			return new ResponseEntity("값 불러오지 못함", HttpStatus.BAD_REQUEST);
		}else {
			return new ResponseEntity<String>(usableTime, HttpStatus.OK);
		}
	}

	/* ===========================================================================
	 * 3. 예약 등록  
	 * ---------------------------------------------------------------------------
	 * > 입력 : reserveVO, scale (ajax/post)
	 * > 출력 : boolean
	 * 			
	 * > 이동 페이지 : - 
	 * > 설명 : 
	 * 		- 예약 등록
	 ===========================================================================*/
	@RequestMapping(value= {"/addReserve.do"}, method=RequestMethod.POST)
	public ResponseEntity<Boolean> addReserve(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// Reserve 
		ReserveVO reserve = new ReserveVO();
		String jsonDataReserve = request.getParameter("reserve");
		if(!conData.isEmpty(jsonDataReserve)) {
			jsonDataReserve = URLDecoder.decode(jsonDataReserve,"utf-8");
			System.out.println(jsonDataReserve);
			JSONObject jsonObjReserve = JSONObject.fromObject(jsonDataReserve);
			reserve = JSONtoReserve(jsonObjReserve);
			if(reserve == null) {
				return new ResponseEntity("[warning] ReserveVO 값을 받아오지 못했습니다.", HttpStatus.BAD_REQUEST);
			}
		}else {
			return new ResponseEntity("[warning] Parameter(reserve)를 받아오지 못했습니다.", HttpStatus.BAD_REQUEST);
		}
		// scale(RoomInfo)
		String strScale = request.getParameter("scale");
		if(conData.isEmpty(strScale)) {
			return new ResponseEntity("[warning] Parameter(scale)를 받아오지 못했습니다.", HttpStatus.BAD_REQUEST);
		}
		Integer scale = conData.StringtoInteger(strScale);
		// Reserve 
		CenterInfoVO center = new CenterInfoVO();
		String jsonDataCenter = request.getParameter("centerInfo");
		if(!conData.isEmpty(jsonDataCenter)) {
			jsonDataCenter = URLDecoder.decode(jsonDataCenter,"utf-8");
			System.out.println(jsonDataCenter);
			JSONObject jsonObjCenter = JSONObject.fromObject(jsonDataCenter);
			center = JSONtoCenterInfo(jsonObjCenter);
			if(reserve == null) {
				return new ResponseEntity("[warning] CenterInfoVO 값을 받아오지 못했습니다.", HttpStatus.BAD_REQUEST);
			}
		}else {
			return new ResponseEntity("[warning] Parameter(center)를 받아오지 못했습니다.", HttpStatus.BAD_REQUEST);
		}
		
		// 예약등록
		boolean result = false;
		result = adminReserveService.insertReserve(reserve, scale, center);
		
		return new ResponseEntity<Boolean>(result, HttpStatus.OK);
	}
	
	/* ===========================================================================
	 * 4. 예약목록 
	 * ---------------------------------------------------------------------------
	 * > 입력 :	/listReserve.do (Get/Post)
	 * > 출력 : List<MemberVO>
	 * > 이동 페이지 : /admin/adminMembers.jsp (회원목록 창 - 실제페이지)
	 * > 설명 : 
	 * 		- 회원 목록 전달
	 ===========================================================================*/
	@RequestMapping(value={"/listReserve.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView listReserve(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List<AdminReserveSearchVO> reserveList = new ArrayList<AdminReserveSearchVO>();
		
		ReserveFilterVO searchInfo = (ReserveFilterVO)request.getAttribute("searchInfo");
		if(searchInfo == null)
			searchInfo = new ReserveFilterVO();
		System.out.println(searchInfo.toString());
		
		reserveList = adminReserveService.listReserveByFiltered(searchInfo);
		for(AdminReserveSearchVO reserve : reserveList) {
			System.out.println(reserve.toString());
			//reserve.setReserveStatus(conData.transStatusLang(reserve.getReserveStatus()));
		}
		
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		mav.addObject("reserveList",reserveList);
		mav.addObject("searchInfo",searchInfo);
		return mav;
	}
	
	/* ===========================================================================
	 * 5. 예약검색 
	 * ---------------------------------------------------------------------------
	 * > 입력 : ReserveFilter (submit/get)
	 * > 출력 : ReserveFilter
	 * > 이동 페이지 : /admin/listReserve.do (예약목록)
	 * > 설명 : 
	 * 		- 조건에 맞는 회원 검색 후,회원 목록 전달
	 ===========================================================================*/
	@RequestMapping(value={"/searchReserve.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public void searchReserve(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String nextPage = "/admin/listReserve.do";
		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		
		ReserveFilterVO searchInfo = new ReserveFilterVO();
		String jsonData = request.getParameter("searchInfo");

		if(!conData.isEmpty(jsonData)) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println(jsonData);
			JSONObject jsonObj = JSONObject.fromObject(jsonData);
			searchInfo = JSONtoReserveFilter(jsonObj);
		}else{
			searchInfo = null;
		}
		
		request.setAttribute("searchInfo", searchInfo);
		dispatcher.forward(request, response);
	}
	/* ===========================================================================
	 * 6. 예약 삭제  
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum (ajax/post)
	 * > 출력 : boolean
	 * > 이동 페이지 : - 
	 * > 설명 : 
	 * 		- 예약 삭제
	 ===========================================================================*/
	@RequestMapping(value= {"/delReserve.do"}, method=RequestMethod.POST)
	public ResponseEntity<Boolean> delReserve(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		Integer keyNum = conData.StringtoInteger(request.getParameter("keyNum"));
		if(keyNum == null) {
			return new ResponseEntity("[warning] keyNumd을 받아오는데 문제가 발생했습니다.", HttpStatus.BAD_REQUEST);
		}
		
		// 예약 삭제
		boolean result = false;
		result = adminReserveService.deleteReserve(keyNum);
		
		return new ResponseEntity<Boolean>(result, HttpStatus.OK);
	}
	
	/* ===========================================================================
	 * 7. 다중예약삭제 
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum - List (ajax/post)
	 * > 출력 : boolean
	 * > 이동 페이지 : 회원 리스트(/admin/listMembers.do))
	 * > 설명 : 
	 * 		- keyNum - List 받아서 예약 삭제
	 ===========================================================================*/
	@RequestMapping(value={"/delReserveList.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Boolean> delReserveList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		int result = 0;
		
		String jsonData = request.getParameter("list");
		if(jsonData != null) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println(jsonData);
			JSONArray array = JSONArray.fromObject(jsonData);
			for(int i=0;i<array.size();i++) {
				Integer keyNum = array.getInt(i);
				boolean delResult = adminReserveService.deleteReserve(keyNum);
				if(delResult) result++;
			}
			System.out.println("삭제된 열 : " + result + "/" + array.size());
		}
		
		return new ResponseEntity<Boolean>(true, HttpStatus.OK);
	}
	
	/* ===========================================================================
	 * 8. 예약 수정 창 
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum, searchInfo
	 * > 출력 : ReserveVO, searchInfo
	 * > 이동 페이지 : /admin/adminModReserve.jsp (예약수정창)
	 * > 설명 : 
	 * 		- 조건에 맞는 회원 목록 불러오기 
	 ===========================================================================*/
	@RequestMapping(value= {"/modReserveForm.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView modReserveForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// reserve
		ReserveVO reserve = null;
		String centerCode = null;
		Integer keyNum = conData.StringtoInteger(request.getParameter("keyNum"));
		if(keyNum != null) {
			reserve = adminReserveService.selectReserve(keyNum);
			centerCode = reserve.getCenterCode();
			System.out.println(reserve.toString());
		}else {
			System.out.println("[warning] keyNum을 불러오지 못했습니다.");
		}
		
		// SearchInfo
		ReserveFilterVO searchInfo = null;
		String jsonDataSearch = request.getParameter("searchInfo");
		if(!conData.isEmpty(jsonDataSearch)) {
			jsonDataSearch = URLDecoder.decode(jsonDataSearch,"utf-8");
			System.out.println(jsonDataSearch);
			JSONObject jsonObjSearch = JSONObject.fromObject(jsonDataSearch);
			searchInfo = JSONtoReserveFilter(jsonObjSearch);
			System.out.println(searchInfo.toString());
		}else {
			System.out.println("[warning] searchInfo를 불러오지 못했습니다.");
		}
		
		// CenterInfo
		CenterInfoVO centerInfo = null;
		if(!conData.isEmpty(centerCode)) {
			centerInfo = adminCenterService.selectCenterByCenterCode(centerCode);
		}else {
			System.out.println("[warning] centerInfo를 불러오지 못했습니다.");
		}
		
		// RoomInfo List
		List<RoomInfoVO> roomList = new ArrayList<RoomInfoVO>();
		if(!conData.isEmpty(centerCode)) {
			roomList = adminCenterService.listRoomsByCenter(centerCode);
		}else {
			System.out.println("[warning] roomList를 불러오지 못했습니다.");
		}
		
		
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		mav.addObject("reserve", reserve);
		mav.addObject("searchInfo", searchInfo);
		mav.addObject("roomList", roomList);
		mav.addObject("centerInfo", centerInfo);
		return mav;
	}
	
	/* ===========================================================================
	 * 9. 예약 수정  
	 * ---------------------------------------------------------------------------
	 * > 입력 : reserveVO, scale, centerInfo, keyNum(old) (ajax/post)
	 * > 출력 : boolean
	 * > 이동 페이지 : - 
	 * > 설명 : 
	 * 		- 기존 예약 삭제  후  새 예약 등록
	 ===========================================================================*/
	@RequestMapping(value= {"/modReserve.do"}, method=RequestMethod.POST)
	public ResponseEntity<Boolean> modReserve(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// Reserve 
		ReserveVO reserve = new ReserveVO();
		String jsonDataReserve = request.getParameter("reserve");
		if(!conData.isEmpty(jsonDataReserve)) {
			jsonDataReserve = URLDecoder.decode(jsonDataReserve,"utf-8");
			System.out.println(jsonDataReserve);
			JSONObject jsonObjReserve = JSONObject.fromObject(jsonDataReserve);
			reserve = JSONtoReserve(jsonObjReserve);
			if(reserve == null) {
				return new ResponseEntity("[warning] ReserveVO 값을 받아오지 못했습니다.", HttpStatus.BAD_REQUEST);
			}
		}else {
			return new ResponseEntity("[warning] Parameter(reserve)를 받아오지 못했습니다.", HttpStatus.BAD_REQUEST);
		}
		// scale(RoomInfo)
		String strScale = request.getParameter("scale");
		if(conData.isEmpty(strScale)) {
			return new ResponseEntity("[warning] Parameter(scale)를 받아오지 못했습니다.", HttpStatus.BAD_REQUEST);
		}
		Integer scale = conData.StringtoInteger(strScale);
		// Reserve 
		CenterInfoVO center = new CenterInfoVO();
		String jsonDataCenter = request.getParameter("centerInfo");
		if(!conData.isEmpty(jsonDataCenter)) {
			jsonDataCenter = URLDecoder.decode(jsonDataCenter,"utf-8");
			System.out.println(jsonDataCenter);
			JSONObject jsonObjCenter = JSONObject.fromObject(jsonDataCenter);
			center = JSONtoCenterInfo(jsonObjCenter);
			if(reserve == null) {
				return new ResponseEntity("[warning] CenterInfoVO 값을 받아오지 못했습니다.", HttpStatus.BAD_REQUEST);
			}
		}else {
			return new ResponseEntity("[warning] Parameter(center)를 받아오지 못했습니다.", HttpStatus.BAD_REQUEST);
		}
		// keyNum
		Integer oldKeyNum = conData.StringtoInteger(request.getParameter("keyNum"));
		if(oldKeyNum == null) {
			return new ResponseEntity("[warning] keyNumd을 받아오는데 문제가 발생했습니다.", HttpStatus.BAD_REQUEST);
		}
		
		boolean result = false;
		result = adminReserveService.insertReserve(reserve, scale, center);
		result = adminReserveService.deleteReserve(oldKeyNum);
		
		return new ResponseEntity<Boolean>(result, HttpStatus.OK);
	}

	/* ===========================================================================
	 * 10. 결재 완료 
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum 
	 * > 출력 : boolean
	 * > 이동 페이지 : - 
	 * > 설명 : 
	 * 		- 예약신청(Apply) > 결재완료(Payment)
	 ===========================================================================*/
	@RequestMapping(value= {"/payment.do"}, method=RequestMethod.POST)
	public ResponseEntity<Boolean> payment(HttpServletRequest request, HttpServletResponse response) throws Exception {

		Integer keyNum = conData.StringtoInteger(request.getParameter("keyNum"));
		if(keyNum == null) {
			return new ResponseEntity("[warning] keyNum을 받아오는데 문제가 발생했습니다.", HttpStatus.BAD_REQUEST);
		}
		System.out.println("keyNum : " + keyNum);
		
		// 결재 완료
		boolean result = false;
		result = adminReserveService.paymentReserve(keyNum);
		
		// 메일 전송
		AdminReserveSearchVO rsvSearch = adminReserveService.selectReserveSearch(keyNum);
		if(rsvSearch != null) { 
			System.out.println(rsvSearch.toString()); 
		}else { 
			System.out.println("[warning] AdminReserveSearchVO를 받아오는데 문제가 발생했습니다.");
		}
		
		CenterInfoVO center = adminCenterService.selectCenterByCenterCode(rsvSearch.getCenterCode());
		if(center != null) { 
			System.out.println(center.toString()); 
		}else { 
			System.out.println("[warning] CenterInfoVO를 받아오는데 문제가 발생했습니다.");
		}
		
		MemberVO member = adminMemberService.getMemberById(rsvSearch.getUserId());
		if(member != null) { 
			System.out.println(member.toString()); 
		}else { 
			System.out.println("[warning] MemberVO를 받아오는데 문제가 발생했습니다.");
		}
		
		if(rsvSearch!=null && center!=null && member!=null) {
			mailService.mailForPayment(request, member.getUserEmail(), rsvSearch, center);
		}
		
		return new ResponseEntity<Boolean>(result, HttpStatus.OK);
	}
	
	
	// ===========================================================================
	//                                    기타 
	// ===========================================================================
	
	// JSONObject to ReserveVO for Apply
	private ReserveVO JSONtoReserve(JSONObject obj) {
		ReserveVO reserve = new ReserveVO();
		SimpleDateFormat dateForm = new SimpleDateFormat("yyyy-MM-dd");

		// 입력 파라미터 
		// 1. userId
		// 2. centerCode
		// 3. roomCode
		// 4. reserveDate
		// 5. usingTime
		// 6. extraCode
		if(obj.size() < 6) {
			System.out.println("[warning] reserveVO 입력 파라메터 수(6) 불일치");
			return null;
		}
		// null 값  예외처리 -> 
		Iterator<String> keys = obj.keys();
		while(keys.hasNext()) {
			String name = keys.next();
			String param = (String)obj.get(name);
			if(param == null) {
				System.out.println("[warning] " + name + " is null ");
				return null;
			}
		}
		
		// 값 등록 (8 / keyNun,applyDate 제외)
		reserve.setUserId(obj.getString("userId"));
		reserve.setCenterCode(obj.getString("centerCode"));
		reserve.setRoomCode(obj.getString("roomCode"));
		reserve.setUsingTime(obj.getString("usingTime"));
		reserve.setExtraCode(obj.getString("extraCode"));
		try {
			String strReserveDate = (String)obj.get("reserveDate");
			Date reserveDate = new Date(dateForm.parse(strReserveDate).getTime());
			reserve.setReserveDate(reserveDate);
		} catch(Exception e) {
			return null;
		}
		
		return reserve;
	}
	// JSONObject to CenterInfoVO for Apply
	private CenterInfoVO JSONtoCenterInfo(JSONObject obj) {
		CenterInfoVO center = new CenterInfoVO();

		// 입력 파라미터 
		// 1. unitPrice
		// 2. premiumRate(%)
		// 3. surchageTime(분)
		// 4. unitTime(분)
		// 5. operTimeStart(분)
		// 6. operTimeEnd(분)
		if(obj.size() < 3) {
			System.out.println("[warning] CenterInfoVO 입력 파라메터 수(3) 불일치");
			return null;
		}
		// 빈 값 예외처리 
		Iterator<String> keys = obj.keys();
		while(keys.hasNext()) {
			String name = keys.next();
			String param = (String)obj.get(name);
			if(conData.isEmpty(param)) {
				System.out.println("[warning] " + name + " is null ");
				return null;
			}
		}
		
		// 값 등록 (8 / keyNun,applyDate 제외)
		Integer unitPrice = conData.StringtoInteger(obj.getString("unitPrice"));
		if(unitPrice == null) {
			System.out.println("[warning] CenterInfoVO > insert unitPrice Error");
			return null;
		}
		Integer premiumRate = conData.StringtoInteger(obj.getString("premiumRate"));
		if(premiumRate == null) {
			System.out.println("[warning] CenterInfoVO > insert premiumRate Error");
			return null;
		}
		Integer surchageTime = conData.StringtoInteger(obj.getString("surchageTime"));
		if(surchageTime == null) {
			System.out.println("[warning] CenterInfoVO > insert surchageTime Error");
			return null;
		}
		
		Integer unitTime = conData.StringtoInteger(obj.getString("unitTime"));
		if(unitTime == null) {
			System.out.println("[warning] CenterInfoVO > insert unitTime Error");
			return null;
		}
		Integer operTimeStart = conData.StringtoInteger(obj.getString("operTimeStart"));
		if(operTimeStart == null) {
			System.out.println("[warning] CenterInfoVO > insert operTimeStart Error");
			return null;
		}
		Integer operTimeEnd = conData.StringtoInteger(obj.getString("operTimeEnd"));
		if(operTimeEnd == null) {
			System.out.println("[warning] CenterInfoVO > insert operTimeEnd Error");
			return null;
		}
		center.setUnitPrice(unitPrice);
		center.setPremiumRate(premiumRate);
		center.setSurchageTime(surchageTime);
		center.setUnitTime(unitTime);
		center.setOperTimeStart(operTimeStart);
		center.setOperTimeEnd(operTimeEnd);
		
		return center;
	}
	
	// JSONObject to ReserveFilterVO for Apply
	private ReserveFilterVO JSONtoReserveFilter(JSONObject obj) {
		ReserveFilterVO searchInfo = new ReserveFilterVO();
		
		// 입력 파라미터 
		// 1. searchFilter	
		// 2. searchContent	
		// 3. reserveStatus	
		// 4. page			
		if(obj.size() < 4) {
			System.out.println("[warning] SearchFilterVO 입력 파라메터 수(4) 불일치");
			return null;
		}
		// null 값  예외처리
		Iterator<String> keys = obj.keys();
		while(keys.hasNext()) {
			String name = keys.next();
			String param = (String)obj.get(name);
			if(param == null) {
				System.out.println("[warning] " + name + " is null ");
				return null;
			}
		}
		
		// 값 등록
		searchInfo.setSearchFilter(obj.getString("searchFilter"));
		searchInfo.setSearchContent(obj.getString("searchContent"));
		searchInfo.setReserveStatus(obj.getString("reserveStatus"));
		Integer page = conData.StringtoInteger(obj.getString("page"));
		if(page == null) {
			System.out.println("[warning] SearchFilterVO > insert page is Empty");
			page = 1;
		}
		searchInfo.setPage(page);
		
		return searchInfo;
	}
	
	private String delOldUsingTime(String usableTime, String oldTime) {
		if(usableTime.length() != oldTime.length()) {
			return usableTime;
		}
		
		int length = usableTime.length();
		List<String> charList = new ArrayList<String>();
		for(int i=0; i<length; i++) {
			if(usableTime.charAt(i) == '1' && oldTime.charAt(i) == '1') {
				charList.add("0");
			}else {
				charList.add(usableTime.substring(i, i+1));
			}
		}
		
		String newUsableTime = "";
		for(int i=0; i<charList.size(); i++) {
			newUsableTime += charList.get(i);
		}
		
		return newUsableTime;
	}
}
