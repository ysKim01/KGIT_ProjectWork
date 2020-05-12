<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>
<%	request.setCharacterEncoding("utf-8"); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin 예약관리</title>
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/board/adminBoard.css">

<style>

	#questionClass{min-width:120px;}
	#searchFilter{min-width:120px;}
	#searchContent{min-width: 350px;}
</style>
<script>
	var isEmpty = function(value){
		if(value == "" || value == null || value == undefined || (value != null && typeof value == "object" && !Object.keys(value).length)){
			return true;
		}else{
			return false;
		}
	}
	/* ===========================================================================
	 * 0. 필터 값 유지 
	 * ---------------------------------------------------------------------------
	 * - ComboBox(searchFilter) 값 유지 
	 ===========================================================================*/
	var searchFilter = '${searchInfo.searchFilter}';
	var reserveStatus = '${searchInfo.reserveStatus}';
	$(document).on('ready',function(){
		if(searchFilter != ''){
			$('#searchFilter option[value='+searchFilter+']').attr('selected',true);
		}
		if(reserveStatus != ''){
			$('#reserveStatus option[value='+reserveStatus+']').attr('selected',true);
		}
	})
	
	/* ===========================================================================
	 * 1. 예약 검색
	 * ---------------------------------------------------------------------------
	 * > 입력 : searchInfo
	 * > 출력 : Reserve List
	 * > 이동 페이지 : /admin/searchReserve.do
	 * > 설명 : 
		 	- 검색필터 전달 후 예약 검색창으로
	 ===========================================================================*/
	function searchReserve(paginate){
		var form = document.createElement("form");
        form.setAttribute("charset", "UTF-8");
        form.setAttribute("method", "Get");  //Get 방식
        form.setAttribute("action", "${contextPath}/admin/searchReserve.do"); //요청 보낼 주소
		if(paginate == null || paginate == '' || paginate == 'undefined'){
			paginate = '1';
		}
        
        // searchInfo
        var searchInfo = new Object();
        searchInfo['searchFilter'] = document.getElementById("searchFilter").value;
        searchInfo['searchContent'] = document.getElementById("searchContent").value;
        searchInfo['reserveStatus'] = document.getElementById("reserveStatus").value;
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
	 * 2. 예약 삭제
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum
	 * > 출력 : -
	 * > 이동 페이지 : /admin/delReserve.do > /admin/searchReserve.do 
	 * > 설명 : 
	 ===========================================================================*/
	function delReserve(keyNum){
		if(!confirm('정말로 선택하신 예약을 취소하시겠습니까?')){
			return;
		}
		$.ajax({
			type:"post",
			async: false,
			url:"${contextPath}/admin/delReserve.do",
			dataType:"text",
			data:{"keyNum" : keyNum},
			success:function(data, status){
				alert("삭제했습니다.");
			},
			error: function(data, status) {
				alert("error");
	        }
		})  
		searchReserve();
	}
	 /* ===========================================================================
	 * 3. 예약 수정
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum, SearchInfo
	 * > 출력 : - 
	 * > 이동 페이지 : /admin/modMemberForm.do 
	 * > 설명 : 
		 	- 
	 ===========================================================================*/
	function editReserve(keyNum){
		// form 생성
		var form = document.createElement("form");
        form.setAttribute("charset", "UTF-8");
        form.setAttribute("method", "Post");  //Post 방식
        form.setAttribute("action", "${contextPath}/admin/modReserveForm.do"); //요청 보낼 주소
		
        // keyNum
		var key = document.createElement("input");
		key.setAttribute("type", "hidden");
		key.setAttribute("name", "keyNum");
		key.setAttribute("value", keyNum);
        form.appendChild(key);
        
        // searchInfo
        var searchObj = new Object();
        searchObj['searchFilter'] = document.getElementById("searchFilter").value;
        searchObj['searchContent'] = document.getElementById("searchContent").value;
        searchObj['reserveStatus'] = document.getElementById("reserveStatus").value;
        searchObj['page'] = $('#paginate .pageCover a.select').text();
        
        var searchInfo = document.createElement("input");
        searchInfo.setAttribute("type", "hidden");
        searchInfo.setAttribute("name", "searchInfo");
        searchInfo.setAttribute("value", encodeURI(JSON.stringify(searchObj)));
        form.appendChild(searchInfo);
        
        
        document.body.appendChild(form);
        form.submit();
	}
	 
	 /* ===========================================================================
	 * 4. 예약 다중 삭제
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum-List, SearchInfo
	 * > 출력 : - 
	 * > 이동 페이지 : /admin/delReserveList.do > /admin/searchReserve.do 
	 * > 설명 : 
	 ===========================================================================*/
	function chkDelReserve(){
		var keyList = [];
		<c:forEach var="item" items="${reserveList}" varStatus="status">
			var key = "${item.keyNum}";
			keyList.push(key);
		</c:forEach>
		
		var chkObj = new Object();
		var delKeyObj = [];
		var targets = document.getElementsByClassName('rsvChk');
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
				delKeyObj[count++] = keyList[i];
			}
		}
		
		if(isEmpty(delKeyObj)) {
			alert("체크된 항목이 없습니다. 다시 선택해 주세요.");
			return;
		}
		
		if(!confirm("정말 삭제하시겠습니까?")) return;
		
		$.ajax({
			type:"post",
			async: false,
			url:"${contextPath}/admin/delReserveList.do",
			dataType:"text",
			data:{"list" : JSON.stringify(delKeyObj)},
			success:function(data, status){
				alert("삭제했습니다.");
			},
			error: function(data, status) {
				alert("error");
	        }
		});
		
		searchReserve();
	}
	 
	/* ===========================================================================
	* 5. 결재확인
	* ---------------------------------------------------------------------------
	* > 입력 : keyNum
	* > 출력 : - 
	* > 이동 페이지 : /admin/payment.do 
	* > 설명 : 예약 신청 인 상태의 예약을 결재 완료로
	===========================================================================*/
	function payment(keyNum){
		$.ajax({
			type:"post",
			async: false,
			url:"${contextPath}/admin/payment.do",
			dataType:"text",
			data:{"keyNum" : keyNum},
			success:function(data, status){
				alert("결재 확인 되었습니다.");
			},
			error: function(data, status) {
				alert("error");
	        }
		});  
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
	 			
	 			searchReserve();
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
			
			searchReserve(String(setPage));
			return;
			
		}
		if(event.context.id == 'next'){
			if(maxPaging < 1){
				return;
			}
			var setPage = pagingGroup * 10 + 1;
			
			searchReserve(String(setPage));
			return;
		}
		
		searchReserve(String(event.context.id));
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
                            <strong class="btn_cover"><i class="icon icon-search"></i><input class="search_btn" type="button" value="조회" onclick="searchReserve()"></strong>
                            </span>
						</li>
					</ul>
				</fieldset>
			</form>
		</div>
		<!--  search_wrap end -->
		
		<div class="content_wrap">
			<div class="content">
				<table class="memberContent adminTable">
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
							<th>결제확인</th>
							<th>수정</th>
							<th>삭제</th>
						</tr>
					</thead>
					<c:choose>
						<c:when test="${reserveList eq '' || empty reserveList  }">
							<tr>
								<th colspan="13" style="padding:30px 0;">현재 등록된 예약 정보가 없습니다.</th>
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
									<td><button type="button" class="checkBtn" onclick="payment('${reserveTable.keyNum}')" value="결재확인"><i class="icon icon-checkmark"></i></button></td>
									<td><button type="button" class="editBtn" onclick="editReserve('${reserveTable.keyNum}')" value="수정"><i class="icon icon-pencil"></i></button></td>
									<td><button type="button" class="delBtn" onclick="delReserve('${reserveTable.keyNum}')" value="삭제"><i class="icon icon-cross"></i></button></td>
								</tr>
							</c:forEach> 
						</c:otherwise>
					</c:choose> 
					  
				</table>
				<p class="editBtn_wrap">
					<a href="${contextPath }/admin/addReserveForm.do" class="memAdd"><strong>등록</strong></a>
					<a href="#" onclick="chkDelOneDay()" class="memDel"><strong>삭제</strong></a>
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