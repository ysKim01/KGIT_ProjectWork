package com.myspring.mall.admin.reserve.service;

import java.sql.Date;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.myspring.mall.admin.center.dao.AdminCenterDAO;
import com.myspring.mall.admin.reserve.dao.AdminReserveDAO;
import com.myspring.mall.center.vo.CenterInfoVO;
import com.myspring.mall.common.ControllData;


@Service("adminReserveService")
@Transactional(propagation=Propagation.REQUIRED)
public class AdminReserveServiceImpl implements AdminReserveService{
	@Autowired
	private AdminReserveDAO adminReserveDAO;
	@Autowired
	private AdminCenterDAO adminCenterDAO;
	
	private static ControllData conData = new ControllData();

	
	@Override
	public String getUsableTime(String centerCode, String roomCode, Date reserveDate) {
		// 정보 가져오기
		CenterInfoVO centerInfo = adminCenterDAO.selectCenterByCenterCode(centerCode);
		if(centerInfo == null) return null;
		Map searchMap = new HashMap();
		searchMap.put("centerCode", centerCode);
		searchMap.put("roomCode", roomCode);
		searchMap.put("reserveDate", reserveDate);
		List<String> usingTimeList = new ArrayList<String>(); 
		usingTimeList = adminReserveDAO.listUsingTimeForUsable(searchMap); 
		if(usingTimeList.size() == 0) return null;
		
		// 계산
		int startTime = centerInfo.getOperTimeStart();
		int endTime = centerInfo.getOperTimeEnd();
		int unitTime = centerInfo.getUnitTime();
		int usableTimeLength = (endTime - startTime) / unitTime;
		int listSize = usingTimeList.size();
		
		List<String> charList = new ArrayList<String>();
		for(int i=0; i<usableTimeLength; i++) {
			charList.add("0");
		}
		for(int timeIdx=0;timeIdx<usableTimeLength;timeIdx++) {
			for(int listIdx=0;listIdx<listSize;listIdx++) {
				char num = usingTimeList.get(listIdx).charAt(timeIdx);
				if(num == '1') {
					charList.set(timeIdx, "1");
					break;
				}
			}
		}
		
		String usableTime = "";
		for(int i=0;i<charList.size();i++) {
			usableTime += charList.get(i);
		}
		
		return usableTime;
	}
	
}
