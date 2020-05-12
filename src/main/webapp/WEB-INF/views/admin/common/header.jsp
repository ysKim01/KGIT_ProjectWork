<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	request.setCharacterEncoding("utf-8");
%>
<c:set var="contextPath" value="${pageContext.request.contextPath }"></c:set>
<c:if test="${logon == '' || empty logon }">
<script>
	
		console.log('로그인 체크2');
		document.body.style.display = "none";
		var isLogOn=document.getElementById("logon").value;
		
		if(isLogOn=="false" || isLogOn=='' ){
			setTimeout(function(){
				var target = document.getElementById('pageLayer');
				console.log(target);
				target.remove();
				document.body.style.overflow = 'auto';
			}, 3000);
			alert('로그인이 필요한 페이지입니다.');
			window.location.href="/mall/main.do";
		}
	
</script>

</c:if>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>헤더</title>
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/reset.css">
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/adminTop.css">
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/icomoon.css">
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="${contextPath }/resources/js/main.js"></script>
<script>
$(window).on('load',function(){
	//test
	var isAdmin = document.getElementById("isAdmin").value;
	if(isAdmin != 1){
		alert("관리자가 아니면 접근하실 수 없습니다.");
		location.href = "${contextPath}/main.do";
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
		<a href="${contextPath }/admin" style="display:block;">
			<img src="${contextPath }/resources/image/admLogo.png"></img>
			</a>
		</nav>
	</div>
	<nav id="top_menu">
		<ul>
			<li class="menu"><a href="${contextPath }/admin/listMembers.do">회원관리</a></li>
			<li class="menu"><a href="${contextPath }/admin/listReserve.do">예약관리</a></li>
			<li class="menu"><a href="${contextPath }/admin/listQuestion.do">1:1문의</a></li>
			<li class="menu"><a href="${contextPath }/admin/listOneDay.do">원데이클래스</a></li>
						<li class="menu"><a href="${contextPath }/admin/listCenter.do">업체관리</a></li>
			<li class="menu"><a href="${contextPath }/admin/listNotice.do">공지사항</a></li>
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
<input type="hidden" name="isAdmin" id="isAdmin" value="${isAdmin}"/>
</body>
</html>











