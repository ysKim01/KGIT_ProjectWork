package com.myspring.mall.reserve.service;

import java.util.List;

import com.myspring.mall.admin.reserve.vo.AdminReserveSearchVO;
import com.myspring.mall.reserve.vo.ReserveVO;

public interface ReserveService {
	List<AdminReserveSearchVO> listReserveResultByStatus(String userId, String status);
	List<ReserveVO> listReserveById(String userId);
	boolean updateReserveStatus(Integer keyNum, String string);
}
