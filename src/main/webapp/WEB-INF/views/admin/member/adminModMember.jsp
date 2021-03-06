<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false" %>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html> 
<html>
<head>
<meta charset="UTF-8">
<title>관리자 회원가입 창</title>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Document</title>
   <link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/adminAddMember.css">
   <script src="http://code.jquery.com/jquery-latest.js"></script>
   <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
   <!-- daum 우편번호 검색 시스템-->
   <script>
   	var pwMapp = false;
   	// 패스워드 일치 확인
   	var pwPtnOk = false;
   	// 패스워드 패턴 확인
   	var idOverLap = false;
   	// 아이디 중복확인
   	var adminModeOk = false;
   
   	
   	
   	
	var userAdd = '${member.userAdd1}' + ' ' + '${member.userAdd2}' + ' ' + '${member.userAdd3}'; 
   	var userSubAdd = '${member.userAdd4}';
   	var userTel1 = '${member.userTel1}';
   	var userTel2 = '${member.userTel2}';
   	var userTel3 = '${member.userTel3}';
   	var userDate = '${member.userBirth}';
   	var userBirth = userDate.split('-');
   	var userbirthYear = userBirth[0];
   	var userbirthMonth = userBirth[1]-1;
   	var userbirthDay = userBirth[2];
   	
       $(window).on('load',function(){
    	   
		   $('#userAdd1').val(userAdd);
		   $('#userAdd2').val(userSubAdd);
		   
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
           $('.birthYear option[value='+userbirthYear+']').attr('selected',true);
           for(var i = 1; i<=12; i++){
               var count = i;
               if(i < 10){
                   count = "0"+i;
               }
               $('.birthMonth').append(
                   "<option value="+count+">"+count+"월</option>"
               )
           }
           $('.birthMonth > option[value='+userbirthMonth+']').attr('selected',true);
           for(var i=1; i<=day; i++){
               var count = i;
               if(i < 10){
                   count = "0"+i;
               }
               $('.birthDay').append(
                   "<option value="+count+">"+count+"일</option>"
               )
           }
           $('.birthDay > option[value='+userbirthDay+']').attr('selected',true);
           
           // 날짜 end\
           $('.birthDay').focus(function(){
               
               getDay();
           })



           $('#userPw').change(function(){
               pwPattern();
           })
           $('#userPwOverLapped').on("focusin focusout",function(){
               pwMapping();
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

        
        function pwPattern(){
        	var inputPw = adminAddMember.userPw.value;
            // info(error)box 생성 준비
            var pwPtn = /^[a-zA-Z](?=.*[a-zA-Z])((?=.*\d)|(?=.*\W)).{6,20}$/;
           // a~z,A~Z로 시작하고 숫자 또는 특수문자 1개이상 포함
            var info_box = document.createElement('i');
            info_box.className='info_box';
            $('#userPw').siblings().remove('.info_box');
            
            if(pwPtn.test(inputPw)){
            	info_box.className="info_box green";
                var info_text = document.createTextNode("적절한 패스워드입니다.");
                info_box.appendChild(info_text);
                $('#userPw').parent("b").append(info_box);
                pwPtnOk = true;
            }else if(!pwPtn.test(inputPw)){
            	var info_text = document.createTextNode("영문, 숫자 조합으로 6~20글자의 패스워드를 만들어주세요.");
                info_box.appendChild(info_text);
                $('#userPw').parent("b").append(info_box);
                adminAddMember.userPw.focus();
                pwPtnOk = false;
            }
        }
        
        
        function pwMapping(){
        	var inputPw = adminAddMember.userPw.value;
        	var pwMapping = adminAddMember.userPwOverLapped.value;
        	var info_box = document.createElement('i');
            info_box.className='info_box';
            $('#userPwOverLapped').siblings().remove('.info_box');
            
        	if(!(inputPw==pwMapping)){
        		info_box.className="info_box";
                var info_text = document.createTextNode("비밀번호가 일치하지 않습니다.");
                info_box.appendChild(info_text);
                $('#userPwOverLapped').parent("b").append(info_box);
                pwMapp = false;
                return;
        	}else if(inputPw==pwMapping){
                if(inputPw== ''){
                    info_box.className="info_box";
                    var info_text = document.createTextNode("비밀번호를 입력해주세요.");
                    pwMapp = false;
                }else{
                    info_box.className="info_box green";
                    var info_text = document.createTextNode("비밀번호가 동일합니다.");
                    pwMapp = true;
                }
                info_box.appendChild(info_text);
                $('#userPwOverLapped').parent("b").append(info_box);
                
                return;
            }
        }
    
    function submitAction(){
        
        var userBirth = $('.birthYear').val() + "-";
        userBirth += $('.birthMonth').val() + "-";
        userBirth += $('.birthDay').val();

        if($("#adminMode").prop("checked")){
        	adminModeOk = "1";
        } else{
        	adminModeOk = "0";
        }
    	
         
        
        if(!pwPtnOk){
            alert("패스워드형식이 일치하지 않습니다. 다시 입력해주세요.");
            $('#userPw').text('');
            $('#userPw').focus();
            return;
        }
        if(!pwMapp){
            alert("패스워드가 일치하지 않습니다. 다시 입력해주세요.");
            $('#userPwOverLapped').text('');
            $('#userPwOverLapped').focus();
            return;
        }

        // email 패턴 검사
        var emailPtn = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
        var info_box = document.createElement('i');
        info_box.className='info_box';
        $('#userEmail').siblings().remove('.info_box');
        
        if(!emailPtn.test(adminAddMember.userEmail.value)){
            var info_text = document.createTextNode("이메일 형식을 맞춰주세요.");
            info_box.appendChild(info_text);
            $('#userEmail').parent("p").append(info_box);
            $('#uesrEmail').focus();
            return;
        }
        
        // tel 패턴 검사
        if(isNaN(parseInt($("#userTel2").val())) || $('#userTel2').val().length < 3){
            var info_text = document.createTextNode("전화번호 형식에 맞춰주세요.");
            info_box.appendChild(info_text);
            $('#userTel2').parent("p").append(info_box);
            $('#userTel2').focus();
            return;
        }
        if(isNaN(parseInt($("#userTel3").val())) || $('#userTel3').val().length < 4){
            var info_text = document.createTextNode("전화번호 형식에 맞춰주세요.");
            info_box.appendChild(info_text);
            $('#userTel3').parent("p").append(info_box);
            $('#userTel3').focus();
            return;
        }
        

     	// 주소값
        var fullAdd = adminAddMember.userAdd1.value.split(' ');
       	var userAdd1 = fullAdd[0];
       	var userAdd2 = fullAdd[1];
       	var userAdd3 = "";
        for(var i=2;i<fullAdd.length;i++){
        	userAdd3 += fullAdd[i] + " "; 
        }
        // 주소값
        var member = {
            userId : adminAddMember.userId.value,
            userPw : adminAddMember.userPw.value,
            userName : adminAddMember.userName.value,
            userEmail : adminAddMember.userEmail.value,
            userBirth : userBirth,
            userTel1 : adminAddMember.userTel1.value,
            userTel2 : adminAddMember.userTel2.value,
            userTel3 : adminAddMember.userTel3.value,
            
            userAdd1 : userAdd1,
            userAdd2 : userAdd2,
            userAdd3 : userAdd3,
            userAdd4 : adminAddMember.userAdd2.value,
            adminMode : adminModeOk
        }
        for(var key in member) {
            if(isEmpty(member[key])){
            	var name;
            	if(key == 'userAdd3'){
            		key = 'userAdd2';
            		name = "상세주소"; 
            	}else{
            		name = $("#"+key).prev().text();
            	}
                
                alert(name+"를 입력해주세요.")
                $('#'+key).focus();
                return;
            }
       	}
        console.log(member);
        //ajxa 수정
        // script로 form만들어서 데이터 저장 후 전송
        $.ajax({
            type:"post",
            url:"${contextPath}/admin/modMember.do",
            dataType:"text",
            data:{"member" : JSON.stringify(member)},
            success:function(data, textStatus){
                console.log(textStatus);
                alert(member.userId+"님의 정보가 수정되었습니다..");
                searchMember();
            }

        })
    }

    var isEmpty = function(value){
         if( value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length ) ) { 
             return true 
         }else{
              return false 
              }
        };
       
    // daum 우편번호 검색 시스템
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R'){
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    // 조합된 참고항목을 해당 필드에 넣는다.
                } 
                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById("userAdd1").value = addr;
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById("userAdd2").focus();
            }
        }).open();
    }
    
    /* ===========================================================================
	 *  회원 검색
	 * ---------------------------------------------------------------------------
	 * > 입력 : searchInfo
	 * > 출력 : -
	 * > 이동 페이지 : /admin/searchMembers.do
	 * > 설명 : 
		 	- 검색필터 전달 후 회원 검색창으로
	 ===========================================================================*/
	function searchMember(){
		var form = document.createElement("form");
        form.setAttribute("charset", "UTF-8");
        form.setAttribute("method", "Get");  //Get 방식
        form.setAttribute("action", "${contextPath}/admin/searchMembers.do"); //요청 보낼 주소
        
        // searchInfo
        var searchInfo = new Object();
        searchInfo['searchFilter'] = '${searchInfo.searchFilter}';
        searchInfo['searchContent'] = '${searchInfo.searchContent}';
        searchInfo['joinStart'] = '${searchInfo.joinStart}';
        searchInfo['joinEnd'] = '${searchInfo.joinEnd}';
        searchInfo['adminMode'] = '${searchInfo.adminMode}';
        searchInfo['page'] = '${searchInfo.page}';
        
        var hiddenField = document.createElement("input");
        hiddenField.setAttribute("type", "hidden");
        hiddenField.setAttribute("name", "searchInfo");
        hiddenField.setAttribute("value", encodeURI(JSON.stringify(searchInfo)));
        form.appendChild(hiddenField);
        
        document.body.appendChild(form);
        form.submit();
	}

       
    </script>
