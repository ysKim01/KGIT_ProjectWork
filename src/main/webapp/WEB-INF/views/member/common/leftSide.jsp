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
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/mSide.css">
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/memLeftSide.css">
<style>
	.no-underline{
		text-decoration: none;
	}
</style>
<script>
$(window).on('load',function(){
	var userId = '${logonId}';
	var userName = document.getElementById("userName");
	$.ajax({
        type:"post",
        async:false,
        url:"${contextPath}/member/getMember.do",
        dataType:"json",
        data:{"userId" : userId},
        success:function(data, textStatus){
			userName.innerHTML = data.userName;
        }
    })
});
</script>
<meta charset="UTF-8">
<title>사이드 메뉴</title>
</head>
<body>
	<div class="side_nav">
         <div class="side_top">
             <h4>
                 <a href="${contextPath}/mypage.do"><i class="icon-cool"></i></a>
                 <span id="userName"></span>
                 <%-- ${userInfo.name } --%>
             </h4>
         </div>
         <nav>
             <ul class="snb">
                 <li><a href="${contextPath }/member/modMemberForm.do"><i class="icon-profile"></i>회원정보<span class="icon_gt"></span></a></li>
                 <li><a href="${contextPath }/reserve/listReserveBefore.do"><i class="icon-clock"></i>예약관리<span class="icon_gt"></span></a></li>
                 <li><a href="${contextPath }/question/listQuestion.do"><i class="icon-bubbles4"></i>1:1상담<span class="icon_gt"></span></a></li>
                 <li><a href="${contextPath }/favorite/listFavorite.do"><i class="icon-bookmark"></i>즐겨찾기<span class="icon_gt"></span></a></li>
                 <li><a href="${contextPath }/member/delMemberForm.do"><i class="icon-cancel-circle"></i>회원탈퇴<span class="icon_gt"></span></a></li>
             </ul>
         </nav>
     </div>
     <!-- sideNav end-->
</body>
</html>










