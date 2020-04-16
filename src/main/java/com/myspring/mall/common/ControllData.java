package com.myspring.mall.common;

import java.io.File;
import java.sql.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.myspring.mall.center.vo.CenterInfoVO;

public class ControllData {
	public Integer StringtoInteger(String str) {
		Integer result = null;
		
		try {
			result = Integer.parseInt(str);
		}catch(Exception e) {
			//e.printStackTrace();
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

	public String transStatusLang(String status) {
		if(status.equals("Apply")) {
			return "예약신청";
		}else if(status.equals("Payment")){
			return "결재완료";
		}else if(status.equals("Checkout")){
			return "사용완료";
		}else {
			return "None";
		}
	}

	public String usingTimeToString(CenterInfoVO center, String usingTime) {
		int openMinute = center.getOperTimeStart();
		int unitMinute = center.getUnitTime();
		int startIdx = usingTime.indexOf("1");
		int endIdx = usingTime.lastIndexOf("1");
		
		int startMinute = openMinute + (startIdx*unitMinute);
		int endMinute = openMinute + ((endIdx+1)*unitMinute);
		
		String startTime = MinuteToTime(startMinute);
		String endTime = MinuteToTime(endMinute);
		
		return startTime + " ~ " + endTime;
	}

	private String MinuteToTime(int time) {
		String hour = Integer.toString(time/60);
		for(int i=0; i<(2-hour.length()); i++) {
			hour = "0" + hour;
		}
		
		String minute = Integer.toString(time%60);
		for(int i=0; i<(2-minute.length()); i++) {
			minute = "0" + minute;
		}
		
		return hour + ":" + minute;
	}

	public Float StringtoFloat(String str) {
		Float result = null;
		
		try {
			result =  Float.parseFloat(str);
		}catch(Exception e) {
			//e.printStackTrace();
		}
		
		return result;
	}
	
	public static void deleteFileFn(String path) {
		File file = new File(path); // 매개변수로 받은 경로를 파일객체선언 (/home/nation909/test 경로의 폴더를 지정함)
		File[] files = file.listFiles();  // 해당 폴더 안의 파일들을 files 변수에 담음

		if(files.length > 0) { // 파일, 폴더가 1개라도 있을경우 실행
			for (int i=0; i<files.length; i++) { // 개수만큼 루프
				if(files[i].isFile()) { // 파일일경우 해당파일 삭제
					files[i].delete();
				}
				else { // 폴더일경우 재귀함수로 해당폴더의 경로를 전달함
					deleteFileFn(files[i].getPath()); // 재귀함수
				}
				files[i].delete(); // 폴더일경우 재귀함수가 다돌고나서, 즉 폴더안의 파일이 다지워지고 나서 해당폴더를 삭제함 
			}
		}
		file.delete();
	}

}
