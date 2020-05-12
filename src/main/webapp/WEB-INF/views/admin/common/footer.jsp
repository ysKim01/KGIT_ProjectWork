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
<script>
function setFooterSearch(){
    //searchDate
    // searchAdd city gu
    // roomScale
    var getDate = $('.searchDate').val()
    var getAddCity = $('.searchAdd #city').val();
    var getAddGu = $('.searchAdd #gu').val();
    var roomScale = $('.scale').val();
    if(getDate == '' || getDate == null){
    	getDate = new Date();
        var getYear = getDate.getFullYear();
        var getMonth = getDate.getMonth()+1;
        var getDate = getDate.getDate()+1;
        if(getMonth < 10) getMonth = '0'+getMonth;
        if(getDate < 10) getDate = '0'+getDate;
        getDate = getYear + '-'+ getMonth + '-' + getDate;
    }
    if(getAddCity == '' || getAddCity == null){
        getAddCity = '서울';
    }
    if(getAddGu == '' || getAddGu == null){
        getAddGu = '종로구';
    }
    var reg = /^[0-9]*$/;
    
    if(roomScale == '' || roomScale == null || !reg.test(roomScale)){
        roomScale = '4';
    }

    let setForm = document.createElement('form');
    setForm.setAttribute('action','${contextPath}/listSearch.do');
    setForm.setAttribute('method','get');
    setForm.setAttribute('encType','UTF-8');

    const searchInfo = {
        'searchDate' : getDate,
        'searchAdd1' :  getAddCity, 
        'searchAdd2' : getAddGu,
        'scale' :  roomScale,
        'sort' : '0',
        'page' : '1'
    }
    
    var setDate = document.createElement('input');
    setDate.setAttribute('type','hidden');
    setDate.setAttribute('name','searchInfo');
    setDate.setAttribute('value',encodeURI(JSON.stringify(searchInfo)));
    setForm.appendChild(setDate);
    
    
    const facilityObj = {
    		'locker' : '0',
    		'projector' : '0',
    		'printer' : '0',
    		'noteBook' : '0',
    		'whiteBoard' : '0'
    };
    var facility = document.createElement('input');
    facility.setAttribute('type','hidden');
    facility.setAttribute('name','facility');
    facility.setAttribute('value',encodeURI(JSON.stringify(facilityObj)));
    setForm.appendChild(facility);
    
    
    document.body.appendChild(setForm);
    setForm.submit();
}
</script>
</head>
<body>
<div class="footer_wrap">
	<div class="footer_lnb">
		<div class="width_wrap">
			<ul class="clear_both">
				<li><a href="${contextPath }/showTermsOfUse.do">이용약관</a></li>
				<li><a href="${contextPath}/showPrivacyStatement.do ">개인정보취급방침</a></li>
			</ul>
		</div>
	</div>
	<div class="width_wrap">
		<div class="footer_infos">
			<div class="footer_boxs clear_both">
				<div class="box footer_logo_wrap">
					<h2 class="footer_logo">
						<img src="${contextPath }/resources/image/mFooter_logo.png">
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
						<li><a href="${contextPath }/admin/listMembers.do">회원관리</a></li>
						<li><a href="${contextPath }/admin/listReserve.do">예약관리</a></li>
						<li><a href="${contextPath }/admin/listQuestion.do">1:1문의</a></li>
						<li><a href="${contextPath }/admin/listOneDay.do">원데이클래스</a></li>
						<li><a href="${contextPath }/admin/listCenter.do">업체관리</a></li>
						<li><a href="${contextPath }/admin/listNotice.do">공지사항</a></li>
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








