package com.myspring.mall.reserve.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.myspring.mall.admin.reserve.vo.AdminReserveSearchVO;
import com.myspring.mall.reserve.vo.ReserveVO;

@Repository("reserveDAO")
public class ReserveDAOImpl implements ReserveDAO{
	@Autowired
	private SqlSession sqlSession;

	@Override
	public List<AdminReserveSearchVO> listReserveResultByCheckout(Map searchMap) {
		List<AdminReserveSearchVO> reserveList = null;
		reserveList = sqlSession.selectList("mapper.reserve.listReserveResultByCheckout", searchMap);
		return reserveList;
	}

	@Override
	public List<ReserveVO> listReserveById(String userId) {
		List<ReserveVO> reserveList = null;
		reserveList = sqlSession.selectList("mapper.reserve.listReserveById", userId);
		return reserveList;
	}

	@Override
	public int updateReserveStatus(Map map) {
		int result = 0;
		result = sqlSession.update("mapper.reserve.updateReserveStatus", map);
		return result;
	}
}
