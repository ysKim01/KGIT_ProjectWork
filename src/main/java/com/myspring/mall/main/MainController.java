package com.myspring.mall.main;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.mall.common.ControllData;

@Controller("mainController")
@EnableAspectJAutoProxy
public class MainController {
	
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
}
