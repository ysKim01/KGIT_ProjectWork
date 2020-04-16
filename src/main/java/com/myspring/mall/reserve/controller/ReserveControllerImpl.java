package com.myspring.mall.reserve.controller;

import java.net.URLDecoder;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.mall.admin.center.service.AdminCenterService;
import com.myspring.mall.admin.member.service.AdminMemberService;
import com.myspring.mall.admin.reserve.service.AdminReserveService;
import com.myspring.mall.admin.reserve.vo.AdminReserveSearchVO;
import com.myspring.mall.admin.reserve.vo.ReserveFilterVO;
import com.myspring.mall.center.service.CenterService;
import com.myspring.mall.center.vo.CenterInfoVO;
import com.myspring.mall.center.vo.RoomInfoVO;
import com.myspring.mall.common.ControllData;
import com.myspring.mall.member.vo.MemberVO;
import com.myspring.mall.reserve.service.ReserveService;
import com.myspring.mall.reserve.vo.ReserveVO;

import net.sf.json.JSONObject;

@RestController
@Controller("reserveController")
@EnableAspectJAutoProxy
@RequestMapping("/reserve")
public class ReserveControllerImpl implements ReserveController{
	@Autowired
	private ReserveService reserveService;
	@Autowired
	private AdminReserveService adminReserveService;
	@Autowired
	private AdminCenterService adminCenterService; 
	@Autowired
	private CenterService centerService; 
	@Autowired
	private AdminMemberService adminMemberService;
	
