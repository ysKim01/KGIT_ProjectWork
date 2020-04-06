package com.myspring.mall.admin.reserve.dao;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.myspring.mall.admin.reserve.vo.AdminReserveSearchVO;
import com.myspring.mall.member.vo.MemberVO;
import com.myspring.mall.reserve.vo.ReserveVO;


@Repository("adminReserveDAO")
public class AdminReserveDAOImpl implements AdminReserveDAO{
	@Autowired
	private SqlSession sqlSession;

	@Override
	public List<String> listUsingTimeForUsable(Map searchMap) {
		List<String> usingTimeList = null;
		usingTimeList = sqlSession.selectList("mapper.reserve.listUsingTimeForUsable", searchMap);
		return usingTimeList;
	}

	@Override
	public List<AdminReserveSearchVO> listReserveByFilter_None(Map searchMap) {
		List<AdminReserveSearchVO> reserveList = null;
		reserveList = sqlSession.selectList("mapper.reserve.listReserveByFilter_None", searchMap);
		return reserveList;
	}

	@Override
	public int countReserveByFilter_None(Map searchMap) {
		int result = 0;
		result = (Integer)sqlSession.selectOne("mapper.reserve.countReserveByFilter_None", searchMap);
		return result;
	}

	@Override
	public int insertReserve(ReserveVO reserve) {
		int result = 0;
		result = (Integer)sqlSession.insert("mapper.reserve.insertReserve", reserve);
		return result;
	}

	@Override
	public List<AdminReserveSearchVO> listReserveByFilter_Id(Map searchMap) {
		List<AdminReserveSearchVO> reserveList = null;
		reserveList = sqlSession.selectList("mapper.reserve.listReserveByFilter_Id", searchMap);
		return reserveList;
	}
	@Override
	public List<AdminReserveSearchVO> listReserveByFilter_Tel(Map searchMap) {
		List<AdminReserveSearchVO> reserveList = null;
		reserveList = sqlSession.selectList("mapper.reserve.listReserveByFilter_Tel", searchMap);
		return reserveList;
	}
	@Override
	public List<AdminReserveSearchVO> listReserveByFilter_CenterCode(Map searchMap) {
		List<AdminReserveSearchVO> reserveList = null;
		reserveList = sqlSession.selectList("mapper.reserve.listReserveByFilter_CenterCode", searchMap);
		return reserveList;
	}
	@Override
	public List<AdminReserveSearchVO> listReserveByFilter_CenterName(Map searchMap) {
		List<AdminReserveSearchVO> reserveList = null;
		reserveList = sqlSession.selectList("mapper.reserve.listReserveByFilter_CenterName", searchMap);
		return reserveList;
	}

	
	@Override
	public int countReserveByFilter_Id(Map searchMap) {
		int result = 0;
		result = (Integer)sqlSession.selectOne("mapper.reserve.countReserveByFilter_Id", searchMap);
		return result;
	}
	@Override
	public int countReserveByFilter_Tel(Map searchMap) {
		int result = 0;
		result = (Integer)sqlSession.selectOne("mapper.reserve.countReserveByFilter_Tel", searchMap);
		return result;
	}
	@Override
	public int countReserveByFilter_CenterCode(Map searchMap) {
		int result = 0;
		result = (Integer)sqlSession.selectOne("mapper.reserve.countReserveByFilter_CenterCode", searchMap);
		return result;
	}
	@Override
	public int countReserveByFilter_CenterName(Map searchMap) {
		int result = 0;
		result = (Integer)sqlSession.selectOne("mapper.reserve.countReserveByFilter_CenterName", searchMap);
		return result;
	}

	@Override
	public int deleteReserve(Integer keyNum) {
		int result = 0;
		result = sqlSession.delete("mapper.reserve.deleteReserve", keyNum);
		return result;
	}

	@Override
	public ReserveVO selectReserve(Integer keyNum) {
		ReserveVO reserve = null;
		reserve = (ReserveVO)sqlSession.selectOne("mapper.reserve.selectReserve", keyNum);
		return reserve;
	}

	@Override
	public int updateReserve_ApplyToPayment(Integer keyNum) {
		int result = 0;
		result = sqlSession.update("mapper.reserve.updateReserve_ApplyToPayment", keyNum);
		return result;
	}

	@Override
	public AdminReserveSearchVO selectReserveSearch(Integer keyNum) {
		AdminReserveSearchVO rsvSearch = null;
		rsvSearch = (AdminReserveSearchVO)sqlSession.selectOne("mapper.reserve.selectReserveSearch", keyNum);
		return rsvSearch;
	}
}

























