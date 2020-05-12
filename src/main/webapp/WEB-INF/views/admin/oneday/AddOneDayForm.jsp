<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false" %>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html> 
<html>
<head>
<meta charset="UTF-8">
<title>관리자 일일클래스 등록</title>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Document</title>
   <link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/adminAddMember.css">
   <script src="http://code.jquery.com/jquery-latest.js"></script>
   <script>
       $(window).on('load',function(){
           
           // 생년월일 날짜 option
           var adminAddMember = document.adminAddMember;
           var date = new Date();
           var year = date.getFullYear(); // 년도
           var month = date.getMonth(); // 월
           var day = new Date(year, month+1,"").getDate();
           for(var i = year-60; i<= year; i++){
               $('.birthYear').append(
                   "<option value="+i+">"+i+"년</option>"
               );
           };
           for(var i = 1; i<=12; i++){
               var count = i;
               if(i < 10){
                   count = "0"+i;
               }
               $('.birthMonth').append(
                   "<option value="+count+">"+count+"월</option>"
               )
           }
           for(var i=1; i<=day; i++){
               var count = i;
               if(i < 10){
                   count = "0"+i;
               }
               $('.birthDay').append(
                   "<option value="+count+">"+count+"일</option>"
               )
           }
           $('.birthYear option:last').attr('selected','select');
           $('.birthMonth option:eq('+month+')').attr('selected','select');
           // 날짜 end\
           $('.birthDay').focus(function(){
               
               getDay();
           })
        });
        function getDay(){
            var getYear = adminAddMember.birthYear.value;
            var getMonth = adminAddMember.birthMonth.value;
            
            getLastDay = new Date(getYear, getMonth,"").getDate();
            $('.birthDay').html('');
            for(var i=1; i<=getLastDay; i++){
                var count = i;
                if(i < 10) count = "0"+i;
                $('.birthDay').append(
                    
                    "<option value="+count+">"+count+"일</option>"
                )
            }
        }
        
    function submitAction(){
    	var form = document.createElement('form');
    	form.setAttribute('action','${contextPath}/admin/addOneDay.do');
    	form.setAttribute('method','POST');
    	form.setAttribute('encType','multipart/form-data');
        
    	
    	// 1. 일반 입력 데이터 ==================================================
    	
    	// classTitle
    	var classTitle = adminAddMember.classTitle.value;
    	if(isEmpty(classTitle)){
    		alert("강의명을 입력해 주세요.");
    		return;
    	}
    	// classContent
    	var classContent = adminAddMember.classContent.value;
    	if(isEmpty(classContent)){
    		alert("강의내용을 입력해 주세요.");
    		return;
    	}
    	// lector
    	var lector = adminAddMember.lector.value;
    	if(isEmpty(lector)){
    		alert("강사명을 입력해 주세요.");
    		return;
    	}
    	
    	// classDate
    	var classDate = $('.birthYear').val();
        classDate += "-" + $('.birthMonth').val();
        classDate += "-" + $('.birthDay').val();
    	
        // tel
        if(isNaN(parseInt($("#Tel1").val())) || $('#Tel1').val().length != 3){
            var info_text = document.createTextNode("전화번호 형식에 맞춰주세요.");
            info_box.appendChild(info_text);
            $('#Tel1').parent("p").append(info_box);
            $('#Tel1').focus();
            return;
        }
        if(isNaN(parseInt($("#Tel2").val())) || $('#Tel2').val().length != 4){
            var info_text = document.createTextNode("전화번호 형식에 맞춰주세요.");
            info_box.appendChild(info_text);
            $('#Tel2').parent("p").append(info_box);
            $('#Tel2').focus();
            return;
        }
        if(isNaN(parseInt($("#Tel3").val())) || $('#Tel3').val().length != 4){
            var info_text = document.createTextNode("전화번호 형식에 맞춰주세요.");
            info_box.appendChild(info_text);
            $('#Tel3').parent("p").append(info_box);
            $('#Tel3').focus();
            return;
        }
        var tel = "";
        tel += adminAddMember.Tel1.value;
        tel += adminAddMember.Tel2.value;
        tel += adminAddMember.Tel3.value;
        
        // classTime
        var timeStart = adminAddMember.timeStart.value;
        var timeEnd = adminAddMember.timeEnd.value;
        if(isEmpty(timeStart)){
        	alert("강의 시작시간을 입력해 주세요.");
        	return;
        }
        if(isEmpty(timeEnd)){
        	alert("강의 종료시간을 입력해 주세요.");
        	return;
        }
        var classTime = timeStart + " ~ " + timeEnd;

        var oneDayObj = {
        	classTitle : classTitle,
        	classContent : classContent,
        	classDate : classDate,
        	classTime : classTime,
        	lector : lector,
        	lectorTel : tel,
        }
        var oneDay = document.createElement('input');
        oneDay.setAttribute('type','hidden');
        oneDay.setAttribute('name','oneDay');
        oneDay.setAttribute('value',encodeURI(JSON.stringify(oneDayObj)));
        form.append(oneDay);
        console.log(oneDayObj); 
        
        
     	// 2. 파일 데이터 ======================================================
        var inputPhotos = document.getElementsByClassName('classPhoto');
     	var roomPhotos = [];
        for(var i = 0; i< inputPhotos.length; i++){
            if(inputPhotos[i].files.length != 0){
            	roomPhotos.push(inputPhotos[i]);
            }
        } 
        console.log("roomPhotos size : " + roomPhotos.length);
        for(var i=0; i<roomPhotos.length; i++){
        	form.append(roomPhotos[i]);
        	console.log(roomPhotos[i]);
        }
        
        document.body.appendChild(form);
        form.submit();
    }

    var isEmpty = function(value){
         if( value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length ) ) { 
             return true 
         }else{
              return false 
              }
        };
       
    </script>
