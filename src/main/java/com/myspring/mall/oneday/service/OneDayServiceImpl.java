package com.myspring.mall.oneday.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service("oneDayService")
@Transactional(propagation=Propagation.REQUIRED)
public class OneDayServiceImpl implements OneDayService{

}
