package com.myspring.mall.main;

import java.net.URLDecoder;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
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

import com.myspring.mall.admin.member.service.AdminMemberService;
import com.myspring.mall.admin.question.service.AdminQuestionService;
import com.myspring.mall.admin.reserve.service.AdminReserveService;
import com.myspring.mall.admin.reserve.vo.AdminReserveSearchVO;
import com.myspring.mall.admin.reserve.vo.ReserveFilterVO;
import com.myspring.mall.center.service.CenterService;
import com.myspring.mall.center.vo.CenterFacilityVO;
import com.myspring.mall.center.vo.CenterSearchVO;
import com.myspring.mall.center.vo.MainSearchFilterVO;
import com.myspring.mall.common.ControllData;
import com.myspring.mall.favorite.service.FavoriteService;
import com.myspring.mall.favorite.vo.FavoriteVO;
import com.myspring.mall.member.vo.MemberVO;
import com.myspring.mall.question.service.QuestionService;
import com.myspring.mall.question.vo.QuestionVO;
import com.myspring.mall.reserve.service.ReserveService;
import com.myspring.mall.reserve.vo.ReserveVO;

import net.sf.json.JSONObject;

@Controller("mainController")
@EnableAspectJAutoProxy
public class MainController {
	@Autowired
	private AdminMemberService adminMemberService;
	@Autowired
	private ReserveService reserveService;
	@Autowired
	private CenterService centerService;
	@Autowired
	private QuestionService questionService;
	@Autowired
	private FavoriteService favoriteService;
	
	private static ControllData conData = new ControllData();

	// ===========================================================================
	// 1. 메인
	// ===========================================================================
	@RequestMapping(value= {"/", "/main.do"}, method={RequestMethod.GET, RequestMethod.POST})
	public ModelAndView main(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		
		// Top 5 Center
		List<CenterSearchVO> top5Center = new ArrayList<CenterSearchVO>();
		top5Center = centerService.listTop5Center();
		if(top5Center != null) {
			System.out.println("[Top5 Center]");
			for(CenterSearchVO center : top5Center) {
				System.out.println(center.toString());
			}
		}else {
			System.out.println("[warning] CenterList를 불러오지 못했습니다.");
		}
		
		mav.addObject("top5Center", top5Center);
		return mav;
	}
	
	// ===========================================================================
	// 2. 이전 페이지
	// ===========================================================================
	@RequestMapping(value= {"/lastPage.do"}, method={RequestMethod.GET, RequestMethod.POST})
	public ModelAndView lastPage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String lastPageName = conData.getLastPage(request);
		System.out.println(lastPageName);
		
