package com.myspring.mall.reserve.service;

import java.util.List;

import com.myspring.mall.admin.reserve.vo.AdminReserveSearchVO;

public interface ReserveService {
	List<AdminReserveSearchVO> listReserveResultByStatus(String userId, String status);
}
