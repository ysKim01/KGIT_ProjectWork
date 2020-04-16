<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false" %>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin 일일클래스 관리</title>

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
	var classStatus = '${searchInfo.classStatus}';
	$(document).on('ready',function(){
		if(classStatus != ''){
			$('#classStatus option[value='+classStatus+']').attr('selected',true);
		}
		
	})
 	
	/* ===========================================================================
	 * 1. 일일클래스 검색
	 * ---------------------------------------------------------------------------
	 * > 입력 : searchInfo
	 * > 출력 : -
	 * > 이동 페이지 : /admin/searchOneDay.do
	 * > 설명 : 
		 	- 검색필터 전달 후 일일클래스 검색창으로
	 ===========================================================================*/
	function searchOneDay(paginate){
		var form = document.createElement("form");
        form.setAttribute("charset", "UTF-8");
        form.setAttribute("method", "Get");  //Get 방식
        form.setAttribute("action", "${contextPath}/admin/searchOneDay.do"); //요청 보낼 주소
		if(paginate == null || paginate == '' || paginate == 'undefined'){
			paginate = $('#paginate .pageCover a.select').text();
			if(isEmpty(paginate)){
				paginate = '1';
			}
		}
        
        // searchInfo
        var searchObj = new Object();
        searchObj['searchContent'] = document.getElementById("searchContent").value;
        searchObj['classStatus'] = document.getElementById("classStatus").value;
        searchObj['page'] = paginate;
        
        var searchInfo = document.createElement("input");
        searchInfo.setAttribute("type", "hidden");
        searchInfo.setAttribute("name", "searchInfo");
        searchInfo.setAttribute("value", encodeURI(JSON.stringify(searchObj)));
        form.appendChild(searchInfo);
        
        document.body.appendChild(form);
        form.submit();
	}
	
	 /* ===========================================================================
	 * 2. 일일클래스 삭제
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum
	 * > 출력 : -
	 * > 이동 페이지 : /admin/delOneDay.do  
	 * > 설명 : 일일클래스 삭제
	 ===========================================================================*/
	function delOneDay(keyNum){
		$.ajax({
			type:"post",
			async: false,
			url:"${contextPath}/admin/delOneDay.do",
			dataType:"text",
			data:{"keyNum" : keyNum},
			success:function(data, status){
				console.log("삭제 결과 : " + data);
				alert("삭제했습니다.");
				searchOneDay();
			},
			error: function(data, status) {
				alert("error");
	        }
		});  
	}
	 
	 /* ===========================================================================
	 * 3. 일일클래스 다중 삭제
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum-List
	 * > 출력 : - 
	 * > 이동 페이지 : /admin/delOneDayList.do  
	 * > 설명 : 
	 ===========================================================================*/
	 function chkDelOneDay(){
		var keyList = [];
		<c:forEach var="item" items="${oneDayList}" varStatus="status">
			var key = "${item.keyNum}";
			keyList.push(key);
		</c:forEach>
		
		var chkObj = new Object();
		var delKeyObj = [];
		var targets = document.getElementsByClassName('memChk');
		$.each(targets, function(index, items){
			if(items.checked == true){
				delKeyObj.push(items.value);
			}
		});
		console.log(delKeyObj);
		
		if(isEmpty(delKeyObj)) {
			alert("체크된 항목이 없습니다. 다시 선택해 주세요.");
			return;
		}
		if(!confirm("정말 삭제하시겠습니까?")) return;
		
		$.ajax({
			type:"post",
			async: false,
			url:"${contextPath}/admin/delOneDayList.do",
			dataType:"text",
			data:{"list" : JSON.stringify(delKeyObj)},
			success:function(data, status){
				console.log("다중삭제 결과 : " + data);
				alert("삭제했습니다.");
				searchOneDay();
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
	 			
	 			searchOneDay();
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
			
			searchOneDay(String(setPage));
			return;
			
		}
		if(event.context.id == 'next'){
			if(maxPaging < 1){
				return;
			}
			var setPage = pagingGroup * 10 + 1;
			
			searchOneDay(String(setPage));
			return;
		}
		
		searchOneDay(String(event.context.id));
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
					<legend>일일클래스 검색창</legend>
					<ul class="search_list clear_both">
						<li>
							<label for="searchContent">클래스 제목</label>
                            <span class="input_wrap "><input type="text" name="searchContent" id="searchContent" value="${searchInfo.searchContent}"><input type="hidden"></span> <!-- text name값 설정 -->
						</li>
						<li>
							<label for="classStatus">모집상태</label>
							<span class="input_wrap"><select id="classStatus" name="classStatus"> <!-- select name값 설정 -->
								<option value="9999">전체</option>
								<option value="0">모집중</option>
								<option value="1">모집마감</option>
                  		  	</select></span>
						</li>
						<li>
                            <strong class="btn_cover"><i class="icon icon-search"></i><input class="search_btn" type="button" value="조회" onclick="searchOneDay()"></strong>
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
							<th>NO</th>
							<th>클래스 제목</th>
							<th>등록일자</th>
							<th>모집상태</th>
							<th>삭제</th>
						</tr>
					</thead>
					<c:choose>
						<c:when test="${oneDayList eq '' || empty oneDayList  }">
							<tr>
								<th colspan="8" style="padding:30px 0;">현재 등록된 일일클래스가 없습니다.</th>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="oneDayTable" items="${oneDayList}" varStatus="status">
								<tr>
									<td><input value="${oneDayTable.keyNum}" type="checkbox" class="memChk" name="memChk${oneDayTable.keyNum}"></td>
									<td>${oneDayTable.keyNum}</td>
									<td>${oneDayTable.classTitle}</td>
									<td>${oneDayTable.classDate}</td>
									<c:choose>
			                     	<c:when test="${oneDayTable.classStatus == 0}">
			                     		<td>모집중</td>
			                     	</c:when>
			                     	<c:otherwise>
			                     		<td>모집완료</td>
			                     	</c:otherwise>
				                    </c:choose>
									<td><button type="button" class="delBtn" onclick="delOneDay('${oneDayTable.keyNum}')" value="삭제"><i class="icon icon-cross"></i></button></td>
								</tr>
							</c:forEach> 
						</c:otherwise>
					</c:choose> 
					  
				</table>
				<p class="editBtn_wrap">
					<a href="${contextPath }/admin/addOneDayForm.do" class="memAdd"><strong>등록</strong></a>
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