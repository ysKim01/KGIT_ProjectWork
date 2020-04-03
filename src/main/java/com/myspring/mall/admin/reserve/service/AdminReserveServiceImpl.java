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
import com.myspring.mall.admin.member.vo.MemberFilterVO;
import com.myspring.mall.admin.reserve.dao.AdminReserveDAO;
import com.myspring.mall.admin.reserve.vo.AdminReserveSearchVO;
import com.myspring.mall.admin.reserve.vo.ReserveFilterVO;
import com.myspring.mall.center.vo.CenterInfoVO;
import com.myspring.mall.common.ControllData;
import com.myspring.mall.reserve.vo.ReserveVO;


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
		
		List<String> usingTimeList = new ArrayList<String>(); 
		Map searchMap = new HashMap();
		searchMap.put("centerCode", centerCode);
		searchMap.put("roomCode", roomCode);
		searchMap.put("reserveDate", reserveDate);
		usingTimeList = adminReserveDAO.listUsingTimeForUsable(searchMap); 
		
		
		// 계산
		int startTime = centerInfo.getOperTimeStart();
		int endTime = centerInfo.getOperTimeEnd();
		int unitTime = centerInfo.getUnitTime();
		int usableTimeLength = (endTime - startTime) / unitTime;
		int listSize = usingTimeList.size();
		
		if(listSize == 0) {
			String blank = "";
			for(int i=0;i<usableTimeLength;i++)
				blank += "0";
			return blank;
		}
		
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


	@Override
	public List<AdminReserveSearchVO> listReserveByFiltered(ReserveFilterVO searchInfo) {
		List<AdminReserveSearchVO> reserveList = null;
		
		String searchFilter = searchInfo.getSearchFilter();		// all
		String searchContent = searchInfo.getSearchContent();	// all
		String reserveStatus = searchInfo.getReserveStatus();	// null, 신청, 결재완료, 대관확정
		Integer page = searchInfo.getPage();					// 0 +
		if(searchFilter==null) searchFilter = "None";
		if(page==null || page<1) page = 1;
		
		Map searchMap = new HashMap();
		searchMap.put("reserveStatus", reserveStatus);
		searchMap.put("page", page);
		if(!conData.isEmpty(searchContent)) {
			if(searchFilter.equals("userId")) {
				
			}else if(searchFilter.equals("userTel")) {
				
			}else if(searchFilter.equals("centerCode")) {
				
			}else if(searchFilter.equals("centerName")) {
				
			}else {
				reserveList = adminReserveDAO.listReserveByFilter_None(searchMap);
			}
		}else {
			reserveList = adminReserveDAO.listReserveByFilter_None(searchMap);
		}
		
		
		return reserveList;
	}

	@Override
	public int getMaxNumByFiltered(ReserveFilterVO searchInfo) {
		int result = 0;
		
		String searchFilter = searchInfo.getSearchFilter();		// all
		String searchContent = searchInfo.getSearchContent();	// all
		String reserveStatus = searchInfo.getReserveStatus();	// null, 신청, 결재완료, 대관확정
		Integer page = searchInfo.getPage();					// 0 +
		if(searchFilter==null) searchFilter = "None";
		if(page==null || page<1) page = 1;
		
		Map searchMap = new HashMap();
		searchMap.put("reserveStatus", reserveStatus);
		searchMap.put("page", page);
		if(!conData.isEmpty(searchContent)) {
			if(searchFilter.equals("userId")) {
				
			}else if(searchFilter.equals("userTel")) {
				
			}else if(searchFilter.equals("centerCode")) {
				
			}else if(searchFilter.equals("centerName")) {
				
			}else {
				result = adminReserveDAO.countReserveByFilter_None(searchMap);
			}
		}else {
			result = adminReserveDAO.countReserveByFilter_None(searchMap);
		}
		
		return result;
	}


	@Override
	public boolean insertReserve(ReserveVO reserve, Integer scale, CenterInfoVO center) {
		boolean result = false;
		
		// set reservePrice
		reserve.setReservePrice(calReservePrice(reserve, scale, center));
		
		int num = adminReserveDAO.insertReserve(reserve);
		if(num > 0) result = true;
		
		return result;
	}
	private int calReservePrice(ReserveVO reserve, Integer scale, CenterInfoVO center) {
		int result = 0;
		
		int idxPrice = center.getUnitPrice() * center.getUnitTime() / 60;
		double premiumRate = (double)center.getPremiumRate() / 100.0;
		int premiumIdx = (center.getSurchageTime()-center.getOperTimeStart()) 
				/ center.getUnitTime();
				
		String usingTime = reserve.getUsingTime();
		double priceCnt = 0;
		for(int i=0;i<usingTime.length();i++) {
			if(usingTime.charAt(i) == '1') {
				if(i >= premiumIdx) {
					priceCnt += premiumRate;
				}else {
					priceCnt += 1;
				}
			}
		}
		result = (int)(idxPrice * priceCnt);
		
		return result;
	}
	
}
