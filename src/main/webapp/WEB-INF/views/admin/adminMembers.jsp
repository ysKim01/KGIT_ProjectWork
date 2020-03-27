<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false" %>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin 회원관리</title>

<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/adminMemList.css">

<script>
	var isEmpty = function(value){
		if(value == "" || value == null || value == undefined || (value != null && typeof value == "object" && !Object.keys(value).length)){
			return true;
		}else{
			return false;
		}
	}
 	

	function chkDelMember(){
		var membersList = new Object();
		
		<c:forEach var="item" items="${membersList}" varStatus="status">
			var list = new Object();
			list['userId'] = "${item.userId}";
			list['userPw'] = "${item.userPw}";
			list['userName'] = "${item.userName}";
			list['userEmail'] = "${item.userEmail}";
			list['userBirth'] = "${item.userBirth}";
			list['userTel1'] = "${item.userTel1}";
			list['userTel2'] = "${item.userTel2}";
			list['userTel3'] = "${item.userTel3}";
			list['userAdd1'] = "${item.userAdd1}";
			list['userAdd2'] = "${item.userAdd2}";
			list['userAdd3'] = "${item.userAdd3}";
			list['joinDate'] = "${item.joinDate}";
			list['adminMode'] = "${item.adminMode}";
			membersList[${status.index}] = list;
		</c:forEach>
		console.log(membersList);
		var chkObj = new Object();
		var delMemberObj = new Object();
		var targets = document.getElementsByClassName('memChk');
		$.each(targets, function(index, items){
			
			if(items.checked == true){
				chkObj[index] = 'chk';
			}else{
				chkObj[index] = 'false';
			}
		});
		
		let count = 0;		
		for(var i in chkObj){
			if(chkObj[i] === "chk"){
				console.log();
				delMemberObj[count++] = membersList[i];
			}
		}
		
		if(isEmpty(delMemberObj)) {
			alert("체크된 항목이 없습니다. 다시 선택해 주세요.");
			return;
		}
		console.log(delMemberObj);
		
	}
	
	
</script>
</head>
<body>

<div id="container">
	<div class="width_wrap">
		<div class="search_wrap">
			<form method="get" action="#">
				<fieldset>
					<legend>회원정보 검색창</legend>
					<ul class="search_list clear_both">
						<li>
							<label for="study_member">조회정보</label>
							<span class="input_wrap"><select id="study_member" name="studyMember"> <!-- select name값 설정 -->
								<option value="UserId">ID</option>
								<option value="UserName">이름</option>
								<option value="UserTel">휴대전화</option>
                  		  	</select></span>
                            <span class="input_wrap"><input type="text" name="memberSearch" id="memberSearch"></span> <!-- text name값 설정 -->
						</li>
						<li>
                            <label for="startDate">가입일자</label>
                            <span class="input_wrap"><input type="text" class="searchDate" name="startDate"></span>
                            <i>~</i>
							<span class="input_wrap"><input type="text" class="searchDate" name="endDate"></span>
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
					
					
					<c:choose>
						<c:when test="${membersList eq '' || empty membersList  }">
							<tr>
								<th colspan="6">현재 등록된 회원 정보가 없습니다.</th>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="memTable" items="${membersList }" varStatus="status">
								<tr>
									<td><input value="${status.index}" type="checkbox" class="memChk" name="memChk${status.index }"></td>
									<td>${memTable.userId }</td>
									<td>${memTable.userName }</td>
									<td>${memTable.userTel1 }-${memTable.userTel2 }-${memTable.userTel3 }</td>
									<td>${memTable.userEmail }</td>
									<td>${memTable.joinDate }</td>
								</tr>
							</c:forEach> 
						</c:otherwise>
					</c:choose> 
					  
				</table>
				<p class="editBtn_wrap">
					<a href="${contextPath }/admin/membershipForm.do" class="memAdd"><strong>등록</strong></a>
					<a href="#" onclick="chkDelMember()" class="memDel"><strong>탈퇴</strong></a>
				</p>
			</div>
			<!-- content end-->
		</div>
		
	</div>
</div>
</body>
</html>