<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false" %>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin업체관리</title>

<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/adminCompanyList.css">
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script>
	window.onload = function(){
		

	}
	
</script>
</head>
<body>



	<div id="container">
		<div class="width_wrap">
			<div class="search_wrap">
				<form method="post" action="#">
					<fieldset>
						<legend>업체관리 검색창</legend>
						<ul class="search_list clear_both">
							<li>
								<label for="companyInfo">조회정보</label>
								<span class="input_wrap"><select id="companyInfo" name="companyInfo">
									<option value="companyAll">전체</option>
									<option value="companyCode">업체코드</option>
									<option value="companyName">업체명</option>
									<option value="companyAdd">지역</option>
								</select></span>
								<span class="input_wrap"><input type="text" name="companySearch" id="companySearch"></span> <!-- text name값 설정 -->
								
							</li>	
							
							<li>
                                <span class="search_btn_wrap">
                                
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
					<table class="companyContent">
						<thead>	
							<tr>
								<th>선택</th>
								<th>업체코드</th>
								<th>업체명</th>
								<th>지역</th>
								<th>전화번호</th>
								<th>등록일자</th>
							</tr>
						</thead>
						<tr>
							<td><input type="checkbox" name="comChk01" class="comChk"></td>
							<td>AA11</td>
							<td>르하임스터디룸</td>
							<td>서울시 종로구 어쩌구저쩌구</td>
							<td>02-0000-0000</td>
							<td>2020-03-20</td>
						</tr>
						<tr>
							<td><input type="checkbox" name="comChk02" class="comChk"></td>
							<td>CE14</td>
							<td>테스트스터디룸</td>
							<td>서울시 강남구 어쩌구저쩌구</td>
							<td>02-0000-0000</td>
							<td>2020-03-20</td>
						</tr>
						<tr>
							<td><input type="checkbox" name="comChk03" class="comChk"></td>
							<td>FH33</td>
							<td>INN스터디룸</td>
							<td>서울시 서초구 어쩌구저쩌구</td>
							<td>02-0000-0000</td>
							<td>2020-03-20</td>
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
										<td><input value="${status.index} type="checkbox" class="memChk" name="memChk${status.index }"></td>
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
					<p class="editBtn_wrap">
						<a href="#" class="comAdd"><strong>업체등록</strong></a>
						<a href="#" class="comDel"><strong>업체삭제</strong></a> 
					</p>
				</div>
				<!-- content end-->
			</div>
			
		</div>
	</div>
</body>
</html>