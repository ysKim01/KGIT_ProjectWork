<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%	request.setCharacterEncoding("utf-8"); %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html> 
<html>
<head>
<meta charset="UTF-8">
<title>관리자 예약 등록 창</title>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Document</title>
   <link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/reset.css">
   <link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/adminReservForm.css">
   <link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/dcalendar.picker.css">
	<script src="http://code.jquery.com/jquery-latest.js"></script>
	<script src="${contextPath }/resources/js/dcalendar.picker.js"></script>
<script>

const centerCode = "${centerInfo.centerCode}";
const operTimeStart = "${centerInfo.operTimeStart}";
const operTimeEnd = "${centerInfo.operTimeEnd}";
const unitTime = "${centerInfo.unitTime}";
const minTime = "${centerInfo.minTime}";


$(window).on('load',function(){
	var centerCode = '${centerCode}';
	console.log("[이전예약정보]");
	console.log("예약 방 : ${reserve.roomCode}")
	console.log("예약시간 : " + "${reserve.usingTime}");
	console.log("예약날짜 : ${reserve.reserveDate}")
});

$(function(){
    $('.dcalendar').dcalendarpicker({
        // default: mm/dd/yyyy
        format:'yyyy-mm-dd'
    });
    
})


let reservDate;
let reservRoom;
let reservRoomName;
function getReservTime(){
	reservDate = document.adminReservForm.reservDate.value;
	reservRoom = document.adminReservForm.reservRoom.value;
	reservRoomName = $('.reservRoom option[value='+reservRoom+']').text();
	console.log(reservRoomName);
    // ================================================= //
    // =============== url 수정 ======================== //
    // ================================================= //
    $.ajax({
        type:"post",
        url:"${contextPath}/admin/usableTime.do",
        dataType:"text",
        data:{
            centerCode : centerCode,
            reserveDate : reservDate,
            roomCode : reservRoom,
            keyNum : "${reserve.keyNum}",
        },
        success:function(data, textStatus){
            setTimeTable(data);
        },
        error:function(data, textStatus){
            alert("값을 불러오는데 실패했습니다.");
        }

    })
    
}


// ============================================== //
// ============== 시간표 활성화 =================== //
// ============================================== //
//
// OperTime_Start - 운영 시작 시간 10
// OperTime_End - 운영 종료 시간 22
// unitTime - 운영 단위 시간(분) 30
// minTime - 최소 예약시간 1
//
// 1440 720


let _operTimeStart;
let _operTimeEnd0
let _unitTime; 
let _minTime;
function setTimeTable(data){
	_operTimeStart = operTimeStart / 60;
	_operTimeEnd = operTimeEnd / 60
	_unitTime = unitTime / 60; 
	_minTime = minTime / 60;    
    var _reservIndex = new Array();
    for(var i = 0; i < data.length; i++){
        _reservIndex[i] = data.substr(i,1);
    }


    setHtml = "<table class='timeField'>";
    setHtml += "<thead><tr><th><b class='roomName'>룸 이름</b></th><th><strong>예약 시간</strong></th><th><span>예약 상태</span></th></thead><tbody>";
    var count = 0; // for문 카운트횟수 저장
    for(var time = _operTimeStart; time < _operTimeEnd; time += _unitTime){
        var getHour = Math.floor(time); // 10.5 = 10
        
        var getMinute = (time - getHour) * 60;
        if(getMinute == 0) getMinute = '00';
        if(getHour < 10) getHour = '0'+getHour;
        if(_reservIndex[count++] != 0){
            setHtml += "<tr data-time-hour="+getHour+" data-time-minute="+getMinute+" data-index="+count+" data-sort='0' data-status='false'><td><b class='roomName'>"+reservRoomName+"</b></td><td><strong>"+getHour+ " : " + getMinute+"</strong></td><td><span class='red'>예약불가</span></tr>";
        }else{
            setHtml += "<tr data-time-hour="+getHour+" data-time-minute="+getMinute+" data-index="+count+" data-sort='0' data-status='true'><td><b class='roomName'>"+reservRoomName+"</b></td><td><strong>"+getHour+ " : " + getMinute+"</strong></td><td><span class='green'>예약가능</span></td></tr>";
        }
        
    }
    setHtml += "</tbody></table>";
    $('#timeTableWrap').html(setHtml);
    
    createClickEvent()
    
    // element 생성 후 click이벤트 추가

}


