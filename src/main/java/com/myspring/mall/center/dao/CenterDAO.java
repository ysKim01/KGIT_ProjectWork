package com.myspring.mall.center.dao;

import java.util.List;
import java.util.Map;

import com.myspring.mall.center.vo.CenterContentsVO;
import com.myspring.mall.center.vo.CenterSearchVO;
import com.myspring.mall.center.vo.RoomInfoVO;

public interface CenterDAO {

	int updateRating(Map map);

	List<String> listCenterCodeByFilter(Map searchMap);

	int selectMaxScaleByCenter(String code);

	CenterSearchVO selectCenterSearchByCenterCode(String string);

	CenterContentsVO selectCenterContents(String centerCode);

	RoomInfoVO selectRoomByCode(Map map);

	List<CenterSearchVO> listTop5Center();

	CenterSearchVO selectCenterSearch(String centerCode);

}
