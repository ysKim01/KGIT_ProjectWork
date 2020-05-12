package com.myspring.mall.admin.oneday.service;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.myspring.mall.admin.oneday.dao.AdminOneDayDAO;
import com.myspring.mall.admin.oneday.vo.AdminOneDayFilterVO;
import com.myspring.mall.admin.oneday.vo.OneDayVO;
import com.myspring.mall.common.ControllData;

@Service("adminOneDayService")
@Transactional(propagation=Propagation.REQUIRED)
public class AdminOneDayServiceImpl implements AdminOneDayService{
	@Autowired
	private AdminOneDayDAO adminOneDayDAO;
	
	
	static private ControllData conData = new ControllData();
	

	@Override
	public boolean setOneDayKeyNum(OneDayVO oneDay) {
		boolean result = false;
		
		Integer maxNum = adminOneDayDAO.getMaxKeyNum();
		if(maxNum != null) {
			oneDay.setKeyNum(maxNum+1);
			result = true;
		}
		
		return result;
	}


	@Override
	public boolean uploadOneDayPhoto(HttpServletRequest request, List<MultipartFile> fileList, OneDayVO oneDay) {
		String path = request.getSession().getServletContext().getRealPath("/resources/oneday/" + oneDay.getKeyNum() +"/");
		File folder = new File(path);
		System.out.println(path);
		// 이미 생성된 폴더 삭제
		if (folder.exists()){
			conData.deleteFileFn(path);
		}
		// 폴더 생성
		if(!folder.mkdirs()) {
			System.out.println("[warning] oneDay 파일 경로를 생성하는데 실패했습니다.");
			return false;
		}
		
		List<String> photoList = new ArrayList<String>();
		for(int i=0; i<5; i++){ // null 초기화
			photoList.add(null);
		}
		
		int idx = 0;
		for (MultipartFile mf : fileList) {
			String originFileName = mf.getOriginalFilename(); // 원본 파일 명
			long fileSize = mf.getSize(); // 파일 사이즈
			System.out.println("originFileName : " + originFileName);
			System.out.println("fileSize : " + fileSize);
			
			String exc = originFileName.substring(originFileName.lastIndexOf(".")+1, originFileName.length());
			String newFileName = Integer.toString(idx);
			String safeFile = newFileName + "." + exc;
			try {
				mf.transferTo(new File( path +"\\"+ safeFile));
			} catch (Exception e) {
				e.printStackTrace();
				return false;
			}
			String photoPath = "/resources/oneday/" + oneDay.getKeyNum() +"/" + safeFile;
			photoList.set(idx, photoPath);
			idx++;
		}
		oneDay.setClassPhoto1(photoList.get(0));
		oneDay.setClassPhoto2(photoList.get(1));
		oneDay.setClassPhoto3(photoList.get(2));
		oneDay.setClassPhoto4(photoList.get(3));
		oneDay.setClassPhoto5(photoList.get(4));
		return true;
	}


	@Override
	public boolean addOneDay(OneDayVO oneDay) {
		boolean result = false;
		
		int num = adminOneDayDAO.insertOneDay(oneDay);
		if(num >= 1) {
			result = true;
		}
		
		return result;
	}


	@Override
	public List<OneDayVO> listOneDayByFilter(AdminOneDayFilterVO searchInfo) {
		List<OneDayVO> oneDayList = new ArrayList<OneDayVO>();
		int maxNum = 0;
		
		String searchContent = searchInfo.getSearchContent();
		Integer page = searchInfo.getPage();
		Integer classStatus = searchInfo.getClassStatus();
		if(classStatus != 1 && classStatus != 0) {
			classStatus = null;
		}

		Map searchMap = new HashMap();
		searchMap.put("page", page);
		searchMap.put("classStatus", classStatus);
		
		if(!conData.isEmpty(searchContent)) {
			searchMap.put("classTitle", searchContent);
			oneDayList = adminOneDayDAO.listOneDayByFilter_Title(searchMap);
			maxNum = adminOneDayDAO.countOneDayByFilter_Title(searchMap);
			searchInfo.setMaxNum(maxNum);
		}else {
			oneDayList = adminOneDayDAO.listOneDayByFilter_None(searchMap);
			maxNum = adminOneDayDAO.countOneDayByFilter_None(searchMap);
			searchInfo.setMaxNum(maxNum);
		}
		
		return oneDayList;
	}


	@Override
	public boolean deleteOneDay(Integer keyNum) {
		boolean result = false;
		
		int num = adminOneDayDAO.deleteOneDay(keyNum);
		if(num >= 1) {
			result = true;
		}
		
		return result;
	}


	@Override
	public OneDayVO selectOneDay(Integer keyNum) {
		OneDayVO oneDay = null;
		oneDay = adminOneDayDAO.selectOneDay(keyNum);
		return oneDay;
	}


	@Override
	public Integer countOneDay() {
		Integer cnt = 0;
		cnt = adminOneDayDAO.countOneDay();
		return cnt;
	}


}
