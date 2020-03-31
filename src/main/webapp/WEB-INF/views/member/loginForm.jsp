<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%	request.setCharacterEncoding("utf-8"); %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"></c:set>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인창</title>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script>
	function login(){
		var userId = document.frmLogin.userId.value;
		var userPw = document.frmLogin.userPw.value;
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
                    location.href="${contextPath}/lastPage.do";
                }
            }
        })
	}
</script>
</head>
<body>
	<form name="frmLogin" method="post" action="${contextPath }/member/login.do">
		<table border="1" width="80%" align="center">
			<tr align="center">
				<th>아이디</th>
				<th>비밀번호</th>
			</tr>
			<tr align="center">
				<td>
					<input type="text" name="userId" id="userId" value="" size="20">
				</td>
				<td>
					<input type="password" name="userPw" id="userPw" value="" size="20">
				</td>
			</tr>
			<tr align="center">
				<td	colspan="2">
					<input type="button" value="로그인" onclick="login()">
					<input type="reset" value="다시입력">
				</td>
			</tr>
		</table>
	</form>
</body>
</html>





