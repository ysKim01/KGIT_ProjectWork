package com.myspring.mall.center.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.myspring.mall.center.service.CenterService;
import com.myspring.mall.center.vo.CenterContentsVO;
import com.myspring.mall.center.vo.CenterInfoVO;
import com.myspring.mall.common.ControllData;
import com.myspring.mall.reserve.service.ReserveService;

@RestController
@Controller("centerController")
@EnableAspectJAutoProxy
@RequestMapping("/center")
public class CenterControllerImpl implements CenterController {
	@Autowired
	private CenterService centerService;
	@Autowired
	private AdminCenterService adminCenterService;
	@Autowired
	private ReserveService reserveService; 
	
	private static ControllData conData = new ControllData();
	
	
	/* ===========================================================================
	 * 1. 평점 매기기
	 * ---------------------------------------------------------------------------
	 * > 입력 : centerCode, point ,keyNum (ajax/post)
	 * > 출력 : boolean
	 * > 이동 페이지 : - 
	 * > 설명 : 
	 * 		- 센터 평점 매기기
	 ===========================================================================*/
	@RequestMapping(value= {"/rating.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Boolean> delReserve(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 점수 
		Float point = conData.StringtoFloat(request.getParameter("point"));
		if(point == null) {
			return new ResponseEntity("[warning] point를 받아오는데 문제가 발생했습니다.", HttpStatus.BAD_REQUEST);
		}
		// 센터 코드
		String centerCode = request.getParameter("centerCode");
		if(centerCode == null) {
			return new ResponseEntity("[warning] centerCode를 받아오는데 문제가 발생했습니다.", HttpStatus.BAD_REQUEST);
		}
		
		// reserve keyNum 
		Integer keyNum = conData.StringtoInteger(request.getParameter("keyNum"));
		if(keyNum == null) {
			return new ResponseEntity("[warning] keyNum을 받아오는데 문제가 발생했습니다.", HttpStatus.BAD_REQUEST);
		}
		
		// 평점 계산
		CenterInfoVO center = adminCenterService.selectCenterByCenterCode(centerCode);
		if(center == null) {
			System.out.println("[warning] center 정보를 받아오는데 문제가 발생했습니다.");
			return new ResponseEntity("[warning] center 정보를 받아오는데 문제가 발생했습니다.", HttpStatus.BAD_REQUEST);
		}
		int ratingNum = center.getRatingNum();
		double ratingScore = center.getRatingScore();
		double newRating = ((ratingScore*ratingNum) + point) / (ratingNum + 1); 
		
		// 평점 등록
		boolean result = false;
		result = centerService.updateRating(centerCode, newRating, ratingNum+1);
		
		if(result) {
			result = reserveService.updateReserveStatus(keyNum, "Rating");
		}
		
		return new ResponseEntity<Boolean>(result, HttpStatus.OK);
	}
	
	/* ===========================================================================
	 * 2. 센터 상세정보 보기
	 * ---------------------------------------------------------------------------
	 * > 입력 : centerCode (ajax/post)
	 * > 출력 : boolean
	 * > 이동 페이지 : - 
	 * > 설명 : 
	 * 		- 센터 평점 매기기
	 ===========================================================================*/
	@RequestMapping(value= {"/showCenterContents.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Object> showCenterContents(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 센터 코드
		String centerCode = request.getParameter("centerCode");
		if(centerCode == null) {
			System.out.println("[warning] centerCode를 받아오는데 문제가 발생했습니다.");
			return new ResponseEntity("[warning] centerCode를 받아오는데 문제가 발생했습니다.", HttpStatus.BAD_REQUEST);
		}
		
		CenterContentsVO contents = centerService.selectCenterContents(centerCode);
		if(contents == null) {
			System.out.println("[warning] centerContents를 불러오는데 문제가 발생했습니다.");
			return new ResponseEntity("[warning] centerContents를 불러오는데 문제가 발생했습니다.", HttpStatus.BAD_REQUEST);
		}
		
		return new ResponseEntity<Object>(contents, HttpStatus.OK);
	}
}
