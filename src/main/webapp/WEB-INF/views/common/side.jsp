<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("utf-8");
	//RequestDispatcher dispatcher = request.getRequestDispatcher("footer.jsp");
	//dispatcher.include(request, response);
%>
<c:set var="contextPath" value="${pageContext.request.contextPath }"></c:set>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사이드 메뉴</title>
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/quickMenu.css">
<script type="text/javascript">

$(window).on(function(){
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

$(function(){
	var duration = 300;

	var $side = $('#quick_menu');
	var $sidebt = $side.find('button').on('click', function(){
		$side.toggleClass('open');

		if($side.hasClass('open')) {
			$side.stop(true).animate({right:'0px'}, duration);
			$sidebt.find('span').text('CLOSE');
		}else{
			$side.stop(true).animate({right:'-100px'}, duration);
			$sidebt.find('span').text('OPEN');
		};
	});
});
</script>
</head>
<body>
	<div id="quick_menu" class="open">
		<div class="content">
			<div class="btn_wrap">
				<ul>
					<c:if test="${logon == '' || empty logon}">
	                    <li><a href="#" class="loginMember"><p class="login icon-user"></p><span>로그인</span></a></li>
						<li><a href="${contextPath}/member/addMemberForm.do"><p class="member icon-user-plus"></p> <span>회원가입</span></a></li>
                    </c:if>
                    <c:if test="${logon == true }">
                    	<li><a href="${contextPath}/member/logout.do"><p class="login icon-user"></p><span>로그아웃</span></a></li>
	                    <li><a href="${contextPath}/mypage.do"><p class="member icon-user-plus"></p><span>마이페이지</span></a></li>
                    </c:if>
					<li><a href="${contextPath}/notice/listNotice.do"><p class="notice icon-blocked"></p> <span>공지사항</span></a></li>
					<li><a href="${contextPath}/question/showFAQ.do"><p class="question icon-info"></p> <span>자주하는 질문</span></a></li>
					<li><a href="${contextPath}/question/listQuestion.do"><p class="QA icon-question"></p><span>질문과 답변</span></a></li>
					<li><a href="#"><p class="top icon-eject"></p><span>TOP</span></a></li>
				</ul>
			</div>
		</div>
		<button type="button" class="toggle icon-menu" /></button>
	</div>
</body>
</html>










