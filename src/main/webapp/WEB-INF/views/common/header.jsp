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
<<<<<<< HEAD
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="${contextPath }/resources/js/main.js"></script>
<script>
$(window).on('load',function(){
	//test
	var _isLogOn=document.getElementById("logon");
	var isLogOn=_isLogOn.value;
	var loginTag = document.getElementById("loginMember");

 	if(isLogOn=="false" || isLogOn=='' ){
 		loginTag.innerHTML = "로그인";
 		loginTag.href="${contextPath}/member/loginForm.do"; 
 	}else{
 		loginTag.innerHTML = "로그아웃";
 		loginTag.href="${contextPath}/member/logout.do";
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
=======
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/icomoon.css">
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="${contextPath }/resources/js/main.js"></script>
<script>
$(window).on('load',function(){
	//test
	var _isLogOn=document.getElementById("logon");
	var isLogOn=_isLogOn.value;
	var loginTag = document.getElementById("loginMember");
 	if(isLogOn=="false" || isLogOn=='' ){
 		loginTag.innerHTML = "로그인";
 		
 		//loginTag.href="${contextPath}/member/loginForm.do";
 	}else{
 		loginTag.innerHTML = "로그아웃";
 		loginTag.href="${contextPath}/member/logout.do";
 	}
 	
 	$('#loginMember').on('click',function(){
 		if($(this).text() == '로그인'){
 			activeLogon();
 		}
 	})
});
function login(){
    var userId = document.frmlogin.userId.value;
	var userPw = document.frmlogin.userPw.value;
	console.log(userId);
	console.log(userPw);
	if(userId == ''){
        alert("아이디를 입력하세요.");
        return;
    }
	if(userPw == ''){
        alert("비밀번호를 입력하세요.");
        return;
    }
	$.ajax({
        type:"post",
        async:false,
        url:"${contextPath}/member/login.do",
        dataType:"text",
        data:{"userId" : userId, "userPw" : userPw},
        success:function(data, textStatus){
            if(data=='false'){
                alert("가입하지 않은 아이디이거나, 잘못된 비밀번호입니다.");
                document.frmLogin.userPw.focus();
            }else{
                alert(userId + "님 환영합니다.");
                $('.screenWrap').remove();
                window.location.reload();
            }
        }
    })
 }
</script>
</head>
<body><header>
	<div id="login">
		<a href="#" id="loginMember"></a>
	</div>
	<div id="top">
		<nav id="top_logo">
		<a href="${contextPath }" style="display:block;">
			<img src="${contextPath }/resources/image/Admin_logo.png"></img>
			</a>
		</nav>
	</div>
	<nav id="top_menu">
		<ul>
			<li class="menu"><a href="${contextPath }/admin/listMembers.do">회원관리</a></li>
			<li class="menu"><a href="${contextPath }/admin/adminReservation.do">예약관리</a></li>
			<li class="menu"><a href="${contextPath }/admin/adminQna.do">1:1문의</a></li>
			<li class="menu"><a href="${contextPath }/admin/adminOnedayclass.do">원데이클래스</a></li>
			<li class="menu"><a href="${contextPath }/admin/listCenter.do">업체관리</a></li>
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
<input type="hidden" name="userId" id="userId" value="${logonId}"/>
<input type="hidden" name="isAdmin" id="isAdmin" value="${isAdmin}"/>
>>>>>>> branch 'master' of https://github.com/ysKim01/KGIT_ProjectWork
</body>
</html>











