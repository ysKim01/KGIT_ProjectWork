<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />
<%
	request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 정보 출력창</title>
</head>
<body>
	<div id="container">
		<div class="width_wrap">
			<div class="search_wrap">
				<form method="post" action="#">
					<fieldset>
						<legend>회원정보 검색창</legend>
						<ul>
							<li>
								<label for="study_member"></label>
								<select id="study_member" name=""> <!-- select name값 설정 -->
									<option value="UserId">ID</option>
									<option value="UserName">이름</option>
									<option value="UserTel">휴대전화</option>
								</select>
							</li>
							<li>
								<input type="text" name="" id="memberSearch"> <!-- text name값 설정 -->
							</li>
							<li>
								<span><input type="text" name="startDate"></span>
								<span><input type="text" name="endDate"></span>
							</li>
							<li>
								<input type="checkbox" name="adminChk"><label ></label>
							</li>
							<li>
								<input type="submit" value="조회">
							</li>
						</ul>
					</fieldset>
				</form>
			</div>
			<!--  search_wrap end -->
			
			<div class="content_wrap">
				<div class="content">
					<table class="memberContent">
						<thead>	
							<tr>
								<th>선택</th>
								<th>ID</th>
								<th>이름</th>
								<th>휴대전화</th>
								<th>이메일</th>
								<th>가입일</th>
							</tr>
						</thead>
						<tr>
							<td><input type="checkbox" name="memChk01"></td>
							<td>sample</td>
							<td>name</td>
							<td>010-1234-1234</td>
							<td>test@test.com</td>
							<td>1994-01-01</td>
						</tr>
						<!-- 
						<c:choose>
							<c:when test="${membersList eq '' || empty membersList  }">
								<tr>
									<th colspan="6">현재 등록된 회원 정보가 없습니다.</th>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="memTable" items="${membersList }" varStatus="status">
									<tr>
										<td><input type="checkbox" class="memChk" name="memChk${status.index }"></td>
										<td>${memTable.id }</td>
										<td>${memTable.name }</td>
										<td>${memTable.telNum }</td>
										<td>${memTable.email }</td>
										<td>${memTable.joinDate }</td>
									</tr>
								</c:forEach> 
							</c:otherwise>
						</c:choose> 
						-->
						
					</table>
				</div>
			</div>
			
		</div>
	</div>
</body>
</html>









