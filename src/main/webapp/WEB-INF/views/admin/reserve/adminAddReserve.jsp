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
   <link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/adminReservForm.css">
   <link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/dcalendar.picker.css">
	<script src="http://code.jquery.com/jquery-latest.js"></script>
	<script src="${contextPath }/resources/js/dcalendar.picker.js"></script>
<script>

const centerCode = "${centerCode}";
const OperTime_Start = "${OperTime_Start}";
const OperTime_End = "${OperTime_End}";
const unitTime = "${conterInfo.unitTime}";
const minTime = "${conterInfo.minTime}";


$(window).on('load',function(){
	
	var centerCode = '${centerCode}';
	console.log(centerCode);
	<c:forEach var="item" items="${roomList}" varStatus="status">
		console.log('${item.roomCode}');
		console.log('${item.centerCode}');
		console.log('${item.roomName}');
		console.log('${item.scale}');
	</c:forEach>
	
});

$(function(){
    $('.dcalendar').dcalendarpicker({
        // default: mm/dd/yyyy
        format:'yyyy-mm-dd'
    });

})



function getReservTime(){
    var reservDate = document.adminReservForm.reservDate.value;
    var reservRoom = document.adminReservForm.reservRoom.value;
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
            roomCode : reservRoom
        },
        success:function(data, textStatus){
            setTimeTable(data);
        },
        error:function(data, textStatus){
            alert("값을 불러오는데 실패했습니다.");
        }

    })
    serTimeTable();
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

function serTimeTable(){
    var _operTimeStart = operTimeStart / 60;
    var _operTimeEnd = operTimeEnd / 60
    var _unitTime = unitTime / 60; 
    var _minTime = minTime / 60;
    var _reservIndex = new Array();
    console.log(reservIndex.length);
    for(var i = 0; i < reservIndex.length; i++){
        console.log()
        _reservIndex[i] = reservIndex.substr(i,1);
    }
    console.log("오픈시간 : " + _operTimeStart); // 10시
    console.log("종료 시간 : " + _operTimeEnd); // 20시
    console.log("기준시간 : " + _unitTime); // 30분(0.5);
    console.log("최소 예약시간 : " + _minTime); // 1시간
    console.log("room Index Array : " + _reservIndex);


    setHtml = "<ul class='timeField'>";
    var count = 0; // for문 카운트횟수 저장
    for(var time = _operTimeStart; time <= _operTimeEnd; time += _unitTime){
        var getHour = Math.floor(time); // 10.5 = 10
        var getMinute = (time - getHour) * 60;
        if(getMinute == 0) getMinute = '00';
        if(_reservIndex[count++] != 0){
            setHtml += "<li><p><a href='#' data-time-hour="+getHour+" data-time-minute="+getMinute+"><strong>"+getHour + " : " + getMinute+"</strong></a><span class=''>예약불가</span></p></li>";
        }else{
            setHtml += "<li><p><a href='#' data-time-hour="+getHour+" data-time-minute="+getMinute+"><strong>"+getHour + " : " + getMinute+"</strong></a><span class=''>예약가능</span></p></li>";
        }
        
    }
    setHtml += "</ul>";
    $('#timeTableWrap').append(setHtml);

    createClickEvent()
    // element 생성 후 click이벤트 추가

}


function createClickEvent(){
    let clickCount = 0;
    let reservTime = {
        startTime : '',
        endTime : ''
    };
    $('.timeField a').on('click',function(){
        console.log('click');
        console.log($(this).data('time-hour'));
        console.log($(this).data('time-minute'));
        event.target.prop('class','checked');
        
        clickCount++;
        if(clickCount > 1){
            reservTime.endTime = parseInt($(this).data('time-hour')) + parseInt($(this).data('time-minute')) * 60;
            if(reservTime.startTime >= reservTime.endTime){
                reservTime.endTime = 0;
                reservTime.startTime = 0;
                clickCount = 0;
            }
        }
        reservTime.startTime = parseInt($(this).data('time-hour')) + parseInt($(this).data('time-minute')) * 60;

        
        return;
    })
}
</script>
</head>
<body>

	<div id="container">
		<div class="width_wrap">
			<h3 class="content_title">
	       		예약 등록 폼
	        </h3>
			<div class="content_wrap">
				<div class="content">
                    <div class="reservFormWrap">
                        <form action="#" method="post" onsubmit="return false;" name="adminReservForm" id="adminReservForm">
                            <fieldset>
                                <ul>
                                	<li>
                                        <p>
                                        <label>센터 코드</label>
                                        <strong><input type="text" readonliy name="centerCode" class="centerCode" value="${centerCode }"></strong>
                                        </p>
                                    </li>
                                    <li>
                                        <p>
                                        <label>날짜</label>
                                        <strong><input type="text" name="reservDate" class="dcalendar"></strong>
                                        </p>
                                    </li>
                                    <li>
                                        <p>
                                            <label>방 선택</label>
                                            <strong>
                                                <select name="reservRoom">
                                                    <!-- ================================================ -->
                                                    <!-- ======== controller 값 따라 변경할 부분 ========= -->
                                                    <!-- ================================================ -->
                                                    <c:forEach var="item" items="${roomList}" varStatus="status">
                                                        <option value="${item.roomCode}">${item.roomName}</option>
                                                    </c:forEach>
                                                    
                                                </select>
                                            </strong>
                                            <input type="button" value="시간 확인" onclick="getReservTime()">
                                        </p>
                                    </li>
                                    <li>
                                        <dl class="reservTimeWrap">
                                            <dt><label>시간 선택</label></dt>
                                            <dd>
                                                <div class="float_sec clear_both reservTime">
                                                    <p>
                                                        <b>시작 시간</b>
                                                        <input type="text" readOnly>
                                                    </p>
                                                    <p>
                                                        <b>끝 시간</b>
                                                        <input type="text" readOnly>
                                                    </p>
                                                </div>
                                            </dd>
                                        </dl>
                                    </li>

                                </ul>
                                <p class="btnArea">
                                    <input type="button" value="예약" onclick="onReserv()">
                                </p>
                            </fieldset>
                        </form>
                    </div>
                    <div class="getTimeTableWrap">

                    </div>
				</div>
				<!-- content end-->
			</div>
			
		</div>
	</div>
    


</body>
</html>