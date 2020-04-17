<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false" %>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin업체관리</title>
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/board/adminBoard.css">
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/reset.css">
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/adminCompanyList.css">
<style>
.search_list li .search_btn_wrap{width:auto !important;}
</style>
<script>
	
	var isEmpty = function(value){
		if(value == "" || value == null || value == undefined || (value != null && typeof value == "object" && !Object.keys(value).length)){
			return true;
		}else{
			return false;
		}
	}
	var searchFilter = '${centerSearch.searchFilter}';
	$(document).on('ready',function(){
		
		if(searchFilter != ''){
			
			$('#searchFilter option[value='+searchFilter+']').attr('selected',true);
		}	
	})

	
	/* ===========================================================================
	 * 센터 검색
	 * ---------------------------------------------------------------------------
	 * > 입력 : searchInfo
	 * > 출력 : 
	 * > 이동 페이지 : 
	 * > 설명 : 
		 	- 검색필터 전달 후 회원 검색창으로
	 ===========================================================================*/
	function searchCenter(paginate){
		var form = document.createElement("form");
        form.setAttribute("charset", "UTF-8");
        form.setAttribute("method", "Get");  //Get 방식
        form.setAttribute("action", "${contextPath}/admin/searchCenter.do"); //요청 보낼 주소
		if(paginate == null || paginate == '' || paginate == 'undefined'){
			paginate = '1';
		}
        
        // searchInfo
        var centerSearch = new Object();
        centerSearch['searchFilter'] = document.getElementById("searchFilter").value;
        centerSearch['searchContents'] = document.getElementById("searchContents").value;
        centerSearch['page'] = paginate;
        
        var hiddenField = document.createElement("input");
        hiddenField.setAttribute("type", "hidden");
        hiddenField.setAttribute("name", "centerSearch");
        hiddenField.setAttribute("value", encodeURI(JSON.stringify(centerSearch)));
        form.appendChild(hiddenField);
        
        document.body.appendChild(form);
        form.submit();
	}
	
	/* ===========================================================================
	 * 2. 센터 수정
	 * ---------------------------------------------------------------------------
	 * > 입력 : 
	 * > 출력 : - 
	 * > 이동 페이지 : 
	 * > 설명 : 
		 	- 
	 ===========================================================================*/
	 /*function editCenter(centerCode){
		// form 생성
		var form = document.createElement("form");
        form.setAttribute("charset", "UTF-8");
        form.setAttribute("method", "Post");  //Post 방식
        form.setAttribute("action", "${contextPath}/admin/modCenterForm.do"); //요청 보낼 주소
		
        // 선택된 Center userId
		var center = document.createElement("input");
		center.setAttribute("type", "hidden");
		center.setAttribute("name", "centerCode");
		center.setAttribute("value", centerCode);
        form.appendChild(center);

        
        // searchInfo
        var searchObj = new Object();
        searchObj['searchFilter'] = document.getElementById("searchFilter").value;
        searchObj['searchContents'] = document.getElementById("searchContents").value;
        searchObj['page'] = $('#paginate .pageCover a.select').val();
        
        var searchInfo = document.createElement("input");
        searchInfo.setAttribute("type", "hidden");
        searchInfo.setAttribute("name", "centerSearch");
        searchInfo.setAttribute("value", encodeURI(JSON.stringify(searchObj)));
        form.appendChild(searchInfo);
        
        
        document.body.appendChild(form);
        form.submit();
	}*/
	 /*===========================================================================
		 * 센터 삭제
		 * ---------------------------------------------------------------------------
		 * > 입력 : 
		 * > 출력 : 
		 * > 이동 페이지 :
		 * > 설명 : obj = 각 리스트의 index 번호
		 ===========================================================================*/
		 function delCenter(obj){
			var com = new Object();
			let count = 0;
			<c:forEach var="item" items="${centersList}" varStatus="status">
			if(count==obj){
				com['centerCode'] = "${item.centerCode}";
				com['centerName'] = "${item.centerName}";
				com['centerTel'] = "${item.centerTel}";
				com['unitPrice'] = "${item.unitPrice}";
				com['operTimeStart'] = "${item.operTimeStart}";
				com['operTimeEnd'] = "${item.operTimeEnd}";
				com['unitTime'] = "${item.unitTime}";
				com['ratingScore'] = "${item.ratingScore}";
				com['ratingNum'] = "${item.ratingNum}";
				com['centerAdd'] = "${item.centerAdd1}" + " ${item.centerAdd2}" + " ${item.centerAdd3}";
				com['minTime'] = "${item.minTime}";
				com['premiumRate'] = "${item.premiumRate}";
				com['surchageTime'] = "${item.surchageTime}";
			}	
			count++;
		</c:forEach>
		if(!confirm('정말로 선택하신 업체를 삭제하시겠습니까?')){
			return;
		}
			
			$.ajax({
				type:"post",
				async: false,
				url:"${contextPath}/admin/delCenter.do",
				dataType:"text",
				data:{"center" : JSON.stringify(com)},
				success:function(data, status){
					alert("삭제했습니다.");
				},
				error: function(data, status) {
					alert("error");
		        }
			})  
			
			searchCenter();
		}
	 
		 /*\\ ===========================================================================
			 * 센터 다중 삭제
			 * ---------------------------------------------------------------------------
			 * > 입력 : 
			 * > 출력 : 
			 * > 이동 페이지 : 
			 * > 설명 : 
			 ===========================================================================*/
			 function chkDelCenter(){
				var centersList = [];
				
				<c:forEach var="item" items="${centersList}" varStatus="status">
					var list = new Object();
					list['centerCode'] = "${item.centerCode}";
					list['centerName'] = "${item.centerName}";
					list['centerTel'] = "${item.centerTel}";
					list['unitPrice'] = "${item.unitPrice}";
					list['operTimeStart'] = "${item.operTimeStart}";
					list['operTimeEnd'] = "${item.operTimeEnd}";
					list['unitTime'] = "${item.unitTime}";
					list['ratingScore'] = "${item.ratingScore}";
					list['ratingNum'] = "${item.ratingNum}";
					list['centerAdd'] = "${item.centerAdd1}" + " ${item.centerAdd2}" + " ${item.centerAdd3}";
					list['minTime'] = "${item.minTime}";
					list['premiumRate'] = "${item.premiumRate}";
					list['surchageTime'] = "${item.surchageTime}";
					centersList.push(list);
				</c:forEach>
				
				var chkObj = new Object();
				var delCentersObj = [];
				var targets = document.getElementsByClassName('comChk');
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
						
						delCentersObj[count++] = centersList[i];
					}
				}
				
				if(isEmpty(delCentersObj)) {
					alert("체크된 항목이 없습니다. 다시 선택해 주세요.");
					return;
				}
				
				if(!confirm("정말 삭제하시겠습니까?")) return;
				
				$.ajax({
					type:"post",
					async: false,
					url:"${contextPath}/admin/delCentersList.do",
					dataType:"text",
					data:{"list" : JSON.stringify(delCentersObj)},
					success:function(data, status){
						alert("삭제했습니다.");
					},
					error: function(data, status) {
						alert("error");
			        }
				}) 
				
				searchCenter();
			}

	
	/* ===========================================================================
	 * 센터 예약
	 * ---------------------------------------------------------------------------
	 * > 입력 : 
	 * > 출력 : - 
	 * > 이동 페이지 :  /admin/addReserveForm.do
	 * > 설명 : 
		 	- 
	 ===========================================================================*/
	 function reservCenter(centerCode){
		// form 생성
		var form = document.createElement("form");
        form.setAttribute("charset", "UTF-8");
        form.setAttribute("method", "Post");  //Post 방식
        form.setAttribute("action", "${contextPath}/admin/addReserveForm.do"); //요청 보낼 주소
		
        // 선택된 Center userId
		var center = document.createElement("input");
		center.setAttribute("type", "hidden");
		center.setAttribute("name", "centerCode");
		center.setAttribute("value", centerCode);
        form.appendChild(center);
		
        
        document.body.appendChild(form);
        form.submit();
	}

	
	// ==================================== //
	// ========== pagination ============== //
	// ==================================== //
	let page = <c:out value="${centerSearch.page}" default="1" />
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
	 	$('#searchContents').on('keydown',function(event){
	 		if(event.keyCode == 13)
	   	     {
	 			
	 			searchCenter();
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
		
		let totalList = "${centerSearch.maxPage}";
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
			
			searchCenter(String(setPage));
			return;
			
		}
		if(event.context.id == 'next'){
			if(maxPaging < 1){
				return;
			}
			var setPage = pagingGroup * 10 + 1;
			
			searchCenter(String(setPage));
			return;
		}
		
		searchCenter(String(event.context.id));
		return;
        
	}
</script>
</head>
<body>



	<div id="container">
		<div class="width_wrap">
			<div class="search_wrap">
				<form method="post" action="#" id='frmCenterList' onsubmit="return false">
					<fieldset>
						<legend>업체관리 검색창</legend>
						<ul class="search_list clear_both">
							<li>
								<label for="study_center">조회정보</label>
								<span class="input_wrap"><select id="searchFilter" name="searchFilter">
									<option value="centerCode">업체코드</option>
									<option value="centerName">업체명</option>
									<option value="centerTel">업체번호</option>
									<option value="centerAdd">업체주소</option>
								</select></span>
								<span class="input_wrap"><input type="text" name="searchContents" id="searchContents"  value="${centerSearch.searchContents }"><input type="hidden"></span> <!-- text name값 설정 -->
								
							</li>	
							
							<li>
                                <span class="search_btn_wrap">
                                
                                <strong class="btn_cover"><i class="icon icon-search"></i><input class="search_btn" type="submit" value="조회" onclick="searchCenter()"></strong>
                                </span>
							</li>
						</ul>
					</fieldset>
				</form>
			</div>
			<!--  search_wrap end -->
			
			<div class="contents_wrap">
				<div class="contents">
					<table class="centerContents">
						<thead>	
							<tr>
								<th>선택</th>
								<th>업체코드</th>
								<th>업체명</th>
								<th>지역</th>
								<th>전화번호</th>
								<th>예약</th>
								<th>수정</th>
								<th>삭제</th>
							</tr>
						</thead>
						<c:choose>
						<c:when test="${centersList eq '' || empty centersList  }">
							<tr>
								<th colspan="8" style="padding:30px 0;">현재 등록된 카페 정보가 없습니다.</th>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="centerTable" items="${centersList }" varStatus="status">
								<tr>
									<td><input value="${status.index}" type="checkbox" class="comChk" name="comchk${status.index }"></td>
									<td>${centerTable.centerCode }</td>
									<td>${centerTable.centerName }</td>
									<td>${centerTable.centerAdd1 } ${centerTable.centerAdd2 } ${centerTable.centerAdd3 }</td>
									<td>${centerTable.centerTel}</td>
									<td><button type="button" class="reservBtn" onclick="reservCenter('${centerTable.centerCode }')" value="예약"><i class="icon icon-calendar"></i></button></td>
									<td><button type="button" class="editBtn" onclick="editCenter('${centerTable.centerCode }')" value="수정"><i class="icon icon-checkmark"></i></button></td>
									<td><button type="button" class="delBtn" onclick="delCenter('${status.index}')" value="삭제"><i class="icon icon-cross"></i></button></td>
								</tr>
							</c:forEach> 
						</c:otherwise>
					</c:choose> 
					</table>
					<p class="editBtn_wrap">
						<a href="${contextPath}/admin/centerAddForm.do" class="comAdd"><strong>등록</strong></a>
						<a href="#"  onclick="chkDelCenter()" class="comDel"><strong>센터삭제</strong></a> 
					</p>
					<div id="paginate">
					</div>
				</div>
				<!-- Contents end-->
			</div>
			
		</div>
	</div>
</body>
</html>