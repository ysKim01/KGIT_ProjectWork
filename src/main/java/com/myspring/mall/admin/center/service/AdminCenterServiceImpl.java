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
	
	
}


