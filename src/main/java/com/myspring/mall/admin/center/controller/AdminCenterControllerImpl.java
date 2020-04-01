package com.myspring.mall.admin.center.controller;


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
	
		

}