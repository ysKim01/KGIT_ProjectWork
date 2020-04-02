package com.myspring.mall.admin.reserve.service;

import java.sql.Date;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

public interface AdminReserveService {

	String getUsableTime(String centerCode, String roomCode, Date reserveDate);

}
