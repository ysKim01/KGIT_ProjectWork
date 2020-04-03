package com.myspring.mall.admin.center.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.myspring.mall.center.vo.CenterContentsVO;
import com.myspring.mall.center.vo.CenterFacilityVO;
import com.myspring.mall.center.vo.CenterInfoVO;
import com.myspring.mall.center.vo.RoomInfoVO;

public interface AdminCenterDAO {

	List<RoomInfoVO> listRoomsByCenter(String centerCode);
	CenterInfoVO selectCenterByCenterCode(String centerCode);
	public List selectAllCenter() throws DataAccessException;
	public List selectCenterByFilter_Code(Map searchMap);
	public List selectCenterByFilter_Name(Map searchMap);
	public List selectCenterByFilter_Tel(Map searchMap);
	public List selectCenterByFilter_None(Map searchMap);
	public int countCenterByFilter_Code(Map searchMap);
	public int countCenterByFilter_Name(Map searchMap);
	public int countCenterByFilter_Tel(Map searchMap);
	public int countCenterByFilter_None(Map searchMap);
	
}
