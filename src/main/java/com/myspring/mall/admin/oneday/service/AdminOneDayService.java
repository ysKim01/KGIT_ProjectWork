package com.myspring.mall.admin.oneday.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import com.myspring.mall.admin.oneday.vo.AdminOneDayFilterVO;
import com.myspring.mall.admin.oneday.vo.OneDayVO;

public interface AdminOneDayService {

	boolean setOneDayKeyNum(OneDayVO oneDay);

	boolean uploadOneDayPhoto(HttpServletRequest request, List<MultipartFile> fileList, OneDayVO oneDay);

	boolean addOneDay(OneDayVO oneDay);

	List<OneDayVO> listOneDayByFilter(AdminOneDayFilterVO searchInfo);

	boolean deleteOneDay(Integer keyNum);

	OneDayVO selectOneDay(Integer keyNum);

}
