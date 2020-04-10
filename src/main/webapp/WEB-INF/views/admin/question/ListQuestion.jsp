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
<title>Admin 문의 관리</title>
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
	var questionClass = '${searchInfo.questionClass}';
	var isAnswered = '${searchInfo.isAnswered}';
	$(document).on('ready',function(){
		if(searchFilter != ''){
			$('#searchFilter option[value='+searchFilter+']').attr('selected',true);
		}
		if(questionClass != ''){
			$('#questionClass option[value='+questionClass+']').attr('selected',true);
		}
		if(isAnswered != ''){
			$('#isAnswered option[value='+isAnswered+']').attr('selected',true);
		}
	})
	
	/* ===========================================================================
	 * 1. 문의 검색
	 * ---------------------------------------------------------------------------
	 * > 입력 : searchInfo
	 * > 출력 : searchInfo
	 * > 이동 페이지 : /admin/searchQuestion.do
	 * > 설명 : 
		 	- 검색필터 전달 후 문의 검색창으로
	 ===========================================================================*/
	function searchQuestion(paginate){
		var form = document.createElement("form");
        form.setAttribute("charset", "UTF-8");
        form.setAttribute("method", "Get");  //Get 방식
        form.setAttribute("action", "${contextPath}/admin/searchQuestion.do"); //요청 보낼 주소
		if(paginate == null || paginate == '' || paginate == 'undefined'){
			paginate = '1';
		}
        
        // searchInfo
        var searchInfo = new Object();
        searchInfo['searchFilter'] = document.getElementById("searchFilter").value;
        searchInfo['searchContent'] = document.getElementById("searchContent").value;
        searchInfo['questionClass'] = document.getElementById("questionClass").value;
        searchInfo['isAnswered'] = document.getElementById("isAnswered").value;
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
	 * 2. 문의 조회
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum
	 * > 출력 : - 
	 * > 이동 페이지 : /admin/showQuestion.do 
	 * > 설명 : 문의 내용 조회
	 ===========================================================================*/
	 function showQuestion(keyNum){
		// form 생성
		var form = document.createElement("form");
        form.setAttribute("charset", "UTF-8");
        form.setAttribute("method", "Post");  //Post 방식
        form.setAttribute("action", "${contextPath}/admin/showQuestion.do "); //요청 보낼 주소
		
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
        searchObj['questionClass'] = document.getElementById("questionClass").value;
        searchObj['isAnswered'] = document.getElementById("isAnswered").value;
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
	 * 2. 예약 삭제
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum
	 * > 출력 : -
	 * > 이동 페이지 : /admin/delReserve.do > /admin/searchReserve.do 
	 * > 설명 : 
	 ===========================================================================*/
	function delReserve(keyNum){
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
			<form method="post" action="#" id='frmQuestionList' onsubmit="return false;">
				<fieldset>
					<legend>문의 목록</legend>
					<ul class="search_list clear_both">
						<li>
							<label for="study_question">조회정보</label>
							<span class="input_wrap"><select id="searchFilter" name="searchFilter"> 
								<option value="userId">ID</option>
                  		  	</select></span>
                  		  	<span class="input_wrap "><input type="text" name="searchContent" id="searchContent" value="${searchInfo.searchContent}"><input type="hidden"></span> <!-- text name값 설정 -->
						</li>
						<li>
							<label for="study_question">문의유형</label>
							<span class="input_wrap"><select id="questionClass" name="questionClass"> 
								<option value="All">전체</option>
								<option value="예약문의">예약문의</option>
								<option value="원데이클레스문의">원데이클레스문의</option>
								<option value="환불문의">환불문의</option>
								<option value="기타문의">기타문의</option>
                  		  	</select></span>
						</li>
						<li>
							<label for="study_question">답변상태</label>
							<span class="input_wrap"><select id="isAnswered" name="isAnswered"> 
								<option value="All">전체</option>
								<option value="미완료">미완료</option>
								<option value="완료">완료</option>
                  		  	</select></span>
						</li>
						<li>
                            <span class="search_btn_wrap">
                            <strong class="btn_cover"><i class="icon icon-search"></i><input class="search_btn" type="button" value="조회" onclick="searchQuestion()"></strong>
                            </span>
						</li>
					</ul>
				</fieldset>
			</form>
		</div>
		<!--  search_wrap end -->
		
		<div class="content_wrap">
			<div class="content">
				<table class="questionContent">
					<thead>	
						<tr>
							<th>선택</th>
							<th>문의유형</th>
							<th>제목</th>
							<th>작성자</th>
							<th>답변상태</th>
						</tr>
					</thead>
					<c:choose>
						<c:when test="${questionList eq '' || empty questionList  }">
							<tr>
								<th colspan="8" style="padding:30px 0;">현재 등록된 문의 정보가 없습니다.</th>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="questionTable" items="${questionList }" varStatus="status">
								<tr>
									<td><input value="${status.index}" type="checkbox" class="qChk" name="qChk${status.index }"></td>
									<td>${questionTable.questionClass }</td>
									<td>${questionTable.questionTitle }</td>
									<td>${questionTable.userId }</td>
									<c:choose>
			                     	<c:when test="${questionTable.questionAnswer == null}">
			                     		<td>답변대기</td>
			                     		<td><button type="button" class="editBtn" onclick="showQuestion('${questionTable.keyNum}')" value="답변"><i class="icon icon-checkmark"></i></button></td>
			                     	</c:when>
			                     	<c:otherwise>
			                     		<td>답변완료</td>
			                     		<td><button type="button" class="editBtn" onclick="showQuestion('${questionTable.keyNum}')" value="답변"><i class="icon icon-checkmark"></i></button></td>
			                     	</c:otherwise>
				                    </c:choose>
									<td><button type="button" class="delBtn" onclick="delReserve('${reserveTable.keyNum}')" value="삭제"><i class="icon icon-cross"></i></button></td>
								</tr>
							</c:forEach> 
						</c:otherwise>
					</c:choose> 
					  
				</table>
				<p class="editBtn_wrap">
					<a href="#" onclick="chkDelQuestion()" class="qDel"><strong>삭제</strong></a>
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