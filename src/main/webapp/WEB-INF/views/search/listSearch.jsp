<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	request.setCharacterEncoding("utf-8");
%>
<c:set var="contextPath" value="${pageContext.request.contextPath }"></c:set>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인페이지</title>
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/search/searchList.css">    
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/slider-pro.css">
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/jquery.mCustomScrollbar.css">
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/mDcalendar.picker.css">



<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="${contextPath }/resources/js/loginRequired.js"></script>
<script src="${contextPath }/resources/js/jquery.sliderPro.js"></script>
<script src="${contextPath }/resources/js/jquery.mCustomScrollbar.js"></script>
<script src="${contextPath }/resources/js/mDcalendar.picker.js"></script>
<script>
	$(function(){
		$('.selectDate').dcalendarpicker({
            // default: mm/dd/yyyy
            format:'yyyy-mm-dd'
            });
		$(".scroll_list").mCustomScrollbar({
		    axis:"y",
		    theme:'dark',
	    	mouseWheelPixels: 100,
	    	alwaysShowScrollbar: 2
		});
		$(".timeTableLap").mCustomScrollbar({
		    axis:"y",
		    theme:'dark',
	    	mouseWheelPixels: 100,
	    	alwaysShowScrollbar: 2
		});
	

		// 검색 초기값 설정
		$('.searchDate').val('${searchInfo.searchDate}')
		$('#city option[value="${searchInfo.searchAdd1}"]').attr('selected',true);
		$('#gu option[value="${searchInfo.searchAdd2}"]').attr('selected',true);
		$('.scale').val('${searchInfo.scale}');
		
		$('.scrollArea .selRoom').on('click',function(){
			$(this).toggleClass("check");
		})
		var facilityChk = {
			'printer' : '${facility.printer}',
			'locker' : '${facility.locker}',
			'projector' : '${facility.projector}',
			'noteBook' : '${facility.noteBook}',
			'whiteBoard' : '${facility.whiteBoard}'
		}
		var filter = $('.filter');
		for(var i in facilityChk){
			
			if(facilityChk[i] != '0'){
				$('#'+i).prop('checked',true);
				$('#'+i).next().addClass('check');
			}else if(facilityChk[i] == '0'){
				$('#'+i).prop('checked',false);
				$('#'+i).next().removeClass('check');
			}
		}
	});
	
	
	
	
	
	
	// ========================== //
	// ======== 상세보기  01 ========== //
	// ======================== //
	function viewDetail(centerCode, centerName){
		$.ajax({
			type:'post',
			url:'${contextPath}/center/showCenterContents.do',
			data:{'centerCode':centerCode},
			dataType:'json',
			success:function(data, textStatus){
				viewContent(data, centerName, centerCode);
			}
			
		})		
		
	}
	
	// ========================== //
	// ======== 상세보기 ========== //
	// ======================== //
	let loadFavorite = function(centerCode){
		var marks;
		$.ajax({
			type:'post',
			url:'${contextPath}/favorite/isFavorite.do',
			dataType:'text',
			async:false,
			data:{'centerCode':centerCode},
			success:function(data, textStatus){
				
				if(data){
					
					marks = data;
				}else{
					
					marks = data;
				}
				
				
			},
			error:function(data,textStatus){
			}
		})
		
		return marks;
	}
	function viewContent(data, centerName, centerCode){
		
		$('body').css('overflow','hidden');
		var docWrap = document.createElement('div');
		docWrap.setAttribute('class','pageCover');
		
		
		// background 배경
		
		var detailCover = document.createElement('div');
		detailCover.setAttribute('class','detailCover');
		// 상세보기 페이지 작업영역;
		// </div></div>
		var detailArea = document.createElement('div');
		detailArea.setAttribute('class','detailArea');
		
		var detail = document.createElement('div');
		detail.setAttribute('class','detail');
		
		
		
		
		
		
		

		var setTitle = document.createElement('div');
		setTitle.setAttribute('class','detailTitle');
		var marks =loadFavorite(centerCode);
		
		if(marks == 'true'){
			setTitle.innerHTML = "<h4>"+centerName+"</h4><button class='mark'><i clsas='icon-bookmarks'></i><span class='none'>북마크</span></button>";
			
		}else{
			setTitle.innerHTML = "<h4>"+centerName+"</h4><button class='none'><i clsas='icon-bookmarks'></i><span class='none'>북마크</span></button>";
			
		}
		
		// 타이틀 설정
		detail.appendChild(setTitle);
		
		var photoLists = document.createElement('div');
		photoLists.setAttribute('class','photoListWrap slider-pro');
		
		var setPhotoList = "<div class='photoLists sp-slides'>";
		
		var imgArray = new Array();
		
		for(var item in data){
			
			
			if(item.indexOf('Photo') != -1){
				imgArray[imgArray.length] = data[item];
			}
		}
		
		
		for(var i = 0; i < imgArray.length; i++){
			if(imgArray[i] == 'null' || imgArray[i] == null){
				break;
			}
			setPhotoList += '<div class="photoList sp-slide"><a href="#"><img class="sp-image" src="${contextPath}'+imgArray[i]+'" alt="스터디룸 사진"></a><div>';
		}
	
		
		
		// for문 돌리기
		// '<li class="photoList"><figure><img src="${contextPath}/'+data.roomPhoto+' alt="스터디룸 사진"></figure><li>';
		
		photoLists.innerHTML = setPhotoList;
		detail.appendChild(photoLists);
		
		var roomDetailText = document.createElement('div');
		roomDetailText.setAttribute('class','roomDetailText');
		// 소개내용 부모요소
		
		
		var roomSelectArea = document.createElement('ul');
		roomSelectArea.setAttribute('class','roomSelectArea clear_both');
		
		roomSelectArea.innerHTML = '<li class="float_left"><a href="#" class="on">센터 소개</a></li><li class="float_left"><a href="#">요금</a></li><li class="float_left"><a href="#">주의사항</a></li>'
		
		
		var introduce = document.createElement('div');
		introduce.setAttribute('class','introduce text_area');
		introduce.innerHTML = "<p>"+data.centerIntroduce+"</p>";
		
		var fareInfo = document.createElement('div');
		fareInfo.setAttribute('class','fareInfo text_area');
		fareInfo.innerHTML = "<p>"+data.centerFareInfo+"</p>";
		
		var useInfo = document.createElement('div');
		useInfo.setAttribute('class','useInfo text_area');
		useInfo.innerHTML = "<p>"+data.centerUseInfo+"</p>";
		
		roomDetailText.appendChild(roomSelectArea);
		roomDetailText.appendChild(introduce);
		roomDetailText.appendChild(fareInfo);
		roomDetailText.appendChild(useInfo);
		
		detail.appendChild(roomDetailText);
		
		detailArea.appendChild(detail);
		detailCover.appendChild(detailArea);
		docWrap.appendChild(detailCover);
		
		document.body.appendChild(docWrap);
		
		
		$('.roomSelectArea li a').on('click',function(){
			$('.roomSelectArea li a').removeClass('on');
			$(this).addClass('on');
			var getIndex = $(this).parent('li').index();
			$('.roomDetailText > div').removeClass('on');
			$('.roomDetailText > div').eq(getIndex).addClass('on');
		})
		$( '.photoListWrap' ).sliderPro({
			width: 300,
			height: 300,
			visibleSize: '100%',
			//forceSize: 'fullWidth',
			autoSlideSize: true
		});
		$('.pageCover').on('click',function(){
			$(this).remove();
			$('body').css('overflow','auto');
		})
		$('.detailArea').on('click',function(){
			event.stopPropagation();
			return false;
		})
		$(".detailArea").mCustomScrollbar({
		    axis:"y",
		    theme:'dark',
	    	mouseWheelPixels: 100,
	    	//alwaysShowScrollbar: 2
		});
		
		$('.detailTitle button').on('click',function(){
			$(this).toggleClass('mark');
			if($(this).hasClass('mark')){
				editFavorite(centerCode,'true');
			}else{
				editFavorite(centerCode,'false');
			}
		})
		
		
	}
	
	let editFavorite = function(centerCode, booln){
		if(booln == 'true'){
			$.ajax({
				type:'post',
				url:'${contextPath}/favorite/addFavorite.do',
				dataType:'text',
				data:{'centerCode':centerCode},
				success:function(data,textStatus){
					alert("즐겨찾기 리스트에 등록되었습니다.");
				},
				error:function(data, textStatus){
					
				}
			})
			return false;
		}else{
			$.ajax({
				type:'post',
				url:'${contextPath}/favorite/delFavorite.do',
				dataType:'text',
				data:{'centerCode':centerCode},
				success:function(data,textStatus){
					alert("즐겨찾기 리스트에서 삭제되었습니다.");
				},
				error:function(data, textStatus){
					
				}
			})
			 return false;
		}
		
	}
	
	
	// ========================== //
	// ======== 센터 선택 ========== //
	// ======================== //
	
	let _openTime = '';
	let _closeTime = '';
	let _minTime = '';
	let _unitTime = '';
	
	function selectCenter(centerCode, openTime, closeTime, minTime, unitTime){
		_openTime = openTime / 60;
		_closeTime = closeTime / 60;
		_minTime = minTime / 60;
		_unitTime = unitTime / 60;
		var minHour, minMinute;
		if(minTime > 60){
			 minHour = minTime / 60;
			 minMinute = minTime % 60;
		}else{
			minMinute = minTime;
		}
		if(minMinute == '0') minMinute = '00';
		if(minHour == 0 || minHour == null){
			$('.reservInfo span i').text(minMinute);
		}else{
			$('.reservInfo span i').text(minHour +" : "+minMinute);
		}
		
		$('.selectArea').removeClass('on');
		event.target.parentNode.parentNode.parentNode.nextSibling.nextElementSibling.classList.toggle('on');
		$.ajax({
			type:'post',
			url:'${contextPath}/reserve/addReserveForm.do',
			dataType:'json',
			data:{'centerCode':centerCode},
			success:function(data, textStatus){
				selectReserv(data, centerCode)
			}
		})
	}
	

	
	let selectCenterCode = '';
	let selectRoomName = '';
	let selectScale = '';
	function selectReserv(data, centerCode){
		selectCenterCode = centerCode;
		// 선택한 centerCode 저장
		var setIndex = $('.selectArea.on').parent('li').index();
		
		$('.selectArea .scrollArea > ul > *').remove();
		data.forEach(function(item, index, array){
			$('.selectArea.on .scrollArea > ul')[0].innerHTML += '<li><button type="button" class="selRoom" data-roomName="'+item.roomName+'" data-roomCode='+item.roomCode+' data-roomScale='+item.scale+'>'+item.roomName+'<span>'+ item.scale+'인실</span></button></li>'
			
		});
		// 입력 : centerCode, roomCode, reserveDate (ajax/post)
		$('.selectArea.on .selRoom').on('click',function(){
			$('.scrollArea .selRoom').removeClass('chk');
			$(this).addClass('chk');
			selectRoomCode = $(this).data('roomcode');
			selectRoomName = $(this).data('roomname');
			selectScale = $(this).data('roomscale');
			$.ajax({
				type:'post',
				url:'${contextPath}/admin/usableTime.do',
				dataType:'text',
				data:{
					'centerCode':centerCode,
					'roomCode':selectRoomCode,
					'reserveDate':$('.selectDate').val()
				},
				success:function(data, textStatus){
					setTimeTable(data);
				}
			})
		})
	}
	
	
	
	// ========================== //
	// ======== 시간표 업데이트 ========== //
	// ======================== //
	// _openTime _closeTime _minTime _unitTime 
	// selectRoomName selectScale
	function setTimeTable(data){
		
		
		
		var _reservIndex = new Array();
	    for(var i = 0; i < data.length; i++){
	        _reservIndex[i] = data.substr(i,1);
	    }
	    
	    var count = 0;
	    $('.timeTable > ul > *').remove();
		for(var time = _openTime; time < _closeTime; time += _unitTime){
			var timeObj = {
				'startHour' : Math.floor(time),
				'startTime' : _openTime * 60,
				'endHour' : Math.floor(time+_unitTime),
				'endTime' : _closeTime * 60
			};
			//'startMinute' : (time - timeObj.startHour) * 60,
			//'endMinute' : ((time+_unitTime) - timeObj.endHour) * 60,
			timeObj.startHour = (timeObj.startHour < 10) ? "0"+timeObj.startHour: timeObj.startHour;
			timeObj.endHour = (timeObj.endHour < 10) ? "0"+timeObj.endHour: timeObj.endHour;
			timeObj.startMinute = ((time - timeObj.startHour) * 60) < 10 ? "0"+(time - timeObj.startHour) * 60 : (time - timeObj.startHour) * 60 ;
			timeObj.endMinute = ((time + _unitTime - timeObj.endHour) * 60) < 10 ? '00' : (time + _unitTime - timeObj.endHour) * 60;
			
			var setHtml = "<li class='time_list'><div><button type='button' class='table_btn' data-start-hour="+timeObj.startHour+" data-start-minute="+timeObj.startMinute+" data-start-time="+timeObj.startTime+" data-end-hour="+timeObj.endHour+" data-end-minute="+timeObj.endMinute+" data-end-time="+timeObj.endTime+">";
			setHtml += "<span class='time'><strong title='대관시작'>"+timeObj.startHour+":"+timeObj.startMinute+"</strong><em title='대관종료'>~"+timeObj.endHour+":"+timeObj.endMinute+"</em></span>";
			setHtml += "<span class='title'><strong title="+selectRoomName+">"+selectRoomName+"</strong><em title="+selectScale+">"+selectScale+"인실</em></span>"
			setHtml += "<span class='status'>";
			setHtml += (_reservIndex[count++] == 0) ? "<span class='true'>예약가능</span>":"<span class='false'>예약불가</span>"+"</span></button></div></li>";
			$('.selectArea.on .timeTable > ul').append(setHtml);
		}
		
		
		selectTimeBtn()
	}
	
	
	
	// ========================== //
	// ======== 시간표 선택시 Event  ========== //
	// ======================== //  
	function selectTimeBtn(){
		$('.time_list .table_btn').on('click',function(){
			let getIndex= [$(this).parent('div').parent('li').index()];
			
			if($(this).children('span.status').children('span').hasClass('false')){
				alert("예약이 불가능한 시간입니다. 다시 선택해 주세요.")
				return;
			}
			$('.time_list').each(function(e){
				if($(this).find('button').hasClass('check')){
					getIndex[getIndex.length] = e;
				}
			})
			$(this).toggleClass('check');
			
			if(getIndex.length == 3){
				$('.time_list .table_btn').removeClass('check');
				$('.time_list .table_btn').removeClass('ing');
				$(this).addClass('check');
				getIndex.splice(0);
			}
			if(getIndex[0]< getIndex[1]){
				$(this).removeClass('check');
				alert('시간을 잘못 선택하셨습니다.');
				getIndex.splice(1,1);
			}else if(getIndex[0] > getIndex[1]){
				
				$('.time_list').each(function(e){
					if( e > getIndex[1] && e < getIndex[0]){
						$(this).children('div').children('button').addClass('ing');
						if($(this).children('div').children('button').children('span.status').children('span').hasClass('false')){
							alert("예약이 불가능한 시간이 섞여있습니다. 다시 선택해 주세요.")
							$('.time_list .table_btn').removeClass('check');
							$('.time_list .table_btn').removeClass('ing');
							return false;
						}
					}else{
						$(this).children('div').children('button').removeClass('ing');
					}
				})
			}
		})
	}
	
	
	// ========================== //
	// ======== 예약하기 ========== //
	// ======================== //
	// 경로 : /reserve/confirmReserve.do
	/*
	// 입력 파라미터 
    // 1. userId
    // 2. centerCode
    // 3. roomCode
    // 4. reserveDate
    // 5. usingTime
    // 6. extraCode
	// scale
		
	*/
	
	function reservNext(centerCode){
		var userId = "<%= session.getAttribute("logonId")%>";
		
		var reserveDate = $('.selectArea.on .selectDate').val();
		var roomCode = $('.selectArea.on .selRoom.chk').data('roomcode');
		var usingTime = '';
		$('.selectArea.on .timeTable .time_list').each(function(e){
			var target = $(this).children('div').children('button');
			if(target.hasClass('check') || target.hasClass('ing')){
				usingTime += '1';
			}else{
				usingTime += '0';
			}
		});
		var selectTime = (usingTime.match(/1/g) || []).length;
		if(selectTime == 0) {
			alert('시간을 선택해주세요.');
			return;
		}
		var reservTime = (selectTime * _unitTime * 60);
		if(reservTime < (_minTime * 60)){
			alert("최소 예약시간보다 적게 예약하실 수 없습니다. 다시 선택해 주세요.");
			$('.selectArea.on .table_btn').removeClass('ing');
			$('.selectArea.on .table_btn').removeClass('check');
			return;
		}
		
		var reserve = {
				'userId' : userId,
				'centerCode' : centerCode,
				'roomCode' : roomCode,
				'reserveDate' : reserveDate,
				'usingTime' : usingTime,
				'extraCode' : ''
		}
		var scale = $('.selectArea.on .selRoom.chk').data('roomscale');
		
		var setForm = document.createElement('form');
		setForm.setAttribute('method','post');
		setForm.setAttribute('action','${contextPath}/reserve/confirmReserve.do');
		setForm.setAttribute('name','addReserve');
		setForm.setAttribute('encType','UTF-8');
		
		var setReserve = document.createElement('input');
		setReserve.setAttribute('name','reserve');
		setReserve.setAttribute('type','hidden');
		setReserve.setAttribute('value',JSON.stringify(reserve));
		
		setForm.appendChild(setReserve);
		
		var setScale = document.createElement('input');
		setScale.setAttribute('name','scale');
		setScale.setAttribute('type','hidden');
		setScale.setAttribute('value',scale);
		setForm.appendChild(setScale);
		
		document.body.appendChild(setForm);
		setForm.submit();
		
		
		
		
	}
	
	// searchInfo
	// centerList
	/*
	private Date searchDate;
	private String searchAdd1;
	private String searchAdd2;
	private Integer scale;
	private Integer sort; // 0:이름순, 1: 낮은가격순, 2: 인기순
	private Integer page;
	private Integer maxNum;
	*/
	
	/*
	private String centerCode;
	private String centerName;
	private String centerTel;
	private int unitPrice;
	private int operTimeStart;
	private int operTimeEnd;
	private int unitTime;
	private float ratingScore;
	private int ratingNum;
	private String centerAdd1;
	private String centerAdd2;
	private String centerAdd3;
	private int minTime;
	private int premiumRate;
	private int surchageTime;
	// CenterContents
	private String centerPhoto;
	// Facility
	private Integer locker;
	private Integer projector;
	private Integer printer;
	private Integer noteBook;
	private Integer whiteBoard;
	*/
	
	
	
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
		
		if(pagingGroup != 1){
			html += "<span class='pagePrev'><button  id='prev'><i class='larr'></i>prev</button></span><span class='pageCover'>";
		}else{
			html += "<span class='pageArea'>";
		}
		
		
		for(var i=firstPage; i <= lastPage; i++){
			if(i > maxNum) break;
			if(i == page){
				html += "<a href='#' id=" + i + " class='select'>" + i + "</a> ";
			}else{
				html += "<a href='#' id=" + i + ">" + i + "</a> ";
			}
		}
		
		
		
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
			
			setSearch(String(setPage));
			return;
			
		}
		if(event.context.id == 'next'){
			if(maxPaging < 1){
				return;
			}
			var setPage = pagingGroup * 10 + 1;
			
			setSearch(String(setPage));
			return;
		}
		
		setSearch(String(event.context.id));
		return;
        
	}
	
