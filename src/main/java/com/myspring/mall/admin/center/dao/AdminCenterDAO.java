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
	
}
