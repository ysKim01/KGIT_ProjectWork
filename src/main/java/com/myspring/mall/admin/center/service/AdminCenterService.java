package com.myspring.mall.admin.center.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.dao.DataAccessException;

import com.myspring.mall.admin.center.vo.CenterSearchVO;
import com.myspring.mall.center.vo.CenterContentsVO;
import com.myspring.mall.center.vo.CenterFacilityVO;
import com.myspring.mall.center.vo.CenterInfoVO;
import com.myspring.mall.center.vo.RoomInfoVO;

public interface AdminCenterService {

	List<RoomInfoVO> listRoomsByCenter(String centerCode);
	CenterInfoVO selectCenterByCenterCode(String centerCode);

}