</script>
</head>
<body>
	 <div class="content_block">
    <div class="block_wrap">
               
        <div class="searchList_wrap">
            <ul>
            
            <c:choose>
	            <c:when test="${centerList eq '' || empty centerList  }">
					<li class="notList">
						<p style="padding:30px 0; text-align:center; font-size:17px; font-weight:500; ">검색된 센터가 없습니다.</p>
					</li>
				</c:when>
				<c:otherwise>
				<c:forEach var="board" items="${centerList }">
            	<li class="list_box">
                    <div class="box_cover">
                        <div class="img_wrap">
                            <figure><img src="${contextPath }/${board.centerPhoto }"></figure>
                        </div>
                        <div class="txt_wrap">
                            <div class="box_title">
                                <h5>${board.centerName }</h5>
                            </div>
                            <div class="sub_txt">
                                <dl class="clear_both">
                                    <dt>주소</dt>
                                    <dd><p>${board.centerAdd1 } ${board.centerAdd2 } ${board.centerAdd3 }</p></dd>
                                </dl>
                                <dl class="clear_both">
                                    <dt>평점</dt>
                                    <dd>
                                    	<p class="starRev">
                                   		<c:forEach var="i" begin="1" step="1" end="10" varStatus="status">
                                   			<c:set var="j" value="${i / 2 }"/>
                                   			<c:choose>
                                   				<c:when test="${j >= board.ratingScore }">
                                   					
                                   				</c:when>
                                   				<c:otherwise>
	                                   				<c:if test="${j % 1 > 0 }">
		                                   				<span class="starR1 on">${i }</span>
		                                   			</c:if>
		                                   			<c:if test="${j % 1 == 0 }">
		                                   				<span class="starR2 on">${i }</span>
		                                   			</c:if>
                                   				</c:otherwise>
                                   			</c:choose>
                                   			
                                   		</c:forEach>
                                    	</p>
                                    </dd>
                                </dl>
                                <dl class="clear_both">
                                    <dt>운영시간</dt>
                                    <dd><p>
                                    <c:choose>
	                                    <c:when test="${board.operTimeStart / 60 < 10}">
	                                    		<fmt:parseNumber var="startDate" value="${board.operTimeStart / 60}" type="number" />
	                                    		0${startDate }
	                                    </c:when>
	                                    <c:otherwise>
	                                    <fmt:parseNumber var="startDate" value="${board.operTimeStart / 60}" type="number" />
	                                    	${startDate }
	                                    </c:otherwise>
                                   	</c:choose>
                                   	<c:choose>
	                                    <c:when test="${board.operTimeStart % 60  == 0}">
	                                    		: 00  ~  
	                                    </c:when>
	                                    <c:otherwise>
	                                    	${board.operTimeStart % 60} ~ 
	                                    </c:otherwise>
                                   	</c:choose>
                                   	<c:choose>
	                                    <c:when test="${board.operTimeEnd / 60 < 10}">
	                                    <fmt:parseNumber var="endDate" value="${board.operTimeEnd / 60}" type="number" />
	                                    		0${endDate}
	                                    </c:when>
	                                    <c:otherwise>
	                                    <fmt:parseNumber var="endDate" value="${board.operTimeEnd / 60}" type="number" />
	                                    	${endDate}
	                                    </c:otherwise>
                                   	</c:choose>
                                   	<c:choose>
	                                    <c:when test="${board.operTimeEnd % 60  == 0}">
	                                    		: 00
	                                    </c:when>
	                                    <c:otherwise>
	                                    	: ${board.operTimeEnd % 60} 
	                                    </c:otherwise>
                                   	</c:choose>
                                    </p></dd>
                                </dl>
                                <dl class="equp clear_both">
                                    <dt>구비물품</dt>
                                    <dd>
                                        <p data-printer="${board.printer }" data-projector="${board.projector }" data-noteBook="${board.noteBook }" data-locker="${board.locker }" data-whiteBoard="${board.whiteBoard }">
                                        <c:if test="${board.printer == 1 }">
                                        <span class="setPrinter">
                                           <i class='icon-printer'></i>프린터
                                        </span>	
                                        </c:if>
                                        <c:if test="${board.projector == 1 }">
                                        <span class='setProjecter'>
                                            <i class='icon-video-camera'></i>프로젝터
                                        </span>
                                        </c:if>
                                        <c:if test="${board.locker == 1 }">
                                        <span class="setLocker">
                                           <i class="icon-box-add"></i>사물함
                                        </span>
                                        </c:if>
                                        <c:if test="${board.noteBook == 1 }">
                                        <span class="setNotebook">
                                            <i class="icon-laptop"></i>노트북
                                        </span>
                                        </c:if>
                                        <c:if test="${board.whiteBoard == 1 }">
                                        <span class="setWhiteboard">
                                            <i class="icon-display"></i>화이트보드
                                        </span>
                                        </c:if>
                                        </p>
                                    </dd>
                                </dl>
                            </div>
                            <div class="priceLap">
                                <h4 class="red align_right">
                                
                                
                                    <span>\</span><b class="price"><fmt:formatNumber value="${board.unitPrice }" pattern="#,###" /></b>
                                </h4>
                            </div>
                        </div>
                        <div class="btn_wrap">
                            <div class="">
                                <!-- centerCode ? -->
                                <button type="button" class="btn_type_03 " onclick="viewDetail('${board.centerCode}','${board.centerName }')">상세보기</button> 
                                <!-- centerCode ? -->
                                <button type="button" class="btn_type_03" onclick="selectCenter('${board.centerCode}','${board.operTimeStart }','${board.operTimeEnd }','${board.minTime }','${board.unitTime }')">선택하기</button>
                            </div>
                        </div>
                    </div>
                    
                    
                    <div class="selectArea">
                        	<div class="selectBorder">
                        		<ul class="clear_both">
                        		<li>
	                        		<dl>
		                        		<dt><strong>날짜</strong></dt>
		                        		<dd>
		                        		<input type="text" readonly class="selectDate" name="selectDate" value="${searchInfo.searchDate }">
		                        		</dd>
	                        		</dl>
                        			
                        			
                        		</li>
                        		<li>
                        		<dl>
	                        		<dt><strong>방선택</strong></dt>
	                        		<dd>
		                        		<div class="scroll_list">
		                        			<div class="scrollArea">
		                        				<ul>
		                        				</ul>
		                        			</div>
		                        		</div>
		                    		</dd>
                        		</dl>
                        		</li>
                        		<li>
                        			<dl>
                        				<dt><strong>시간</strong></dt>
                        				<dd>
                        					<div class="timeTableLap">
                        						<div class="timeTable">
	                        						<ul>
	                        							
	                        						</ul>
                        						</div>
                        					</div>
                        				</dd>
                        			</dl>
                        		</li>
                        		</ul>
                        	</div>
                        	<p class="reservInfo align_right">
                        		<span class="small red">※ 최소 예약시간 : <i class="min_reserv"></i></span>
                        	</p>
                        	<p class="clear_both">
                        		<button type="button" onclick="reservNext('${board.centerCode}')" class="btn_type_03 submitBtn float_right">예약하기</button>
                        	</p>
                        </div>
                </li>
            </c:forEach>
				</c:otherwise>
            </c:choose>
            
                <li class="list_box">
                    <div class="box_cover">
                        <div class="img_wrap">
                            <figure><img src="http://placehold.it/200x200"></figure>
                        </div>
                        <div class="txt_wrap">
                            <div class="box_title">
                                <h5>르하임 스터디 카페</h5>
                            </div>
                            <div class="sub_txt">
                                <dl class="clear_both">
                                    <dt>주소</dt>
                                    <dd><p>서울특별시 종로구 종로동 126-3 3층 302호</p></dd>
                                </dl>
                                <dl class="clear_both">
                                    <dt>평점</dt>
                                    <dd><p><i class="icon-star yellow"></i></p></dd>
                                </dl>
                                <dl class="clear_both">
                                    <dt>운영시간</dt>
                                    <dd><p>10:00 ~ 20:00</p></dd>
                                </dl>
                                <dl class="equp clear_both">
                                    <dt>구비물품</dt>
                                    <dd>
                                        <p>
                                            <span class="setPrinter">
                                                <i class='icon-printer'></i>
                                                프린터
                                            </span>
                                            <span class='setProjecter'>
                                                <i class='icon-video-camera'></i>
                                                프로젝터
                                            </span>
                                            <span class="setLocker">
                                                <i class="icon-box-add"></i>
                                                사물함
                                            </span>
                                            <span class="setNotebook">
                                                <i class="icon-laptop"></i>
                                                노트북
                                            </span>
                                            <span class="setWhiteboard">
                                                <i class="icon-display"></i>
                                                화이트보드
                                            </span>
                                        </p>
                                    </dd>
                                </dl>
                            </div>
                            <div class="priceLap">
                                <h4 class="red align_right">
                                    <span>\</span><b class="price">89,000</b>
                                </h4>
                            </div>
                        </div>
                        <div class="btn_wrap">
                            <div class="">
                                <!-- centerCode ? -->
                                <button type="button" class="btn_type_03 " onclick="viewDetail()">상세보기</button> 
                                <!-- centerCode ? -->
                                <button type="button" class="btn_type_03" onclick="selectCenter()">선택하기</button>
                            </div>
                        </div>
                        
                    </div>
                    
                    
                    <div class="selectArea">
                        	<div class="selectBorder">
                        		<ul class="clear_both">
                        		<li>
	                        		<dl>
		                        		<dt><strong>날짜</strong></dt>
		                        		<dd>
		                        		<input type="text" readonly class="selectDate" name="selectDate"></table>
		                        		</dd>
	                        		</dl>
                        			
                        			
                        		</li>
                        		<li>
                        		<dl>
	                        		<dt><strong>방선택</strong></dt>
	                        		<dd>
		                        		<div class="scroll_list">
		                        			<div class="scrollArea">
		                        				<ul>
		                        					<li><button type="button" class="selRoom" data-roomName="" data-roomCode="" data-roomScale="">테스트 룸1 <span class="scale">(4인실)</span></button></li>
		                        					<li><button type="button" class="selRoom" data-roomName="" data-roomCode="" data-roomScale="">테스트 룸2 <span class="scale">(4인실)</span></button></li>
		                        					<li><button type="button" class="selRoom" data-roomName="" data-roomCode="" data-roomScale="">테스트 룸3 <span class="scale">(4인실)</span></button></li>
		                        					<li><button type="button" class="selRoom" data-roomName="" data-roomCode="" data-roomScale="">테스트 룸4 <span class="scale">(4인실)</span></button></li>
		                        				</ul>
		                        			</div>
		                        		</div>
		                    		</dd>
                        		</dl>
                        		</li>
                        		<li>
                        			<dl>
                        				<dt><strong>시간</strong></dt>
                        				<dd>
                        					<div class="timeTableLap">
                        						<div class="timeTable">
	                        						<ul>
	                        							<li class="time_list">
	                        								<div>	
	                        									<button type="button" class="table_btn" data-start-hour="" data-start-minute="" data-start-time="" data-end-hour="" data-end-minute="" data-end-time="">
	                        										<span class="time">
				                        								<strong title="대관 시작">10:00</strong>
				                        								<em title="대관 종료">~10:30</em>
				                        							</span>
				                        							<span class="title">
				                        								<strong title="테스트룸">테스트룸</strong>
				                        								<em title="적정인원">4인</em>
				                        							</span>
				                        							<span class="status">
				                        								<span class="false">예약 불가</span>
				                        							</span>
	                        									</button>
	                        								</div>
	                        							</li>
	                        							<li class="time_list">
	                        								<div>	
	                        									<button type="button" class="table_btn" data-start-hour="" data-start-minute="" data-start-time="" data-end-hour="" data-end-minute="" data-end-time="">
	                        										<span class="time">
				                        								<strong title="대관 시작">10:00</strong>
				                        								<em title="대관 종료">~10:30</em>
				                        							</span>
				                        							<span class="title">
				                        								<strong title="테스트룸">테스트룸</strong>
				                        								<em title="적정인원">4인</em>
				                        							</span>
				                        							<span class="status">
				                        								<span class="false">예약 불가</span>
				                        							</span>
	                        									</button>
	                        								</div>
	                        							</li>
	                        							<li class="time_list">
	                        								<div>	
	                        									<button type="button" class="table_btn" data-start-hour="" data-start-minute="" data-start-time="" data-end-hour="" data-end-minute="" data-end-time="">
	                        										<span class="time">
				                        								<strong title="대관 시작">10:00</strong>
				                        								<em title="대관 종료">~10:30</em>
				                        							</span>
				                        							<span class="title">
				                        								<strong title="테스트룸">테스트룸</strong>
				                        								<em title="적정인원">4인</em>
				                        							</span>
				                        							<span class="status">
				                        								<span class="true">예약 가능</span>
				                        							</span>
	                        									</button>
	                        								</div>
	                        							</li>
	                        							<li class="time_list">
	                        								<div>	
	                        									<button type="button" class="table_btn" data-start-hour="" data-start-minute="" data-start-time="" data-end-hour="" data-end-minute="" data-end-time="">
	                        										<span class="time">
				                        								<strong title="대관 시작">10:00</strong>
				                        								<em title="대관 종료">~10:30</em>
				                        							</span>
				                        							<span class="title">
				                        								<strong title="테스트룸">테스트룸</strong>
				                        								<em title="적정인원">4인</em>
				                        							</span>
				                        							<span class="status">
				                        								<span class="true">예약 가능</span>
				                        							</span>
	                        									</button>
	                        								</div>
	                        							</li>
	                        							<li class="time_list">
	                        								<div>	
	                        									<button type="button" class="table_btn" data-start-hour="" data-start-minute="" data-start-time="" data-end-hour="" data-end-minute="" data-end-time="">
	                        										<span class="time">
				                        								<strong title="대관 시작">10:00</strong>
				                        								<em title="대관 종료">~10:30</em>
				                        							</span>
				                        							<span class="title">
				                        								<strong title="테스트룸">테스트룸</strong>
				                        								<em title="적정인원">4인</em>
				                        							</span>
				                        							<span class="status">
				                        								<span class="true">예약 가능</span>
				                        							</span>
	                        									</button>
	                        								</div>
	                        							</li>
	                        							<li class="time_list">
	                        								<div>	
	                        									<button type="button" class="table_btn" data-start-hour="" data-start-minute="" data-start-time="" data-end-hour="" data-end-minute="" data-end-time="">
	                        										<span class="time">
				                        								<strong title="대관 시작">10:00</strong>
				                        								<em title="대관 종료">~10:30</em>
				                        							</span>
				                        							<span class="title">
				                        								<strong title="테스트룸">테스트룸</strong>
				                        								<em title="적정인원">4인</em>
				                        							</span>
				                        							<span class="status">
				                        								<span class="true">예약 가능</span>
				                        							</span>
	                        									</button>
	                        								</div>
	                        							</li>
	                        							<li class="time_list">
	                        								<div>	
	                        									<button type="button" class="table_btn" data-start-hour="" data-start-minute="" data-start-time="" data-end-hour="" data-end-minute="" data-end-time="">
	                        										<span class="time">
				                        								<strong title="대관 시작">10:00</strong>
				                        								<em title="대관 종료">~10:30</em>
				                        							</span>
				                        							<span class="title">
				                        								<strong title="테스트룸">테스트룸</strong>
				                        								<em title="적정인원">4인</em>
				                        							</span>
				                        							<span class="status">
				                        								<span class="true">예약 가능</span>
				                        							</span>
	                        									</button>
	                        								</div>
	                        							</li>
	                        							<li class="time_list">
	                        								<div>	
	                        									<button type="button" class="table_btn" data-start-hour="" data-start-minute="" data-start-time="" data-end-hour="" data-end-minute="" data-end-time="">
	                        										<span class="time">
				                        								<strong title="대관 시작">10:00</strong>
				                        								<em title="대관 종료">~10:30</em>
				                        							</span>
				                        							<span class="title">
				                        								<strong title="테스트룸">테스트룸</strong>
				                        								<em title="적정인원">4인</em>
				                        							</span>
				                        							<span class="status">
				                        								<span class="false">예약 불가</span>
				                        							</span>
	                        									</button>
	                        								</div>
	                        							</li>
	                        						</ul>
                        						</div>
                        					</div>
                        				</dd>
                        			</dl>
                        		</li>
                        		</ul>
                        	</div>
                        </div>
                        
                        
                        
                </li>

                <li class="list_box">
                    <div class="box_cover">
                        <div class="img_wrap">
                            <figure><img src="http://placehold.it/200x200"></figure>
                        </div>
                        <div class="txt_wrap">
                            <div class="box_title">
                                <h5>르하임 스터디 카페</h5>
                            </div>
                            <div class="sub_txt">
                                <dl class="clear_both">
                                    <dt>주소</dt>
                                    <dd><p>서울특별시 종로구 종로동 126-3 3층 302호</p></dd>
                                </dl>
                                <dl class="clear_both">
                                    <dt>평점</dt>
                                    <dd><p><i class="icon-star yellow"></i></p></dd>
                                </dl>
                                <dl class="clear_both">
                                    <dt>운영시간</dt>
                                    <dd><p>10:00 ~ 20:00</p></dd>
                                </dl>
                                <dl class="equp clear_both">
                                    <dt>구비물품</dt>
                                    <dd>
                                        <p>
                                            <span class="setPrinter">
                                                <i class='icon-printer'></i>
                                                프린터
                                            </span>
                                            <span class='setProjecter'>
                                                <i class='icon-video-camera'></i>
                                                프로젝터
                                            </span>
                                            <span class="setLocker">
                                                <i class="icon-box-add"></i>
                                                사물함
                                            </span>
                                            <span class="setNotebook">
                                                <i class="icon-laptop"></i>
                                                노트북
                                            </span>
                                            <span class="setWhiteboard">
                                                <i class="icon-display"></i>
                                                화이트보드
                                            </span>
                                        </p>
                                    </dd>
                                </dl>
                            </div>
                            <div class="priceLap">
                                <h4 class="red align_right">
                                    <span>\</span><b class="price">89,000</b>
                                </h4>
                            </div>
                        </div>
                        <div class="btn_wrap">
                            <div class="">
                                <!-- centerCode ? -->
                                <button type="button" class="btn_type_03 " onclick="viewDetail()">상세보기</button> 
                                <!-- centerCode ? -->
                                <button type="button" class="btn_type_03" onclick="selectCenter()">선택하기</button>
                            </div>
                        </div>
                    </div>
                </li>


            </ul>
        </div>
        <div id="paginate">
		</div>
               
    </div>
</div>
<!-- body end  -->
</body>
</html>