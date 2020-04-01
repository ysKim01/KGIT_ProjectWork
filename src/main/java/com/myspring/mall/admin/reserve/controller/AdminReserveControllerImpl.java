package com.myspring.mall.admin.reserve.controller;

import java.net.URLDecoder;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.dao.DataAccessException;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.DispatcherServlet;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.myspring.mall.common.ControllData;
import com.fasterxml.jackson.core.io.JsonStringEncoder;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonArrayFormatVisitor;
import com.myspring.mall.admin.member.service.AdminMemberService;
import com.myspring.mall.admin.member.vo.SearchInfoVO;
import com.myspring.mall.admin.reserve.service.AdminReserveService;
import com.myspring.mall.member.vo.MemberVO;

import net.sf.ezmorph.MorpherRegistry;
import net.sf.ezmorph.object.DateMorpher;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONString;
import net.sf.json.util.JSONUtils;
import oracle.jdbc.proxy.annotation.GetProxy;

@RestController
@Controller("adminReserveController")
@EnableAspectJAutoProxy
@RequestMapping("/admin")
public class AdminReserveControllerImpl extends MultiActionController implements AdminReserveController{
	private static final Logger logger = LoggerFactory.getLogger(AdminReserveControllerImpl.class);
	@Autowired
	private AdminReserveService adminReserveService;
	
	private static ControllData conData = new ControllData();
	
	/* ===========================================================================
	 * 1. 예약등록 창 
	 * ---------------------------------------------------------------------------
	 * > 입력 : centerCode
	 * > 출력 : centerCode, roomInfo-List, 
	 * 			
	 * > 이동 페이지 : /admin/listMembersForm.do (회원목록창)
	 * > 설명 : 
	 * 		- 조건에 맞는 회원 목록 불러오기 
	 ===========================================================================*/
	@RequestMapping(value= {"/addReserveForm.do"}, method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView membershipForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		
		// Center Code
		String centerCode = request.getParameter("centerCode");
		
		// RoomInfo List
		
		
		ModelAndView mav = new ModelAndView((String)request.getAttribute("viewName"));
		return mav;
	}
}
