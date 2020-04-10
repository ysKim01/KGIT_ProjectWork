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
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/mHeader.css">
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/icomoon.css">

<style>
	.oneDayClass_wrap strong:before{
        content:''; display:block;
        width:35px; height:22px;
        position:absolute; top:3px; left:50%; margin-left:-17px;
        background:url('${contextPath}/resources/image/oncicon.png') no-repeat center center;
    }
</style>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="${contextPath }/resources/js/main.js"></script>
<script>
$(window).on('load',function(){
	//test
	var _isLogOn=document.getElementById("logon");
	var isLogOn=_isLogOn.value;
	console.log(isLogOn);
	var loginTag = document.getElementById("loginMember");
 	if(isLogOn=="false" || isLogOn=='' ){
 		//loginTag.innerHTML = "로그인";
 		
 		//loginTag.href="${contextPath}/member/loginForm.do";
 	}else{
 		/* loginTag.innerHTML = "로그아웃";
 		loginTag.href="${contextPath}/member/logout.do"; */
 	}
 	
 	$('.loginMember').on('click',function(){
		activeLogon();
 	})
});
function login(){
    var userId = document.frmlogin.userId.value;
	var userPw = document.frmlogin.userPw.value;
	
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
<body>
<header>
    <div id="header">
        <div class="width_wrap">
            <h1 class="logo_wrap">
            	<a href="${contextPath }" style="display:block;">
                <img src="http://placehold.it/200x80">
                </a>
            </h1>
            <div class="nav_wrap">
                <nav class="">
                    <ul class="gnb">
                    	<c:if test="${logon == '' || empty logon}">
	                    	<li><a href="#" class="loginMember">로그인</a></li>
	                        <li><a href="${contextPath}/member/addMemberForm.do">회원가입</a></li>
                    	</c:if>
                    	<c:if test="${logon == true }">
                    		<li><a href="${contextPath}/member/logout.do">로그아웃</a></li>
	                        <li><a href="${contextPath }/mypage.do">마이페이지</a></li>
                    	</c:if>
                        <li class="oneDayClass_wrap"><a href="#"><strong>OneDayClass</strong></a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</header>
    <!-- header end -->
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
</body>
</html>











