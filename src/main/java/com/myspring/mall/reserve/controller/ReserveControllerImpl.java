package com.myspring.mall.reserve.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.mall.admin.reserve.vo.AdminReserveSearchVO;
import com.myspring.mall.admin.reserve.vo.ReserveFilterVO;
import com.myspring.mall.common.ControllData;
import com.myspring.mall.reserve.service.ReserveService;

@RestController
@Controller("reserveController")
@EnableAspectJAutoProxy
@RequestMapping("/reserve")
public class ReserveControllerImpl implements ReserveController{
	@Autowired
	private ReserveService reserveService;
	
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
		// userId 
		HttpSession session=request.getSession();
		String userId = (String)session.getAttribute("userId");
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
		for(AdminReserveSearchVO reserve : reserveList) {
			System.out.println(reserve.toString());
		}
		
		ModelAndView mav = new ModelAndView("/reserve/listReserve");
		mav.addObject("reserveList",reserveList);
		return mav;
	}
}