	private static ControllData conData = new ControllData();
	
	
	/* ===========================================================================
	 * 1. 예약목록 
	 * ---------------------------------------------------------------------------
	 * > 입력 : -
	 * > 출력 : AdminReserveSearchVO - List
	 * > 이동 페이지 : /reserve/listReserve.jsp (예약 목록 창)
	 * > 설명 : 
	 * 		- 회원 목록 전달
	 ===========================================================================*/
	@RequestMapping(value={"/listReserveBefore.do", "/listReserveAfter.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView listReserve(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("/reserve/listReserve");
		
		// userId 
		HttpSession session=request.getSession();
		String userId = (String)session.getAttribute("logonId");
		if(userId == null) {
			System.out.println("[warning] 로그인 되지 않았습니다.");
			return mav;
		}
		
		// status
		String status = "before";
		String viewName = (String)request.getAttribute("viewName");
		if(viewName.equals("/reserve/listReserveBefore")) {
			status = "before";
		}else {
			status = "after";
		}
		
		// 목록 출력
		List<AdminReserveSearchVO> reserveList = new ArrayList<AdminReserveSearchVO>();
		reserveList = reserveService.listReserveResultByStatus(userId, status);
		if(reserveList != null) {
			for(AdminReserveSearchVO reserve : reserveList) {
				CenterInfoVO center = adminCenterService.selectCenterByCenterCode(reserve.getCenterCode());
				reserve.setUsingTimeString(conData.usingTimeToString(center, reserve.getUsingTime()));
				System.out.println(reserve.toString());
			}
		}
		
		mav.addObject("pageStatus", status);
		mav.addObject("reserveList",reserveList);
		return mav;
	}
	
	/* ===========================================================================
	 * 2. 예약 삭제  
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum (ajax/post)
	 * > 출력 : boolean
	 * > 이동 페이지 : - 
	 * > 설명 : 
	 * 		- 예약 삭제
	 ===========================================================================*/
	@RequestMapping(value= {"/delReserve.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Boolean> delReserve(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		Integer keyNum = conData.StringtoInteger(request.getParameter("keyNum"));
		if(keyNum == null) {
			return new ResponseEntity("[warning] keyNum을 받아오는데 문제가 발생했습니다.", HttpStatus.BAD_REQUEST);
		}
		
		// 예약 삭제
		boolean result = false;
		result = adminReserveService.deleteReserve(keyNum);
		
		return new ResponseEntity<Boolean>(result, HttpStatus.OK);
	}
	
	
	/* ===========================================================================
	 * 3. 예약등록 창 
	 * ---------------------------------------------------------------------------
	 * > 입력 : centerCode (ajax-post)
	 * > 출력 : roomInfo-List, 
	 * > 이동 페이지 : -
	 * > 설명 : 
	 * 		- 예약 등록 창 
	 ===========================================================================*/
	@RequestMapping(value= {"/addReserveForm.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Object> addReserveForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// Center Code
		String centerCode = request.getParameter("centerCode");
		if(centerCode == null) {
			System.out.println("[warning] centerCode를 받아오는데 문제가 발생했습니다.");
			return new ResponseEntity("[warning] centerCode를 받아오는데 문제가 발생했습니다.", HttpStatus.BAD_REQUEST);
		}
		
		// RoomInfo List
		List<RoomInfoVO> roomList = new ArrayList<RoomInfoVO>();
		if(!conData.isEmpty(centerCode)) {
			roomList = adminCenterService.listRoomsByCenter(centerCode);
		}
		
		return new ResponseEntity<Object>(roomList, HttpStatus.OK);
	}
	
	/* ===========================================================================
	 * 4. 예약 정보 확인 
	 * ---------------------------------------------------------------------------
	 * > 입력 : reserveVO, scale (ajax/post)
	 * > 출력 : boolean
	 * 			
	 * > 이동 페이지 : - 
	 * > 설명 : 
	 * 		- 예약 등록
	 ===========================================================================*/
	@RequestMapping(value= {"/confirmReserve.do"}, method=RequestMethod.POST)
	public ModelAndView confirmReserve(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		
		// Reserve 
		ReserveVO reserve = new ReserveVO();
		String jsonDataReserve = request.getParameter("reserve");
		if(!conData.isEmpty(jsonDataReserve)) {
			jsonDataReserve = URLDecoder.decode(jsonDataReserve,"utf-8");
			System.out.println(jsonDataReserve);
			JSONObject jsonObjReserve = JSONObject.fromObject(jsonDataReserve);
			reserve = JSONtoReserve(jsonObjReserve);
			if(reserve == null) {
				System.out.println("[warning] ReserveVO 값을 받아오지 못했습니다.");
				return mav;
			}
		}else {
			System.out.println("[warning] Parameter(reserve)를 받아오지 못했습니다.");
			return mav;
		}
		// scale(RoomInfo)
		String strScale = request.getParameter("scale");
		if(conData.isEmpty(strScale)) {
			System.out.println("[warning] Parameter(scale)를 받아오지 못했습니다.");
			return mav;
		}
		Integer scale = conData.StringtoInteger(strScale);
		
		// Reserve 
		CenterInfoVO center = adminCenterService.selectCenterByCenterCode(reserve.getCenterCode());
		if(center == null) {
			System.out.println("[warning] center를 불러오지 못했습니다.");
			return mav;
		}
		
		// 예약금액
		int reservePrice = adminReserveService.calReservePrice(reserve, scale, center);
		reserve.setReservePrice(reservePrice);
		
		
		// 예약등록 확인 정보
		MemberVO member = adminMemberService.getMemberById(reserve.getUserId());
		RoomInfoVO room = centerService.selectRoomByCode(reserve.getCenterCode(), reserve.getRoomCode());
		Map reserveInfo = new HashMap();
		reserveInfo.put("usingTime", conData.usingTimeToString(center, reserve.getUsingTime()));
		reserveInfo.put("roomName", room.getRoomName());
		reserveInfo.put("scale", scale);
		reserveInfo.put("userName", member.getUserName());
		reserveInfo.put("userTel1", member.getUserTel1());
		reserveInfo.put("userTel2", member.getUserTel2());
		reserveInfo.put("userTel3", member.getUserTel3());
		reserveInfo.put("userEmail", member.getUserEmail());
		reserveInfo.put("centerName", center.getCenterName());
		reserveInfo.put("centerAdd1", center.getCenterAdd1());
		reserveInfo.put("centerAdd2", center.getCenterAdd2());
		reserveInfo.put("centerAdd3", center.getCenterAdd3());
		
		mav.addObject("reserve", reserve);
		mav.addObject("paymentInfo", reserveInfo);
		return mav;
	}
	
	/* ===========================================================================
	 * 5. 예약 등록 
	 * ---------------------------------------------------------------------------
	 * > 입력 : reserve (ajax-post)
	 * > 출력 : boolean 
	 * > 이동 페이지 : -
	 * > 설명 : 
	 * 		- 예약 등록
	 ===========================================================================*/
	@RequestMapping(value= {"/addReserve.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Boolean> addReserve(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		
		// reservePrice
		Integer reservePrice = conData.StringtoInteger(request.getParameter("reservePrice"));
		if(reservePrice == null) {
			System.out.println("[warning] reservePrice를 받아오는데 문제가 발생했습니다.");
			return new ResponseEntity("[warning] reservePrice를 받아오는데 문제가 발생했습니다.", HttpStatus.BAD_REQUEST);
		}
		// Reserve 
		ReserveVO reserve = new ReserveVO();
		String jsonDataReserve = request.getParameter("reserve");
		if(!conData.isEmpty(jsonDataReserve)) {
			jsonDataReserve = URLDecoder.decode(jsonDataReserve,"utf-8");
			System.out.println(jsonDataReserve);
			JSONObject jsonObjReserve = JSONObject.fromObject(jsonDataReserve);
			reserve = JSONtoReserve(jsonObjReserve);
			if(reserve == null) {
				System.out.println("[warning] ReserveVO 값을 받아오지 못했습니다.");
				return new ResponseEntity("[warning] ReserveVO 값을 받아오지 못했습니다.", HttpStatus.BAD_REQUEST);
			}else {
				reserve.setReservePrice(reservePrice);
			}
		}else {
			System.out.println("[warning] Parameter(reserve)를 받아오지 못했습니다.");
			return new ResponseEntity("[warning] Parameter(reserve)를 받아오지 못했습니다.", HttpStatus.BAD_REQUEST);
		}
		
		boolean result = adminReserveService.insertReserve(reserve);
		
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
	
}
