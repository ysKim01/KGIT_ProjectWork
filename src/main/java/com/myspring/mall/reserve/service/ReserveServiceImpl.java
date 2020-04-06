package com.myspring.mall.reserve.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.myspring.mall.admin.reserve.vo.AdminReserveSearchVO;
import com.myspring.mall.common.ControllData;
import com.myspring.mall.reserve.dao.ReserveDAO;

@Service("reserveService")
@Transactional(propagation=Propagation.REQUIRED)
public class ReserveServiceImpl implements ReserveService {
	@Autowired
	private ReserveDAO reserveDAO;
	
	private static ControllData conData = new ControllData();

	@Override
	public List<AdminReserveSearchVO> listReserveResultByStatus(String userId, String status) {
		List<AdminReserveSearchVO> reserveList = null;
		
		Map searchMap = new HashMap();
		searchMap.put("userId", userId);
		searchMap.put("status", status);
		
		reserveList = reserveDAO.listReserveResultByCheckout(searchMap);
		
		return reserveList;
	}
}
