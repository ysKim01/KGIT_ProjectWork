<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false" %>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin 회원관리</title>

<link rel="stylesheet" type="text/css" href="${contextPath }resources/css/adminMemList.css">
</head>
<body>

<div id="container">
	<div class="width_wrap">
		<div class="search_wrap">
			<form method="post" action="${contextPath }/admin/listMembers.do">
				<fieldset>
					<legend>회원정보 검색창</legend>
					<ul class="search_list clear_both">
						<li>
							<label for="study_member">조회정보</label>
							<span class="input_wrap"><select id="study_member" name="searchFilter"> <!-- select name값 설정 -->
								<option value="userId">ID</option>
								<option value="userName">이름</option>
								<option value="userTel">휴대전화</option>
                               </select></span>
                               <span class="input_wrap"><input type="text" name="searchContent" id="searchContent"></span> <!-- text name값 설정 -->
						</li>
						<li>
                               <label for="startDate">가입일자</label>
                               <span class="input_wrap"><input type="date" class="searchDate" name="joinStart"></span>
                               <i>~</i>
							<span class="input_wrap"><input type="date" searchDate" name="joinEnd"></span>
						</li>
						<li>
                               <span class="search_btn_wrap">
                               <input type="checkbox" name="adminChk" id="adminChk"><label for="adminChk">관리자</label>
                               
                               <strong class="btn_cover"><i class="icon icon-search"></i><input class="search_btn" type="submit" value="조회"></strong>
                               </span>
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
						<td><input type="checkbox" name="memChk01" class="memChk"></td>
						<td>sample</td>
						<td>name</td>
						<td>010-1234-1234</td>
						<td>test@test.com</td>
						<td>1994-01-01</td>
					</tr>
					<%-- 
					<c:choose>
						<c:when test="${membersList eq '' || empty membersList  }">
							<tr>
								<th colspan="6">현재 등록된 회원 정보가 없습니다.</th>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="memTable" items="${membersList }" varStatus="status">
								<tr>
									<td><input value="${status.index} type="checkbox" class="memChk" name="memChk${status.index }"></td>
									<td>${memTable.userId }</td>
									<td>${memTable.name }</td>
									<td>${memTable.telNum }</td>
									<td>${memTable.email }</td>
									<td>${memTable.joinDate }</td>
								</tr>
							</c:forEach> 
						</c:otherwise>
					</c:choose> 
					 --%>
				</table>
				<p class="editBtn_wrap">
					<a href="javscript:window.open('${contextPath }/admin/adminAddMember.do','회원등록','width=600,height=700,top=200,left=100,location=false,status=false,resizeable=false,toolbar=false,menubar=false')" class="memAdd"><strong>등록</strong></a>
					<a href="#" class="memDel"><strong>탈퇴</strong></a>
				</p>
			</div>
			<!-- content end-->
		</div>
		
	</div>
</div>
</body>
</html>