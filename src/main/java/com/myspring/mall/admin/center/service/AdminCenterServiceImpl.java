package com.myspring.mall.admin.center.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import com.myspring.mall.admin.center.controller.AdminCenterControllerImpl;
import com.myspring.mall.admin.center.dao.AdminCenterDAO;
import com.myspring.mall.admin.center.vo.CenterSearchVO;
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
	public List listCenterByFiltered(CenterSearchVO centerSearch) {
		List centerList = null;
		
		String searchFilter = centerSearch.getSearchFilter();
		String searchContent = centerSearch.getSearchContents();
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
				
				if(!conData.isEmpty(searchContent)) { // 검색내용 있을 경우
					if(searchFilter.equals("centerCode")) {
						searchMap.put("centerCode", searchContent);
						centerList = centerDAO.selectCenterByFilter_Code(searchMap);
					}
					else if(searchFilter.equals("centerName")) {
						searchMap.put("centerName", searchContent);
						centerList = centerDAO.selectCenterByFilter_Name(searchMap);
					}
					else if(searchFilter.equals("centerTel")) {
						String centerTel = conData.CenterTelDiv(searchContent);
						if(centerTel!=null) {
							searchMap.put("centerTel", centerTel);
							centerList = centerDAO.selectCenterByFilter_Tel(searchMap);
						}else {
							System.out.println("[Warning] admin / service / listCenterByFiltered > "
									+ "전화번호 입력을 다시한번 확인해주세요.");
							centerList = null;
						}
					}
					else {
						System.out.println("[Warning] admin / service / listCenterByFiltered > "
								+ "검색 필터값이 정확하지 않습니다.");
						centerList = centerDAO.selectCenterByFilter_None(searchMap);
					}
				}
				else { // 검색내용 없을 경우
					centerList = centerDAO.selectCenterByFilter_None(searchMap);
				}
				
				return centerList;
			}

	@Override
	public int getMaxPageByBiltered(CenterSearchVO centerSearch) {
		int result = 0;
		
		String searchFilter = centerSearch.getSearchFilter();		// not null
		String searchContent = centerSearch.getSearchContents();
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
		
		if(!conData.isEmpty(searchContent)) { // 검색내용 있을 경우
			if(searchFilter.equals("centerCode")) {
				searchMap.put("centerCode", searchContent);
				result = centerDAO.countCenterByFilter_Code(searchMap);
			}
			else if(searchFilter.equals("centerName")) {
				searchMap.put("centerName", searchContent);
				result = centerDAO.countCenterByFilter_Name(searchMap);
			}
			else if(searchFilter.equals("centerTel")) {
				Map userTel = conData.TelDivThree(searchContent);
				if(userTel!=null) {
					searchMap.put("centerTel", userTel);
					result = centerDAO.countCenterByFilter_Tel(searchMap);
				}else {
					System.out.println("[Warning] admin / service / listMembersByFiltered > "
							+ "전화번호가 10자리가 아닙니다.");
				}
			}
			else {
				System.out.println("[Warning] admin / service / listMembersByFiltered > "
						+ "계정 검색 필터값이 정확하지 않습니다.");
				result = centerDAO.countCenterByFilter_None(searchMap);
			}
		}
		else { // 검색내용 없을 경우
			result = centerDAO.countCenterByFilter_None(searchMap);
		}
		
		return result;
	}
	
	
}


