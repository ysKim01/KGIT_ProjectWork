<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />
<%
	request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 가입창</title>
<style>
	.text_center{
		text-align:center;
	}
</style>
</head>
<body>
	<form method="post" action="${contextPath }/member/addMember.do">
	<h1 class="text_center">회원 가입창</h1>
	<table align="center">
		<tr>
			<td width="200"><p align="right">아이디</p></td>
			<td width="400"><input type="text" name="userId"></td>
		</tr>
		<tr>
			<td width="200"><p align="right">비밀번호</p></td>
			<td width="400"><input type="password" name="userPw"></td>
		</tr>
		<tr>
			<td width="200"><p align="right">이름</p></td>
			<td width="400"><input type="text" name="userName"></td>
		</tr>
		<tr>
			<td width="200"><p align="right">주소</p></td>
			<td width="400">
				<input type="text" name="userAdd1"> - 
				<input type="text" name="userAdd2"> - 
				<input type="text" name="userAdd3">
			</td>
		</tr>
		<tr>
			<td width="200"><p align="right">휴대전화</p></td>
			<td width="400">
				<input type="text" name="userTel1"> - 
				<input type="text" name="userTel1"> - 
				<input type="text" name="userTel1">
			</td>
		</tr>
		<tr>
			<td width="200"><p align="right">이메일</p></td>
			<td width="400"><input type="text" name="userEmail"></td>
		</tr>
		<tr>
			<td width="200"><p align="right">생년월일</p></td>
			<td width="400">
				<input type="text" name="userBirth1"> - 
				<input type="text" name="userBirth2"> - 
				<input type="text" name="userBirth3">
			</td>
		</tr>
		<tr>
			<td width="200"><p>&nbsp;</p></td>
			<td width="400">
				<input type="submit" value="가입하기">
				<input type="reset" value="다시입력">
			</td>
		</tr>
	</table>
	</form>
</body>
</html>









