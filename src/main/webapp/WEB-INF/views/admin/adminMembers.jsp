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
		var membersList = [];
		
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
			membersList.push(list);
		</c:forEach>
		console.log(membersList);
		var chkObj = new Object();
		var delMemberObj = [];
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
		if(!confirm("정말 삭제하시겠습니까?")) return;
		
		$.ajax({
			type:"post",
			async: false,
			url:"${contextPath}/admin/delMembersList.do",
			dataType:"text",
			data:{"list" : JSON.stringify(delMemberObj)},
			success:function(data, status){
				alert("삭제했습니다.");
			},
			error: function(data, status) {
				alert("error");
	        }
		}) 
		
		searchMember();
	}
	function searchMember(obj){
		var form = document.getElementById("frmMembersList");
        form.setAttribute("charset", "UTF-8");
        form.setAttribute("method", "Post");  //Post 방식
        form.setAttribute("action", "${contextPath}/admin/searchMembers.do"); //요청 보낼 주소

        // AdminMode
        var adminMode = document.createElement("input");
        adminMode.setAttribute("type", "hidden");
        adminMode.setAttribute("id", "adminMode");
        var adminChk = document.getElementById("adminChk");
        if(adminChk.checked == true){
        	 adminMode.setAttribute("value", 1);
		}else{
			adminMode.setAttribute("value", 0);
		}
        form.appendChild(adminMode);
        
        // searchInfo
        var searchInfo = new Object();
        searchInfo['searchFilter'] = document.getElementById("searchFilter").value;
        searchInfo['searchContent'] = document.getElementById("searchContent").value;
        searchInfo['joinStart'] = document.getElementById("joinStart").value;
        searchInfo['joinEnd'] = document.getElementById("joinEnd").value;
        searchInfo['adminMode'] = document.getElementById("adminMode").value;
        searchInfo['page'] = "1";
        
        var hiddenField = document.createElement("input");
        hiddenField.setAttribute("type", "hidden");
        hiddenField.setAttribute("name", "searchInfo");
        hiddenField.setAttribute("value", encodeURI(JSON.stringify(searchInfo)));
        form.appendChild(hiddenField);
        
        document.body.appendChild(form);
        form.submit();
	}
	function editMember(obj){
	}
	function delMember(obj){
		var mem = new Object();
		let count = 0;
		<c:forEach var="item" items="${membersList}" varStatus="status">
			if(count==obj){
				mem['userId'] = "${item.userId}";
				mem['userPw'] = "${item.userPw}";
				mem['userName'] = "${item.userName}";
				mem['userEmail'] = "${item.userEmail}";
				mem['userBirth'] = "${item.userBirth}";
				mem['userTel1'] = "${item.userTel1}";
				mem['userTel2'] = "${item.userTel2}";
				mem['userTel3'] = "${item.userTel3}";
				mem['userAdd1'] = "${item.userAdd1}";
				mem['userAdd2'] = "${item.userAdd2}";
				mem['userAdd3'] = "${item.userAdd3}";
				mem['joinDate'] = "${item.joinDate}";
				mem['adminMode'] = "${item.adminMode}";
			}	
			count++;
		</c:forEach>
		console.log(mem);
		
		$.ajax({
			type:"post",
			async: false,
			url:"${contextPath}/admin/delMember.do",
			dataType:"text",
			data:{"member" : JSON.stringify(mem)},
			success:function(data, status){
				alert("삭제했습니다.");
			},
			error: function(data, status) {
				alert("error");
	        }
		})  
		
		searchMember();
	}
	
	
</script>
</head>
<body>

<div id="container">
	<div class="width_wrap">
		<div class="search_wrap">
			<form method="post" action="#" id='frmMembersList'>
				<fieldset>
					<legend>회원정보 검색창</legend>
					<ul class="search_list clear_both">
						<li>
							<label for="study_member">조회정보</label>
							<span class="input_wrap"><select id="searchFilter" name="searchFilter"> <!-- select name값 설정 -->
								<option value="userId">ID</option>
								<option value="userName">이름</option>
								<option value="userTel">휴대전화</option>
                  		  	</select></span>
                            <span class="input_wrap"><input type="text" name="searchContent" id="searchContent" value="${searchInfo.searchContent}"></span> <!-- text name값 설정 -->
						</li>
						<li>
                            <label for="startDate">가입일자</label>
                            <span class="input_wrap"><input type="date" class="joinDate" name="joinStart" id="joinStart" value="${searchInfo.joinStart}"></span>
                            <i>~</i>
							<span class="input_wrap"><input type="date" class="searchDate" name="joinEnd" id="joinEnd" value="${searchInfo.joinEnd}"></span>
						</li>
						<li>
                            <span class="search_btn_wrap">
                            <input type="checkbox" name="adminChk" id="adminChk"><label for="adminChk">관리자</label>
                            
                            <strong class="btn_cover"><i class="icon icon-search"></i><input class="search_btn" type="button" value="조회" onclick="searchMember()"></strong>
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
							<th>수정</th>
							<th>삭제</th>
						</tr>
					</thead>
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
									<td><input type="button" class="btn_type_02" href="#" onclick="editMember(${status.index})" value="수정"></td>
									<td><input type="button" class="btn_type_02" href="#" onclick="delMember(${status.index})" value="삭제"></td>
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