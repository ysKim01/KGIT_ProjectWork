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
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/dcalendar.picker.css">
<script src="${contextPath }/resources/js/dcalendar.picker.js"></script>
<script>
	var isEmpty = function(value){
		if(value == "" || value == null || value == undefined || (value != null && typeof value == "object" && !Object.keys(value).length)){
			return true;
		}else{
			return false;
		}
	}
	var searchFilter = '${searchInfo.searchFilter}';
	var adminChk = '${searchInfo.adminMode}';
	$(document).on('ready',function(){
		$('#joinStart').dcalendarpicker({
			format:'yyyy-mm-dd'
		})
		$('#joinEnd').dcalendarpicker({
			format:'yyyy-mm-dd'
		})
		
		if(searchFilter != ''){
			
			$('#searchFilter option[value='+searchFilter+']').attr('selected',true);
		}
		if(adminChk == 1){
			$('#adminChk').attr('checked',true);
		}else{
			$('#adminChk').attr('checked',false);
		}
		
	})
 	
	/* ===========================================================================
	 * 1. 회원 검색
	 * ---------------------------------------------------------------------------
	 * > 입력 : searchInfo
	 * > 출력 : Member List
	 * > 이동 페이지 : /admin/searchMembers.do
	 * > 설명 : 
		 	- 검색필터 전달 후 회원 검색창으로
	 ===========================================================================*/
	function searchMember(paginate){
		var form = document.createElement("form");
        form.setAttribute("charset", "UTF-8");
        form.setAttribute("method", "Get");  //Get 방식
        form.setAttribute("action", "${contextPath}/admin/searchMembers.do"); //요청 보낼 주소
		if(paginate == null || paginate == '' || paginate == 'undefined'){
			paginate = '1';
		}
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
        searchInfo['adminMode'] = adminMode.value;
        searchInfo['page'] = paginate;
        
        var hiddenField = document.createElement("input");
        hiddenField.setAttribute("type", "hidden");
        hiddenField.setAttribute("name", "searchInfo");
        hiddenField.setAttribute("value", encodeURI(JSON.stringify(searchInfo)));
        form.appendChild(hiddenField);
        
        document.body.appendChild(form);
        form.submit();
	}
	
	/* ===========================================================================
	 * 2. 회원 수정
	 * ---------------------------------------------------------------------------
	 * > 입력 : MemberInfo, SearchInfo
	 * > 출력 : - 
	 * > 이동 페이지 : /admin/modMemberForm.do 
	 * > 설명 : 
		 	- 
	 ===========================================================================*/
	function editMember(userId){
		// form 생성
		var form = document.getElementById("frmMembersList");
        form.setAttribute("charset", "UTF-8");
        form.setAttribute("method", "Post");  //Post 방식
        form.setAttribute("action", "${contextPath}/admin/modMemberForm.do"); //요청 보낼 주소
		
        // 선택된 Member userId
		var member = document.createElement("input");
		member.setAttribute("type", "hidden");
		member.setAttribute("name", "userId");
		member.setAttribute("value", userId);
        form.appendChild(member);

        
		// 검색 필터
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
        var searchObj = new Object();
        searchObj['searchFilter'] = document.getElementById("searchFilter").value;
        searchObj['searchContent'] = document.getElementById("searchContent").value;
        searchObj['joinStart'] = document.getElementById("joinStart").value;
        searchObj['joinEnd'] = document.getElementById("joinEnd").value;
        searchObj['adminMode'] = document.getElementById("adminMode").value;
        searchObj['page'] = $('#paginate .pageCover a.select').val();
        
        var searchInfo = document.createElement("input");
        searchInfo.setAttribute("type", "hidden");
        searchInfo.setAttribute("name", "searchInfo");
        searchInfo.setAttribute("value", encodeURI(JSON.stringify(searchObj)));
        form.appendChild(searchInfo);
        
        
        document.body.appendChild(form);
        form.submit();
	}
	
	/* ===========================================================================
	 * 3. 회원 삭제
	 * ---------------------------------------------------------------------------
	 * > 입력 : MemberInfo, SearchInfo
	 * > 출력 : Member List
	 * > 이동 페이지 : /admin/delMember.do > /admin/searchMembers.do 
	 * > 설명 : 
	 ===========================================================================*/
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
	
	/* ===========================================================================
	 * 4. 회원 다중 삭제
	 * ---------------------------------------------------------------------------
	 * > 입력 : MembersList, SearchInfo
	 * > 출력 : Member List
	 * > 이동 페이지 : /admin/delMembersList.do > /admin/searchMembers.do 
	 * > 설명 : 
	 ===========================================================================*/
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
				
				delMemberObj[count++] = membersList[i];
			}
		}
		
		if(isEmpty(delMemberObj)) {
			alert("체크된 항목이 없습니다. 다시 선택해 주세요.");
			return;
		}
		
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
    // ==================================== //
	// ========== pagination ============== //
	// ==================================== //
	let page = <c:out value="${searchInfo.page}" default="1" />
	let pagingGroup = 1;
	let maxPaging = 1;
	$("document").ready(function(){
		
		
	 	var currentPage = page;	// 현재 보고있는 페이지
		paging(currentPage);
	 	
	 	$('#prev').on('click',function(){
	 		clickPaging($(this));
	 	});
	 	$('#next').on('click',function(){
	 		clickPaging($(this));
	 	});
	 	$('.pageCover > a').on('click',function(){
	 		clickPaging($(this));
	 	})
	 	
	 	// 검색창 enter키 이벤트
	 	$('#searchContent').on('keydown',function(event){
	 		if(event.keyCode == 13)
	   	     {
	 			
	 			searchMember();
	 			return;
	   	     }
	 		
	 	})
	});
	
	function paging(currentPage){
		var html = "";
		
		/* if(prev > 0){
			html += "<a href=# id='one'>&lt;&lt;</a> ";
			html += "<a href=# id='prev'>&lt;</a> ";
			
		} */
		pagingGroup = Math.ceil(currentPage / 10);
		
		let firstPage = pagingGroup * 10 - 9;
		let lastPage = firstPage + 9;
		
		let totalList = "${searchInfo.maxPage}";
		let maxPage = Math.ceil(totalList / 10);
		console.log(maxPage);
		if(pagingGroup != 1){
			html += "<span class='pagePrev'><button  id='prev'><i class='larr'></i>prev</button></span><span class='pageCover'>";
		}else{
			html += "<span class='pageCover'>";
		}
		
		
		for(var i=firstPage; i <= lastPage; i++){
			if(i > maxPage) break;
			if(i == page){
				html += "<a href='#' id=" + i + " class='select'>" + i + "</a> ";
			}else{
				html += "<a href='#' id=" + i + ">" + i + "</a> ";
			}
		}
		console.log(pagingGroup);
		console.log(Math.floor(maxPage / 10));
		
		if(!(pagingGroup > (Math.floor(maxPage / 10)))){
			html += "</span><span class='pageNext'><button  id='next'><i class='rarr'></i>next</button></span>";
		}else{
			html += "</span>";
		}
		
		$("#paginate").html(html);
		
	}
	function clickPaging(event){
		
		if(event.context.id == 'prev'){
			if(pagingGroup == 1){
				return;
			}
			
			var setPage = (pagingGroup - 1) * 10 ;
			
			searchMember(String(setPage));
			return;
			
		}
		if(event.context.id == 'next'){
			if(maxPaging < 1){
				return;
			}
			var setPage = pagingGroup * 10 + 1;
			
			searchMember(String(setPage));
			return;
		}
		
		searchMember(String(event.context.id));
		return;
        
	}
	
