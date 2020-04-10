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
	public int insertCenter(CenterInfoVO center) throws DataAccessException {
		int result = 0;
		result = sqlSession.insert("mapper.center.insertCenter",center);
		return 0;
	}

	@Override
	public int insertContents(CenterContentsVO contents) throws DataAccessException {
		int result =0;
		result = sqlSession.insert("mapper.center.insertContents",contents);
		return 0;
	}

	@Override
	public int insertFacility(CenterFacilityVO facility) throws DataAccessException {
		int result =0;
		result = sqlSession.insert("mapper.center.insertFacility",facility);
		return 0;
	}

	@Override
	public int insertRoom(RoomInfoVO room) throws DataAccessException {
		int result =0;
		result = sqlSession.insert("mapper.center.insertRoom",room);
		return 0;
	}

	@Override
	public List<RoomInfoVO> listRoomsByCenter(String centerCode) {
		List<RoomInfoVO> roomList = null;
		roomList = sqlSession.selectList("mapper.center.listRoomByCenter", centerCode);
		return roomList;
	}
	@Override
	public CenterInfoVO selectCenterByCenterCode(String centerCode) {
		CenterInfoVO centerInfo = null;
		centerInfo = sqlSession.selectOne("mapper.center.selectCenterByCenterCode", centerCode);
		return centerInfo;
	}
	
	@Override
	public List selectAllCenter() throws DataAccessException {
		List<CenterInfoVO> centerList = null;
		centerList = sqlSession.selectList("mapper.center.selectAllCenterList");
		return centerList;
	}

	@Override
	public List selectCenterByFilter_Code(Map searchMap) {
		List<CenterInfoVO> centerList = null;
		centerList = sqlSession.selectList("mapper.center.selectCenterByFilter_Code", searchMap);
		return null;
	}

	@Override
	public List selectCenterByFilter_Name(Map searchMap) {
		List<CenterInfoVO> centerList = null;
		centerList = sqlSession.selectList("mapper.center.selectCenterByFilter_Name", searchMap);
		return null;
	}

	@Override
	public List selectCenterByFilter_None(Map searchMap) {
		List<CenterInfoVO> centerList = null;
		centerList = sqlSession.selectList("mapper.center.selectCenterByFilter_None", searchMap);
		return null;
	}

	@Override
	public List selectCenterByFilter_Tel(Map searchMap) {
		List<CenterInfoVO> centerList = null;
		centerList = sqlSession.selectList("mapper.center.selectCenterByFilter_Tel", searchMap);
		return null;
	}

	@Override
	public int countCenterByFilter_Code(Map searchMap) {
		int result = 0;
		result = (Integer)sqlSession.selectOne("mapper.center.countCenterByFilter_Code", searchMap);
		return result;
	}

	@Override
	public int countCenterByFilter_Name(Map searchMap) {
		int result = 0;
		result = (Integer)sqlSession.selectOne("mapper.center.countMemberByFilter_Name", searchMap);
		return result;
	}

	@Override
	public int countCenterByFilter_Tel(Map searchMap) {
		int result = 0;
		result = (Integer)sqlSession.selectOne("mapper.center.countMemberByFilter_Tel", searchMap);
		return result;
	}

	@Override
	public int countCenterByFilter_None(Map searchMap) {
		int result = 0;
		result = (Integer)sqlSession.selectOne("mapper.center.countCenterByFilter_None", searchMap);
		return result;
	}


}