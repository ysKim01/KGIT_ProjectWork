package com.myspring.mall.center.dao;

import java.util.List;
import java.util.Map;

import com.myspring.mall.center.vo.CenterSearchVO;

public interface CenterDAO {

	int updateRating(Map map);

	List<String> listCenterCodeByFilter(Map searchMap);

	int selectMaxScaleByCenter(String code);

	CenterSearchVO selectCenterSearchByCenterCode(String string);

}