		String viewName = "redirect:" + lastPageName;
		ModelAndView mav = new ModelAndView(viewName);
		return mav;
	}
	
	/* ===========================================================================
	 * 3. 마이페이지 
	 * ---------------------------------------------------------------------------
	 * > 입력 : -
	 * > 출력 : ???
	 * > 이동 페이지 : /mypage.jsp (예약 목록 창)
	 * > 설명 : 
	 * 		- 마이 페이지 메인 이동
	 ===========================================================================*/
	@RequestMapping(value= {"/mypage.do"}, method={RequestMethod.GET, RequestMethod.POST})
	public ModelAndView mypage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		
		// userId 
		HttpSession session=request.getSession();
		String userId = (String)session.getAttribute("logonId");
		if(userId == null) {
			System.out.println("[warning] 로그인 되지 않았습니다.");
			return mav;
		}
		
		// member
		MemberVO member = null;
		member = adminMemberService.getMemberById(userId);
		
		// reserve count
		int reserveCnt = 0;
		int reserveWaitingCnt = 0;
		List<ReserveVO> reserveList = reserveService.listReserveById(userId);
		if(reserveList != null && reserveList.size() != 0) {
			for(ReserveVO reserve : reserveList) {
				if(reserve.getReserveStatus().equals("Apply")) {
					reserveWaitingCnt++;
				}
			}
		}
		reserveCnt = reserveList.size();
		
		// 1:1 문의 현황
		int questionCnt = 0;
		int questionWaitingCnt = 0;
		List<QuestionVO> questionList = questionService.listQuestionById(userId);
		if(questionList != null && questionList.size() != 0) {
			for(QuestionVO question : questionList) {
				if(question.getQuestionAnswer() == null) {
					questionWaitingCnt++;
				}
			}
		}
		questionCnt = questionList.size();
		
		// 즐겨 찾기 센터 리스트
		List<CenterSearchVO> centerList = new ArrayList<CenterSearchVO>();
		List<FavoriteVO> favoriteList = favoriteService.listFavoriteById(userId);
		if(favoriteList != null && favoriteList.size() > 0) {
			for(FavoriteVO favorite : favoriteList) {
				CenterSearchVO center = centerService.selectCenterSearch(favorite.getCenterCode());
				centerList.add(center);
			}
		}
		
		mav.addObject("member", member);
		mav.addObject("reserveCnt", reserveCnt);
		mav.addObject("reserveWaitingCnt", reserveWaitingCnt);
		mav.addObject("questionCnt", questionCnt);
		mav.addObject("questionWaitingCnt", questionWaitingCnt);
		mav.addObject("centerList", centerList);
		return mav;
	}
	
	/* ===========================================================================
	 * 4. 카페 검색 
	 * ---------------------------------------------------------------------------
	 * > 입력 : mainSearchFilter
	 * > 출력 : CenterSearchResult - List
	 * > 이동 페이지 : 검색 결과 창 (/listSearch.jsp)
	 * > 설명 : 
	 * 		- 센터 검색 목록 표시
	 ===========================================================================*/
	@RequestMapping(value={"/listSearch.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView listSearch(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		
		// Search Info 받아오기
		MainSearchFilterVO searchInfo = new MainSearchFilterVO();
		String jsonData = request.getParameter("searchInfo");
		if(!conData.isEmpty(jsonData)) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println("jsonData : " + jsonData);
			JSONObject jsonObj = JSONObject.fromObject(jsonData);
			searchInfo = JSONtoMainSearchFilter(jsonObj);
		}else{
			searchInfo = null;
		}
		if(searchInfo == null) { return mav; }
		
		// facility
		CenterFacilityVO facilityChk = new CenterFacilityVO();
		String jsonFacility = request.getParameter("facility");
		if(!conData.isEmpty(jsonData)) {
			jsonFacility = URLDecoder.decode(jsonFacility,"utf-8");
			System.out.println("jsonFacility : " + jsonFacility);
			JSONObject jsonFacilityObj = JSONObject.fromObject(jsonFacility);
			facilityChk = JSONtoFacilityChk(jsonFacilityObj);
		}else{
			facilityChk = null;
		}
		if(facilityChk == null) { return mav; }
		
		// List 불러오기
		List<CenterSearchVO> centerList = new ArrayList<CenterSearchVO>();
		centerList = centerService.listCenterByFilter(searchInfo, facilityChk);
		if(centerList != null) {
			for(CenterSearchVO center : centerList) {
				System.out.println(center.toString());
			}
		}else {
			System.out.println("[warning] CenterList를 불러오지 못했습니다.");
		}
		
		mav.addObject("searchInfo", searchInfo);
		mav.addObject("facility", facilityChk);
		mav.addObject("centerList", centerList);
		return mav;
	}
	
	/* ===========================================================================
	 * 5. 특정 카페 검색 
	 * ---------------------------------------------------------------------------
	 * > 입력 : centerCode
	 * > 출력 : CenterSearchResult, searchInfo
	 * > 이동 페이지 : 검색 결과 창 
	 * > 설명 : 
	 * 		- 센터 검색 목록 표시
	 ===========================================================================*/
	@RequestMapping(value={"/searchCenter.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView searchCenter(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		ModelAndView mav = new ModelAndView("/listSearch");
		
		// centerCode
		String centerCode = request.getParameter("centerCode");
		if(centerCode == null) {
			System.out.println("[warning] centerCode을 받아오는데 문제가 발생했습니다.");
			return mav;
		}
		
		// center
		List<CenterSearchVO> centerList = new ArrayList<CenterSearchVO>();
		CenterSearchVO centerSearch = centerService.selectCenterSearch(centerCode);
		if(centerSearch == null) {
			System.out.println("[warning] centerSearch를 불러오는데 실패했습니다.");
			return mav;
		}
		centerList.add(centerSearch);
		
		// Search Info 받아오기
		MainSearchFilterVO searchInfo = new MainSearchFilterVO();
		searchInfo.setSearchAdd1(centerSearch.getCenterAdd1());
		searchInfo.setSearchAdd2(centerSearch.getCenterAdd2());
		searchInfo.setScale(null);
		searchInfo.setSort(0);
		searchInfo.setPage(1);
		searchInfo.setMaxNum(1);
		Date searchDate = new Date(new java.util.Date().getTime());
		searchInfo.setSearchDate(searchDate);
		
		// facility
		CenterFacilityVO facilityChk = new CenterFacilityVO();
		facilityChk.setLocker(0);
		facilityChk.setNoteBook(0);
		facilityChk.setPrinter(0);
		facilityChk.setProjector(0);
		facilityChk.setWhiteBoard(0);
		
		
		mav.addObject("searchInfo", searchInfo);
		mav.addObject("facility", facilityChk);
		mav.addObject("centerList", centerList);
		return mav;
	}
	
	
	// ===========================================================================
	//                                    기타 
	// ===========================================================================
	private MainSearchFilterVO JSONtoMainSearchFilter(JSONObject obj) {
		MainSearchFilterVO searchInfo = new MainSearchFilterVO();
		SimpleDateFormat dateForm = new SimpleDateFormat("yyyy-MM-dd");

		// 1. searchDate
		// 2. searchAdd1
		// 3. searchAdd2
		// 4. scale
		// 5. sort
		// 6. page
		if(obj.size() < 5) {
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
		
		// 값 등록
		searchInfo.setSearchAdd1(obj.getString("searchAdd1"));
		searchInfo.setSearchAdd2(obj.getString("searchAdd2"));
		
		Integer scale = conData.StringtoInteger(obj.getString("scale"));
		if(scale == null) {
			System.out.println("[warning] scale을 받아오는데 문제 발생");
			return null;
		}
		searchInfo.setScale(scale);
		
		Integer sort = conData.StringtoInteger(obj.getString("sort"));
		if(sort == null) {
			System.out.println("[warning] sort을 받아오는데 문제 발생");
			return null;
		}
		searchInfo.setSort(sort);
		
		Integer page = conData.StringtoInteger(obj.getString("page"));
		if(page == null) {
			System.out.println("[warning] page를 받아오는데 문제 발생");
			return null;
		}
		searchInfo.setPage(page);
		
		try {
			String strSearchDate = (String)obj.get("searchDate");
			Date searchDate = new Date(dateForm.parse(strSearchDate).getTime());
			searchInfo.setSearchDate(searchDate);
		} catch(Exception e) {
			System.out.println("[warning] searchDate를 받아오는데 문제 발생");
			return null;
		}
		
		return searchInfo;
	}
	
	private CenterFacilityVO JSONtoFacilityChk(JSONObject obj) {
		CenterFacilityVO facilityChk = new CenterFacilityVO();
		
		// 1. locker
		// 2. projector
		// 3. printer
		// 4. noteBook
		// 5. whiteBoard
		if(obj.size() < 5) {
			System.out.println("[warning] reserveVO 입력 파라메터 수(5) 불일치");
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
		
		// 값 등록
		Integer locker = conData.StringtoInteger(obj.getString("locker"));
		if(locker == null) {
			System.out.println("[warning] locker을 받아오는데 문제 발생");
			return null;
		}
		facilityChk.setLocker(locker);
		
		Integer projector = conData.StringtoInteger(obj.getString("projector"));
		if(projector == null) {
			System.out.println("[warning] projector을 받아오는데 문제 발생");
			return null;
		}
		facilityChk.setProjector(projector);
		
		Integer printer = conData.StringtoInteger(obj.getString("printer"));
		if(printer == null) {
			System.out.println("[warning] printer을 받아오는데 문제 발생");
			return null;
		}
		facilityChk.setPrinter(printer);
		
		Integer noteBook = conData.StringtoInteger(obj.getString("noteBook"));
		if(noteBook == null) {
			System.out.println("[warning] noteBook을 받아오는데 문제 발생");
			return null;
		}
		facilityChk.setNoteBook(noteBook);
		
		Integer whiteBoard = conData.StringtoInteger(obj.getString("whiteBoard"));
		if(whiteBoard == null) {
			System.out.println("[warning] whiteBoard을 받아오는데 문제 발생");
			return null;
		}
		facilityChk.setWhiteBoard(whiteBoard);
		
		return facilityChk;
	}

}
