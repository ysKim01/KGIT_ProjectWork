package com.myspring.mall.admin.center.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.dao.DataAccessException;

import com.myspring.mall.admin.center.vo.AdminCenterFilterVO;
import com.myspring.mall.center.vo.CenterContentsVO;
import com.myspring.mall.center.vo.CenterFacilityVO;
import com.myspring.mall.center.vo.CenterInfoVO;
import com.myspring.mall.center.vo.RoomInfoVO;

public interface AdminCenterService {

	List<RoomInfoVO> listRoomsByCenter(String centerCode);
	CenterInfoVO selectCenterByCenterCode(String centerCode);
	public List listCenter() throws DataAccessException;
	public List listCenterByFiltered(AdminCenterFilterVO centerSearch);
	public int getMaxPageByBiltered(AdminCenterFilterVO centerSearch);
	public int addCenter(CenterInfoVO center) throws DataAccessException;
	public int addContents(CenterContentsVO contents) throws DataAccessException;
	public int addFacility(CenterFacilityVO facility) throws DataAccessException;
	public int addRoom(RoomInfoVO room) throws DataAccessException;
	public int delCentersList(List<CenterInfoVO> centersList);
	public int delCentersList(CenterInfoVO center);
	Integer countCenter();
	
	
}
