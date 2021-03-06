package com.myspring.mall.reserve.dao;

import java.util.List;
import java.util.Map;

import com.myspring.mall.admin.reserve.vo.AdminReserveSearchVO;
import com.myspring.mall.reserve.vo.ReserveVO;

public interface ReserveDAO {
	List<AdminReserveSearchVO> listReserveResultByCheckout(Map searchMap);
	List<ReserveVO> listReserveById(String userId);
	int updateReserveStatus(Map map);
}
