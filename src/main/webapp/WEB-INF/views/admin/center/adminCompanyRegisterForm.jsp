<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false" %>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>업체등록 폼</title>
<link rel="stylesheet" type="text/css" href="${contextPath}/resources/css/adminCompany_registerForm.css">
<script src="https://code.jquery.com/jquery-latest.js"></script>
<script>
    //추가 버튼


    // RoomInfo
    var MIN_COUNT = 1;
    var MAX_COUNT = 10;
    $(document).ready(function(){
        

        // RoomInfo 룸정보 추가
        $(document).on("click","button[name=rowAddBtn]",function(){

            var createIndexNum = $('.trRoomInfo').last().index()-1;
            if(createIndexNum == MAX_COUNT) return;
            if(createIndexNum == 1) createIndexNum =2;
            
            var addRoomText = 
            '<tr class="trRoomInfo" name="trRoomInfo">'+'<td>'+
            '<input type="text" class="roomCode" name="roomCode'+createIndexNum+'" >'+
            '</td>'+
            '<td>'+
            '<input type="text" class="roomName" name="roomName'+createIndexNum+'" >'+
            '</td>'+
            '<td>'+
            '<input type="text" class="scale" name="scale'+createIndexNum+'" >'+
            '</td>'+
            '<td>'+
            '<button type="button" id="rowAddBtn" name="rowAddBtn" class="rowAddBtn">+</button>'+
            '<button type="button" id="rowDelBtn" name="rowDelBtn" class="rowDelBtn">-</button>'+
            '</td>'+
            '</tr>';
            
        var trHtml = $( "tr[name=trRoomInfo]:last" ); //last를 사용하여 trStaff라는 명을 가진 마지막 태그 호출
        
        trHtml.after(addRoomText); //마지막 trStaff명 뒤에 붙인다.
        
        return;
        });
        
    })
   
    
    //RoomInfo Btn 삭제 버튼
    $(document).on("click","button[name=rowDelBtn]",function(){
        
        var createIndexNum = $('.trRoomInfo').last().index()-1;
        if(createIndexNum <= MIN_COUNT) return;
        $(this).parent().parent('tr').remove();
        
        return;
    });

    function isEmpty(val){
        if(val == null || val == '' || val == 'NaN' || val == 'undefined' || (val == '' || typeof val == 'Object' && !(val.length == 0))){
            return true;
        }else{
            return false;
        }
    }
    
    function onNext(){
        // =================================== //
        //====== centerInfo 기본 정의=============//
        // =================================== //
        
    	if(isNaN(parseInt($('.centerTel').val(), 10))){
            alert("전화번호에는 숫자값만 입력해주세요.");
            return;
        }
        
        
        var centerInfo = {
            centerCode : $('#centerCode').val(),
            centerName : $('#centerName').val(),
            centerAdd1 : $('#centerAdd1').val(),
            centerAdd2 : $('#centerAdd2').val(),
            centerAdd3 : $('#centerAdd3').val(),
            operTimeStart : $('#operTimeStart').val() * 60,
            operTimeEnd : $('#operTimeEnd').val() * 60,
            unitTime : $('#unitTime').val(),
            minTime : $('#minTime').val() * 60,
            surchageTime : $('#surchageTime').val() * 60,
            unitPrice : $('#unitPrice').val(),
            premiumRate : $('#premiumRate').val()
        }
      for(var key in centerInfo){
            if(isEmpty(centerInfo[key])){
                var targetName = $("#"+key).parent('td').prev().children('label').text();
                alert("모든 항목을 입력해주세요.");
                $("#"+key).focus();
                return;
            }
        }
        for(var i = 2; i <= 3; i++){
            if($('#centerTel'+i).val() == ''){
                alert("전화번호를 입력해주세요.");
                $("#centerTel"+i).focus();
                return;
            }
            if(isNaN($('#centerTel'+i).val())){
                alert("전화번호에는 숫자만 입력해주세요.");
                $("#centerTel"+i).focus();
                return;
            }
        }
        centerInfo.centerTel = $('#centerTel1').val() + "" + $('#centerTel2').val() +"" + $('#centerTel3').val();
        
        
        console.log("centerInfo 객체 저장 성공")
        console.log(centerInfo);
        console.log("====================");

        // =================================== //
        //======roomInfo 기본 정의=============//
        // =================================== //
        
        var keyArray = ['roomCode','roomName','scale'];
        var count = $('.trRoomInfo').length;
        var roomInfo = new Object();

        for(var j=0; j<count; j++){
            var select = $('.trRoomInfo').eq(j);
            var childObj = {
            	centerCode : centerInfo.centerCode,
                roomCode : '',
                roomName : '',
                scale : '',
            };
            
            var max = select.children('td').length-1;
            for(var i = 0; i<max ; i++){
                thisVal = select.children('td').eq(i).children('input').val();
                if(isEmpty(thisVal)){
                    console.log(childObj[i]);
                    // 데이터 확인
                    alert("모든 방 정보를 입력해주세요.");
                    select.children('td').eq(i).children('input').focus();
                    return;
                }
                childObj[keyArray[i]] = thisVal;
            }
            roomInfo[j] = childObj;
        }
        console.log(roomInfo);
        // ==================================== //
        // ========== studyFacility =========== //
        // ======= 체크시 1 , 미체크시 0 =========//
        // ==================================== //
        
        var studyFacility = {
        	centerCode : centerInfo.centerCode
        }
		
        var facility = document.getElementsByClassName('facility');
        for(var i = 0; i < facility.length; i++){
            console.log(facility[i].checked);
            if(facility[i].checked == true){
                studyFacility[facility[i].name] = '1';
            }else if(facility[i].checked == false){
                studyFacility[facility[i].name] = '0';
            }
        }
        console.log(studyFacility);
        

        





        // ==================================== //
        // ====== centerContents start ======== //
        // ==================================== //
        var centerIntroduce = $('#centerIntroduce').val();
        var centerFareInfo = $('#centerFareInfo').val();
        var centerUseInfo = $('#centerUseInfo').val();
        var introduce = document.getElementsByClassName('introduce');

        
        var centerMain = $('#foomMain').get(0).files[0];
        const url1 = '/resources/image/center/';
        var url2 = centerInfo.centerCode + '/';
        console.log(centerMain);
        if(centerMain.length == 0){
            alert('센터 메인사진을 첨부해주세요.');
            $('#centerMain').focus();
            return;
        }
        centerMain = url1 +'' + url2 + '' + centerMain.name;

        
        var roomPhotos = document.getElementsByClassName('foomPhoto');
        var foomPhoto = new Array();
        var centerPhoto = document.getElementsByClassName('foomMain');
        console.log(centerPhoto);
        var fileList = new Array();
        for(var i = 0; i< roomPhotos.length; i++){
            
            if(roomPhotos[i].files.length != 0){
                
                foomPhoto[foomPhoto.length] = roomPhotos[i].files[0].name;
                fileList[fileList.length] = roomPhotos[i];
            }
        }
        
        // 사진 업로드 
        /*<form name="fileForm" action="requestupload2" method="post" enctype="multipart/form-data">*/
        var fileForm = document.createElement('form');
        	fileForm.setAttribute('action','${contextPath}/admin/requestupload2');
        	fileForm.setAttribute('method','POST');
        	fileForm.setAttribute('encType','multipart/form-data');
        
        var centerContents = {
       		centerCode : centerInfo.centerCode,
            centerIntroduce : centerIntroduce,
            centerFareInfo : centerFareInfo,
            centerUseInfo : centerUseInfo,
            centerMain : centerMain,
            foomPhotos : foomPhoto
        };

        console.log('첨부파일 리스트 확인 ----');
        console.log(centerContents);
        console.log('첨부파일 리스트 끝 -- ');
        console.log(fileList);

        console.log("for" + i+ "start");
        console.log(fileForm); 
        console.log("for" + i+ "end");
        
       for(var i = 0; i < foomPhoto.length + 1; i++){ 
    	   fileForm.append(fileList[i]);
	        /*
	        console.log("file" + i + "start");
	        console.log(fileForm);
	        console.log("file" + i+ "start"); 
	        */
        }
       var createSRC = document.createElement('input');
        createSRC.setAttribute('type','text');
        createSRC.setAttribute('name','src');
        createSRC.setAttribute('value',centerInfo.centerCode);
        fileForm.append(createSRC);
        console.log(fileForm);
        
        fileForm.append(centerPhoto[0]);
    	
        console.log('submit start--------------------------------')
        document.body.appendChild(fileForm);
        console.log('submit end--------------------------------')
       
        $.ajax({
            type:'post',
            url : '${contextPath}/admin/addCenter.do',
            dataType : 'text',
            data:{
                centerInfo : JSON.stringify(centerInfo),
                roomInfo : JSON.stringify(roomInfo),
                studyFacility : JSON.stringify(studyFacility),
                centerContents : JSON.stringify(centerContents)
            },
            success:function(data, textStatus){
                console.log(textStatus);
                alert('업체등록이 성공적했습니다.');
                // 업로드 파일 전송
            	fileForm.submit();
            },
            error:function(data, textStatus){
                console.log(data);
                console.log(textStatus);
                alert("error");
            }

        })
    }
