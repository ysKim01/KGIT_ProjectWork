package com.myspring.mall.common;

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
	
	public boolean StringisEmpty(String str) {
		boolean result = false;
		
		if(str.equals("") || str.length()==0) {
			result = true;
		}
		
		return result;
	}
}
