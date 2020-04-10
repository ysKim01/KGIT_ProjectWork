package com.myspring.mall.admin.question.controller;

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
import org.springframework.web.servlet.ModelAndView;

import com.myspring.mall.admin.question.service.AdminQuestionService;
import com.myspring.mall.admin.question.vo.AdminQuestionFilterVO;
import com.myspring.mall.admin.reserve.vo.AdminReserveSearchVO;
import com.myspring.mall.admin.reserve.vo.ReserveFilterVO;
import com.myspring.mall.center.vo.CenterSearchVO;
import com.myspring.mall.center.vo.MainSearchFilterVO;
import com.myspring.mall.common.ControllData;
import com.myspring.mall.question.service.QuestionService;
import com.myspring.mall.question.vo.QuestionVO;

import net.sf.json.JSONObject;

@RestController
@Controller("adminQuestionController")
@EnableAspectJAutoProxy
@RequestMapping("/admin")
public class AdminQuestionControllerImpl implements AdminQuestionController{
	@Autowired
	private AdminQuestionService adminQuestionService;
	@Autowired
	private QuestionService questionService;
	
	static private ControllData conData = new ControllData();
	
	/* ===========================================================================
	 * 1. 문의 목록 
	 * ---------------------------------------------------------------------------
	 * > 입력 : searchInfo
	 * > 출력 : question-List, searchInfo
	 * > 이동 페이지 : 문의 목록 창 (/admin/question/ListQuestion.jsp)
	 * > 설명 : 
	 * 		- 문의 목록 창
	 ===========================================================================*/
	@RequestMapping(value={"/listQuestion.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView listQuestion(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		List<QuestionVO> questionList = new ArrayList<QuestionVO>();
		
		AdminQuestionFilterVO searchInfo = (AdminQuestionFilterVO)request.getAttribute("searchInfo");
		if(searchInfo == null) {
			searchInfo = new AdminQuestionFilterVO();
			searchInfo.setSearchFilter("userId");
			searchInfo.setSearchContent("");
			searchInfo.setQuestionClass("All");
			searchInfo.setIsAnswered("All");
			searchInfo.setPage(1);
		}
		System.out.println(searchInfo.toString());
		
		questionList = adminQuestionService.listQuestionByFiltered(searchInfo);
		if(questionList != null) {
			for(QuestionVO question : questionList) {
				System.out.println(question.toString());
			}
		}
		
		mav.addObject("questionList",questionList);
		mav.addObject("searchInfo",searchInfo);
		return mav;
	}

	/* ===========================================================================
	 * 2. 문의 검색 
	 * ---------------------------------------------------------------------------
	 * > 입력 : searchInfo
	 * > 출력 : searchInfo
	 * > 이동 페이지 : 문의 목록 (/admin/listQuestion.do)
	 * > 설명 : 
	 * 		- 문의 검색
	 ===========================================================================*/
	@RequestMapping(value={"/searchQuestion.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public void searchQuestion(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		String nextPage = "/admin/listQuestion.do";
		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		
		AdminQuestionFilterVO searchInfo = new AdminQuestionFilterVO();
		String jsonData = request.getParameter("searchInfo");
		if(!conData.isEmpty(jsonData)) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println("jsonData : " + jsonData);
			JSONObject jsonObj = JSONObject.fromObject(jsonData);
			searchInfo = JSONtoMainAdminQuestionFilter(jsonObj);
		}else{
			searchInfo = null;
		}
		
		request.setAttribute("searchInfo", searchInfo);
		dispatcher.forward(request, response);
	}

	/* ===========================================================================
	 * 3. 문의 조회
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum, searchInfo
	 * > 출력 : question, searchInfo
	 * > 이동 페이지 : 문의 조회 창 (/admin/question/ShowQuestion.jsp)
	 * > 설명 : 
	 * 		- 문의 조회 창
	 ===========================================================================*/
	@RequestMapping(value={"/showQuestion.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView showQuestionForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		
		// keyNum 
		Integer keyNum = conData.StringtoInteger(request.getParameter("keyNum"));
		if(keyNum == null) {
			System.out.println("[warning] keyNum을 받아오는데 문제가 발생했습니다.");
			return mav;
		}
		
		// question
		QuestionVO question = questionService.selectQuestion(keyNum);
		if(question == null) {
			System.out.println("[warning] Question을 디비에서 불러오는데 실패했습니다.");
			return mav;
		}
		System.out.println(question.toString());
		
		// searchInfo
		AdminQuestionFilterVO searchInfo = new AdminQuestionFilterVO();
		String jsonData = request.getParameter("searchInfo");
		if(!conData.isEmpty(jsonData)) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println("jsonData : " + jsonData);
			JSONObject jsonObj = JSONObject.fromObject(jsonData);
			searchInfo = JSONtoMainAdminQuestionFilter(jsonObj);
		}else{
			searchInfo = null;
		}
		
		mav.addObject("question", question);
		mav.addObject("searchInfo", searchInfo);
		return mav;
	}
	
	// ===========================================================================
	//                                    기타 
	// ===========================================================================
	private AdminQuestionFilterVO JSONtoMainAdminQuestionFilter(JSONObject obj) {
		AdminQuestionFilterVO searchInfo = new AdminQuestionFilterVO();
		
		// 1. searchFilter
		// 2. searchContent
		// 3. questionClass
		// 4. isAnswered
		// 5. page
		if(obj.size() < 5) {
			System.out.println("[warning] AdminQuestionFilterVO 입력 파라메터 수(5) 불일치");
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
		searchInfo.setSearchFilter(obj.getString("searchFilter"));
		searchInfo.setSearchContent(obj.getString("searchContent"));
		searchInfo.setQuestionClass(obj.getString("questionClass"));
		searchInfo.setIsAnswered(obj.getString("isAnswered"));
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
