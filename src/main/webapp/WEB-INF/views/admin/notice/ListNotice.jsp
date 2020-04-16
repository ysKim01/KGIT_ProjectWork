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
<title>Admin 공지 관리</title>
<script>
	var isEmpty = function(value){
		if(value == "" || value == null || value == undefined || (value != null && typeof value == "object" && !Object.keys(value).length)){
			return true;
		}else{
			return false;
		}
	}
	
	/* ===========================================================================
	 * 1. 공지 검색
	 * ---------------------------------------------------------------------------
	 * > 입력 : page
	 * > 출력 : page
	 * > 이동 페이지 : /admin/searchNotice.do
	 * > 설명 : 
		 	- 검색필터 전달 후 문의 검색창으로
	 ===========================================================================*/
	 function searchNotice(paginate){
		var form = document.createElement("form");
        form.setAttribute("charset", "UTF-8");
        form.setAttribute("method", "Get");  //Get 방식
        form.setAttribute("action", "${contextPath}/admin/searchNotice.do"); //요청 보낼 주소
		if(paginate == null || paginate == '' || paginate == 'undefined'){
			paginate = $('#paginate .pageCover a.select').text();
			if(isEmpty(paginate)){
				paginate = '1';
			}
		}
        
        // searchInfo
        var searchObj = new Object();
        searchObj['searchContent'] = document.getElementById("searchContent").value;
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
	 * 2. 공지 조회
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum
	 * > 출력 : - 
	 * > 이동 페이지 : /admin/showQuestion.do 
	 * > 설명 : 문의 내용 조회
	 ===========================================================================*/
	 function showNotice(keyNum){
		// form 생성
		var form = document.createElement("form");
        form.setAttribute("charset", "UTF-8");
        form.setAttribute("method", "Post");  //Post 방식
        form.setAttribute("action", "${contextPath}/admin/showNotice.do "); //요청 보낼 주소
		
        // keyNum
		var key = document.createElement("input");
		key.setAttribute("type", "hidden");
		key.setAttribute("name", "keyNum");
		key.setAttribute("value", keyNum);
        form.appendChild(key);
        
     	// searchInfo
        var searchObj = new Object();
        searchObj['searchContent'] = document.getElementById("searchContent").value;
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
	 * 3. 공지 등록 폼
	 * ---------------------------------------------------------------------------
	 * > 입력 : -
	 * > 출력 : - 
	 * > 이동 페이지 : /admin/AddNoticeForm.do 
	 * > 설명 : 문의 내용 조회
	 ===========================================================================*/
	 function addNotice(){
		 location.href="${contextPath}/admin/addNoticeForm.do";
	 }
	 
 	/* ===========================================================================
	 * 4. 공지 삭제
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum
	 * > 출력 : -
	 * > 이동 페이지 : /admin/delNotice.do  
	 * > 설명 : 공지 삭제
	 ===========================================================================*/
	function delNotice(keyNum){
		$.ajax({
			type:"post",
			async: false,
			url:"${contextPath}/admin/delNotice.do",
			dataType:"text",
			data:{"keyNum" : keyNum},
			success:function(data, status){
				console.log("삭제 결과 : " + data);
				alert("삭제했습니다.");
				searchNotice();
			},
			error: function(data, status) {
				alert("error");
	        }
		});  
	}
	 
	 /* ===========================================================================
	 * 5. 공지 다중 삭제
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum-List
	 * > 출력 : - 
	 * > 이동 페이지 : /admin/delNoticeList.do  
	 * > 설명 : 
	 ===========================================================================*/
	 function chkDelNotice(){
		var keyList = [];
		<c:forEach var="item" items="${noticeList}" varStatus="status">
			var key = "${item.keyNum}";
			keyList.push(key);
		</c:forEach>
		
		var chkObj = new Object();
		var delKeyObj = [];
		var targets = document.getElementsByClassName('ntcChk');
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
			url:"${contextPath}/admin/delNoticeList.do",
			dataType:"text",
			data:{"list" : JSON.stringify(delKeyObj)},
			success:function(data, status){
				console.log("다중삭제 결과 : " + data);
				alert("삭제했습니다.");
				searchNotice();
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
			
			listNotice(String(setPage));
			return;
			
		}
		if(event.context.id == 'next'){
			if(maxPaging < 1){
				return;
			}
			var setPage = pagingGroup * 10 + 1;
			
			listNotice(String(setPage));
			return;
		}
		
		listNotice(String(event.context.id));
		return;
        
	}
	
</script>
</head>
<body>

<div id="container">
	<div class="width_wrap">
		<div class="content_wrap">
			<div class="content">
				<table class="noticeContent">
					<thead>	
						<tr>
							<th>선택</th>
							<th>No</th>
							<th>제목</th>
							<th>등록일자</th>
						</tr>
					</thead>
					<c:forEach var="topTable" items="${topList}" varStatus="status">
						<tr>
							<td><input value="${topTable.keyNum}" type="checkbox" class="ntcChk" name="ntcChk${status.index }"></td>
							<td>중요</td>
							<td>${topTable.noticeTitle}</td>
							<td>${topTable.noticeWriteDate}</td>
		                    <td><button type="button" class="editBtn" onclick="showNotice('${topTable.keyNum}')" value="보기"><i class="icon icon-checkmark"></i></button></td>
							<td><button type="button" class="delBtn" onclick="delNotice('${topTable.keyNum}')" value="삭제"><i class="icon icon-cross"></i></button></td>
						</tr>
					</c:forEach> 
					<c:forEach var="noticeTable" items="${noticeList}" varStatus="status">
						<tr>
							<td><input value="${noticeTable.keyNum}" type="checkbox" class="ntcChk" name="ntcChk${status.index }"></td>
							<td>${noticeTable.keyNum}</td>
							<td>${noticeTable.noticeTitle}</td>
							<td>${noticeTable.noticeWriteDate}</td>
		                    <td><button type="button" class="editBtn" onclick="showNotice('${noticeTable.keyNum}')" value="보기"><i class="icon icon-checkmark"></i></button></td>
							<td><button type="button" class="delBtn" onclick="delNotice('${noticeTable.keyNum}')" value="삭제"><i class="icon icon-cross"></i></button></td>
						</tr>
					</c:forEach> 
					  
				</table>
				<p class="editBtn_wrap">
					<a href="#" onclick="chkDelNotice()" class="ntcDel"><strong>삭제</strong></a>
					<a href="#" onclick="addNotice()" class="ntcDel"><strong>등록</strong></a>
				</p>
				<div id="paginate">
				</div>
				<ul class="search_list clear_both">
					<li>
						<span class="input_wrap"><select id="searchFilter" name="searchFilter"> 
						<option value="noticeTitle">제목</option>
	           		  	</select></span>
	           		  	<span class="input_wrap "><input type="text" name="searchContent" id="searchContent" value="${searchInfo.searchContent}"><input type="hidden"></span> <!-- text name값 설정 -->
					</li>
					<li>
	                    <span class="search_btn_wrap">
	                    <strong class="btn_cover"><i class="icon icon-search"></i><input class="search_btn" type="button" value="검색" onclick="searchNotice()"></strong>
	                    </span>
					</li>
				</ul>
				
			</div>
			<!-- content end-->
		</div>
		
	</div>
</div>
</body>
</html>