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
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.mall.admin.member.service.AdminMemberService;
import com.myspring.mall.admin.reserve.service.AdminReserveService;
import com.myspring.mall.admin.reserve.vo.AdminReserveSearchVO;
import com.myspring.mall.admin.reserve.vo.ReserveFilterVO;
import com.myspring.mall.center.service.CenterService;
import com.myspring.mall.center.vo.CenterSearchVO;
import com.myspring.mall.center.vo.MainSearchFilterVO;
import com.myspring.mall.common.ControllData;
import com.myspring.mall.member.vo.MemberVO;
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
	
	private static ControllData conData = new ControllData();

	// ===========================================================================
	// 1. 메인
	// ===========================================================================
	@RequestMapping(value= {"/", "/main.do"}, method={RequestMethod.GET, RequestMethod.POST})
	public ModelAndView main(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String)request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView(viewName);
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
		int applyCnt = 0;
		List<ReserveVO> reserveList = reserveService.listReserveById(userId);
		for(ReserveVO reserve : reserveList) {
			if(reserve.getReserveStatus().equals("Apply"));
				applyCnt++;
		}
		reserveCnt = reserveList.size();
		
		// 1:1 문의 현황
		
		// 즐겨 찾기 리스트
		
		mav.addObject("member", member);
		mav.addObject("reserveCnt", reserveCnt);
		mav.addObject("applyCnt", applyCnt);
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
		
		// List 불러오기
		List<CenterSearchVO> centerList = new ArrayList<CenterSearchVO>();
		centerList = centerService.listCenterByFilter(searchInfo);
		if(centerList != null) {
			for(CenterSearchVO center : centerList) {
				System.out.println(center.toString());
			}
		}else {
			System.out.println("[warning] CenterList를 불러오지 못했습니다.");
		}
		
		mav.addObject("searchInfo", searchInfo);
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
}
