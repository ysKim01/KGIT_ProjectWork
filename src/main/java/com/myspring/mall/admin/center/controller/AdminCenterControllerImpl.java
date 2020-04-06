package com.myspring.mall.admin.center.controller;


import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.fasterxml.jackson.annotation.JsonFormat.Value;
import com.myspring.mall.admin.center.service.AdminCenterService;
import com.myspring.mall.admin.center.vo.CenterSearchVO;
import com.myspring.mall.center.vo.CenterContentsVO;
import com.myspring.mall.center.vo.CenterFacilityVO;
import com.myspring.mall.center.vo.CenterInfoVO;
import com.myspring.mall.center.vo.RoomInfoVO;
import com.myspring.mall.common.ControllData;

import net.sf.json.JSONObject;

@RestController
@Controller("acenterController")
@EnableAspectJAutoProxy
@RequestMapping("/admin")
public class AdminCenterControllerImpl extends MultiActionController implements AdminCenterController {

	@Autowired
	private AdminCenterService centerService;
	
	private static ControllData conData = new ControllData();
	
	/* ===========================================================================
	 * 스터디룸 목록 
	 * ---------------------------------------------------------------------------
	 * > 입력 : /listCenter.do -> -(aTag/get)
	 * > 출력 : List<CenterInfoVO>
	 * > 이동 페이지 : /admin/adminCenter.jsp (카페목록 창 - 실제페이지)
	 * > 설명 : 
	 * 		- 카페 목록 전달
	 ===========================================================================*/
	
	@RequestMapping(value={"/listCenter.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView listCenter(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String)request.getAttribute("viewName"); 
		System.out.println("viewName : "+viewName);
		
		List<CenterInfoVO> centerList = new ArrayList<CenterInfoVO>();
		CenterSearchVO centerSearch = (CenterSearchVO)request.getAttribute("centerSearch");
		if(centerSearch == null)
			centerSearch = new CenterSearchVO();
		
		centerList = centerService.listCenterByFiltered(centerSearch);
		int maxPage = centerService.getMaxPageByBiltered(centerSearch);
		centerSearch.setMaxPage(maxPage);
		
		ModelAndView mav = new ModelAndView(viewName);
		mav.addObject("centerList",centerList);
		mav.addObject("centerSearch",centerSearch);
		return mav;
	}
	/* ===========================================================================
	 * 카페검색 
	 * ---------------------------------------------------------------------------
	 * > 입력 : CenterSearch (submit/get)
	 * > 출력 : CenterSearch
	 * > 이동 페이지 : /admin/listCenter.do (회원목록)
	 * > 설명 : 
	 * 		- 조건에 맞는 카페 검색 후,카페 목록 전달
	 ===========================================================================*/
	@RequestMapping(value= {"/searchCenter.do"}, method = {RequestMethod.GET,RequestMethod.POST})
	public void searchCenter(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String nextPage = "/admin/listCenter.do";
		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		
		CenterSearchVO centerSearch = new CenterSearchVO();
		String jsonData = request.getParameter("centerSearch");

		if(jsonData != null) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println(jsonData);
			JSONObject jsonObj = JSONObject.fromObject(jsonData);
			centerSearch = JSONtoSearchInfo(jsonObj);
		}
		
		request.setAttribute("centerSearch", centerSearch);
		dispatcher.forward(request, response);
	}

	
	private String getViewName(HttpServletRequest request)  throws Exception{
		String contextPath = request.getContextPath();
		String uri = (String)request.getAttribute("javax.servlet.include.request_uri");
		
		if (uri == null || uri.trim().equals("")) {
			uri = request.getRequestURI();
		}
		
		int begin = 0;
		if(!((contextPath==null)|| ("".equals(contextPath)))) {
			begin = contextPath.length();
		}
		
		int end;
		if(uri.indexOf(";") != -1) {
			end = uri.indexOf(";");
		} else if (uri.indexOf("?") != -1) {
			end = uri.indexOf("?");
		} else {
			end = uri.length();
		}
		
		String viewName = uri.substring(begin, end);
		if(viewName.indexOf(".") != -1) {
			viewName=viewName.substring(0,viewName.lastIndexOf("."));
		}
		if(viewName.lastIndexOf("/") != -1) {
			viewName=viewName.substring(viewName.lastIndexOf("/",1), viewName.length());
		}
		
		//viewName = viewName.replace("/", "");
		return viewName;
	}	
	
	// JSONObject to CenterSearchVO
			private CenterSearchVO JSONtoSearchInfo(JSONObject obj) {
				CenterSearchVO info = new CenterSearchVO();

				info.setSearchFilter((String)obj.get("searchFilter"));
				info.setSearchContents((String)obj.get("searchContents"));
				info.setPage(conData.StringtoInteger((String)obj.get("page")));
				
				return info;
			}

}