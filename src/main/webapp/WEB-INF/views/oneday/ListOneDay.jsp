<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false" %>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>원데이 클래스 목록</title>

<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/ListOnedayClass.css">

<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="${contextPath }/resources/js/loginRequired.js"></script>
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
	
 	// 검색
	function searchOneDay(paginate){
		var form = document.createElement("form");
        form.setAttribute("charset", "UTF-8");
        form.setAttribute("method", "Get");  //Get 방식
        form.setAttribute("action", "${contextPath}/oneDay/searchOneDay.do"); //요청 보낼 주소
		if(paginate == null || paginate == '' || paginate == 'undefined'){
			paginate = '1';
		}
        
        // searchInfo
        var searchInfo = new Object();
        searchInfo['searchContent'] = document.getElementById("searchContent").value;
        searchInfo['page'] = paginate;
        
        var hiddenField = document.createElement("input");
        hiddenField.setAttribute("type", "hidden");
        hiddenField.setAttribute("name", "searchInfo");
        hiddenField.setAttribute("value", encodeURI(JSON.stringify(searchInfo)));
        form.appendChild(hiddenField);
        
        document.body.appendChild(form);
        form.submit();
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
					<legend>OneDay Class</legend>
					<ul class="search_list clear_both">
						<li>
							<label for="status">모집상태</label>
							<span class="input_wrap"><select id="classStatus" name="classStatus"> <!-- select name값 설정 -->
								<option value="2">전체</option>
								<option value="0">모집중</option>
								<option value="1">모집완료</option>
                  		  	</select></span>
                  		 </li>
						<li>
							<label for="searchContent">클래스 제목</label>
                            <span class="input_wrap "><input type="text" name="searchContent" id="searchContent" value="${searchInfo.searchContent}"><input type="hidden"></span> <!-- text name값 설정 -->
						</li>
						<li>
                            <span class="search_btn_wrap">
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
					<table class="onedayContent">
						<c:choose>
							<c:when test="${oneDayList eq '' || empty oneDayList  }">
								<tr>
									<th colspan="8" style="padding: 30px 0;">현재 등록된 클래스 정보가 없습니다.</th>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="oneday" items="${oneDayList }" varStatus="status">
									<ul>
										<li>
											<figure>
												<a href=""> 
												<img src= '${contextPath}${oneday.classPhoto1}' alt="${oneday.classTitle }"></a>
											</figure>
											<div>
												<span class="oneday-subject">"${oneday.classTitle}"</span>
											</div>
											<div>
												<span class="oneday-subject"> 등록일 : "${oneday.classWriteDate}"</span>
											</div>
											<div>
												<span class="oneday-subject">개강일 : "${oneday.classDate}"</span>
											</div>
										</li>
									</ul>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</table>
				<div id="paginate"></div>
			</div>
			<!-- content end-->
		</div>
	</div>
</div>
</body>
</html>