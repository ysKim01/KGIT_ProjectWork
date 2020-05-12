package com.myspring.mall.admin.oneday.controller;

import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.RequestDispatcher;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.mall.admin.notice.vo.AdminNoticeFilterVO;
import com.myspring.mall.admin.notice.vo.NoticeVO;
import com.myspring.mall.admin.oneday.service.AdminOneDayService;
import com.myspring.mall.admin.oneday.vo.AdminOneDayFilterVO;
import com.myspring.mall.admin.oneday.vo.OneDayVO;
import com.myspring.mall.admin.question.vo.AdminQuestionFilterVO;
import com.myspring.mall.common.ControllData;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@RestController
@Controller("adminOneDayController")
@EnableAspectJAutoProxy
@RequestMapping("/admin")
public class AdminOneDayControllerImpl implements AdminOneDayController{
	@Autowired
	private AdminOneDayService adminOneDayService;
	
	static private ControllData conData = new ControllData();
	
	/* ===========================================================================
	 * 1. 일일클레스 목록 
	 * ---------------------------------------------------------------------------
	 * > 입력 : searchInfo
	 * > 출력 : oneday-List, searchInfo
	 * > 이동 페이지 : 공지 목록 창 (/admin/notice/ListOneDay.jsp)
	 * > 설명 : 
	 * 		- 일일클레스 목록 창
	 ===========================================================================*/
	@RequestMapping(value={"/listOneDay.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView listOneDay(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		
		AdminOneDayFilterVO searchInfo = (AdminOneDayFilterVO)request.getAttribute("searchInfo");
		if(searchInfo == null) {
			searchInfo = new AdminOneDayFilterVO();
			searchInfo.setSearchContent("");
			searchInfo.setClassStatus(9999);
			searchInfo.setPage(1);
		}
		
		List<OneDayVO> oneDayList = adminOneDayService.listOneDayByFilter(searchInfo);
		if(oneDayList != null) {
			for(OneDayVO oneDay : oneDayList) {
				System.out.println(oneDay.toString());
			}
		}else {
			System.out.println("[info] 검색된 oneDayList 없음.");
		}
		System.out.println(searchInfo.toString());
		
		mav.addObject("oneDayList",oneDayList);
		mav.addObject("searchInfo",searchInfo);
		return mav;
	}
	
	/* ===========================================================================
	 * 2. 일일클래스 검색 
	 * ---------------------------------------------------------------------------
	 * > 입력 : searchInfo
	 * > 출력 : searchInfo
	 * > 이동 페이지 : 일일클래스 목록 (/admin/listOneDay.do)
	 * > 설명 : 
	 * 		- 일일클래스 검색
	 ===========================================================================*/
	@RequestMapping(value={"/searchOneDay.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public void searchOneDay(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		String nextPage = "/admin/listOneDay.do";
		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		
		AdminOneDayFilterVO searchInfo = new AdminOneDayFilterVO();
		String jsonData = request.getParameter("searchInfo");
		if(!conData.isEmpty(jsonData)) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println("jsonData : " + jsonData);
			JSONObject jsonObj = JSONObject.fromObject(jsonData);
			searchInfo = JSONtoAdminOneDayFilter(jsonObj);
		}else{
			searchInfo = null;
		}
		
		request.setAttribute("searchInfo", searchInfo);
		dispatcher.forward(request, response);
	}
	

	/* ===========================================================================
	 * 3. 일일클래스 등록 창
	 * ---------------------------------------------------------------------------
	 * > 입력 : - 
	 * > 출력 : - 
	 * > 이동 페이지 : 일일클래스 등록 창 (/admin/oneday/AddOneDayForm.jsp)
	 * > 설명 : 
	 * 		- 공지 등록 창
	 ===========================================================================*/
	@RequestMapping(value={"/addOneDayForm.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView addOneDayForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		
		return mav;
	}
	
	/* ===========================================================================
	 * 4. 일일클래스 등록
	 * ---------------------------------------------------------------------------
	 * > 입력 : oneDay 
	 * > 출력 : - 
	 * > 이동 페이지 : ???
	 * > 설명 : 
	 * 		- 일일 클래스 등록
	 ===========================================================================*/
	@RequestMapping(value={"/addOneDay.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView addOneDay(MultipartHttpServletRequest mtfRequest, HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		ModelAndView mav = new ModelAndView("redirect:/admin/main.do");
		
		// OneDay 데이터
		OneDayVO oneDay = new OneDayVO();
		String jsonData = request.getParameter("oneDay");
		if(!conData.isEmpty(jsonData)) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println("jsonData : " + jsonData);
			JSONObject jsonObj = JSONObject.fromObject(jsonData);
			oneDay = JSONtoOneDay(jsonObj);
			if(oneDay == null) {
				System.out.println("[warning] oneDay를 변환하는데 문제가 발생했습니다.");
				return mav;
			}else {
				if(!adminOneDayService.setOneDayKeyNum(oneDay)) {
					System.out.println("[warning] keyNum을 설정하는데 문제가 발생했습니다.");
					return mav;
				}
			}
		}else{
			System.out.println("[warning] oneDay를 가져오는데 문제가 발생했습니다.");
			return mav;
		}
		
		// 파일 데이터 업로드 및 경로 저장
		List<MultipartFile> fileList = mtfRequest.getFiles("file");
		System.out.println("fileList-size : " + fileList.size());
		if(fileList.size() > 0) {
			boolean uploadResult = adminOneDayService.uploadOneDayPhoto(request, fileList, oneDay);
			if(!uploadResult) {
				System.out.println("[warning] 파일 업로드 중 문제가 발생했습니다.");
				return mav;
			}
		}
		
		boolean result = adminOneDayService.addOneDay(oneDay);
		if(!result) {
			System.out.println("[warning] 원데이클래스 등록 중 문제가 발생했습니다.");
		}
		
		return mav;
	}

	/* ===========================================================================
	 * 5. 일일클래스 삭제
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum
	 * > 출력 : boolean
	 * > 이동 페이지 : -
	 * > 설명 : 
	 * 		- 문의 조회 창
	 ===========================================================================*/
	@RequestMapping(value={"/delOneDay.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Boolean> delOneDay(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		
		// keyNum 
		Integer keyNum = conData.StringtoInteger(request.getParameter("keyNum"));
		if(keyNum == null) {
			System.out.println("[warning] keyNum을 받아오는데 문제가 발생했습니다.");
			return new ResponseEntity("[warning] keyNum을 받아오는데 문제가 발생했습니다.", HttpStatus.BAD_REQUEST);
		}
		
		// 문의 삭제
		boolean result = adminOneDayService.deleteOneDay(keyNum);
		
		return new ResponseEntity<Boolean>(result, HttpStatus.OK);
	}
	
	/* ===========================================================================
	 * 6. 일일클래스 다중 삭제
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum - List
	 * > 출력 : boolean
	 * > 이동 페이지 : -
	 * > 설명 : 
	 * 		- 일일클래스 다중 삭제
	 ===========================================================================*/
	@RequestMapping(value={"/delOneDayList.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Boolean> delOneDayList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		boolean result = false;
		
		String jsonData = request.getParameter("list");
		if(jsonData != null) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println(jsonData);
			JSONArray array = JSONArray.fromObject(jsonData);
			int num = 0;
			for(int i=0;i<array.size();i++) {
				Integer keyNum = array.getInt(i);
				System.out.println("delKeyNum : "+keyNum);
				boolean delResult = adminOneDayService.deleteOneDay(keyNum);
				if(delResult) num++;
			}
			if(array.size() == num) {
				result = true;
			}
			System.out.println("삭제된 열 : " + num + "/" + array.size());
		}else {
			System.out.println("[warning] keyNum-List를 받아오는데 문제가 발생했습니다.");
			return new ResponseEntity("[warning] keyNum-List를 받아오는데 문제가 발생했습니다.", HttpStatus.BAD_REQUEST);
		}
		
		return new ResponseEntity<Boolean>(result, HttpStatus.OK);
	}
	
	// ===========================================================================
	//                                    기타 
	// ===========================================================================
	private OneDayVO JSONtoOneDay(JSONObject obj) {
		OneDayVO oneDay = new OneDayVO();
		SimpleDateFormat dateForm = new SimpleDateFormat("yyyy-MM-dd");
		
		// 1. classTitle
		// 2. classContent
		// 3. classDate
		// 4. classTile
		// 5. lector
		// 6. lectorTel
		if(obj.size() < 6) {
			System.out.println("[warning] OneDayVO 입력 파라메터 수(6) 불일치");
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
		oneDay.setClassTitle(obj.getString("classTitle"));
		oneDay.setClassContent(obj.getString("classContent"));
		oneDay.setClassTime(obj.getString("classTime"));
		oneDay.setLector(obj.getString("lector"));
		oneDay.setLectorTel(obj.getString("lectorTel"));
		try {
			String strClassDate = obj.getString("classDate");
			Date classDate = new Date(dateForm.parse(strClassDate).getTime());
			oneDay.setClassDate(classDate);
		} catch(Exception e) {
			System.out.println("[warning] classDate를 받아오는데 문제 발생");
			return null;
		}
		
		return oneDay;
	}
	
	private AdminOneDayFilterVO JSONtoAdminOneDayFilter(JSONObject obj) {
		AdminOneDayFilterVO searchInfo = new AdminOneDayFilterVO();
		
		// 1. searchContent
		// 2. classStatus
		// 2. page
		if(obj.size() < 3) {
			System.out.println("[warning] AdminOneDayFilterVO 입력 파라메터 수(3) 불일치");
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
		searchInfo.setSearchContent(obj.getString("searchContent"));
		Integer classStatus = conData.StringtoInteger(obj.getString("classStatus"));
		if(classStatus == null) {
			System.out.println("[warning] classStatus를 받아오는데 문제 발생");
			return null;
		}
		searchInfo.setClassStatus(classStatus);
		Integer page = conData.StringtoInteger(obj.getString("page"));
		if(page == null) {
			System.out.println("[warning] page를 받아오는데 문제 발생");
			return null;
		}
		searchInfo.setPage(page);
		System.out.println(searchInfo.toString());
		
		return searchInfo;
	}
	
}
