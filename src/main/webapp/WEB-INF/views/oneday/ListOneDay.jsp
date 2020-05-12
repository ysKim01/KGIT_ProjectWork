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

<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/oneday/ListOnedayClass.css">
<style>
   
   	.block_wrap{margin:0;}
   	.oneday_list > ul{display:table; width:100%;}
   	.oneday_list > ul > li{display:table-cell;}
	
	.oneday_list .list_list{
		margin-bottom: 8px;
	    background-color: #fff;
	    border-radius: 0;
	    box-shadow: 2px 2px 3px rgba(22,22,22,0.1);
	}
	.oneday_list .list_list.important{
		background-color:#fafafa;
	}
	.important .Impt{
		display:inline-block;
		padding:0px 10px; box-sizing:border-box;
		border:1px solid #FF0040;background-color:#FFEDED;
		font-style:normal;    line-height: 20px;
	}
	.important .Impt span{
		font-size:11px; font-weight:500; 
	}  
	.notFound{background-color:#fff;}
	.notFound p{font-size:15px; text-align:center;     
	padding: 25px 0;
	}
	
	.ter img {
    max-width: 300px;
    max-height: 200px;
    min-width: 200px;
    min-height: 100px;
	}
	
   </style>


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
	
 	/* ===========================================================================
	 * 원데이클래스 검색
	 * ---------------------------------------------------------------------------
	 * > 입력 : page
	 * > 출력 : page
	 * > 이동 페이지 : /notice/searchOneDay.do
	 * > 설명 : 
		 	- 검색필터 전달 후 문의 검색창으로
	 ===========================================================================*/
	function searchOneDay(paginate){
		var form = document.createElement("form");
        form.setAttribute("charset", "UTF-8");
        form.setAttribute("method", "Get");  //Get 방식
        form.setAttribute("action", "${contextPath}/oneDay/searchOneDay.do"); //요청 보낼 주소
		if(paginate == null || paginate == '' || paginate == 'undefined'){
			paginate = $('#paginate .pageCover a.select').text();
			if(isEmpty(paginate)){
				paginate = '1';
			}
		}
        
        // searchInfo
        var searchInfo = new Object();
        searchInfo['searchContent'] = document.getElementById("searchContent").value;
        searchInfo['classStatus'] = document.getElementById("classStatus").value;
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
	 * 원데이클래스 조회
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum
	 * > 출력 : - 
	 * > 이동 페이지 : /notice/showOneday.do 
	 * > 설명 : 문의 내용 조회
	 ===========================================================================*/
	 function showOneDay(keyNum){
		// form 생성
		var form = document.createElement("form");
       form.setAttribute("charset", "UTF-8");
       form.setAttribute("method", "Post");  //Post 방식
       form.setAttribute("action", "${contextPath}/oneDay/showOneDay.do"); //요청 보낼 주소
		
       // keyNum
		var key = document.createElement("input");
		key.setAttribute("type", "hidden");
		key.setAttribute("name", "keyNum");
		key.setAttribute("value", keyNum);
       	form.appendChild(key);
       
    	// searchInfo
       var searchObj = new Object();
       searchObj['searchContent'] = document.getElementById("searchContent").value;
       searchObj['classStatus'] = document.getElementById("classStatus").value;
       searchObj['page'] = $('#paginate .pageCover a.select').text();
       var searchInfo = document.createElement("input");
       searchInfo.setAttribute("type", "hidden");
       searchInfo.setAttribute("name", "searchInfo");
       searchInfo.setAttribute("value", encodeURI(JSON.stringify(searchObj)));
       form.appendChild(searchInfo);
       
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
<div id="mContent_wrap">
	<section class='content_top'>
		<div class="img_wrap">
			<div class="width_wrap">
				<h2>
                    <span>OneDay Class</span>
                </h2>
            </div>
		</div>
	</section>
<div class="onedayListWrap">
	<div class="width_wrap">
		<div class="content_block">
		
				<div class="oneday_list">
					<div class="content">
					<div></div>
						<c:choose>
						<c:when test="${oneDayList eq '' || empty oneDayList  }">
							<tr>
								<th colspan="8" style="padding:30px 0;">현재 등록된 일일클래스가 없습니다.</th>
							</tr>
						</c:when>
						<c:otherwise>
							<ul class ="clear_both">
							<c:forEach var="oneDayTable" items="${oneDayList}" varStatus="status">
								<li class="cen">
									<div class="ter">
									<figure>
										<%-- <img src= '${contextPath}${oneDayTable.classPhoto1}' alt="${oneDayTable.classTitle }"></a> --%>
										<img src= '${contextPath}${oneDayTable.classPhoto1}' alt="${oneDayTable.classTitle }" onclick="showOneDay('${oneDayTable.keyNum}')">
									</figure>
									<div onclick="showOneDay('${oneDayTable.keyNum}')" >
									<div>
										<span class="oneday-subject">강의명 : ${oneDayTable.classTitle}</span>
									</div>
									<div>
										<span class="oneday-subject"> 등록일 : ${oneDayTable.classWriteDate}</span>
									</div>
									<div>
										<span class="oneday-subject">개강일 : ${oneDayTable.classDate}</span>
									</div>
									<c:choose>
			                     	<c:when test="${oneDayTable.classStatus == 0}">
			                     		<div>모집 상태 : 모집중</div>
			                     	</c:when>
			                     	<c:otherwise>
			                     		<div>모집 상태 : 모집완료</div>
			                     	</c:otherwise>
				                    </c:choose>
									</div>
									</div>
								</li>
							</c:forEach>
							</ul> 
						</c:otherwise>
					</c:choose> 
					<ul class="fliter clear_both">
						<li>
							<label for="searchContent">클래스 제목</label>
                            <span class="input_wrap "><input type="text" name="searchContent" id="searchContent" value="${searchInfo.searchContent}"><input type="hidden"></span> <!-- text name값 설정 -->
						</li>
						<li>
							<label for="classStatus">모집상태</label>
							<span class="input_wrap"><select id="classStatus" name="classStatus"> <!-- select name값 설정 -->
								<option value="2">전체</option>
								<option value="0">모집중</option>
								<option value="1">모집마감</option>
                  		  	</select></span>
						</li>
						<li>
                            <strong class="btn_cover"><i class="icon icon-search"></i><input class="search_btn" type="button" value="조회" onclick="searchOneDay()"></strong>
						</li>
					</ul>
				<div id="paginate"></div>
				</div>
				</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>