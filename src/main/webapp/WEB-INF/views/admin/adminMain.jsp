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
<title>메인페이지</title>
<script src="http://code.jquery.com/jquery-latest.js"></script>
</head>
<body>
	<h1>관리자 메인 페이지입니다.!!</h1>
	<a href="${contextPath}/admin/membershipForm.do">회원가입 하기</a><br>
	
	<!-- 임시 예약 등록창 이동 폼 -->
	<form action="${contextPath}/admin/addReserveForm.do" method="post">
		CenterCode : <input type="text" id="centerCod" name="centerCode"> 
		<input type='submit' value='입력'>
	</form>
</body>
</html>