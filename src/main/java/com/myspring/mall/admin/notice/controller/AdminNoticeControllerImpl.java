package com.myspring.mall.admin.notice.controller;

import java.net.URLDecoder;
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
import org.springframework.web.servlet.ModelAndView;

import com.myspring.mall.admin.notice.service.AdminNoticeService;
import com.myspring.mall.admin.notice.vo.AdminNoticeFilterVO;
import com.myspring.mall.admin.notice.vo.NoticeVO;
import com.myspring.mall.admin.question.vo.AdminQuestionFilterVO;
import com.myspring.mall.common.ControllData;
import com.myspring.mall.member.vo.MemberVO;
import com.myspring.mall.question.vo.QuestionVO;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@RestController
@Controller("adminNoticeController")
@EnableAspectJAutoProxy
@RequestMapping("/admin")
public class AdminNoticeControllerImpl implements AdminNoticeController{
	@Autowired
	private AdminNoticeService adminNoticeService; 
	
	static ControllData conData = new ControllData();
	
	/* ===========================================================================
	 * 1. 공지 목록 
	 * ---------------------------------------------------------------------------
	 * > 입력 : searchInfo
	 * > 출력 : notice-List, searchInfo
	 * > 이동 페이지 : 공지 목록 창 (/admin/notice/ListNotice.jsp)
	 * > 설명 : 
	 * 		- 공지 목록 창
	 ===========================================================================*/
	@RequestMapping(value={"/listNotice.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView listQuestion(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		
		AdminNoticeFilterVO searchInfo = (AdminNoticeFilterVO)request.getAttribute("searchInfo");
		if(searchInfo == null) {
			searchInfo = new AdminNoticeFilterVO();
			searchInfo.setSearchContent("");
			searchInfo.setPage(1);
		}
		
		List<NoticeVO> topList = adminNoticeService.listTopNotice();
		if(topList != null) {
			for(NoticeVO top : topList) {
				System.out.println(top.toString());
			}
		}else {
			System.out.println("[info] 검색된 topList 없음.");
		}
		
		List<NoticeVO> noticeList = adminNoticeService.listNoticeByFilter(searchInfo);
		if(noticeList != null) {
			for(NoticeVO notice : noticeList) {
				System.out.println(notice.toString());
			}
		}else {
			System.out.println("[info] 검색된 noticeList 없음.");
		}
		System.out.println(searchInfo.toString());
		
		mav.addObject("topList",topList);
		mav.addObject("noticeList",noticeList);
		mav.addObject("searchInfo",searchInfo);
		return mav;
	}

	/* ===========================================================================
	 * 2. 공지 검색 
	 * ---------------------------------------------------------------------------
	 * > 입력 : searchInfo
	 * > 출력 : searchInfo
	 * > 이동 페이지 : 공지 목록 (/admin/listNotice.do)
	 * > 설명 : 
	 * 		- 공지 검색
	 ===========================================================================*/
	@RequestMapping(value={"/searchNotice.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public void searchNotice(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		String nextPage = "/admin/listNotice.do";
		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		
		AdminNoticeFilterVO searchInfo = new AdminNoticeFilterVO();
		String jsonData = request.getParameter("searchInfo");
		if(!conData.isEmpty(jsonData)) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println("jsonData : " + jsonData);
			JSONObject jsonObj = JSONObject.fromObject(jsonData);
			searchInfo = JSONtoAdminNoticeFilter(jsonObj);
		}else{
			searchInfo = null;
		}
		
		request.setAttribute("searchInfo", searchInfo);
		dispatcher.forward(request, response);
	}

	/* ===========================================================================
	 * 3. 공지 조회
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum, searchInfo
	 * > 출력 : notice, searchInfo
	 * > 이동 페이지 : 공지 조회 창 (/admin/notice/ShowNotice.jsp)
	 * > 설명 : 
	 * 		- 공지 조회 창
	 ===========================================================================*/
	@RequestMapping(value={"/showNotice.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView showNotice(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		
		// keyNum 
		Integer keyNum = conData.StringtoInteger(request.getParameter("keyNum"));
		if(keyNum == null) {
			System.out.println("[warning] keyNum을 받아오는데 문제가 발생했습니다.");
			return mav;
		}
		
		// notice
		NoticeVO notice = adminNoticeService.selectNotice(keyNum);
		if(notice == null) {
			System.out.println("[warning] notice를 디비에서 불러오는데 실패했습니다.");
			return mav;
		}
		System.out.println(notice.toString());
		
		// searchInfo
		AdminNoticeFilterVO searchInfo = new AdminNoticeFilterVO();
		String jsonData = request.getParameter("searchInfo");
		if(!conData.isEmpty(jsonData)) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println("jsonData : " + jsonData);
			JSONObject jsonObj = JSONObject.fromObject(jsonData);
			searchInfo = JSONtoAdminNoticeFilter(jsonObj);
		}else{
			searchInfo = null;
		}
		
		mav.addObject("notice", notice);
		mav.addObject("searchInfo", searchInfo);
		return mav;
	}
	
	/* ===========================================================================
	 * 4. 공지 수정
	 * ---------------------------------------------------------------------------
	 * > 입력 : notice
	 * > 출력 : boolean
	 * > 이동 페이지 : -
	 * > 설명 : 
	 * 		- 공지 수정
	 ===========================================================================*/
	@RequestMapping(value={"/modNotice.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Boolean> modNotice(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		
		// keyNum 
		Integer keyNum = conData.StringtoInteger(request.getParameter("keyNum"));
		if(keyNum == null) {
			System.out.println("[warning] keyNum을 받아오는데 문제가 발생했습니다.");
			return new ResponseEntity("[warning] keyNum을 받아오는데 문제가 발생했습니다.", HttpStatus.BAD_REQUEST);
		}
		
		// notice
		NoticeVO notice = new NoticeVO();
		String jsonData = request.getParameter("notice");
		if(!conData.isEmpty(jsonData)) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println("jsonData : " + jsonData);
			JSONObject jsonObj = JSONObject.fromObject(jsonData);
			notice = JSONtoNotice(jsonObj);
			if(notice == null) {
				System.out.println("[warning] jsonData를 변환하는데 문제가 발생했습니다.");
				return new ResponseEntity("[warning] jsonData를 변환하는데 문제가 발생했습니다.", HttpStatus.BAD_REQUEST);
			}else{
				notice.setKeyNum(keyNum);
			}
		}else{
			System.out.println("[warning] notice를 받아오는데 문제가 발생했습니다.");
			return new ResponseEntity("[warning] notice를 받아오는데 문제가 발생했습니다.", HttpStatus.BAD_REQUEST);
		}
		
		// 문의 수정
		boolean result = adminNoticeService.updateNotice(notice);
		
		return new ResponseEntity<Boolean>(result, HttpStatus.OK);
	}
	
	/* ===========================================================================
	 * 5. 공지 등록 창
	 * ---------------------------------------------------------------------------
	 * > 입력 : - 
	 * > 출력 : - 
	 * > 이동 페이지 : 공지 조회 창 (/admin/notice/AddNoticeForm.jsp)
	 * > 설명 : 
	 * 		- 공지 등록 창
	 ===========================================================================*/
	@RequestMapping(value={"/addNoticeForm.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView addNoticeForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		
		return mav;
	}
	
	/* ===========================================================================
	 * 6. 공지 등록
	 * ---------------------------------------------------------------------------
	 * > 입력 : notice
	 * > 출력 : boolean
	 * > 이동 페이지 : -
	 * > 설명 : 
	 * 		- 공지 등록
	 ===========================================================================*/
	@RequestMapping(value={"/addNotice.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Boolean> addNotice(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		
		// notice
		NoticeVO notice = new NoticeVO();
		String jsonData = request.getParameter("notice");
		if(!conData.isEmpty(jsonData)) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println("jsonData : " + jsonData);
			JSONObject jsonObj = JSONObject.fromObject(jsonData);
			notice = JSONtoNotice(jsonObj);
			if(notice == null) {
				System.out.println("[warning] jsonData를 변환하는데 문제가 발생했습니다.");
				return new ResponseEntity("[warning] jsonData를 변환하는데 문제가 발생했습니다.", HttpStatus.BAD_REQUEST);
			}
		}else{
			System.out.println("[warning] notice를 받아오는데 문제가 발생했습니다.");
			return new ResponseEntity("[warning] notice를 받아오는데 문제가 발생했습니다.", HttpStatus.BAD_REQUEST);
		}
		
		// 문의 수정
		boolean result = adminNoticeService.insertNotice(notice);
		
		return new ResponseEntity<Boolean>(result, HttpStatus.OK);
	}

	/* ===========================================================================
	 * 7. 공지 삭제
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum
	 * > 출력 : boolean
	 * > 이동 페이지 : -
	 * > 설명 : 
	 * 		- 문의 조회 창
	 ===========================================================================*/
	@RequestMapping(value={"/delNotice.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Boolean> delNotice(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		
		// keyNum 
		Integer keyNum = conData.StringtoInteger(request.getParameter("keyNum"));
		if(keyNum == null) {
			System.out.println("[warning] keyNum을 받아오는데 문제가 발생했습니다.");
			return new ResponseEntity("[warning] keyNum을 받아오는데 문제가 발생했습니다.", HttpStatus.BAD_REQUEST);
		}
		
		// 문의 삭제
		boolean result = adminNoticeService.deleteNotice(keyNum);
		
		return new ResponseEntity<Boolean>(result, HttpStatus.OK);
	}
	
	/* ===========================================================================
	 * 8. 공지 다중 삭제
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum - List
	 * > 출력 : boolean
	 * > 이동 페이지 : -
	 * > 설명 : 
	 * 		- 공지 다중 삭제
	 ===========================================================================*/
	@RequestMapping(value={"/delNoticeList.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Boolean> delNoticeList(HttpServletRequest request, HttpServletResponse response) throws Exception {
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
				boolean delResult = adminNoticeService.deleteNotice(keyNum);
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
	private AdminNoticeFilterVO JSONtoAdminNoticeFilter(JSONObject obj) {
		AdminNoticeFilterVO searchInfo = new AdminNoticeFilterVO();
		
		// 1. searchContent
		// 2. page
		if(obj.size() < 2) {
			System.out.println("[warning] AdminNoticeFilterVO 입력 파라메터 수(2) 불일치");
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
		searchInfo.setSearchContent(obj.getString("searchContent"));
		Integer page = conData.StringtoInteger(obj.getString("page"));
		if(page == null) {
			System.out.println("[warning] page를 받아오는데 문제 발생");
			return null;
		}
		searchInfo.setPage(page);
		System.out.println(searchInfo.toString());
		
		return searchInfo;
	}
	
	private NoticeVO JSONtoNotice(JSONObject obj) {
		NoticeVO notice = new NoticeVO();
		
		// 1. noticeTitle
		// 2. noticeContent
		// 3. noticeTop
		if(obj.size() < 3) {
			System.out.println("[warning] NoticeVO 입력 파라메터 수(3) 불일치");
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
		notice.setNoticeTitle(obj.getString("noticeTitle"));
		notice.setNoticeContent(obj.getString("noticeContent"));
		Integer noticeTop = conData.StringtoInteger(obj.getString("noticeTop"));
		if(noticeTop == null) {
			System.out.println("[warning] noticeTop을 받아오는데 문제 발생");
			return null;
		}
		notice.setNoticeTop(noticeTop);
		
		System.out.println(notice.toString());
		return notice;
	}
}
