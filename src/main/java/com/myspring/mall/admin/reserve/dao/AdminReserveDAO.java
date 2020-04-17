package com.myspring.mall.admin.reserve.dao;

import java.sql.Date;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.myspring.mall.admin.member.vo.MemberFilterVO;
import com.myspring.mall.admin.reserve.vo.AdminReserveSearchVO;
import com.myspring.mall.member.vo.MemberVO;
import com.myspring.mall.reserve.vo.ReserveVO;


public interface AdminReserveDAO {
	List<String> listUsingTimeForUsable(Map searchMap);
	List<AdminReserveSearchVO> listReserveByFilter_None(Map searchMap);
	int countReserveByFilter_None(Map searchMap);
	int insertReserve(ReserveVO reserve);
	List<AdminReserveSearchVO> listReserveByFilter_Id(Map searchMap);
	List<AdminReserveSearchVO> listReserveByFilter_Tel(Map searchMap);
	List<AdminReserveSearchVO> listReserveByFilter_CenterCode(Map searchMap);
	List<AdminReserveSearchVO> listReserveByFilter_CenterName(Map searchMap);
	int countReserveByFilter_Id(Map searchMap);
	int countReserveByFilter_Tel(Map searchMap);
	int countReserveByFilter_CenterCode(Map searchMap);
	int countReserveByFilter_CenterName(Map searchMap);
	int deleteReserve(Integer keyNum);
	ReserveVO selectReserve(Integer keyNum);
	int updateReserve_ApplyToPayment(Integer keyNum);
	AdminReserveSearchVO selectReserveSearch(Integer keyNum);
	List<ReserveVO> listReserveByStatus(String status);
}
