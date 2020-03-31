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
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/reset.css">
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/adminTop.css">
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="${contextPath }/resources/js/main.js"></script>
<script>
$(window).on('load',function(){
	var isAdmin = document.getElementById("isAdmin").value;
	
	if(isAdmin != 1){
		alert("관리자가 아니므로 접근하실수 없습니다.");
		location.href="${contextPath}/main.do";
	}
	
});
</script>
</head>
<body><header>
	<div id="login">
		<a href="#" id="loginMember"></a>
	</div>
	<div id="top">
		<nav id="top_logo">
			<img src="${contextPath }/resources/image/Admin_logo.png"></img>
		</nav>
	</div>
	<nav id="top_menu">
		<ul>
			<li class="menu"><a href="${contextPath }/admin/listMembers.do">회원관리</a></li>
			<li class="menu"><a href="${contextPath }/admin/adminReservation.do">예약관리</a></li>
			<li class="menu"><a href="${contextPath }/admin/adminQna.do">1:1문의</a></li>
			<li class="menu"><a href="${contextPath }/admin/adminOnedayclass.do">원데이클래스</a></li>
			<li class="menu"><a href="${contextPath }/admin/adminCompany.do">업체관리</a></li>
			<li class="menu"><a href="${contextPath }/admin/adminNotice.do">공지사항</a></li>
		</ul>
	</nav>
	
</header>

<!-- 
기존 로그인 소스
			<c:choose>
				<c:when test="${isLogon == true && member != null }">
					<h3>환영합니다. ${member.name }님!</h3>
					<a href="#"><h3>로그아웃</h3></a>
				</c:when>
				<c:otherwise>
					<a href="#"><h3>로그인</h3></a>
				</c:otherwise>
			</c:choose>
 -->

<!-- Session 값 받아오기 -->
<input type="hidden" name="logon" id="logon" value="${logon}"/>
<input type="hidden" name="isAdmin" id="isAdmin" value="${logonMember.adminMode}"/>
</body>
</html>











