package com.myspring.mall.center.service;

import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.myspring.mall.center.dao.CenterDAO;
import com.myspring.mall.center.vo.CenterContentsVO;
import com.myspring.mall.center.vo.CenterFacilityVO;
import com.myspring.mall.center.vo.CenterSearchVO;
import com.myspring.mall.center.vo.MainSearchFilterVO;
import com.myspring.mall.center.vo.RoomInfoVO;

@Service("centerService2")
public class CenterServiceImpl implements CenterService{
	@Autowired
	private CenterDAO centerDAO;

	@Override
	public boolean updateRating(String centerCode, double newRating, int ratingNum) {
		boolean result = false;
		
		Map map = new HashMap();
		map.put("centerCode", centerCode);
		map.put("ratingScore", newRating);
		map.put("ratingNum", ratingNum);
		
		int num = centerDAO.updateRating(map);
		if(num >= 1) {
			result = true;
		}
		
		return result;
	}

	@Override
	public List<CenterSearchVO> listCenterByFilter(MainSearchFilterVO searchInfo, CenterFacilityVO facilityChk) {
		List<CenterSearchVO> centerList = new ArrayList<CenterSearchVO>();
		int maxNum = 0;
		
		Map searchMap = new HashMap();
		//searchMap.put("searchDate", searchInfo.getSearchDate());
		searchMap.put("searchAdd1", searchInfo.getSearchAdd1());
		searchMap.put("searchAdd2", searchInfo.getSearchAdd2());
		searchMap.put("sort", searchInfo.getSort());
		
		int scale = searchInfo.getScale();
		int page = searchInfo.getPage();
		
		List<String> codeList = centerDAO.listCenterCodeByFilter(searchMap);
		if(codeList==null || codeList.size()==0) return null;
		
		for(int i=0; i<codeList.size(); i++) {
			int sMax = centerDAO.selectMaxScaleByCenter(codeList.get(i));
			if(sMax < scale) {
				codeList.remove(i);
			}
		}
		
		searchInfo.setMaxNum(codeList.size());
		
		for(int i=(page-1); i<(page-1)+10; i++) {
			if(i > codeList.size()-1){ break; }
			CenterSearchVO centerSearch = centerDAO.selectCenterSearchByCenterCode(codeList.get(i));
			if(CheckFacility(facilityChk, centerSearch)){
				centerList.add(centerSearch);
			}
		}
		
		return centerList;
	}

	private boolean CheckFacility(CenterFacilityVO facilityChk, CenterSearchVO center) {
		boolean result = true;
		
		if(facilityChk.getLocker() == 1) {
			if(center.getLocker() != 1) {
				return false;
			}
		}
		if(facilityChk.getProjector() == 1) {
			if(center.getProjector() != 1) {
				return false;
			}
		}
		if(facilityChk.getPrinter() == 1) {
			if(center.getPrinter() != 1) {
				return false;
			}
		}
		if(facilityChk.getNoteBook() == 1) {
			if(center.getNoteBook() != 1) {
				return false;
			}
		}
		if(facilityChk.getWhiteBoard() == 1) {
			if(center.getWhiteBoard() != 1) {
				return false;
			}
		}
		
		return result;
	}

	@Override
	public CenterContentsVO selectCenterContents(String centerCode) {
		CenterContentsVO contents = null;
		contents = centerDAO.selectCenterContents(centerCode);
		return contents;
	}

	@Override
	public RoomInfoVO selectRoomByCode(String centerCode, String roomCode) {
		RoomInfoVO room = null;
		
		Map map = new HashMap();
		map.put("centerCode", centerCode);
		map.put("roomCode", roomCode);
		room = centerDAO.selectRoomByCode(map);
		
		return room;
	}

	@Override
	public List<CenterSearchVO> listTop5Center() {
		List<CenterSearchVO> centerList = new ArrayList<CenterSearchVO>();
		centerList = centerDAO.listTop5Center();
		return centerList;
	}

	@Override
	public CenterSearchVO selectCenterSearch(String centerCode) {
		CenterSearchVO center = null;
		center = centerDAO.selectCenterSearch(centerCode);
		return center;
	}

}