function createClickEvent(){
    let clickCount = 0;
    let reservTime = {
           startTime : {minute:'',hour:'',setTime:''},
            endTime : {minute:'',hour:'',setTime:''}
    };
    
    $('.timeField tbody tr').on('click',function(e){
    	e.preventDefault();
    	console.log($(this).data('status'));
        if(!$(this).data('status')){
        	alert("예약이 불가능한 시간입니다. 다시 선택해주세요.");
        	return;
        }
        
    	if(clickCount == 0){
    		console.log(clickCount);
        	var target = $('.timeField tbody tr');
        	target.removeClass('checked');
        	target.removeClass('ing');
        	target.data('sort','0');
        }
    	clickCount++;
    	
    	$(this).addClass('checked');
    	
    	$(this).data('sort',clickCount);
        
        
        
        if(clickCount % 2 == 1){
        	// 시작값 저장
        	
        	reservTime.startTime.setTime = parseInt($(this).data('time-hour')*60) + parseInt($(this).data('time-minute')) * 60;
        }else{
        	// 끝값 저장
        	
        	reservTime.endTime.setTime = parseInt($(this).data('time-hour')*60) + parseInt($(this).data('time-minute'));
        }
        
        
         
        if(clickCount % 2 == 0){
        	if(!(reservTime.startTime.setTime >= reservTime.endTime.setTime) && (reservTime.endTime.setTime - reservTime.startTime.setTime) > _minTime){
            	var checkedList = document.getElementsByClassName('checked');
            	var context = $('.timeField tbody tr');
            	for(var i = checkedList[0].dataset.index; i < checkedList[1].dataset.index - 1; i++){
            		if(!context.eq(i).data('status')){
            			alert("예약이 불가능한 시간이 겹쳐있습니다. 다시 선택해주세요.");
            			context.removeClass();
            			clickCount = 0;
            			return;
            		}
            		context.eq(i).addClass('ing');
            		
            	}
            	reservTime.startTime.hour = reservTime.startTime.setTime / 60;
            	reservTime.startTime.minute =((reservTime.startTime.setTime % 60) == 0 ? '00':'0');
            	
            	reservTime.endTime.hour = reservTime.endTime.setTime / 60;
            	reservTime.endTime.minute = ((reservTime.endTime.setTime % 60) == 0 ? '00':'0');
            	
            	document.adminReservForm.startTime.value = reservTime.startTime.hour + " : " + reservTime.startTime.minute;
                document.adminReservForm.endTime.value = reservTime.endTime.hour + " : " + reservTime.endTime.minute;
            }else{
            	alert('시작 시간과 끝 시간을 올바르게 선택해 주세요.');
            	$('.timeField tbody tr').removeClass('checked');
            	
            }
        	clickCount = 0;
        }
        
        
       
        
        

        
        return;
    })
    
}
function onResorv(){
	var reserve = new Object();
	reserve.userId = document.adminReservForm.userId.value;
	reserve.centerCode = document.adminReservForm.centerCode.value;
	reserve.roomCode = document.adminReservForm.reservRoom.value;
	reserve.reserveDate = document.adminReservForm.reservDate.value;
	reserve.usingTime = "";
	reserve.extraCode = "";
	console.log(document.adminReservForm.userId.value);
	
	var usingSize = $('.timeField tbody tr').length;
	
	for(var i = 0; i < usingSize; i++){
		if($('.timeField tbody tr').eq(i).attr('class') == 'checked' || $('.timeField tbody tr').eq(i).attr('class') == 'ing'){
			reserve.usingTime += "1";			
			continue;
		}
		reserve.usingTime += "0";
	}
	
	console.log(reserve.usingTime);
	
	for(var key in reserve){
		if(reserve[key] == '' && key != 'extraCode'){
			alert('값을 입력해 주세요.');
			document.getElementsByTagName(key).focus;
			return;
		}
	}
	reserve.extraCode = '';
	
	
	var scale = $('.reservRoom option[value='+reserve.roomCode+']').data('scale'); 
	
	var centerInfo = {
			unitTime : '${centerInfo.unitTime}',
			unitPrice : '${centerInfo.unitPrice}',
			premiumRate : '${centerInfo.premiumRate}',
			surchageTime : '${centerInfo.surchageTime}',
			unitTime : '${centerInfo.unitTime}',
			operTimeStart : '${centerInfo.operTimeStart}',
			operTimeEnd : '${centerInfo.operTimeEnd}'
	}
	console.log(reserve);
	console.log(scale);
	console.log(centerInfo);
	$.ajax({
		type:'post',
		url:'${contextPath}/admin/modReserve.do',
		dataType:'text',
		data:{
			reserve : JSON.stringify(reserve),
			scale : scale,
			centerInfo : JSON.stringify(centerInfo),
			keyNum : "${reserve.keyNum}",
		},
		success(data, textStatus){
			console.log(data);
			console.log(textStatus);
			alert('성공');
			searchReserve();
		},
		error(data, textStatus){
			console.log(data);
			console.log(textStatus);
			alert('실패');
		}
		
	});
}
/* ===========================================================================
 *  예약 검색
 * ---------------------------------------------------------------------------
 * > 입력 : searchInfo
 * > 출력 : Reserve List
 * > 이동 페이지 : /admin/searchReserve.do
 * > 설명 : 
	 	- 검색필터 전달 후 예약 검색창으로
 ===========================================================================*/
