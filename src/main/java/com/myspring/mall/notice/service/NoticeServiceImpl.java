package com.myspring.mall.notice.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service("noticeService")
@Transactional(propagation=Propagation.REQUIRED)
public class NoticeServiceImpl implements NoticeService{

}