</script>


</head>

	
 <body>
    <form method="GET" name="registerForm" class="registerForm">
        <table class="outline" id="centerInfo">
            <thead>
                <tr id="info">
                    <td colspan="2">
                        <h3 class="align_center">업체 정보</h3>
                    </td>
                </tr>
        </thead>
        <tbody>
            <tr>
                <th>
                    <label for="centerCode">업체코드
                </th>
          
                <td>
                    <input type="text" name="centerCode" id="centerCode"> 
                </td>
            </tr>
            
            <tr>
                <th>
                    <label for="centerName">업체명
                </td>
                <th>
                    <input type="text" name="centerName" id="centerName">
                </td>
            </tr>
             <tr>
                <th>
                    <label for="centerTel1">회사전화
                </th>
                <td>
                    <select id="centerTel1"class="centerTel" name="centerTel1">
                        <option value="02" selected="select">02</option>
                        <option value="010" selected="select">010</option>
                        <option value="031" selected="select">031</option>
                        <option value="032" selected="select">032</option>
                        <option value="033" selected="select">033</option>
                        <option value="041" selected="select">041</option>
                        <option value="042" selected="select">042</option>
                        <option value="043" selected="select">043</option>
                        <option value="044" selected="select">044</option>
                        <option value="051" selected="select">051</option>
                        <option value="053" selected="select">053</option>
                        <option value="054" selected="select">054</option>
                        <option value="055" selected="select">055</option>
                        <option value="061" selected="select">061</option>
                        <option value="062" selected="select">062</option>
                        <option value="063" selected="select">063</option>
                        <option value="064" selected="select">064</option>
                        <option value="070" selected="select">070</option>
                    </select>
                    
                    <input type="text" name="centerTel2" class="centerTel" id="centerTel2" size="10" maxlength="4"> 
                    <input type="text" name="centerTel3" class="centerTel" id="centerTel3" size="10" maxlength="4">
                </td>
            </tr>
            <tr>
                <th>
                    <label for="centerAdd1">회사주소
                </th>
                <td>
               		 <select id="centerAdd1" name="centerAdd1" value="시 선택">
                        <option value="서울">서울시</option>
                        <option value="경기">경기도</option>
                        <option value="강원">강원도</option>
                        <option value="경남">경상남도</option>
                        <option value="경북">경상북도</option>
                        <option value="전남">전라남도</option>
                        <option value="전북">전라북도</option>
                        <option value="대전">대전시</option>
                        <option value="제주특별자치도">제주시</option>
                        <option value="충남">충청남도</option>
                        <option value="충북">충청북도</option>
                  	 </select>&nbsp;&nbsp;
                	<select id="centerAdd2" name="centerAdd2" value="구 선택">
                        <option value="강남구">강남구</option>
                        <option value="강동구">강동구</option>
                        <option value="강북구">강북구</option>
                        <option value="강서구">강서구</option>
                        <option value="관악구">관악구</option>
                        <option value="광진구">광진구</option>
                        <option value="구로구">구로구</option>
                        <option value="금천구">금천구</option>
                        <option value="노원구">노원구</option>
                        <option value="도봉구">도봉구</option>
                        <option value="동대문구">동대문구</option>
                        <option value="동작구">동작구</option>
                        <option value="마포구">마포구</option>
                        <option value="서대문구">서대문구</option>
                        <option value="서초구">서초구</option>
                        <option value="성동구">성동구</option>
                        <option value="성북구">성북구</option>
                        <option value="송파구">송파구</option>
                        <option value="양천구">양천구</option>
                        <option value="영등포구">영등포구</option>
                        <option value="용산구">용산구</option>
                        <option value="은평구">은평구</option>
                        <option value="종로구">종로구</option>
                        <option value="중구">중구</option>
                        <option value="중랑구">중랑구</option>
                  	 </select>
                </td>
               
            </tr>
            <tr>
            	<td>
            	</td>
            	
            	 <td>
                	<input type="text" name="centerAdd3" id="centerAdd3"> 상세주소
                </td>
            </tr>
           
               
       
            <tr>
                <th>
                    <label for="opertion">운영시간</label>
                </td>
                <th>
                     <select id="operTimeStart" name="operTimeStart">
                        <option value="">시작시간</option>
                        <option value="9">9시</option>
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
                     <select id="operTimeEnd">
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
                </td>
            </tr>
            <tr>
                <th>
                    <label for="unitTime">운영단위시간
                </th>
				<td>
				
                 <select id="unitTime" name="unitTime">
                        <option value="30">30분</option>
                        <option value="60">60분</option>
                </select>
                </td>
            </tr>
             <tr>
                <th>
                    <label for="minTime">최소예약시간
                </th>
				<td>
				
                 <select id="minTime" name="minTime">
                        <option value="1">1시간</option>
                        <option value="2">2시간</option>
                        <option value="3">3시간</option>
                </select>
                </td>
            </tr>
             <tr>
                <th>
                    <label for="surchageTime">할증시작시간
                </th>
				<td>
				
                 <select id="surchageTime" name="surchageTime" >
                        <option value="16">16시</option>
                        <option value="17">17시</option>
                        <option value="18">18시</option>
                        <option value="19">19시</option>
                        <option value="20">20시</option>
                        <option value="21">21시</option>
                        <option value="22">22시</option>
                        <option value="23">23시</option>                        
                </select>
                </td>
            </tr>
            <tr>
                <th>
                    <label for="unitPrice">기준가격</label>
                </th>
                <td>
                    <input type="text" name="unitPrice" id="unitPrice" size="40"> 원
                </td>
            </tr>
             <tr>
                <th>
                    <label for="premiumRate">할증률</label>
                </th>
                <td>
                    <input type="text" name="unitPrice" id="premiumRate" size="40"> %
                </td>
            </tr>
        </tbody>
        </table>
        <br>
       
       <table class="outline" id="roomInfo">
           <colgroup>
            <col width="31%">
            <col width="31%">
            <col width="31%">
            <col width="6%">
        </colgroup>
           <thead>
       		<tr id="info">
       			<th colspan="4">
       				<h3 class="align_center">
       					방 정보
       				</h3> 
       			</th>
       		</tr>
        </thead>
            <tbody>
            <tr >
                 <th class="text_center">
                    <label for="roomCode">방 코드
                </th>
                <th class="text_center" >
                	<label for="roomName">방 이름</label>                
                </td>
                <th class="text_center" >
                    <label for="scale">방 수용인원
                </th>
                <th><i class="disp_none">추가/삭제</i></th>
			</tr>
			<tr class="trRoomInfo" name="trRoomInfo">
               <td>
                    <input type="text" name="roomCode0"class="roomCode" id="roomCode0" > 
               </td>
                <td>
                    <input type="text" name="roomName0"class="roomName" id="roomName0" > 
                </td>
               <td>
                    <input type="text" name="scale0"class="scale" id="scale0">
               </td>
               <td class="clear_both">
                <button type="button" id="rowAddBtn" class="rowAddBtn" name="rowAddBtn">+</button>
                <button type="button" id="rowDelBtn" class="rowDelBtn" name="rowDelBtn">-</button> 
             </td>
            </tr>
        </tbody>
        </table>
        <br>
        <table class="outline" id="studyFacility">
            <thead>
        	<tr id="info">
        		<td colspan="2">
        			 <h3 class="align_center">
        				편의시설 정보
        			</h3>
        		</td>
            </tr>
        </thead>
        <tbody>
        	<tr>
        		<td style="text-align:center">
        			<input type="checkbox"  class="facility" name="locker" id="locker" value="사물함" >사물함
                    <input type="checkbox" class="facility"  name="projector" id="projector" value="프로젝터">프로젝터
                    <input type="checkbox" class="facility"  name="printer" id="printer" value="프린터">프린터
                    <input type="checkbox" class="facility"  name="notebook" id="notebook" value="노트북">노트북
                    <input type="checkbox" class="facility"  name="whiteboard" id="whiteboard" value="화이트보드">화이트보드
        		
        		</td>
            </tr>
        </tbody>
        </table>
        <br>
        <table class="outline" id="centerContents">
        	<tr id="info">
        		<td colspan="2">
        			<h3 class="align_center">
        				상세 정보
        			</h3>
        		</td>
        		
        	</tr>
        	
      		<tr>
      			<th>
      				<label for="centerIntroduce">업체 소개</label>
      			</th>
      			<td>
      				<textarea class="introduce" name="centerIntroduce" id="centerIntroduce"  ></textarea>
      			</td>
      		</tr>	
      		<tr>
      			<th>
      				<label for="centerFareInfo">요금 안내</label>
      			</th> 
      			<td>
      				<textarea class="introduce" name="centerFareInfo" id="centerFareInfo"  ></textarea>
      			</td>
      		</tr>	
      		<tr>
      			<th>
      				<label for="centerUseInfo">이용 안내</label>
      			</th>
      			<td>
      				<textarea class="introduce" name="centerUseInfo" id="centerUseInfo"  ></textarea>
      			</td>
      		</tr>	
     		<tr>
      			<th>
      				업체 메인 이미지
                  </th>
      			<td>
      				<input type="file" name="file" id="foomMain" class="foomMain" />
      			</td>
      			
      		</tr>
      	
      		<tr>
      			<th>
      				<label for="foomPhoto1">방사진1</label>
                  </th>
      			<td>
      				<input type="file" class="foomPhoto" name="file" id="foomPhoto1" />
      			</td>
      		</tr>
      		<tr>
      			<th>
      				<label for="foomPhoto2">방사진2</label>
                  </th
                  >
      			<td>
      				<input type="file" class="foomPhoto" name="file" id="foomPhoto2"/>
      			</td>
      		</tr>
      		<tr>
      			<th>
      				<label for="foomPhoto3">방사진3</label>
      			</th>
      			<td>
      				<input type="file"class="foomPhoto"  name="file"id="foomPhoto3"/>
      			</td>
      		</tr>
      		<tr>
      			<th>
      				<label for="foomPhoto4">방사진4</label>
      			</th>
      			<td>
      				<input type="file"class="foomPhoto"  name="file" id="foomPhoto4"/>
      			</td>
      		</tr>
      		<tr>
      			<th>
      				<label for="foomPhoto5">방사진5</label>
      			</th>
      			<td>
      				<input type="file"class="foomPhoto"  name="file" id="foomPhoto5"/>
      			</td>
      		</tr>  
      		<tr>
                  <th>
      				<label for="foomPhoto6">방사진6</label>
      			</td>
      			<td>
      				<input type="file" class="foomPhoto" name="file" id="foomPhoto6"/>
      			</td>
      		</tr>  
      		<tr>
      			<th>
      				<label for="foomPhoto7">방사진7</label>
                  </th>
      			<td>
      				<input type="file"class="foomPhoto"  name="file" id="foomPhoto7"/>
      			</td>
      		</tr>  
      		<tr>
      			<th>
      				<label for="foomPhoto8">방사진8</label>
      			</td>
      			<th>
      				<input type="file" class="foomPhoto" name="file" id="foomPhoto8"/>
      			</td>
      		</tr>  
      		<tr>
      			<th>
      				<label for="foomPhoto9">방사진9</label>
      			</td>
      			<th>
      				<input type="file"class="foomPhoto"  name="file" id="foomPhoto9"/>
      			</td>
      		</tr>   
      		<tr>
      			<th>
      				<label for="foomPhoto10">방사진10</label>
      			</td>
      			<th>
      				<input type="file"class="foomPhoto"  name="file" id="foomPhoto10" />
      			</td>
      		</tr>       		      		
      		
      	</table>
        <br><br>
        
         <table class="inputBtn">
          <tr>
          		<td >
       				<input type="button" onclick="onPrev()" id="cancelBtn" value="취소">
       				<input type="button" onclick="onNext()" id="okBtn" value="완료">
          		</td>
                
            </tr>
        </table>
    </form>
</body>
</html>
