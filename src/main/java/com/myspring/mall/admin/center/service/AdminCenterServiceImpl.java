package com.myspring.mall.admin.center.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import com.myspring.mall.admin.center.dao.AdminCenterDAO;
import com.myspring.mall.admin.center.vo.AdminCenterFilterVO;
import com.myspring.mall.center.vo.CenterContentsVO;
import com.myspring.mall.center.vo.CenterFacilityVO;
import com.myspring.mall.center.vo.CenterInfoVO;
import com.myspring.mall.center.vo.RoomInfoVO;
import com.myspring.mall.common.ControllData;

@Service("centerService")
public class AdminCenterServiceImpl implements AdminCenterService {
	@Autowired
	private AdminCenterDAO centerDAO;
	
	private static ControllData conData = new ControllData();
	
	@Override
	public int addCenter(CenterInfoVO center) throws DataAccessException {
		return centerDAO.insertCenter(center);
	}

	@Override
	public int addContents(CenterContentsVO contents) throws DataAccessException {
		return centerDAO.insertContents(contents);
	}

	@Override
	public int addFacility(CenterFacilityVO facility) throws DataAccessException {
		return centerDAO.insertFacility(facility);
	}

	@Override
	public int addRoom(RoomInfoVO room) throws DataAccessException {
		return centerDAO.insertRoom(room);
	}

	
	@Override
	public List<RoomInfoVO> listRoomsByCenter(String centerCode) {
		List<RoomInfoVO> roomList = centerDAO.listRoomsByCenter(centerCode);  
		return roomList;
	}


	@Override
	public CenterInfoVO selectCenterByCenterCode(String centerCode) {
		CenterInfoVO centerInfo = null;
		centerInfo = centerDAO.selectCenterByCenterCode(centerCode);
		return centerInfo;
	}
	
	@Override
	public List listCenter() throws DataAccessException {
		List centerList = null;
		centerList = centerDAO.selectAllCenter();
		return centerList;
	}

	@Override
	public List listCenterByFiltered(AdminCenterFilterVO centerSearch) {
		List centersList = null;
		
		String searchFilter = centerSearch.getSearchFilter();
		String searchContents = centerSearch.getSearchContents();
		Integer page = centerSearch.getPage();
		
		// 예외처리
				if(searchFilter==null) {
					searchFilter = "";
				}
				if(page==null || page<=0) {
					page = 1;
				}
				
				Map searchMap = new HashMap();
				searchMap.put("page", page);
				
				if(!conData.isEmpty(searchContents)) { // 검색내용 있을 경우
					if(searchFilter.equals("centerCode")) {
						searchMap.put("centerCode", searchContents);
						centersList = centerDAO.selectCenterByFilter_Code(searchMap);
					}
					else if(searchFilter.equals("centerName")) {
						searchMap.put("centerName", searchContents);
						centersList = centerDAO.selectCenterByFilter_Name(searchMap);
					}
					else if(searchFilter.equals("centerTel")) {
						searchMap.put("centerTel", searchContents);
						centersList = centerDAO.selectCenterByFilter_Tel(searchMap);
					}
					else {
						System.out.println("[Warning] admin / service / listCenterByFiltered > "
								+ "검색 필터값이 정확하지 않습니다.");
						centersList = centerDAO.selectCenterByFilter_None(searchMap);
					}
				}
				else { // 검색내용 없을 경우
					centersList = centerDAO.selectCenterByFilter_None(searchMap);
				}
				
				return centersList;
			}

	@Override
	public int getMaxPageByBiltered(AdminCenterFilterVO centerSearch) {
		int result = 0;
		
		String searchFilter = centerSearch.getSearchFilter();		// not null
		String searchContents = centerSearch.getSearchContents();
		Integer page = centerSearch.getPage();					// not null, 양수
		// 예외처리
		if(searchFilter==null) {
			searchFilter = "";
		}
		if(page==null || page<=0) {
			page = 1;
		}
		
		Map searchMap = new HashMap();
		searchMap.put("page", page);
		
		if(!conData.isEmpty(searchContents)) { // 검색내용 있을 경우
			if(searchFilter.equals("centerCode")) {
				searchMap.put("centerCode", searchContents);
				result = centerDAO.countCenterByFilter_Code(searchMap);
			}
			else if(searchFilter.equals("centerName")) {
				searchMap.put("centerName", searchContents);
				result = centerDAO.countCenterByFilter_Name(searchMap);
			}
			else if(searchFilter.equals("centerTel")) {
				searchMap.put("centerTel", searchContents);
				result = centerDAO.countCenterByFilter_Tel(searchMap);
			}
			else {
				System.out.println("[Warning] admin / service / listMembersByFiltered > "
						+ "검색 필터값이 정확하지 않습니다.");
				result = centerDAO.countCenterByFilter_None(searchMap);
			}
		}
		else { // 검색내용 없을 경우
			result = centerDAO.countCenterByFilter_None(searchMap);
		}
		
		return result;
	}

	@Override
	public int delCentersList(List<CenterInfoVO> centersList) {
		int result = 0;
		for(int i=0; i<centersList.size();i++) {
			String centerCode = centersList.get(i).getCenterCode();
			result += centerDAO.delCenterByCode(centerCode);
		}
		return result;
	}

	@Override
	public int delCentersList(CenterInfoVO center) {
		int result = 0;
		
		String centerCode = center.getCenterCode();
		result = centerDAO.delCenterByCode(centerCode);
		
		return result;
	}
	
	
}


