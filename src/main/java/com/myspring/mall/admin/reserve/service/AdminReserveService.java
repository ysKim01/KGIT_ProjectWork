package com.myspring.mall.admin.reserve.service;

import java.sql.Date;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.myspring.mall.admin.reserve.vo.AdminReserveSearchVO;
import com.myspring.mall.admin.reserve.vo.ReserveFilterVO;
import com.myspring.mall.center.vo.CenterInfoVO;
import com.myspring.mall.reserve.vo.ReserveVO;

public interface AdminReserveService {
	String getUsableTime(String centerCode, String roomCode, Date reserveDate);
	List<AdminReserveSearchVO> listReserveByFiltered(ReserveFilterVO searchInfo);
	boolean insertReserve(ReserveVO reserve, Integer scale, CenterInfoVO center);
	boolean deleteReserve(Integer keyNum);
	ReserveVO selectReserve(Integer keyNum);
	boolean paymentReserve(Integer keyNum);
	AdminReserveSearchVO selectReserveSearch(Integer keyNum);
	int calReservePrice(ReserveVO reserve, Integer scale, CenterInfoVO center);
	boolean insertReserve(ReserveVO reserve);
	List<ReserveVO> listReserveByStatus(String string);
}
