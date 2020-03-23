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
<title>하단</title>
<style>
	p {
		font-size:20px;
		text-align:center;
	}
</style>
</head>
<body>
	<p>email : admin@test.com</p>
	<p>회사주소 : 서울시 종로구 단성사</p>
	<p>찾아오는길 : <a href="#">약도</a></p>
</body>
</html>
















