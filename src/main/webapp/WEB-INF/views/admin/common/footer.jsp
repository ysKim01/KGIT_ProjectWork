<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	request.setCharacterEncoding("utf-8");
%>

<c:set var="contextPath" value="${pageContext.request.contextPath }"></c:set>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>헤더</title>
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/mFooter.css">
</head>
<body>
<div class="footer_wrap">
	<div class="footer_lnb">
		<div class="width_wrap">
			<ul class="clear_both">
				<li><a href="${contextPath }/member/protection.do">이용약관</a></li>
				<li><a href="${contextPath}/member/privacy.do ">개인정보취급방침</a></li>
			</ul>
		</div>
	</div>
	<div class="width_wrap">
		<div class="footer_infos">
			<div class="footer_boxs clear_both">
				<div class="box footer_logo_wrap">
					<h2 class="footer_logo">
						<h2><img src="http://placehold.it/180x120"></h2>
					</h2>
				</div>
				<div class="box customerCenter">
					<strong class="cust_title">
						Customer Center
					</strong>
					<h4>
						<a href="tel:1644-4461">1644-4461</a>
					</h4>
					<div class="cust_txt">
						<p>AM 10:00 ~ PM:06:00</p>
						<p>SAT, SUN, HOLIDAY OFF</p>
					</div>
				</div>
				<div class="box footer_quick">
					<ul class="clear_both">
						<li><a href="javascript:setSearch()">대관예약</a></li>
						<li><a href="#">원데이 클래스</a></li>
						<li><a href="#">비회원 예약조회</a></li>
						<li><a href="${contextPath }/notice/listNotice.do">공지사항</a></li>
						<li><a href="${contextPath }/question/showFAQ.do">자주묻는 질문</a></li>
						<li><a href="${contextPath }/question/listQuestion.do">질문과 답변</a></li>
					</ul>
				</div>
				
			</div>
			
			<div class="footer_info">
				<ul class="clear_both">
					<li><strong>COMPANY : </strong>대관 예약 통합 관리 시스템</li>
					<li><strong>OWNER : </strong>조별과제</li>
					<li><strong>ADDRESS : </strong>서울특별시 종로구 돈화문로 24, 4층</li>
					<li><strong>TEL : </strong>1644-4461</li>
					<li><strong>E-MAIL : </strong>test@naver.com</li>
				</ul>
				<ul class="clear_both">
					<li><strong>사업자 등록번호 : </strong>110-11-11110</li>
					<li><strong>통신판매업신고번호 : </strong>2020-서울종로-0073</li>
					<li><strong>개인정보보호책임자 : </strong>김영상</li>
				</ul>
				<ul>
					<li>Copyright @ 대관예약통합관리시스템, All Right Reserved
				</ul>
				
			</div>
		</div>
	</div>
</div>



</body>








