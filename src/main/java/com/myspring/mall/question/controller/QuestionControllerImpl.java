package com.myspring.mall.question.controller;

import java.net.URLDecoder;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
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
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.myspring.mall.admin.reserve.vo.AdminReserveSearchVO;
import com.myspring.mall.common.ControllData;
import com.myspring.mall.member.vo.MemberVO;
import com.myspring.mall.question.service.QuestionService;
import com.myspring.mall.question.vo.QuestionVO;

import net.sf.json.JSONObject;

@Controller("questionController")
@EnableAspectJAutoProxy
@RequestMapping("/question")
public class QuestionControllerImpl extends MultiActionController implements QuestionController{
	@Autowired
	private QuestionService questionService;
	
	private static ControllData conData = new ControllData();
	
	/* ===========================================================================
	 * 1. 문의 목록 창
	 * ---------------------------------------------------------------------------
	 * > 입력 : -
	 * > 출력 : Question - List
	 * > 이동 페이지 : /question/ListQuestion.jsp (문의 목록 창)
	 * > 설명 : 
	 * 		- 문의 목록 전달
	 ===========================================================================*/
	@RequestMapping(value={"/listQuestion.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView listQuestion(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		
		// userId 
		HttpSession session=request.getSession();
		String userId = (String)session.getAttribute("logonId");
		if(userId == null) {
			System.out.println("[warning] 로그인 되지 않았습니다.");
			return mav;
		}
		
		// 목록 출력
		List<QuestionVO> qList = new ArrayList<QuestionVO>();
		qList = questionService.listQuestionById(userId);
		if(qList != null) {
			for(QuestionVO question : qList) {
				System.out.println(question.toString());
			}
		}
		
		mav.addObject("questionList", qList);
		return mav;
	}
	
	/* ===========================================================================
	 * 2. 문의 등록 창 
	 * ---------------------------------------------------------------------------
	 * > 입력 : -
	 * > 출력 : -
	 * > 이동 페이지 : /question/AddQuestionForm.jsp (예약 목록 창)
	 * > 설명 : 
	 * 		- 문의 등록 창 이동
	 ===========================================================================*/
	@RequestMapping(value= {"/addQuestionForm.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView addQuestionForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		return mav;
	}
	
	/* ===========================================================================
	 * 3. 문의 등록 
	 * ---------------------------------------------------------------------------
	 * > 입력 : question (ajax/post)
	 * > 출력 : boolean
	 * > 이동 페이지 : -
	 * > 설명 : 
	 * 		- 문의 등록
	 ===========================================================================*/
	@RequestMapping(value= {"/addQuestion.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Boolean> addQuestion(HttpServletRequest request, HttpServletResponse response) throws Exception {
		boolean result = false;
		
		HttpSession session=request.getSession();
		String userId = (String)session.getAttribute("logonId");
		if(userId == null) {
			System.out.println("[warning] 로그인 되지 않았습니다.");
			return new ResponseEntity("[warning] 로그인 되지 않았습니다.", HttpStatus.BAD_REQUEST);
		}
		
		String jsonData = request.getParameter("question");
		if(jsonData != null) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println(jsonData);
			JSONObject jsonObj = JSONObject.fromObject(jsonData);
			QuestionVO question = JSONtoQuestion(jsonObj);
			// 문의 등록
			if(question != null) {
				question.setUserId(userId);
				result = questionService.addQuestion(question);
			}else {
				System.out.println("[warning] 문의등록 입력 정보를 변환하는데 실패했습니다.");
			}
		}else {
			System.out.println("[warning] 문의등록 입력 정보를 가져오는데 실패했습니다.");
		}
		
		try {
			return new ResponseEntity<Boolean>(result, HttpStatus.OK);
		}catch(Exception e) {
			return new ResponseEntity(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
	}
	
	/* ===========================================================================
	 * 4. 문의 내용 창  
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum (submit)
	 * > 출력 : question
	 * > 이동 페이지 : 문의 내용 창(/question/ShowQuestionForm.jsp)
	 * > 설명 : 
	 * 		- 문의 내용 열람 창
	 ===========================================================================*/
	@RequestMapping(value={"/showQuestionForm.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView showQuestionForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		
		Integer keyNum = conData.StringtoInteger(request.getParameter("keyNum"));
		if(keyNum == null) {
			System.out.println("[warning] keyNum을 받아오는데 문제가 발생했습니다.");
			return mav;
		}
		
		QuestionVO question = questionService.selectQuestion(keyNum);
		if(question == null) {
			System.out.println("[warning] Question을 디비에서 불러오는데 실패했습니다.");
			return mav;
		}
		System.out.println(question.toString());
		
		mav.addObject("question", question);
		return mav;
	}

	/* ===========================================================================
	 * 5. 문의 수정 
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum, question (ajax/post)
	 * > 출력 : boolean
	 * > 이동 페이지 : -
	 * > 설명 : 
	 * 		- 문의 수정
	 ===========================================================================*/
	@RequestMapping(value= {"/modQuestion.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Boolean> modQuestion(HttpServletRequest request, HttpServletResponse response) throws Exception {
		boolean result = false;
		
		// 키 값 받아오기
		Integer keyNum = conData.StringtoInteger(request.getParameter("keyNum"));
		if(keyNum == null) {
			System.out.println("[warning] keyNum을 받아오는데 문제가 발생했습니다.");
			return new ResponseEntity("[warning] keyNum을 받아오는데 문제가 발생했습니다.", HttpStatus.BAD_REQUEST);
		}
		
		// 답변 등록 여부확인
		QuestionVO oldQuestion = questionService.selectQuestion(keyNum);
		if(oldQuestion == null) {
			System.out.println("[warning] keyNum과 매칭되는 문의가 없습니다.");
			return new ResponseEntity("[warning] keyNum과 매칭되는 문의가 없습니다.", HttpStatus.BAD_REQUEST);
		}else if(oldQuestion.getQuestionAnswer() != null){
			System.out.println("[warning] 답변의 등록된 문의는 수정할 수 없습니다.");
			return new ResponseEntity("[warning] 답변의 등록된 문의는 수정할 수 없습니다.", HttpStatus.BAD_REQUEST);
		}
		
		// 파라미터 받고 수정
		String jsonData = request.getParameter("question");
		if(jsonData != null) {
			jsonData = URLDecoder.decode(jsonData,"utf-8");
			System.out.println(jsonData);
			JSONObject jsonObj = JSONObject.fromObject(jsonData);
			QuestionVO question = JSONtoQuestion(jsonObj);
			// 문의 수정
			if(question != null) {
				question.setKeyNum(keyNum);
				result = questionService.updateQuestion(question);
			}else {
				System.out.println("[warning] 문의수정 입력 정보를 변환하는데 실패했습니다.");
			}
		}else {
			System.out.println("[warning] 문의수정 입력 정보를 가져오는데 실패했습니다.");
		}
		
		try {
			return new ResponseEntity<Boolean>(result, HttpStatus.OK);
		}catch(Exception e) {
			return new ResponseEntity(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
	}
	
	/* ===========================================================================
	 * 6. FAQ 
	 * ---------------------------------------------------------------------------
	 * > 입력 : - 
	 * > 출력 : - 
	 * > 이동 페이지 : FAQ창 (/views/board/FAQboard.jsp)
	 * > 설명 : 
	 * 		- FAQ 보기
	 ===========================================================================*/
	@RequestMapping(value={"/showFAQ.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView showFAQ(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		return mav;
	}
	
	/* ===========================================================================
	 *                                   기타
	 ===========================================================================*/
	// JSON to QuestionVO for addQuestion
	private QuestionVO JSONtoQuestion(JSONObject obj) {
		QuestionVO question = new QuestionVO();
		// 1. questionClass
		// 2. questionTitle
		// 3. questionContent
		// 4. mailMode
		if(obj.size() < 4) {
			System.out.println("[warning] QuestionVO 입력 파라메터 수(4) 불일치");
			return null;
		}
		// null 값  예외처리 
		Iterator<String> keys = obj.keys();
		while(keys.hasNext()) {
			String param = (String)obj.get(keys.next());
			if(conData.isEmpty(param)) {
				System.out.println("[warning] QuestionVO 입력 파라메터 중 null 값 존재");
				return null;
			}
		}
		
		// 값 등록
		question.setQuestionClass(obj.getString("questionClass"));
		question.setQuestionTitle(obj.getString("questionTitle"));
		question.setQuestionContent(obj.getString("questionContent"));
		Integer mailMode = conData.StringtoInteger(obj.getString("mailMode"));
		if(mailMode == null) {
			System.out.println("[warning] mailMode 데이터 변환 실패");
			return null;
		}
		question.setMailMode(mailMode);
		
		return question;
	}
}
