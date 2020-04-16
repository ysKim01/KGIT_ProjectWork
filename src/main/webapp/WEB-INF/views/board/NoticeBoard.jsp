<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false" %>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html> 
<html>
<head>
<meta charset="UTF-8">
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/board/listBoard.css">
   <style>
   
   	.block_wrap{margin:0;}
   	.board_list > ul{display:table; width:100%;}
   	.board_list > ul > li{display:table-cell;}
   	.board_list ul > li:first-child{ width:10%; }
	.board_list ul > li:nth-child(2){width:70%;}
	
	.board_list ul > li:last-child{width:20%;}
	
	.board_list .list_list{
		margin-bottom: 8px;
	    background-color: #fff;
	    border-radius: 0;
	    box-shadow: 2px 2px 3px rgba(22,22,22,0.1);
	}
	.board_list .list_list.important{
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
	
	.search_list{text-align:center; margin-top:40px;}
	#paginate{padding:15px 0; }
	.search_list > li > span{background-color:#fff; display:block; float:left;}
	.search_list span input,
	.search_list span select{
		border:0; background:unset;
		height:40px;padding: 10px 30px 10px 15px;;     box-sizing: border-box;
		position:relative;
	}
	.search_list > li > span:nth-child(2):after{
		content: '';
	    display: block;
	    width: 1px;
	    height: 60%;
	    position: absolute;
	    top: 50%;
	    left: 0px;
	    background-color: #ccc;
	    margin-top: -4%;
	}
	.search_list span input[type=text]{
	   min-width: 300px;
    }
	
	.search_list:after{clear:both;}
	.search_list > li{
		margin: auto; border: 2px solid #eaeaea; display: inline-block;
	}
	.search_list .search_btn{
		font-size:0; width:0; height:0;border:0; margin:0; padding:0;
	}
	.search_list .search_btn_wrap{
		position:absolute;
		top:50%; right:10px;
	    margin-top: -11px;
	}
	.search_btn_wrap .btn_cover label{color:#999;}
	.search_list .input_wrap{position:relative;}  
	
	
	.notFound{background-color:#fff;}
	.notFound p{font-size:15px; text-align:center;     padding: 25px 0;}
   </style>
   
   
   <script>
   var isEmpty = function(value){
       if( value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length ) ) { 
           return true ;
       }else{
            return false ;
       }
  }
   /* ===========================================================================
	 * 1. 공지 검색
	 * ---------------------------------------------------------------------------
	 * > 입력 : page
	 * > 출력 : page
	 * > 이동 페이지 : /notice/searchNotice.do
	 * > 설명 : 
		 	- 검색필터 전달 후 문의 검색창으로
	 ===========================================================================*/
	 function searchNotice(paginate){
		 var form = document.createElement("form");
       form.setAttribute("charset", "UTF-8");
       form.setAttribute("method", "Get");  //Get 방식
       form.setAttribute("action", "${contextPath}/notice/searchNotice.do"); //요청 보낼 주소
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
	 * > 이동 페이지 : /notice/showQuestion.do 
	 * > 설명 : 문의 내용 조회
	 ===========================================================================*/
	 function showNotice(keyNum){
		// form 생성
		var form = document.createElement("form");
       form.setAttribute("charset", "UTF-8");
       form.setAttribute("method", "Post");  //Post 방식
       form.setAttribute("action", "${contextPath}/notice/showNotice.do "); //요청 보낼 주소
		
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
	 			
	 			searchNotice();
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
<div class="mContent_wrap">
	<section class='content_top'>
           <div class="img_wrap">
               <div class="width_wrap">
                   <h2>
                       <span>공지사항</span>
                   </h2>
               </div>
               
           </div>
       </section>
        
<div class="boardListWrap">
	<div class="width_wrap">
		<div class="content_block">	
         
             <div class="board_list ">
                 <ul class="list_header clear_both">
                     <li><strong>번호</strong></li>
                     <li><strong>제목</strong></li>
                     <li><strong>날짜</strong></li>
                 </ul>
                 
            <c:forEach var="topBoard" items="${topList}" varStatus="status">
				<ul class="list_list clear_both important" onclick="showNotice('${topBoard.keyNum}')">
				     <li><strong><i class="Impt red"><span>중요</span></i></strong></li>
                     <li class="title"><strong>${topBoard.noticeTitle}</strong></li>
                     <li class="dateType"><strong>${topBoard.noticeWriteDate }</strong></li>
				</ul>
			</c:forEach>
			<c:choose>
				<c:when test="${noticeList == '' || empty noticeList }">
					<div class="notFound">
						<p>
							검색된 항목이 존재하지 않습니다.<br>
							다시 검색해 주세요.
						</p>
					</div>
				</c:when>
				<c:otherwise>
					<c:forEach var="board" items="${noticeList }" varStatus="status">
		             	<ul class="list_list clear_both" onclick="showNotice('${board.keyNum}')">
		             	    <li><strong>${board.keyNum}</strong></li>
		                     <li class="title"><strong>${board.noticeTitle }</strong></li>
		                     <li class="dateType"><strong>${board.noticeWriteDate }</strong></li>
		                 </ul>
		             </c:forEach>
				</c:otherwise>
			</c:choose>
             
             </div>
			<ul class="search_list clear_both">
				<li>
					<span class="input_wrap"><select id="searchFilter" name="searchFilter"> 
					<option value="noticeTitle">제목</option>
           		  	</select></span>
           		  	<span class="input_wrap ">
           		  	<input type="text" name="searchContent" id="searchContent" value="${searchInfo.searchContent}"><input type="hidden">
	           		  	<span class="search_btn_wrap">
	                    <strong class="btn_cover"><label for="search_btn"><i class="icon icon-search"></i></label><button id="search_btn" class="none search_btn" type="button" value="검색" onclick="searchNotice()"></button></strong>
	                    </span>
           		  	</span> <!-- text name값 설정 -->
				</li>
			</ul>
			<div id="paginate">
			 </div>
        </div>
	</div>
</div>
</div>
</body>
</html>