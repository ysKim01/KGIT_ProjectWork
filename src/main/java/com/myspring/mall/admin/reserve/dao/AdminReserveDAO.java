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
}
