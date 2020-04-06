package com.myspring.mall.common.mail;

import javax.annotation.Resource;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.myspring.mall.admin.reserve.vo.AdminReserveSearchVO;
import com.myspring.mall.center.vo.CenterInfoVO;
import com.myspring.mall.common.ControllData;
import com.myspring.mall.reserve.vo.ReserveVO;

@Controller("mailController")
public class MailController {
	@Autowired
	private JavaMailSender mailSender;
	
	private static ControllData conData = new ControllData();

	// Mail for payment
	public String mailForPayment(HttpServletRequest request, 
			String tomail, AdminReserveSearchVO reserve, CenterInfoVO center) throws MessagingException {
		System.out.println("메일 보내기 시작");
		String usingTime = conData.usingTimeToString(center, reserve.getUsingTime());
		
		String setfrom = "Studying@std.com";
		String title = reserve.getUserName() + "님의 스터디룸 결재가 완료되었습니다."; // 제목
		String content = "[결재정보]";
		content += "1. 센터 : " + reserve.getUserId() + "\n";
		content += "2. 방 : " + reserve.getRoomName() + "\n";
		content += "3. 날짜 : " + reserve.getReserveDate() + "\n";
		content += "4. 시간 : " + usingTime + "\n";
		content += "5. 금액 : " + reserve.getReservePrice() + "원" + "\n";
		try {
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
			messageHelper.setFrom(setfrom); // 보내는사람 생략하면 정상작동을 안함
			messageHelper.setTo(tomail); // 받는사람 이메일
			messageHelper.setSubject(title); // 메일제목은 생략이 가능하다
			messageHelper.setText(content); // 메일 내용

			mailSender.send(message);
			System.out.println("메일 보내기 완료");
		} catch (MailException e) {
			e.printStackTrace();
			System.out.println("메일 보내기 실패");
		}

		return "main/main.tiles";
	}
}
