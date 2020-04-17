package com.myspring.mall.common.scheduler;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.myspring.mall.admin.reserve.service.AdminReserveService;
import com.myspring.mall.reserve.service.ReserveService;
import com.myspring.mall.reserve.vo.ReserveVO;

@Service("SchedulerService")
public class SchedulerService {
	@Autowired
	private AdminReserveService adminReserveService;
	@Autowired
	private ReserveService reserveService;
	
	private static long oneDay = 1000 * 60 * 60 * 24;

	
    public void TranseReserveList(){
        // 결재일이 지난 예약신청 삭제
    	removeRsvApplyExpired();
    	
    	// 대관 확정
    	updateToCheckout();
    	
    	// 예약기록 기간이 만료된 예약 삭제
    	removeRsvExpired("Checkout");
    	removeRsvExpired("Rating");
    }
    
    
    private void removeRsvExpired(String status) {
    	List<ReserveVO> list = new ArrayList<ReserveVO>();
    	list = adminReserveService.listReserveByStatus("Checkout");
    	if(list == null || list.size() == 0) {
    		return;
    	}
    	
    	long toDay = new java.util.Date().getTime();
    	toDay = (toDay / oneDay) * oneDay; // 일 단위 변경(시분초 삭제)
    	
    	for(ReserveVO rsv : list) {
    		long rsvDate = rsv.getReserveDate().getTime();
    		rsvDate = (rsvDate / oneDay) * oneDay;
    		
    		if(rsvDate+(10*oneDay) <= toDay) {
    			adminReserveService.deleteReserve(rsv.getKeyNum());
    		}
    	}
	}



	// 결재완료 된 예약 중 예약일이 지난 예약들을 대관확정으로 변경
    private void updateToCheckout() {
    	List<ReserveVO> list = new ArrayList<ReserveVO>();
    	list = adminReserveService.listReserveByStatus("Payment");
    	if(list == null || list.size() == 0) {
    		return;
    	}
    	
    	long toDay = new java.util.Date().getTime();
    	toDay = (toDay / oneDay) * oneDay; // 일 단위 변경(시분초 삭제)
    	
    	for(ReserveVO rsv : list) {
    		long rsvDate = rsv.getReserveDate().getTime();
    		rsvDate = (rsvDate / oneDay) * oneDay;
    		
    		if(rsvDate < toDay) {
    			//adminReserveService.
    			reserveService.updateReserveStatus(rsv.getKeyNum(), "Checkout");
    		}
    	}
	}

	private void removeRsvApplyExpired() {
    	List<ReserveVO> list = new ArrayList<ReserveVO>();
    	list = adminReserveService.listReserveByStatus("Apply");
    	if(list == null || list.size() == 0) {
    		return;
    	}
    	
    	long toDay = new java.util.Date().getTime();
    	toDay = (toDay / oneDay) * oneDay; // 일 단위 변경(시분초 삭제)
    	
    	for(ReserveVO rsv : list) {
    		long rsvDate = rsv.getReserveDate().getTime();
    		rsvDate = (rsvDate / oneDay) * oneDay;
    		
    		if(rsvDate <= toDay) {
    			adminReserveService.deleteReserve(rsv.getKeyNum());
    		}
    	}
    }
}