<style>
	textarea {
	resize: none;
}
</style>
</head>
<body>
    <div class="adminaddMemberWrap">
        <h3 class="content_title">
           원데이 클래스 등록
        </h3>
    <form name="adminAddMember" id="adminAddMember"  action="#" method="post">
        <fieldset>
            <ul class="adminMemList clear_both">
                <li>
                    <p>
                        <strong>강의명</strong>
                        <input required type="text" name="classTitle" id="classTitle">
                    </p>
                </li>
                <li>
                    <p>
                        <strong>강의 내용</strong>
                        <textarea cols="60" rows="20" name="classContent" id="classContent"></textarea>
                    </p>
                </li>
                <li>
                    <p>
                        <strong>강의 날짜</strong>
                        <select name="birthYear" class="birthYear birth" id="birthYear">
                        </select>
                        <select name="birthMonth" class="birthMonth birth" id="birthMonth">    
                        </select>
                        <select name="birthDay" class="birthDay birth" id="birthDay">    
                        </select>
                    </p>
                </li>
                <li>
                    <p>
                        <strong>강의 시간</strong>
                        <select id="timeStart" name="timeStart">
	                        <option value="">시작시간</option>
	                        <option value="09">9시</option>
	                        <option value="10">10시</option>
	                        <option value="11">11시</option>
	                        <option value="12">12시</option>
	                        <option value="13">13시</option>
	                        <option value="14">14시</option>
	                        <option value="15">15시</option>
	                        <option value="16">16시</option>
	                        <option value="17">17시</option>
	                        <option value="18">18시</option>
	                        <option value="19">19시</option>
	                        <option value="20">20시</option>
	                        <option value="21">21시</option>
	                        <option value="22">22시</option>
	                        <option value="23">23시</option>
	                  	</select> ~ 
	                    <select id="timeEnd" name="timeEnd">
	                       <option value="">종료시간</option>
	                       <option value="10">10시</option>
	                       <option value="11">11시</option>
	                       <option value="12">12시</option>
	                       <option value="13">13시</option>
	                       <option value="14">14시</option>
	                       <option value="15">15시</option>
	                       <option value="16">16시</option>
	                       <option value="17">17시</option>
	                       <option value="18">18시</option>
	                       <option value="19">19시</option>
	                       <option value="20">20시</option>
	                       <option value="21">21시</option>
	                       <option value="22">22시</option>
	                       <option value="23">23시</option>
	                       <option value="24">24시</option>
	                  	</select>
                    </p>
                </li>
                <li>
                    <p>
                        <strong>강사명</strong>
                        <input required type="text" name="lector" id="lector">
                    </p>
                </li>
                <li>
                    <p>
                        <strong>전화번호</strong>
                        <input required type="text" name="Tel1" class="telNum" maxlength="3" minlength="3" id="Tel1">
                        <input required type="text" name="Tel2" class="telNum" maxlength="4" minlength="3" id="Tel2">
                        <input required type="text" name="Tel3" class="telNum" maxlength="4" minlength="4" id="Tel3">
                    </p>
                </li>
                <li>
                    <p>
                        <strong>강의 사진</strong>
	                        <ul>
	                      	<li><input type="file" class="classPhoto" name="file" id="classPhoto1"/>
	                        	<li><input type="file" class="classPhoto" name="file" id="classPhoto2"/>
	                        	<li><input type="file" class="classPhoto" name="file" id="classPhoto3"/>
	                        	<li><input type="file" class="classPhoto" name="file" id="classPhoto4"/>
	                        	<li><input type="file" class="classPhoto" name="file" id="classPhoto5"/>
	                        </ul>
                    </p>
                </li>
                <li>
                    <p>
                        <input class="btn_type_01" type="button" onclick="submitAction()" value="등록하기">
                        <input class="btn_type_01" type="button" value="취소" onclick="windowClose()">
                    </p>
                </li>
            </ul>
        </fieldset>
    </form>
</div>

</body>
</html>