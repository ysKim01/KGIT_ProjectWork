package com.myspring.mall.reserve.dao;

import java.util.List;
import java.util.Map;

import com.myspring.mall.admin.reserve.vo.AdminReserveSearchVO;

public interface ReserveDAO {
	List<AdminReserveSearchVO> listReserveResultByCheckout(Map searchMap);
}
