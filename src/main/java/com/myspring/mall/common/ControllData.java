package com.myspring.mall.common;

import java.sql.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class ControllData {
	public Integer StringtoInteger(String str) {
		Integer result = null;
		
		try {
			result = Integer.parseInt(str);
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	public boolean isEmpty(String str) {
		boolean result = false;
		if(str == null) {
			return true;
		}
		if(str.equals("") || str.length()==0) {
			result = true;
		}
		
		return result;
	}
	public boolean isEmpty(Date date) {
		boolean result = false;
		
		if(date==null) {
			result = true;
		}else if(date!=null) {
			if(date.toString().equals("")) {
				result = true;
			}
		}
		
		return result;
	}
	public boolean isEmpty(Integer integer) {
		boolean result = false;
		
		if(integer == null) {
			result = true;
		}
		
		return result;
	}
	public Map TelDivThree(String userTel) {
		Map tel = new HashMap();
		if(userTel.length() != 11) {
			return null;
		}
		String userTel1 = userTel.substring(0,3); 	// 0,1,2
		String userTel2 = userTel.substring(3,7);	// 3,4,5,6
		String userTel3 = userTel.substring(7,11);	// 7,8,9,10
		tel.put("userTel1", userTel1);
		tel.put("userTel2", userTel2);
		tel.put("userTel3", userTel3);
		
		return tel;
	}
	
	public String CenterTelDiv(String centerTel) {
		String tel = new String();
		if(centerTel.length() != 10) {
			return null;
		}
		tel = centerTel;
		
		return tel;
	}
	
	public Date Date9999toNull(Date date) {
		if(date != null) {
			if(date.toString().equals("9999-09-09")) {
				date = null;
			}
		}
		return date;
	}
	
	public boolean setLastPage(HttpServletRequest request) {
		boolean result = false;
		try {
			HttpSession session=request.getSession();
			String lastRequest = (String)session.getAttribute("lastRequest");
			session.removeAttribute("lastPage");
			if(isEmpty(lastRequest)) {
				session.setAttribute("lastPage", "/main.do");
			}else {
				session.setAttribute("lastPage", lastRequest);
			}
			result = true;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	public String getLastPage(HttpServletRequest request) {
		String result = null;
		try {
			HttpSession session=request.getSession();
			String lastPage = (String)session.getAttribute("lastPage");
			result = lastPage;
			if(result == null) {
				result = "/main.do";
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
}
