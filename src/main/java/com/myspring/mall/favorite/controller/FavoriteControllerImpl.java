package com.myspring.mall.favorite.controller;

import java.util.ArrayList;
import java.util.List;

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
import org.springframework.web.servlet.ModelAndView;

import com.myspring.mall.center.service.CenterService;
import com.myspring.mall.center.vo.CenterSearchVO;
import com.myspring.mall.favorite.service.FavoriteService;
import com.myspring.mall.favorite.vo.FavoriteVO;
import com.myspring.mall.member.vo.MemberVO;
import com.myspring.mall.question.vo.QuestionVO;
import com.myspring.mall.reserve.vo.ReserveVO;

@Controller("favoriteController")
@EnableAspectJAutoProxy
@RequestMapping("/favorite")
public class FavoriteControllerImpl implements FavoriteController{
	@Autowired
	private FavoriteService favoriteService;
	@Autowired
	private CenterService centerService;
	
	
	/* ===========================================================================
	 * 1. 즐겨찾기 조회
	 * ---------------------------------------------------------------------------
	 * > 입력 : centerCode
	 * > 출력 : boolean
	 * > 이동 페이지 : -
	 * > 설명 : 
	 * 		- 즐겨찾기 여부 반환
	 ===========================================================================*/
	@RequestMapping(value= {"/isFavorite.do"}, method={RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Boolean> isFavorite(HttpServletRequest request, HttpServletResponse response) throws Exception {

		HttpSession session=request.getSession();
		String userId = (String)session.getAttribute("logonId");
		if(userId == null) {
			System.out.println("[warning] 로그인 되지 않았습니다.");
			return new ResponseEntity("[warning] 로그인 되지 않았습니다.", HttpStatus.BAD_REQUEST);
		}
		
		String centerCode = request.getParameter("centerCode");
		if(centerCode == null) {
			System.out.println("[warning] centerCode를 받아오는데 실패했습니다. ");
			return new ResponseEntity("[warning] centerCode를 받아오는데 실패했습니다.", HttpStatus.BAD_REQUEST);
		}
		
		boolean result = favoriteService.isFavorite(userId, centerCode);
		
		return new ResponseEntity<Boolean>(result, HttpStatus.OK);
	}
	
	/* ===========================================================================
	 * 2. 즐겨찾기 주가
	 * ---------------------------------------------------------------------------
	 * > 입력 : centerCode
	 * > 출력 : boolean
	 * > 이동 페이지 : -
	 * > 설명 : 
	 * 		- 즐겨찾기 여부 반환
	 ===========================================================================*/
	@RequestMapping(value= {"/addFavorite.do"}, method={RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Boolean> addFavorite(HttpServletRequest request, HttpServletResponse response) throws Exception {

		HttpSession session=request.getSession();
		String userId = (String)session.getAttribute("logonId");
		if(userId == null) {
			System.out.println("[warning] 로그인 되지 않았습니다.");
			return new ResponseEntity("[warning] 로그인 되지 않았습니다.", HttpStatus.BAD_REQUEST);
		}
		
		String centerCode = request.getParameter("centerCode");
		if(centerCode == null) {
			System.out.println("[warning] centerCode를 받아오는데 실패했습니다. ");
			return new ResponseEntity("[warning] centerCode를 받아오는데 실패했습니다.", HttpStatus.BAD_REQUEST);
		}
		
		boolean result = favoriteService.addFavorite(userId, centerCode);
		
		return new ResponseEntity<Boolean>(result, HttpStatus.OK);
	}
	
	/* ===========================================================================
	 * 3. 즐겨찾기 삭제
	 * ---------------------------------------------------------------------------
	 * > 입력 : centerCode
	 * > 출력 : boolean
	 * > 이동 페이지 : -
	 * > 설명 : 
	 * 		- 즐겨찾기 여부 반환
	 ===========================================================================*/
	@RequestMapping(value= {"/delFavorite.do"}, method={RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Boolean> delFavorite(HttpServletRequest request, HttpServletResponse response) throws Exception {

		HttpSession session=request.getSession();
		String userId = (String)session.getAttribute("logonId");
		if(userId == null) {
			System.out.println("[warning] 로그인 되지 않았습니다.");
			return new ResponseEntity("[warning] 로그인 되지 않았습니다.", HttpStatus.BAD_REQUEST);
		}
		
		String centerCode = request.getParameter("centerCode");
		if(centerCode == null) {
			System.out.println("[warning] centerCode를 받아오는데 실패했습니다. ");
			return new ResponseEntity("[warning] centerCode를 받아오는데 실패했습니다.", HttpStatus.BAD_REQUEST);
		}
		
		boolean result = favoriteService.deleteFavorite(userId, centerCode);
		
		return new ResponseEntity<Boolean>(result, HttpStatus.OK);
	}
	
	/* ===========================================================================
	 * 3. 즐겨찾기 목록
	 * ---------------------------------------------------------------------------
	 * > 입력 : -
	 * > 출력 : centerSearch-List
	 * > 이동 페이지 : 마이페이지 즐겨찾기 창
	 * > 설명 : 
	 * 		- 마이 페이지 즐겨찾기 목록 표시
	 ===========================================================================*/
	@RequestMapping(value= {"/listFavorite.do"}, method={RequestMethod.GET, RequestMethod.POST})
	public ModelAndView listFavorite(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		
		// userId 
		HttpSession session=request.getSession();
		String userId = (String)session.getAttribute("logonId");
		if(userId == null) {
			System.out.println("[warning] 로그인 되지 않았습니다.");
			return mav;
		}
		
		// 즐겨 찾기 센터 리스트
		List<CenterSearchVO> centerList = new ArrayList<CenterSearchVO>();
		List<FavoriteVO> favoriteList = favoriteService.listFavoriteById(userId);
		if(favoriteList != null && favoriteList.size() > 0) {
			for(FavoriteVO favorite : favoriteList) {
				CenterSearchVO center = centerService.selectCenterSearch(favorite.getCenterCode());
				centerList.add(center);
			}
		}
		
		mav.addObject("centerList", centerList);
		return mav;
	}
}
