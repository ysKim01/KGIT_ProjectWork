package com.myspring.mall.center.service;

import java.util.List;

import com.myspring.mall.center.vo.CenterContentsVO;
import com.myspring.mall.center.vo.CenterFacilityVO;
import com.myspring.mall.center.vo.CenterSearchVO;
import com.myspring.mall.center.vo.MainSearchFilterVO;
import com.myspring.mall.center.vo.RoomInfoVO;

public interface CenterService {

	boolean updateRating(String centerCode, double newRating, int ratingNum);

	List<CenterSearchVO> listCenterByFilter(MainSearchFilterVO searchInfo, CenterFacilityVO facilityChk);

	CenterContentsVO selectCenterContents(String centerCode);

	RoomInfoVO selectRoomByCode(String centerCode, String roomCode);

	List<CenterSearchVO> listTop5Center();

	CenterSearchVO selectCenterSearch(String centerCode);

}
