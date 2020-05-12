package com.myspring.mall.oneday.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.myspring.mall.admin.oneday.vo.OneDayVO;
import com.myspring.mall.oneday.dao.OneDayDAO;

@Service("oneDayService")
@Transactional(propagation=Propagation.REQUIRED)
public class OneDayServiceImpl implements OneDayService{
	@Autowired
	private OneDayDAO oneDayDAO;
	
	@Override
	public List<OneDayVO> listNew5OneDay() {
		List<OneDayVO> list = new ArrayList<OneDayVO>();
		
		list = oneDayDAO.listNew5OneDay();
		
		return list;
	}

}