</head>
<body>
    <div class="adminaddMemberWrap">
        <h3 class="content_title">
           회원수정 폼 
        </h3>
    <form name="adminAddMember" id="adminAddMember"  action="#" method="post">
        <fieldset>
            <ul class="adminMemList clear_both">
                <li>
                    <p>
                        <strong>아이디</strong>
                        <input type="text" name="userText" id="userText" value="${member.userId}" disabled>
                        <input required type="hidden" name="userId" id="userId" value="${member.userId}">
                    </p>
                </li>
                <li>
                    <p class="pwLap">
                        <b>
                            <strong>패스워드</strong>
                            <input required type="password" name="userPw" id="userPw" value="${member.userPw}" >
                        </b>
                        <b>
                            <strong>패스워드 확인</strong>
                            <input required type="password" name="userPwOverLapped" id="userPwOverLapped" value="${member.userPw}">
                        </b>
                    </p>
                </li>
                <li>
                    <p>
                        <strong>이름</strong>
                        <input required type="text" name="userName" id="userName" value="${member.userName}">
                    </p>
                </li>
                <li>
                    <p>
                        <strong>이메일</strong>
                        <input required  type="text" name="userEmail" id="userEmail" value="${member.userEmail}">
                    </p>
                </li>
                <li>
                    <p>
                        <strong>생년월일</strong>
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
                        <strong>전화번호</strong>
                        <select name="userTel1" class="telNum firstTelNum" id="userTel1">
                            <option value="010" selected="select">010</option>
                            <option value="011">011</option>
                            <option value="011">017</option>
                        </select>
                        <input required type="text" name="userTel2" class="telNum" maxlength="4" minlength="3" id="userTel2" value="${member.userTel2}">
                        <input required type="text" name="userTel3" class="telNum" maxlength="4" minlength="4" id="userTel3" value="${member.userTel3}">
                    </p>
                </li>
                <li>
                    <p class="addLap">
                        <b>
                            <strong>주소</strong>
                            <input type="text" id="userAdd1" name="userAdd1" disabled="disabled"><input type="button" onclick="execDaumPostcode()" value="우편번호 찾기">
                        </b>
                        <b>
                            <input required  type="text" id="userAdd2" name="userAdd2">
                        </b>
                    </p>
                </li>
                <li>
                    <p>
                        <strong><label for="addAdminChk">관리자 계정</label></strong>
                        <input type="checkbox" name="adminMode" id="adminMode">
                    </p>
                </li>
                <li>
                    <p>
                        <input class="btn_type_01" type="button" onclick="submitAction()" value="가입하기">
                        <input class="btn_type_01" type="button" value="취소" onclick="javascript:history.back()">
                    </p>
                </li>
            </ul>
        </fieldset>
    </form>
</div>

</body>
</html>