package com.myspring.mall.admin.oneday.dao;

import java.util.List;
import java.util.Map;

import com.myspring.mall.admin.oneday.vo.OneDayVO;

public interface AdminOneDayDAO {

	Integer getMaxKeyNum();

	int insertOneDay(OneDayVO oneDay);

	List<OneDayVO> listOneDayByFilter_Title(Map searchMap);

	int countOneDayByFilter_Title(Map searchMap);

	List<OneDayVO> listOneDayByFilter_None(Map searchMap);

	int countOneDayByFilter_None(Map searchMap);

	int deleteOneDay(Integer keyNum);

	OneDayVO selectOneDay(Integer keyNum);

	Integer countOneDay();

}
