package com.myspring.mall.reserve.controller;

import java.util.ArrayList;
import java.util.HashMap;
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
import com.myspring.mall.admin.reserve.service.AdminReserveService;
import com.myspring.mall.admin.reserve.vo.AdminReserveSearchVO;
import com.myspring.mall.admin.reserve.vo.ReserveFilterVO;
import com.myspring.mall.center.vo.CenterInfoVO;
import com.myspring.mall.center.vo.RoomInfoVO;
import com.myspring.mall.common.ControllData;
import com.myspring.mall.reserve.service.ReserveService;

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
	
	// ===========================================================================
	//                                    기타 
	// ===========================================================================
		
	
}
