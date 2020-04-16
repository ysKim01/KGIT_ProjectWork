package com.myspring.mall.center.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.myspring.mall.center.vo.CenterContentsVO;
import com.myspring.mall.center.vo.CenterSearchVO;
import com.myspring.mall.center.vo.RoomInfoVO;

@Repository("centerDAO")
public class CenterDAOImpl implements CenterDAO{
	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public int updateRating(Map map) {
		int result = 0;
		result = sqlSession.update("mapper.center.updateRating", map);
		return result;
	}

	@Override
	public List<String> listCenterCodeByFilter(Map searchMap) {
		List<String> codeList = new ArrayList<String>();
		codeList = sqlSession.selectList("mapper.center.listCenterCodeByFilter", searchMap);
		return codeList;
	}

	@Override
	public int selectMaxScaleByCenter(String centerCode) {
		int result = 0;
		result = sqlSession.selectOne("mapper.center.selectMaxScaleByCenter", centerCode);
		return result;
	}

	@Override
	public CenterSearchVO selectCenterSearchByCenterCode(String centerCode) {
		CenterSearchVO centerSearch = new CenterSearchVO();
		centerSearch = sqlSession.selectOne("mapper.center.selectCenterSearchByCenterCode", centerCode);
		return centerSearch;
	}

	@Override
	public CenterContentsVO selectCenterContents(String centerCode) {
		CenterContentsVO contents = null;
		
		List<CenterContentsVO> contentsList = new ArrayList<CenterContentsVO>();
		contentsList = sqlSession.selectList("mapper.center.selectCenterContents", centerCode);
		if(contentsList != null && contentsList.size() != 0) {
			contents = contentsList.get(0);
		}
		
		return contents;
	}

	@Override
	public RoomInfoVO selectRoomByCode(Map map) {
		RoomInfoVO room = null;
		
		List<RoomInfoVO> roomList = new ArrayList<RoomInfoVO>();
		roomList = sqlSession.selectList("mapper.center.selectRoomByCode", map);
		if(roomList != null && roomList.size() != 0) {
			room = roomList.get(0);
		}
		
		return room;
	}

	@Override
	public List<CenterSearchVO> listTop5Center() {
		List<CenterSearchVO> centerList = new ArrayList<CenterSearchVO>();
		centerList = sqlSession.selectList("mapper.center.listTop5Center");
		return centerList;
	}

	@Override
	public CenterSearchVO selectCenterSearch(String centerCode) {
		CenterSearchVO search = null;
		
		List<CenterSearchVO> searchList = new ArrayList<CenterSearchVO>();
		searchList = sqlSession.selectList("mapper.center.selectCenterSearch", centerCode);
		if(searchList != null && searchList.size() != 0) {
			search = searchList.get(0);
		}
		
		return search;
	}

}
