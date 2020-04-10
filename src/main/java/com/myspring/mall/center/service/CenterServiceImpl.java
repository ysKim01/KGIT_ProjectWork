package com.myspring.mall.center.service;

import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.myspring.mall.center.dao.CenterDAO;
import com.myspring.mall.center.vo.CenterSearchVO;
import com.myspring.mall.center.vo.MainSearchFilterVO;

@Service("centerService2")
public class CenterServiceImpl implements CenterService{
	@Autowired
	CenterDAO centerDAO;

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
	public List<CenterSearchVO> listCenterByFilter(MainSearchFilterVO searchInfo) {
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
			centerList.add(centerSearch);
		}
		
		return centerList;
	}

}