</script>
</head>
<body>

<div id="container">
	<div class="width_wrap">
		<div class="search_wrap">
			<form method="post" action="#" id='frmMembersList' onsubmit="return false;">
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
                            <span class="input_wrap "><input type="text" name="searchContent" id="searchContent" value="${searchInfo.searchContent}"><input type="hidden"></span> <!-- text name값 설정 -->
						</li>
						<li>
                            <label for="startDate">가입일자</label>
                            <span class="input_wrap joinDate"><input type="text" class="" name="joinStart" id="joinStart" value="${searchInfo.joinStart}"></span>
                            <i>~</i>
							<span class="input_wrap joinDate"><input type="text" class="searchDate" name="joinEnd" id="joinEnd" value="${searchInfo.joinEnd}"></span>
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
								<th colspan="8" style="padding:30px 0;">현재 등록된 회원 정보가 없습니다.</th>
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
									
									<td><button type="button" class="editBtn" onclick="editMember('${memTable.userId }')" value="수정"><i class="icon icon-checkmark"></i></button></td>
									<td><button type="button" class="delBtn" onclick="delMember('${status.index}')" value="삭제"><i class="icon icon-cross"></i></button></td>
								</tr>
							</c:forEach> 
						</c:otherwise>
					</c:choose> 
					  
				</table>
				<p class="editBtn_wrap">
					<a href="${contextPath }/admin/membershipForm.do" class="memAdd"><strong>등록</strong></a>
					<a href="#" onclick="chkDelMember()" class="memDel"><strong>탈퇴</strong></a>
				</p>
				<div id="paginate">
				</div>
			</div>
			<!-- content end-->
		</div>
		
	</div>
</div>
</body>
</html>