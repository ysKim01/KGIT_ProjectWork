package com.myspring.mall.admin.oneday.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.myspring.mall.admin.oneday.vo.OneDayVO;

@Repository("adminOneDayDAO")
public class AdminOneDayDAOImpl implements AdminOneDayDAO{
	@Autowired
	private SqlSession sqlSession;
	
	
	@Override
	public Integer getMaxKeyNum() {
		Integer maxNum = null;
		maxNum = sqlSession.selectOne("mapper.oneday.getMaxKeyNum");
		if(maxNum == null) {
			maxNum = 0;
		}
		return maxNum;
	}


	@Override
	public int insertOneDay(OneDayVO oneDay) {
		int result = 0;
		result = sqlSession.insert("mapper.oneday.insertOneDay", oneDay);
		return result;
	}


	@Override
	public List<OneDayVO> listOneDayByFilter_Title(Map searchMap) {
		List<OneDayVO> oneDayList = null;
		oneDayList = sqlSession.selectList("mapper.oneday.listOneDayByFilter_Title", searchMap);
		return oneDayList;
	}

	@Override
	public List<OneDayVO> listOneDayByFilter_None(Map searchMap) {
		List<OneDayVO> oneDayList = null;
		oneDayList = sqlSession.selectList("mapper.oneday.listOneDayByFilter_None", searchMap);
		return oneDayList;
	}

	@Override
	public int countOneDayByFilter_Title(Map searchMap) {
		int result = 0;
		result = sqlSession.selectOne("mapper.oneday.countOneDayByFilter_Title", searchMap);
		return result;
	}

	@Override
	public int countOneDayByFilter_None(Map searchMap) {
		int result = 0;
		result = sqlSession.selectOne("mapper.oneday.countOneDayByFilter_None", searchMap);
		return result;
	}


	@Override
	public int deleteOneDay(Integer keyNum) {
		int result = 0;
		result = sqlSession.delete("mapper.oneday.deleteOneDay", keyNum);
		return result;
	}


	@Override
	public OneDayVO selectOneDay(Integer keyNum) {
		OneDayVO oneDay = null;
		List<OneDayVO> oneDayList = new ArrayList<OneDayVO>();
		oneDayList = sqlSession.selectList("mapper.oneday.selectOneDay", keyNum);
		if(oneDayList != null && oneDayList.size() != 0) {
			oneDay = oneDayList.get(0);
		}
		return oneDay;
	}

}
