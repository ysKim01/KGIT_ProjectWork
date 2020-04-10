package com.myspring.mall.center.service;

import java.util.List;

import com.myspring.mall.center.vo.CenterSearchVO;
import com.myspring.mall.center.vo.MainSearchFilterVO;

public interface CenterService {

	boolean updateRating(String centerCode, double newRating, int ratingNum);

	List<CenterSearchVO> listCenterByFilter(MainSearchFilterVO searchInfo);

}
