package com.myspring.mall.admin.reserve.service;

import java.sql.Date;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.myspring.mall.admin.reserve.dao.AdminReserveDAO;
import com.myspring.mall.common.ControllData;


@Service("adminReserveService")
@Transactional(propagation=Propagation.REQUIRED)
public class AdminReserveServiceImpl implements AdminReserveService{
	@Autowired
	private AdminReserveDAO adminReserveDAO;
	
	private static ControllData conData = new ControllData();
	
	
}
