<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin 예약관리</title>
<script>
	var isEmpty = function(value){
		if(value == "" || value == null || value == undefined || (value != null && typeof value == "object" && !Object.keys(value).length)){
			return true;
		}else{
			return false;
		}
	}
	var searchFilter = '${searchInfo.searchFilter}';
	
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
		
		let totalList = "${searchInfo.maxNum}";
		let maxNum = Math.ceil(totalList / 10);
		console.log(maxNum);
		if(pagingGroup != 1){
			html += "<span class='pagePrev'><button  id='prev'><i class='larr'></i>prev</button></span><span class='pageCover'>";
		}else{
			html += "<span class='pageCover'>";
		}
		
		
		for(var i=firstPage; i <= lastPage; i++){
			if(i > maxNum) break;
			if(i == page){
				html += "<a href='#' id=" + i + " class='select'>" + i + "</a> ";
			}else{
				html += "<a href='#' id=" + i + ">" + i + "</a> ";
			}
		}
		console.log(pagingGroup);
		console.log(Math.floor(maxNum / 10));
		
		if(!(pagingGroup > (Math.floor(maxNum / 10)))){
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
			<form method="post" action="#" id='frmReserveList' onsubmit="return false;">
				<fieldset>
					<legend>예약정보 검색창</legend>
					<ul class="search_list clear_both">
						<li>
							<label for="study_reserve">예약상태</label>
							<span class="input_wrap"><select id="reserveStatus" name="reserveStatus"> <!-- 예약상태 설정 -->
								<option value="All">전체</option>
								<option value="Apply">예약신청</option>
								<option value="Payment">결재완료</option>
								<option value="Checkout">사용완료</option>
                  		  	</select></span>
						</li>
						<li>
							<label for="study_reserve">조회정보</label>
							<span class="input_wrap"><select id="searchFilter" name="searchFilter"> <!-- select name값 설정 -->
								<option value="userId">ID</option>
								<option value="userName">이름</option>
								<option value="userTel">휴대전화</option>
								<option value="centerCode">업체코드</option>
								<option value="centerName">업체이름</option>
                  		  	</select></span>
                            <span class="input_wrap "><input type="text" name="searchContent" id="searchContent" value="${searchInfo.searchContent}"><input type="hidden"></span> <!-- text name값 설정 -->
						</li>
						<li>
                            <span class="search_btn_wrap">
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
							<th>업체코드</th>
							<th>업체이름</th>
							<th>예약자</th>
							<th>예약자 연락처</th>
							<th>방이름</th>
							<th>예약날짜</th>
							<th>방규모</th>
							<th>결재금액</th>
							<th>예약상태</th>
						</tr>
					</thead>
					<c:choose>
						<c:when test="${reserveList eq '' || empty reserveList  }">
							<tr>
								<th colspan="8" style="padding:30px 0;">현재 등록된 회원 정보가 없습니다.</th>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="reserveTable" items="${reserveList }" varStatus="status">
								<tr>
									<td><input value="${status.index}" type="checkbox" class="rsvChk" name="rsvChk${status.index }"></td>
									<td>${reserveTable.centerCode }</td>
									<td>${reserveTable.centerName }</td>
									<td>${reserveTable.userName }</td>
									<td>${reserveTable.userTel1 }-${reserveTable.userTel2 }-${reserveTable.userTel3 }</td>
									<td>${reserveTable.roomName }</td>
									<td>${reserveTable.reserveDate }</td>
									<td>${reserveTable.scale }</td>
									<td>${reserveTable.reservePrice }</td>
									<td>${reserveTable.reserveStatus }</td>
									<td><button type="button" class="editBtn" onclick="editMember('${memTable.userId }')" value="수정"><i class="icon icon-checkmark"></i></button></td>
									<td><button type="button" class="delBtn" onclick="delMember('${status.index}')" value="삭제"><i class="icon icon-cross"></i></button></td>
								</tr>
							</c:forEach> 
						</c:otherwise>
					</c:choose> 
					  
				</table>
				<p class="editBtn_wrap">
					<a href="${contextPath }/admin/membershipForm.do" class="memAdd"><strong>등록</strong></a>
					<a href="#" onclick="chkDelMember()" class="memDel"><strong>삭제</strong></a>
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