function searchReserve(){
	var form = document.createElement("form");
    form.setAttribute("charset", "UTF-8");
    form.setAttribute("method", "Get");  //Get 방식
    form.setAttribute("action", "${contextPath}/admin/searchReserve.do"); //요청 보낼 주소
    
    // searchInfo
    var searchObj = new Object();
    searchObj['searchFilter'] = "${searchInfo.searchFilter}";
    searchObj['searchContent'] = "${searchInfo.searchContent}";
    searchObj['reserveStatus'] = "${searchInfo.reserveStatus}";
    searchObj['page'] = "${searchInfo.page}";
    
    var searchInfo = document.createElement("input");
    searchInfo.setAttribute("type", "hidden");
    searchInfo.setAttribute("name", "searchInfo");
    searchInfo.setAttribute("value", encodeURI(JSON.stringify(searchObj)));
    form.appendChild(searchInfo);
    
    document.body.appendChild(form);
    form.submit();
}
</script>
</head>
<body>

	<div id="container">
		<div class="width_wrap">
			<h3 class="content_title">
	       		예약 수정 폼
	        </h3>
			<div class="content_wrap">
				<div class="content clear_both">
                    <div class="reservFormWrap">
                        <form action="#" method="post" onsubmit="return false;" name="adminReservForm" id="adminReservForm">
                            <fieldset>
                                <table class="reservWrap">
                                	<tr>
                                        
                                        <th>
                                       	 <label>예약자 아이디</label>
                                        </th>
                                        <td>
                                        <strong><input type="text" value="${reserve.userId}" disabled="disabled"></strong>
                                        <strong><input type="hidden" readonly name="userId" class="userId" value="${reserve.userId}"></strong>
                                        </td>
                                        
                                    </tr>
                                	<tr>
                                        <th>
                                        <label>센터 코드</label>
                                        </th>
                                        <td>
                                        <strong><input type="text" value="${reserve.centerCode }" disabled="disabled"></strong>
                                        <input type="hidden" readonly name="centerCode" class="centerCode" value="${centerInfo.centerCode }">
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>
                                        <label>날짜</label>
                                        </th>
                                        <td>
                                        <strong><input type="text" name="reservDate" class="dcalendar" value="${reserve.reserveDate}"></strong>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>
                                            <label>방 선택</label>
                                            </th>
                                            <td>
                                            <strong>
                                                <select name="reservRoom" class="reservRoom">
                                                    <!-- ================================================ -->
                                                    <!-- ======== controller 값 따라 변경할 부분 ========= -->
                                                    <!-- ================================================ -->
                                                    <c:forEach var="item" items="${roomList}" varStatus="status">
                                                        <option value="${item.roomCode}" data-scale="${item.scale }">${item.roomName}  (${item.scale }인실)</option>
                                                    </c:forEach>
                                                    
                                                </select>
                                            </strong>
                                            <strong><input type="button" value="시간 확인" onclick="getReservTime()" class="btn_type_02"></strong>
                                            </td>
                                            
                                        </p>
                                    </tr>
                                    <tr class="reservTimeWrap">
                                        
                                            <th><label>시간 선택</label></th>
                                            <td>
                                                <div class="float_sec clear_both reservTime">
                                                    <p>
                                                        <b>시작 시간</b>
                                                        <input type="text" name="startTime" readOnly>
                                                    </p>
                                                    <p>
                                                        <b>끝 시간</b>
                                                        <input type="text" name="endTime" readOnly>
                                                    </p>
                                                </div>
                                            </td>
                                    </tr>

                                </table>
                                <p class="btnArea">
                                    <input type="button" class="btn_type_01" value="예약" onclick="onResorv()">
                                </p>
                            </fieldset>
                        </form>
                        <div class="getTimeTableWrap">
                        	<div id="timeTableWrap">
                        		
                        	</div>
							<p>
								값을 입력 후 시간 확인 버튼을 눌러주세요.
							</p>
	                    </div>
                    </div>
                    
				</div>
				<!-- content end-->
			</div>
			
		</div>
	</div>
    


</body>
</html>