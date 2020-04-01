package com.myspring.mall.admin.center.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.myspring.mall.center.vo.CenterContentsVO;
import com.myspring.mall.center.vo.CenterFacilityVO;
import com.myspring.mall.center.vo.CenterInfoVO;
import com.myspring.mall.center.vo.RoomInfoVO;
import com.myspring.mall.member.vo.MemberVO;


@Repository("CenterInfoDAO")
public class AdminCenterDAOImpl implements AdminCenterDAO {
	@Autowired
	private SqlSession sqlSession;
	// 호출할때마다 자동으로 생성

	@Override
	public List<RoomInfoVO> listRoomsByCenter(String centerCode) {
		List<RoomInfoVO> roomList = null;
		roomList = sqlSession.selectList("mapper.center.listRoomByCenter", centerCode);
		return roomList;
	}


}