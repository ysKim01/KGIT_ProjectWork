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
	
	private static ControllData conData = new ControllData();
	
	
	/* ===========================================================================
	 * 1. 예약등록 창 
	 * ---------------------------------------------------------------------------
	 * > 입력 : centerCode
	 * > 출력 : centerCode, roomInfo-List, 
	 * 			
	 * > 이동 페이지 : /admin/listMembersForm.do (회원목록창)
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
			if(conData.isEmpty(param)) {
				return new ResponseEntity(param + " : null 값 전송", HttpStatus.BAD_REQUEST);
			}
			paramCnt++;
		}
		if(paramCnt != 3) {
			return new ResponseEntity("파라미터 수 불일치("+paramCnt+"/3)", HttpStatus.BAD_REQUEST);
		}
		
		// param 값 받아오기
		String centerCode = request.getParameter("centerCode");
		String roomCode = request.getParameter("roomCode");
		Date reserveDate = new Date(dateForm.parse(request.getParameter("reserveDate")).getTime());
		
		// List 불러오기
		String usableTime = adminReserveService.getUsableTime(centerCode, roomCode, reserveDate);
		
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
		int maxNum = adminReserveService.getMaxNumByFiltered(searchInfo);
		searchInfo.setMaxNum(maxNum);
		for(AdminReserveSearchVO reserve : reserveList) {
			System.out.println(reserve.toString());
		}
		
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		mav.addObject("reserveList",reserveList);
		mav.addObject("searchInfo",searchInfo);
		return mav;
	}
	
//	/* ===========================================================================
//	 * 2. 회원검색 
//	 * ---------------------------------------------------------------------------
//	 * > 입력 : SearchInfo (submit/get)
//	 * > 출력 : SearchInfo
//	 * > 이동 페이지 : /admin/searchResult.do (회원목록)
//	 * > 설명 : 
//	 * 		- 조건에 맞는 회원 검색 후,회원 목록 전달
//	 ===========================================================================*/
//	@RequestMapping(value={"/searchMembers.do"}, method= {RequestMethod.GET, RequestMethod.POST})
//	public void searchMembers(HttpServletRequest request, HttpServletResponse response) throws Exception {
//		String nextPage = "/admin/listMembers.do";
//		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
//		
//		SearchInfoVO searchInfo = new SearchInfoVO();
//		String jsonData = request.getParameter("searchInfo");
//
//		if(jsonData != null) {
//			jsonData = URLDecoder.decode(jsonData,"utf-8");
//			System.out.println(jsonData);
//			JSONObject jsonObj = JSONObject.fromObject(jsonData);
//			searchInfo = JSONtoSearchInfo(jsonObj);
//		}
//		
//		request.setAttribute("searchInfo", searchInfo);
//		dispatcher.forward(request, response);
//	}
	
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
	// JSONObject to ReserveVO for Apply
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
		// null 값  예외처리 -> 
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
}
