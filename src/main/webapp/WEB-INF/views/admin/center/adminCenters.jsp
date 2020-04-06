<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false" %>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin업체관리</title>

<link rel="stylesheet" type="text/css" href="${contextPath }/css/reset.css">
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/adminCompanyList.css">
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
	 * 1. 센터 예약
	 * ---------------------------------------------------------------------------
	 * > 입력 : 
	 * > 출력 : - 
	 * > 이동 페이지 :  /admin/addReserveForm.do
	 * > 설명 : 
		 	- 
	 ===========================================================================*/
	 function reservCenter(userId){
		// form 생성
		var form = document.createElement("form");
        form.setAttribute("charset", "UTF-8");
        form.setAttribute("method", "Post");  //Post 방식
        form.setAttribute("action", "${contextPath}//admin/addReserveForm.do"); //요청 보낼 주소
		
        // 선택된 Member userId
		var center = document.createElement("input");
		center.setAttribute("type", "hidden");
		center.setAttribute("name", "centerCode");
		center.setAttribute("value", centerCode);
        form.appendChild(center);
		
        
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
	 function editCenter(userId){
		// form 생성
		var form = document.createElement("form");
        form.setAttribute("charset", "UTF-8");
        form.setAttribute("method", "Post");  //Post 방식
        form.setAttribute("action", "${contextPath}/admin/modCenterForm.do"); //요청 보낼 주소
		
        // 선택된 Member userId
		var center = document.createElement("input");
		center.setAttribute("type", "hidden");
		center.setAttribute("name", "centerCode");
		center.setAttribute("value", centerCode);
        form.appendChild(center);

        
        // searchInfo
        var searchObj = new Object();
        searchObj['searchFilter'] = document.getElementById("searchFilter").value;
        searchObj['searchContent'] = document.getElementById("searchContent").value;
        searchObj['page'] = $('#paginate .pageCover a.select').val();
        
        var searchInfo = document.createElement("input");
        searchInfo.setAttribute("type", "hidden");
        searchInfo.setAttribute("name", "centerSearch");
        searchInfo.setAttribute("value", encodeURI(JSON.stringify(searchObj)));
        form.appendChild(searchInfo);
        
        
        document.body.appendChild(form);
        form.submit();
	}



	/* ===========================================================================
	 * 3. 센터 삭제
	 * ---------------------------------------------------------------------------
	 * > 입력 : 
	 * > 출력 : 
	 * > 이동 페이지 :
	 * > 설명 : obj = 각 리스트의 index 번호
	 ===========================================================================*/
	 function delCenter(obj){
		var com = new Object();
		<c:forEach var="item" items="${membersList}" varStatus="status">
		if(status.index==obj){
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
	 * 4. 센터 다중 삭제
	 * ---------------------------------------------------------------------------
	 * > 입력 : 
	 * > 출력 : 
	 * > 이동 페이지 : 
	 * > 설명 : 
	 ===========================================================================*/
	 function chkDelMember(){
		var membersList = [];
		
		<c:forEach var="item" items="${centersList}" varStatus="status">
			var list = new Object();
			list['centerCode'] = "${item.centerCode}";
			list['centerName'] = "${item.centerName}";
			list['centerAdd'] = "${item.centerAdd}" + " ${item.centerAdd2}" + " ${item.centerAdd3}";
			list['centerTel'] = "${item.centerTel}";
			membersList.push(list);
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
		
		searchMember();
	}


	/* ===========================================================================
	 * 5. 센터 검색
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
        centerSearch['searchContent'] = document.getElementById("companySearch").value;
        centerSearch['page'] = paginate;
        
        var hiddenField = document.createElement("input");
        hiddenField.setAttribute("type", "hidden");
        hiddenField.setAttribute("name", "centerSearch");
        hiddenField.setAttribute("value", encodeURI(JSON.stringify(centerSearch)));
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
				<form method="post" action="#" onsubmit="return false">
					<fieldset>
						<legend>업체관리 검색창</legend>
						<ul class="search_list clear_both">
							<li>
								<label for="companyInfo">조회정보</label>
								<span class="input_wrap"><select id="companyInfo" name="companyInfo">
									<option value="centerCode">업체코드</option>
									<option value="centerName">업체명</option>
								</select></span>
								<span class="input_wrap"><input type="text" name="companySearch" id="companySearch" ><input type="hidden"></span> <!-- text name값 설정 -->
								
							</li>	
							
							<li>
                                <span class="search_btn_wrap">
                                
                                <strong class="btn_cover"><i class="icon icon-search"></i><input class="search_btn" type="submit" value="조회"></strong>
                                </span>
							</li>
						</ul>
					</fieldset>
				</form>
			</div>
			<!--  search_wrap end -->
			
			<div class="content_wrap">
				<div class="content">
					<table class="companyContent">
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
						<tr>
							<td><input type="checkbox" name="comChk01" class="comChk"></td>
							<td>AA11</td>
							<td>르하임스터디룸</td>
							<td>서울시 종로구 어쩌구저쩌구</td>
							<td>02-0000-0000</td>
							<td><button type="button" class="reservBtn" onclick="reservCenter('${memTable.centerCode }')" value="수정"><i class="icon icon-calendar"></i></button></td>
							<td><button type="button" class="editBtn" onclick="editCenter('${memTable.centerCode }')" value="수정"><i class="icon icon-checkmark"></i></button></td>
							<td><button type="button" class="delBtn" onclick="delCenter('${status.index}')" value="삭제"><i class="icon icon-cross"></i></button></td>
						</tr>
						<tr>
							<td><input type="checkbox" name="comChk02" class="comChk"></td>
							<td>CE14</td>
							<td>테스트스터디룸</td>
							<td>서울시 강남구 어쩌구저쩌구</td>
							<td>02-0000-0000</td>
							<td><button type="button" class="reservBtn" onclick="reservCenter('${memTable.centerCode }')" value="수정"><i class="icon icon-calendar"></i></button></td>
							<td><button type="button" class="editBtn" onclick="editCenter('${memTable.centerCode }')" value="수정"><i class="icon icon-checkmark"></i></button></td>
							<td><button type="button" class="delBtn" onclick="delCenter('${status.index}')" value="삭제"><i class="icon icon-cross"></i></button></td>
						</tr>
						<tr>
							<td><input type="checkbox" name="comChk03" class="comChk"></td>
							<td>FH33</td>
							<td>INN스터디룸</td>
							<td>서울시 서초구 어쩌구저쩌구</td>
							<td>02-0000-0000</td>
							<td><button type="button" class="reservBtn" onclick="reservCenter('${memTable.centerCode }')" value="수정"><i class="icon icon-calendar"></i></button></td>
							<td><button type="button" class="editBtn" onclick="editCenter('${memTable.centerCode }')" value="수정"><i class="icon icon-checkmark"></i></button></td>
							<td><button type="button" class="delBtn" onclick="delCenter('${status.index}')" value="삭제"><i class="icon icon-cross"></i></button></td>
						</tr>
						<!--
						<c:choose>
						<c:when test="${centersList eq '' || empty centersList  }">
							<tr>
								<th colspan="8" style="padding:30px 0;">현재 등록된 회원 정보가 없습니다.</th>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="centerTable" items="${centersList }" varStatus="status">
								<tr>
									<td><input value="${status.index}" type="checkbox" class="comChk" name="comchk${status.index }"></td>
									<td>${centerTable.centerCode }</td>
									<td>${centerTable.centerName }</td>
									<td>${centerTable.centerTel}</td>
									<td>${centerTable.centerAdd1 } + " " + ${centerTable.centerAdd2 } + " " + ${centerTable.centerAdd3 }</td>
									<td><button type="button" class="reservBtn" onclick="reservCenter('${memTable.centerCode }')" value="수정"><i class="icon icon-calendar"></i></button></td>
									<td><button type="button" class="editBtn" onclick="editCenter('${memTable.centerCode }')" value="수정"><i class="icon icon-checkmark"></i></button></td>
									<td><button type="button" class="delBtn" onclick="delCenter('${status.index}')" value="삭제"><i class="icon icon-cross"></i></button></td>
								</tr>
							</c:forEach> 
						</c:otherwise>
					</c:choose> 
					-->
					</table>
					<p class="editBtn_wrap">
						<a href="${contextPath}/admin/centersForm.do" class="comAdd"><strong>등록</strong></a>
						<a href="chkDelCenters()" class="comDel"><strong>삭제</strong></a> 
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