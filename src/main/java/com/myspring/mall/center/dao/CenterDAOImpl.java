package com.myspring.mall.center.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.myspring.mall.center.vo.CenterSearchVO;

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

}
