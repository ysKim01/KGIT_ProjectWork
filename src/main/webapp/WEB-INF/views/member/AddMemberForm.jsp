<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false" %>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html> 
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 창</title>
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

        
        // 아이디 중복확인 확인 변수        
        function idOverlapped(){
            var inputId = adminAddMember.userId.value;
            if(inputId == ''){
                alert("아이디를 입력하세요.");
                return;
            }

            // ID 패턴 확인
            if(!idPattern(inputId)) return;
            $.ajax({
                type:"post",
                async:false,
                url:"${contextPath}/admin/overlapped.do",
                dataType:"text",
                data:{userId : inputId},
                success:function(data, textStatus){
                    if(data=='false'){
                        alert("사용할 수 있는 ID입니다.");
                        idOverLap = true;
                        document.adminAddMember.userPw.focus();
                    }else{
                        alert("사용할 수 없는 ID입니다.");
                        idOverLap = false;
                        document.adminAddMember.userId.focus();
                    }
                }
            })
        }
        function idPattern(){
        	idOverLap = false;
        	console.log(idOverLap);
        	var inputId = adminAddMember.userId.value;
            // info(error)box 생성 준비
            var idPtn = /^[a-zA-Z](?=.*[a-zA-Z])((?=.*\d)).{5,20}$/;
           // a~z,A~Z로 시작하고 숫자
            var info_box = document.createElement('i');
            info_box.className='info_box';
            $('#userId').siblings().remove('.info_box');
            
            if(idPtn.test(inputId)){
            	info_box.className="info_box green";
                var info_text = document.createTextNode("적절한 아이디입니다.");
                info_box.appendChild(info_text);
                $('#userId').parent("p").append(info_box);
                return true;
            }else if(!idPtn.test(inputId)){
            	var info_text = document.createTextNode("영문, 숫자 조합으로 6~20글자의 아이디를 만들어주세요.");
                info_box.appendChild(info_text);
                $('#userId').parent("p").append(info_box);
                adminAddMember.userId.focus();
                return false;
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
        if(!document.getElementById('tos_chk').checked){
        	alert("이용약관에 동의해 주세요.");
        	document.getElementById('tos_chk').focus();
        	return;
        }
        if(!document.getElementById('privacy_chk').checked){
        	alert("개인정보 취급방침에 동의해 주세요.");
        	document.getElementById('privacy_chk').focus();
        	return;
        }
        
        
        var userBirth = $('.birthYear').val();
        userBirth += "-" + $('.birthMonth').val();
        userBirth += "-" + $('.birthDay').val();

        console.log("중복확인");
        if(!idOverLap){
            alert("아이디 중복확인을 해주세요.");
            $('#btnOverLapped').focus();
            return;
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
        console.log(adminAddMember.userEmail.value);
        if(!emailPtn.test(adminAddMember.userEmail.value)){
            var info_text = document.createTextNode("이메일 형식을 맞춰주세요.");
            info_box.appendChild(info_text);
            $('#userEmail').parent("p").append(info_box);
            $('#uesrEmail').focus();
            return;
        }
        console.log("email");
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
        console.log("전화번호");

     	// 주소값
        var fullAdd = adminAddMember.userAdd1.value.split(' ');
       	var userAdd1 = fullAdd[0];
       	var userAdd2 = fullAdd[1];
       	var userAdd3 = "";
        for(var i=2;i<fullAdd.length;i++){
        	userAdd3 += fullAdd[i] + " "; 
        }
        
        var adminAddMemberInfo = {
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
        }
        for(var key in adminAddMemberInfo) {
            if(isEmpty(adminAddMemberInfo[key])){
            	var name;
            	if(key == 'userAdd4'){
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
        
        //ajxa 수정
        // script로 form만들어서 데이터 저장 후 전송
        $.ajax({
            type:"post",
            url:"${contextPath}/member/addMember.do",
            dataType:"text",
            data:{"member" : JSON.stringify(adminAddMemberInfo)},
            success:function(data, textStatus){
                console.log(textStatus);
                alert(adminAddMemberInfo.userName+"님의 가입을 환영합니다.");
                window.location.href="${contextPath}/main.do";
            },
			error: function(data, status) {
				alert("error");
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

       
    </script>
</head>
<body>

<div class="mContent_wrap">
	<section class='content_top'>
            <div class="img_wrap">
                <div class="width_wrap">
                    <h2>
                        <span>Join Us</span>
                    </h2>
                </div>
                
            </div>
        </section>
        
    <div class="adminaddMemberWrap">
    <div class="width_wrap">
    <div class="privacy_wrap block_wrap">
    	<div class="block_title">
    		<h3>이용약관</h3>
    	</div>
    	<div class="txt_box">
    		<div class="txt_overflow">
    		<div class="txt_wrap">
    		
    			<div class="sub_txt">
    				<h4>제 1 장 총 칙</h4>
 
 				
						<strong>제1조 목적</strong>
						 <p>
						본 약관은 서비스 이용자가 루리웹닷컴(이하 “회사”라 합니다)이 제공하는 온라인상의 인터넷 서비스(이하 “서비스”라고 하며, 접속 가능한 유∙무선 단말기의 종류와는 상관없이 이용 가능한 “회사”가 제공하는 모든 “서비스”를 의미합니다. 이하 같습니다)에 회원으로 가입하고 이를 이용함에 있어 회사와 회원(본 약관에 동의하고 회원등록을 완료한 서비스 이용자를 말합니다. 이하 “회원”이라고 합니다)의 권리•의무 및 책임사항을 규정함을 목적으로 합니다.
						</p>
						 
						 
						<strong>제 2 조 (약관의 명시, 효력 및 개정)</strong>
						 <ul>
						<li>① 회사는 이 약관의 내용을 회원이 쉽게 알 수 있도록 서비스 초기 화면에 게시합니다.</li>
						 
						<li>② 회사는 온라인 디지털콘텐츠산업 발전법, 전자상거래 등에서의 소비자보호에 관한 법률, 약관의 규제에 관한 법률, 소비자기본법 등 관련법을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다.</li>
						 
						<li>③ 회사가 약관을 개정할 경우에는 기존약관과 개정약관 및 개정약관의 적용일자와 개정사유를 명시하여 현행약관과 함께 그 적용일자 일십오(15)일 전부터 적용일 이후 상당한 기간 동안, 개정 내용이 회원에게 불리한 경우에는 그 적용일자 삼십(30)일 전부터 적용일 이후 상당한 기간 동안 각각 이를 서비스 홈페이지에 공지하여 고지합니다.</li>
						 
						<li>④ 회사가 전항에 따라 회원에게 통지하면서 공지∙고지일로부터 개정약관 시행일 7일 후까지 거부의사를 표시하지 아니하면 승인한 것으로 본다는 뜻을 명확하게 고지하였음에도 의사표시가 없는 경우에는 변경된 약관을 승인한 것으로 봅니다. 회원이 개정약관에 동의하지 않을 경우 회원은 제15조 제1항의 규정에 따라 이용계약을 해지할 수 있습니다.</li>
						 </ul>
					 </div>
					 <div class="sub_txt">
						 
						<h4>제2장 회원의 가입 및 관리</h4>
						 
						 
						<strong>제 3 조 (회원가입절차)</strong>
						 <ul>
						<li>① 서비스 이용자가 본 약관을 읽고 “동의” 버튼을 누르거나 “확인” 등에 체크하는 방법을 취한 경우 본 약관에 동의한 것으로 간주합니다.</li>
						 
						<li>② 회사의 서비스 이용을 위한 회원가입은 서비스 이용자가 제1항과 같이 동의한 후, 회사가 정한 온라인 회원가입 신청서에 회원 ID를 포함한 필수사항을 입력하고, “등록하기” 내지 “확인” 단추를 누르는 방법으로 합니다. 다만, 회사가 필요하다고 인정하는 경우 회원에게 별도의 서류를 제출하도록 할 수 있습니다.</li>
						 </ul>
						 
						<strong>제 4 조 (회원등록의 성립과 유보 및 거절)</strong>
						<ul> 
						<li>① 회원등록은 제3조에 정한 절차에 의한 서비스 이용자의 회원가입 신청과 회사의 회원등록 승낙에 의하여 성립합니다. 회사는 회원가입 신청자가 필수사항 등을 성실히 입력하여 가입신청을 완료하였을 때에는 필요한 사항을 확인한 후 지체 없이 이를 승낙을 하여야 합니다. 단 회원가입 신청서 제출 이외에 별도의 자료 제출이 요구되는 경우에는 예외로 합니다.</li>
						 
						<li>② 회사는 아래 각 호의 1에 해당하는 경우에는 회원등록의 승낙을 유보할 수 있습니다.
						   <span>1. 제공서비스 설비용량에 현실적인 여유가 없는 경우</span>
						   <span>2. 서비스를 제공하기에는 기술적으로 문제가 있다고 판단되는 경우</span>
						   <span>3. 기타 회사가 재정적, 기술적으로 필요하다고 인정하는 경우</span>
						 </li>
						<li>③ 회사는 아래 각 호의 1에 해당하는 경우에는 회원등록을 거절 할 수 있습니다.
						   <span>1. 가입신청서의 내용을 허위로 기재하였거나 허위서류를 첨부하여 가입신청을 하는 경우</span>
						   <span>2. 14세 미만의 아동이 개인정보제공에 대한 동의를 부모 등 법정대리인으로부터 받지 않은 경우</span>
						   <span>3. 기타 회사가 관련법령 등을 기준으로 하여 명백하게 사회질서 및 미풍양속에 반할 우려가 있음을 인정하는 경우</span>
						   <span>4. 제15조 제2항에 의하여 회사가 계약을 해지했던 회원이 다시 회원 신청을 하는 경우</span>
						   <li>
						 </ul>
						 
						<strong>제 5 조 (회원 ID 등의 관리책임)</strong>
						 <ul>
						 
						<li>① 회원은 서비스 이용을 위한 회원 ID, 비밀번호의 관리에 대한 책임, 본인 ID의 제3자에 의한 부정사용 등 회원의 고의∙과실로 인해 발생하는 모든 불이익에 대한 책임을 부담합니다.</li>
						 
						<li>② 회원은 회원 ID, 비밀번호 및 추가정보 등을 도난 당하거나 제3자가 사용하고 있음을 인지한 경우에는 즉시 본인의 비밀번호를 수정하는 등의 조치를 취하여야 하며 즉시 이를 회사에 통보하여 회사의 안내를 따라야 합니다.</li>
						 </ul>
						 
						<strong>제 6 조 (개인정보의 수집 등)</strong>
						 
						<p>회사는 서비스를 제공하기 위하여 관련 법령의 규정에 따라 회원으로부터 필요한 개인정보를 수집합니다.</p>
						 
						 
						<strong>제 7 조 (회원정보의 변경)</strong>
						 
						<p>회원은 아래 각 호의 1에 해당하는 사항이 변경되었을 경우 즉시 회원정보 관리페이지에서 이를 변경하여야 합니다. 이 경우 회사는 회원이 회원정보를 변경하지 아니하여 발생한 손해에 대하여 책임을 부담하지 아니합니다.</p>
						 
				   		<strong>1. 이메일 주소</strong>
						 
						 
						</div>
						<div class="sub_txt">
						
						<h4>제3장 서비스의 이용</h4>
						 
						 
						<strong>제 8 조 (서비스 이용)</strong>
						 
						<ul><li>① 서비스 이용은 회사의 서비스 사용승낙 직후부터 가능합니다.</li>
						 
						<li>② 서비스 이용시간은 회사의 업무상 또는 기술상 불가능한 경우를 제외하고는 연중무휴 1일 24시간(00:00-24:00)으로 함을 원칙으로 합니다. 다만, 서비스설비의 정기점검 등의 사유로 회사가 서비스를 특정범위로 분할하여 별도로 날짜와 시간을 정할 수 있습니다.</li>
						 </ul>
						 
						<strong>제 9 조 (서비스내용변경 통지 등)</strong>
<p>						 
						회사가 서비스 제공을 위해 계약한 CP(Contents Provider)와의 계약종료, CP의 변경, 신규서비스의 개시 등의 사유로 서비스 내용이 변경되거나 서비스가 종료되는 경우 회사는 공지를 통하여 서비스 내용의 변경 사항 또는 종료를 통지할 수 있습니다.
	</p>					 
						 
						<strong>제 10 조 (권리의 귀속 및 저작물의 이용)</strong>
						 <ul>
						 
						<li>① 회원이 서비스 내에 게시한 게시물 등(이하 "게시물 등"이라 합니다)의 저작권은 해당 게시물의 저작자에게 귀속됩니다.</li>
						 
						<li>② 게시물 등은 회사가 운영하는 인터넷 사이트 및 모바일 어플리케이션을 통해 노출될 수 있으며, 검색결과 내지 관련 프로모션 등에도 노출될 수 있습니다. 해당 노출을 위해 필요한 범위 내에서는 일부 수정, 복제, 편집되어 게시될 수 있습니다. 이 경우, 회사는 저작권법 규정을 준수하며, 회원은 언제든지 고객센터 또는 각 서비스 내 관리기능을 통해 해당 게시물 등에 대해 삭제 등의 조치를 취할 수 있습니다.</li>
						 </ul> 
						 
						<strong>제 11 조 (서비스 이용의 제한 및 중지)</strong>
						 
						 <ul>
						 
						<li>① 회사는 아래 각 호의 1에 해당하는 사유가 발생한 경우에는 회원의 서비스 이용을 제한하거나 중지시킬 수 있습니다.
						   <span>1. 회원이 회사 서비스의 운영을 고의∙과실로 방해하는 경우</span>
						   <span>2. 회원이 제13조의 의무를 위반한 경우</span>
						   <span>3. 서비스용 설비 점검, 보수 또는 공사로 인하여 부득이한 경우</span>
						   <span>4. 전기통신사업법에 규정된 기간통신사업자가 전기통신 서비스를 중지했을 경우</span>
						   <span>5. 국가비상사태, 서비스 설비의 장애 또는 서비스 이용의 폭주 등으로 서비스 이용에 지장이 있는 때</span>
						   <span>6. 기타 중대한 사유로 인하여 회사가 서비스 제공을 지속하는 것이 부적당하다고 인정하는 경우</span>
						 </li>
						<li>② 회사는 전항의 규정에 의하여 서비스의 이용을 제한하거나 중지한 때에는 그 사유 및 제한기간등을 회원에게 알려야 합니다.</li>
						 
<li>						③ 제15조 제2항에 의해 회사가 회원과의 계약을 해지하고 서비스 이용을 중지시키기로 결정한 경우 회사는 회원의 서비스 이용을 중지시키고 재가입을 차단하기 위해 본인인증값을 저장합니다.</li>
						 
	<li>					④ 정보통신망 이용촉진 및 정보보호 등에 관한 법률(이하 “정보통신망법”이라 합니다)의 규정에 의해 다른 회원의 공개된 게시물 등이 본인의 사생활을 침해하거나 명예를 훼손하는 등 권리를 침해 받은 회원 또는 제3자(이하 “삭제 등 신청인”이라 합니다)는 그 침해사실을 소명하여 회사에 해당 게시물 등의 삭제 또는 반박 내용의 게재를 요청할 수 있습니다. 이 경우 회사는 해당 게시물 등의 권리 침해 여부를 판단할 수 없거나 당사자 간의 다툼이 예상되는 경우 해당 게시물 등에 대한 접근을 임시적으로 차단하는 조치(이하 “임시삭제”라 합니다)를 최장 30일까지 취합니다.</li>
						 
		<li>				⑤ 제4항에 의해 본인의 게시물 등이 임시삭제된 회원(이하 “게시자”라 합니다)은 임시삭제기간 중 회사에 해당 게시물 등을 복원해 줄 것을 요청(이하 “재게시 청구”라 합니다)할 수 있으며, 회사는 임시삭제된 게시물의 명예훼손 등 판단에 대한 방송통신심의위원회 심의 요청에 대한 게시자 및 삭제 등 신청인의 동의가 있는 경우 게시자 및 삭제 등 신청인을 대리하여 이를 요청하고 동의가 없는 경우 회사가 이를 판단하여 게시물 등의 복원 여부를 결정합니다. 게시자의 재게시 청구가 있는 경우 임시삭제 기간 내에 방송통신심의위원회 또는 회사의 결정이 있으면 그 결정에 따르고 그 결정이 임시삭제 기간 내에 있지 않는 경우 해당 게시물 등은 임시삭제 만료일 이후 복원됩니다. 재게시 청구가 없는 경우 해당 게시물 등은 임시삭제 기간 만료 이후 영구 삭제 될 수 있습니다.</li>
						 
			<li>			⑥ 회사는 서비스 내에 게시된 게시물 등이 사생활 침해 또는 명예훼손 등 제3자의 권리를 침해한다고 인정하는 경우 제4항에 따른 회원 또는 제3자의 신고가 없는 경우에도 임시삭제(이하 “임의의 임시삭제”라 합니다)를 취할 수 있습니다. 임의의 임시삭제된 게시물의 처리 절차는 제4항 후단 및 제5항의 규정에 따릅니다.</li>
						 
						<li>⑦ 회원의 게시물 등으로 인한 법률상 이익 침해를 근거로, 다른 회원 또는 제3자가 회원 또는 회사를 대상으로 하여 민형사상의 법적 조치(예: 형사고소, 가처분 신청∙손해배상청구 등 민사소송의 제기)를 취하는 경우, 회사는 동 법적 조치의 결과인 법원의 확정판결이 있을 때까지 관련 게시물 등에 대한 접근을 잠정적으로 제한할 수 있습니다. 게시물 등의 접근 제한과 관련한 법적 조치의 소명, 법원의 확정 판결에 대한 소명 책임은 게시물 등에 대한 조치를 요청하는 자가 부담합니다.</li>
						 
						 </ul>
						<strong>제 12 조 (회사의 의무)</strong>
						 
						<ul><li>① 회사는 회사의 서비스 제공 및 보안과 관련된 설비를 지속적이고 안정적인 서비스 제공에 적합하도록 유지, 점검 또는 복구 등의 조치를 성실히 이행하여야 합니다.</li>
						 
						<li>② 회사는 회원이 수신 동의를 하지 않은 영리 목적의 광고성 전자우편, SMS 문자메시지 등을 발송하지 아니합니다.</li>
						 
						<li>③ 회사는 서비스의 제공과 관련하여 알게 된 회원의 개인정보를 본인의 승낙 없이 제3자에게 누설, 배포하지 않고, 이를 보호하기 위하여 노력합니다. 회원의 개인정보보호에 관한 기타의 사항은 정보통신망법 및 회사가 별도로 정한 “개인정보관리지침”에 따릅니다.</li>
						 
						<li>④ 회사가 제3자와의 서비스 제공계약 등을 체결하여 회원에게 서비스를 제공하는 경우 회사는 각 개별서비스에서 서비스의 제공을 위하여 제3자에게 제공되는 회원의 구체적인 회원정보를 명시하고 회원의 개별적이고 명시적인 동의를 받은 후 동의의 범위 내에서 해당 서비스의 제공 기간 동안에 한하여 회원의 개인정보를 제3자와 공유하는 등 관련 법령을 준수합니다.</li>
						 </ul>
						 
						<strong>제 13 조 (회원의 의무)</strong>
						 
						<ul><li>① 회원은 아래 각 호의 1에 해당하는 행위를 하여서는 아니 됩니다.
						   <span>1. 회원가입신청 또는 변경 시 허위내용을 등록하는 행위</span> 
						   <span>2. 회사의 서비스에 게시된 정보를 변경하거나 서비스를 이용하여 얻은 정보를 회사의 사전 승낙 없이 영리 또는 비영리의 목적으로 복제, 출판, 방송 등에 사
						      용하거나 제3자에게 제공하는 행위</span>
						   <span>3. 회사가 제공하는 서비스를 이용하여 제3자에게 본인을 홍보할 기회를 제공 하거나 제3자의 홍보를 대행하는 등의 방법으로 금전을 수수하거나 서비스를 이
						      용할 권리를 양도하고 이를 대가로 금전을 수수하는 행위</span>
						   <span>4. 회사 기타 제3자에 대한 허위의 사실을 게재하거나 지적재산권을 침해하는 등 회사나 제3자의 권리를 침해하는 행위</span>
						   <span>5. 다른 회원의 ID 및 비밀번호를 도용하여 부당하게 서비스를 이용하는 행위</span>
						   <span>6. 정크메일(junk mail), 스팸메일(spam mail), 행운의 편지(chain letters), 피라미드 조직에 가입할 것을 권유하는 메일, 외설 또는 폭력적인 메시지•화상•음
						      성 등이 담긴 메일을 보내거나 기타 공서양속에 반하는 정보를 공개 또는 게시하는 행위 </span>
						   <span>7. 정보통신망법 등 관련 법령에 의하여 그 전송 또는 게시가 금지되는 정보(컴퓨터 프로그램 등)를 전송하거나 게시하는 행위</span>
						   <span>8. 청소년보호법에서 규정하는 청소년유해매체물을 게시하는 행위</span>
						   <span>9. 공공질서 또는 미풍양속에 위배되는 내용의 정보, 문장, 도형, 음성 등을 유포하는 행위</span>
						   <span>10. 회사의 직원이나 서비스의 관리자를 가장하거나 사칭하여 또는 타인의 명의를 모용하여 글을 게시하거나 메일을 발송하는 행위</span>
						   <span>11. 컴퓨터 소프트웨어, 하드웨어, 전기통신 장비의 정상적인 가동을 방해, 파괴할 목적으로 고안된 소프트웨어 바이러스, 기타 다른 컴퓨터 코드, 파일, 프로
						       그램을 포함하고 있는 자료를 게시하거나 전자우편으로 발송하는 행위</span>
						   <span>12. 어그로(Aggravation), 분탕질, 스토킹(stalking), 욕설, 글 도배 등 다른 회원의 서비스 이용을 방해하는 행위</span>
						   <span>13. 다른 회원의 개인정보를 그 동의 없이 수집, 저장, 공개하는 행위</span>
						   <span>14. 불특정 다수의 회원을 대상으로 하여 광고 또는 선전을 게시하거나 스팸메일을 전송할 목적으로 회사에서 제공하는 프리미엄 메일 기타 서비스를 이용하
						       여 영리활동을 하는 행위</span>
						   <span>15. 회사가 제공하는 소프트웨어 등을 개작하거나 리버스 엔지니어링, 디컴파일, 디스어셈블 하는 행위</span>
						   <span>16. 현행 법령, 회사가 제공하는 서비스에 정한 약관 기타 서비스 이용에 관한 규정을 위반하는 행위</span>
						 
						<li>② 회사는 회원이 제1항의 행위를 하는 경우 해당 게시물 등을 삭제 또는 임시삭제할 수 있고 서비스의 이용을 제한하거나 일방적으로 본 계약을 해지할 수 있습니다.</li>
						
						 
						 </ul>
						<strong>제 14 조 (양도금지)</strong>
						 
						<p>회원의 서비스 받을 권리는 이를 양도 내지 증여하거나 질권의 목적으로 사용할 수 없습니다.</p>
						 
						 
						<strong>제 15 조 (이용계약의 해지)</strong>
						 <ul>
						<li>① 회원이 서비스 이용계약을 해지하고자 하는 때에는 언제든지 회원정보관리에서 회사가 정한 절차에 따라 회원의 ID를 삭제하고 탈퇴할 수 있습니다.</li>
						 
						<li>② 회원이 제13조의 규정을 위반한 경우 회사는 일방적으로 본 계약을 해지할 수 있고, 이로 인하여 서비스 운영에 손해가 발생한 경우 이에 대한 민, 형사상 책임도 물을 수 있습니다.</li>
						 
						<li>③ 회원이 서비스를 이용하는 도중, 연속하여 일(1)년 동안 서비스를 이용하기 위해 회사의 서비스에 log-in한 기록이 없는 경우 회사는 회원의 회원자격을 상실시킬 수 있습니다.</li>
						  
<li>						④ 본 이용 계약이 해지된 경우 회원의 쪽지, 마이피와 같이 본인 개인 영역에 등록된 ‘쪽지글, 게시글 등’ 일체는 삭제됩니다만 다른 회원에 의해 스크랩되어 게시되거나 공용 게시판에 등록된 ‘게시물 등’은 삭제되지 않습니다.</li>
						 </ul>
					 </div>
					 
					 <div class="sub_txt">
						 
						<h4>제4장 기타</h4>
						 
						 
						<strong>제 16 조 (청소년 보호)</strong>
						<p> 
						회사는 모든 연령대가 자유롭게 이용할 수 있는 공간으로써 유해 정보로부터 청소년을 보호하고 청소년의 안전한 인터넷 사용을 돕기 위해 정보통신망법에서 정한 청소년보호정책을 별도로 시행하고 있으며, 구체적인 내용은 서비스 초기 화면 등에서 확인할 수 있습니다.
						 </p>
						 
						<strong>제 17 조 (면책)</strong>
						 <ul>
						 
						<li>① 회사는 다음 각 호의 경우로 서비스를 제공할 수 없는 경우 이로 인하여 회원에게 발생한 손해에 대해서는 책임을 부담하지 않습니다.</li>
						   <span>1. 천재지변 또는 이에 준하는 불가항력의 상태가 있는 경우</span>
						   <span>2. 서비스 제공을 위하여 회사와 서비스 제휴계약을 체결한 제3자의 고의적인 서비스 방해가 있는 경우</span>
						   <span>3. 회원의 귀책사유로 서비스 이용에 장애가 있는 경우</span>
						   <span>4. 제1호 내지 제3호를 제외한 기타 회사의 고의∙과실이 없는 사유로 인한 경우</span>
						 
						<li>② 회사는 CP가 제공하거나 회원이 작성하는 등의 방법으로 서비스에 게재된 정보, 자료, 사실의 신뢰도, 정확성 등에 대해서는 보증을 하지 않으며 이로 인해 발생한 회원의 손해에 대하여는 책임을 부담하지 아니합니다.</li>
						 </ul>
						 
						<strong>제 18 조 (분쟁의 해결)</strong>
						 
						<p>본 약관은 대한민국법령에 의하여 규정되고 이행되며, 서비스 이용과 관련하여 회사와 회원간에 발생한 분쟁에 대해서는 민사소송법상의 주소지를 관할하는 법원을 합의관할로 합니다.</p>
						 
						 
						<strong>제 19 조 (규정의 준용)</strong>
						 
						<p>본 약관에 명시되지 않은 사항에 대해서는 관련법령에 의하고, 법에 명시되지 않은 부분에 대하여는 관습에 의합니다.</p>
						 
						 
						<p>본 약관은 2016년 6월 27일부터 적용됩니다.</p>
						
					</div>
    			</div>
    			
    		</div>
    		
    	</div>
    	<div class="privacy_chk">
    				<input type="checkbox" id="tos_chk" name="tos"><label for="tos_chk">동의합니다.</label>
    			</div>
  		</div>
    <div class="privacy_wrap block_wrap">
    	<div class="block_title">
    		<h3>개인정보 수집 및 동의</h3>
    	</div>
    	<div class="txt_box">
    		<div class="txt_overflow">
    		<div class="txt_wrap">
    		
    			<div class="sub_txt">
    				<h4>제 1 장 총 칙</h4>
 
 				
						<strong>제1조 목적</strong>
						 <p>
						본 약관은 서비스 이용자가 루리웹닷컴(이하 “회사”라 합니다)이 제공하는 온라인상의 인터넷 서비스(이하 “서비스”라고 하며, 접속 가능한 유∙무선 단말기의 종류와는 상관없이 이용 가능한 “회사”가 제공하는 모든 “서비스”를 의미합니다. 이하 같습니다)에 회원으로 가입하고 이를 이용함에 있어 회사와 회원(본 약관에 동의하고 회원등록을 완료한 서비스 이용자를 말합니다. 이하 “회원”이라고 합니다)의 권리•의무 및 책임사항을 규정함을 목적으로 합니다.
						</p>
						 
						 
						<strong>제 2 조 (약관의 명시, 효력 및 개정)</strong>
						 <ul>
						<li>① 회사는 이 약관의 내용을 회원이 쉽게 알 수 있도록 서비스 초기 화면에 게시합니다.</li>
						 
						<li>② 회사는 온라인 디지털콘텐츠산업 발전법, 전자상거래 등에서의 소비자보호에 관한 법률, 약관의 규제에 관한 법률, 소비자기본법 등 관련법을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다.</li>
						 
						<li>③ 회사가 약관을 개정할 경우에는 기존약관과 개정약관 및 개정약관의 적용일자와 개정사유를 명시하여 현행약관과 함께 그 적용일자 일십오(15)일 전부터 적용일 이후 상당한 기간 동안, 개정 내용이 회원에게 불리한 경우에는 그 적용일자 삼십(30)일 전부터 적용일 이후 상당한 기간 동안 각각 이를 서비스 홈페이지에 공지하여 고지합니다.</li>
						 
						<li>④ 회사가 전항에 따라 회원에게 통지하면서 공지∙고지일로부터 개정약관 시행일 7일 후까지 거부의사를 표시하지 아니하면 승인한 것으로 본다는 뜻을 명확하게 고지하였음에도 의사표시가 없는 경우에는 변경된 약관을 승인한 것으로 봅니다. 회원이 개정약관에 동의하지 않을 경우 회원은 제15조 제1항의 규정에 따라 이용계약을 해지할 수 있습니다.</li>
						 </ul>
					 </div>
					 <div class="sub_txt">
						 
						<h4>제2장 회원의 가입 및 관리</h4>
						 
						 
						<strong>제 3 조 (회원가입절차)</strong>
						 <ul>
						<li>① 서비스 이용자가 본 약관을 읽고 “동의” 버튼을 누르거나 “확인” 등에 체크하는 방법을 취한 경우 본 약관에 동의한 것으로 간주합니다.</li>
						 
						<li>② 회사의 서비스 이용을 위한 회원가입은 서비스 이용자가 제1항과 같이 동의한 후, 회사가 정한 온라인 회원가입 신청서에 회원 ID를 포함한 필수사항을 입력하고, “등록하기” 내지 “확인” 단추를 누르는 방법으로 합니다. 다만, 회사가 필요하다고 인정하는 경우 회원에게 별도의 서류를 제출하도록 할 수 있습니다.</li>
						 </ul>
						 
						<strong>제 4 조 (회원등록의 성립과 유보 및 거절)</strong>
						<ul> 
						<li>① 회원등록은 제3조에 정한 절차에 의한 서비스 이용자의 회원가입 신청과 회사의 회원등록 승낙에 의하여 성립합니다. 회사는 회원가입 신청자가 필수사항 등을 성실히 입력하여 가입신청을 완료하였을 때에는 필요한 사항을 확인한 후 지체 없이 이를 승낙을 하여야 합니다. 단 회원가입 신청서 제출 이외에 별도의 자료 제출이 요구되는 경우에는 예외로 합니다.</li>
						 
						<li>② 회사는 아래 각 호의 1에 해당하는 경우에는 회원등록의 승낙을 유보할 수 있습니다.
						   <span>1. 제공서비스 설비용량에 현실적인 여유가 없는 경우</span>
						   <span>2. 서비스를 제공하기에는 기술적으로 문제가 있다고 판단되는 경우</span>
						   <span>3. 기타 회사가 재정적, 기술적으로 필요하다고 인정하는 경우</span>
						 </li>
						<li>③ 회사는 아래 각 호의 1에 해당하는 경우에는 회원등록을 거절 할 수 있습니다.
						   <span>1. 가입신청서의 내용을 허위로 기재하였거나 허위서류를 첨부하여 가입신청을 하는 경우</span>
						   <span>2. 14세 미만의 아동이 개인정보제공에 대한 동의를 부모 등 법정대리인으로부터 받지 않은 경우</span>
						   <span>3. 기타 회사가 관련법령 등을 기준으로 하여 명백하게 사회질서 및 미풍양속에 반할 우려가 있음을 인정하는 경우</span>
						   <span>4. 제15조 제2항에 의하여 회사가 계약을 해지했던 회원이 다시 회원 신청을 하는 경우</span>
						   <li>
						 </ul>
						 
						<strong>제 5 조 (회원 ID 등의 관리책임)</strong>
						 <ul>
						 
						<li>① 회원은 서비스 이용을 위한 회원 ID, 비밀번호의 관리에 대한 책임, 본인 ID의 제3자에 의한 부정사용 등 회원의 고의∙과실로 인해 발생하는 모든 불이익에 대한 책임을 부담합니다.</li>
						 
						<li>② 회원은 회원 ID, 비밀번호 및 추가정보 등을 도난 당하거나 제3자가 사용하고 있음을 인지한 경우에는 즉시 본인의 비밀번호를 수정하는 등의 조치를 취하여야 하며 즉시 이를 회사에 통보하여 회사의 안내를 따라야 합니다.</li>
						 </ul>
						 
						<strong>제 6 조 (개인정보의 수집 등)</strong>
						 
						<p>회사는 서비스를 제공하기 위하여 관련 법령의 규정에 따라 회원으로부터 필요한 개인정보를 수집합니다.</p>
						 
						 
						<strong>제 7 조 (회원정보의 변경)</strong>
						 
						<p>회원은 아래 각 호의 1에 해당하는 사항이 변경되었을 경우 즉시 회원정보 관리페이지에서 이를 변경하여야 합니다. 이 경우 회사는 회원이 회원정보를 변경하지 아니하여 발생한 손해에 대하여 책임을 부담하지 아니합니다.</p>
						 
				   		<strong>1. 이메일 주소</strong>
						 
						 
						</div>
						<div class="sub_txt">
						
						<h4>제3장 서비스의 이용</h4>
						 
						 
						<strong>제 8 조 (서비스 이용)</strong>
						 
						<ul><li>① 서비스 이용은 회사의 서비스 사용승낙 직후부터 가능합니다.</li>
						 
						<li>② 서비스 이용시간은 회사의 업무상 또는 기술상 불가능한 경우를 제외하고는 연중무휴 1일 24시간(00:00-24:00)으로 함을 원칙으로 합니다. 다만, 서비스설비의 정기점검 등의 사유로 회사가 서비스를 특정범위로 분할하여 별도로 날짜와 시간을 정할 수 있습니다.</li>
						 </ul>
						 
						<strong>제 9 조 (서비스내용변경 통지 등)</strong>
<p>						 
						회사가 서비스 제공을 위해 계약한 CP(Contents Provider)와의 계약종료, CP의 변경, 신규서비스의 개시 등의 사유로 서비스 내용이 변경되거나 서비스가 종료되는 경우 회사는 공지를 통하여 서비스 내용의 변경 사항 또는 종료를 통지할 수 있습니다.
	</p>					 
						 
						<strong>제 10 조 (권리의 귀속 및 저작물의 이용)</strong>
						 <ul>
						 
						<li>① 회원이 서비스 내에 게시한 게시물 등(이하 "게시물 등"이라 합니다)의 저작권은 해당 게시물의 저작자에게 귀속됩니다.</li>
						 
						<li>② 게시물 등은 회사가 운영하는 인터넷 사이트 및 모바일 어플리케이션을 통해 노출될 수 있으며, 검색결과 내지 관련 프로모션 등에도 노출될 수 있습니다. 해당 노출을 위해 필요한 범위 내에서는 일부 수정, 복제, 편집되어 게시될 수 있습니다. 이 경우, 회사는 저작권법 규정을 준수하며, 회원은 언제든지 고객센터 또는 각 서비스 내 관리기능을 통해 해당 게시물 등에 대해 삭제 등의 조치를 취할 수 있습니다.</li>
						 </ul> 
						 
						<strong>제 11 조 (서비스 이용의 제한 및 중지)</strong>
						 
						 <ul>
						 
						<li>① 회사는 아래 각 호의 1에 해당하는 사유가 발생한 경우에는 회원의 서비스 이용을 제한하거나 중지시킬 수 있습니다.
						   <span>1. 회원이 회사 서비스의 운영을 고의∙과실로 방해하는 경우</span>
						   <span>2. 회원이 제13조의 의무를 위반한 경우</span>
						   <span>3. 서비스용 설비 점검, 보수 또는 공사로 인하여 부득이한 경우</span>
						   <span>4. 전기통신사업법에 규정된 기간통신사업자가 전기통신 서비스를 중지했을 경우</span>
						   <span>5. 국가비상사태, 서비스 설비의 장애 또는 서비스 이용의 폭주 등으로 서비스 이용에 지장이 있는 때</span>
						   <span>6. 기타 중대한 사유로 인하여 회사가 서비스 제공을 지속하는 것이 부적당하다고 인정하는 경우</span>
						 </li>
						<li>② 회사는 전항의 규정에 의하여 서비스의 이용을 제한하거나 중지한 때에는 그 사유 및 제한기간등을 회원에게 알려야 합니다.</li>
						 
<li>						③ 제15조 제2항에 의해 회사가 회원과의 계약을 해지하고 서비스 이용을 중지시키기로 결정한 경우 회사는 회원의 서비스 이용을 중지시키고 재가입을 차단하기 위해 본인인증값을 저장합니다.</li>
						 
	<li>					④ 정보통신망 이용촉진 및 정보보호 등에 관한 법률(이하 “정보통신망법”이라 합니다)의 규정에 의해 다른 회원의 공개된 게시물 등이 본인의 사생활을 침해하거나 명예를 훼손하는 등 권리를 침해 받은 회원 또는 제3자(이하 “삭제 등 신청인”이라 합니다)는 그 침해사실을 소명하여 회사에 해당 게시물 등의 삭제 또는 반박 내용의 게재를 요청할 수 있습니다. 이 경우 회사는 해당 게시물 등의 권리 침해 여부를 판단할 수 없거나 당사자 간의 다툼이 예상되는 경우 해당 게시물 등에 대한 접근을 임시적으로 차단하는 조치(이하 “임시삭제”라 합니다)를 최장 30일까지 취합니다.</li>
						 
		<li>				⑤ 제4항에 의해 본인의 게시물 등이 임시삭제된 회원(이하 “게시자”라 합니다)은 임시삭제기간 중 회사에 해당 게시물 등을 복원해 줄 것을 요청(이하 “재게시 청구”라 합니다)할 수 있으며, 회사는 임시삭제된 게시물의 명예훼손 등 판단에 대한 방송통신심의위원회 심의 요청에 대한 게시자 및 삭제 등 신청인의 동의가 있는 경우 게시자 및 삭제 등 신청인을 대리하여 이를 요청하고 동의가 없는 경우 회사가 이를 판단하여 게시물 등의 복원 여부를 결정합니다. 게시자의 재게시 청구가 있는 경우 임시삭제 기간 내에 방송통신심의위원회 또는 회사의 결정이 있으면 그 결정에 따르고 그 결정이 임시삭제 기간 내에 있지 않는 경우 해당 게시물 등은 임시삭제 만료일 이후 복원됩니다. 재게시 청구가 없는 경우 해당 게시물 등은 임시삭제 기간 만료 이후 영구 삭제 될 수 있습니다.</li>
						 
			<li>			⑥ 회사는 서비스 내에 게시된 게시물 등이 사생활 침해 또는 명예훼손 등 제3자의 권리를 침해한다고 인정하는 경우 제4항에 따른 회원 또는 제3자의 신고가 없는 경우에도 임시삭제(이하 “임의의 임시삭제”라 합니다)를 취할 수 있습니다. 임의의 임시삭제된 게시물의 처리 절차는 제4항 후단 및 제5항의 규정에 따릅니다.</li>
						 
						<li>⑦ 회원의 게시물 등으로 인한 법률상 이익 침해를 근거로, 다른 회원 또는 제3자가 회원 또는 회사를 대상으로 하여 민형사상의 법적 조치(예: 형사고소, 가처분 신청∙손해배상청구 등 민사소송의 제기)를 취하는 경우, 회사는 동 법적 조치의 결과인 법원의 확정판결이 있을 때까지 관련 게시물 등에 대한 접근을 잠정적으로 제한할 수 있습니다. 게시물 등의 접근 제한과 관련한 법적 조치의 소명, 법원의 확정 판결에 대한 소명 책임은 게시물 등에 대한 조치를 요청하는 자가 부담합니다.</li>
						 
						 </ul>
						<strong>제 12 조 (회사의 의무)</strong>
						 
						<ul><li>① 회사는 회사의 서비스 제공 및 보안과 관련된 설비를 지속적이고 안정적인 서비스 제공에 적합하도록 유지, 점검 또는 복구 등의 조치를 성실히 이행하여야 합니다.</li>
						 
						<li>② 회사는 회원이 수신 동의를 하지 않은 영리 목적의 광고성 전자우편, SMS 문자메시지 등을 발송하지 아니합니다.</li>
						 
						<li>③ 회사는 서비스의 제공과 관련하여 알게 된 회원의 개인정보를 본인의 승낙 없이 제3자에게 누설, 배포하지 않고, 이를 보호하기 위하여 노력합니다. 회원의 개인정보보호에 관한 기타의 사항은 정보통신망법 및 회사가 별도로 정한 “개인정보관리지침”에 따릅니다.</li>
						 
						<li>④ 회사가 제3자와의 서비스 제공계약 등을 체결하여 회원에게 서비스를 제공하는 경우 회사는 각 개별서비스에서 서비스의 제공을 위하여 제3자에게 제공되는 회원의 구체적인 회원정보를 명시하고 회원의 개별적이고 명시적인 동의를 받은 후 동의의 범위 내에서 해당 서비스의 제공 기간 동안에 한하여 회원의 개인정보를 제3자와 공유하는 등 관련 법령을 준수합니다.</li>
						 </ul>
						 
						<strong>제 13 조 (회원의 의무)</strong>
						 
						<ul><li>① 회원은 아래 각 호의 1에 해당하는 행위를 하여서는 아니 됩니다.
						   <span>1. 회원가입신청 또는 변경 시 허위내용을 등록하는 행위</span> 
						   <span>2. 회사의 서비스에 게시된 정보를 변경하거나 서비스를 이용하여 얻은 정보를 회사의 사전 승낙 없이 영리 또는 비영리의 목적으로 복제, 출판, 방송 등에 사
						      용하거나 제3자에게 제공하는 행위</span>
						   <span>3. 회사가 제공하는 서비스를 이용하여 제3자에게 본인을 홍보할 기회를 제공 하거나 제3자의 홍보를 대행하는 등의 방법으로 금전을 수수하거나 서비스를 이
						      용할 권리를 양도하고 이를 대가로 금전을 수수하는 행위</span>
						   <span>4. 회사 기타 제3자에 대한 허위의 사실을 게재하거나 지적재산권을 침해하는 등 회사나 제3자의 권리를 침해하는 행위</span>
						   <span>5. 다른 회원의 ID 및 비밀번호를 도용하여 부당하게 서비스를 이용하는 행위</span>
						   <span>6. 정크메일(junk mail), 스팸메일(spam mail), 행운의 편지(chain letters), 피라미드 조직에 가입할 것을 권유하는 메일, 외설 또는 폭력적인 메시지•화상•음
						      성 등이 담긴 메일을 보내거나 기타 공서양속에 반하는 정보를 공개 또는 게시하는 행위 </span>
						   <span>7. 정보통신망법 등 관련 법령에 의하여 그 전송 또는 게시가 금지되는 정보(컴퓨터 프로그램 등)를 전송하거나 게시하는 행위</span>
						   <span>8. 청소년보호법에서 규정하는 청소년유해매체물을 게시하는 행위</span>
						   <span>9. 공공질서 또는 미풍양속에 위배되는 내용의 정보, 문장, 도형, 음성 등을 유포하는 행위</span>
						   <span>10. 회사의 직원이나 서비스의 관리자를 가장하거나 사칭하여 또는 타인의 명의를 모용하여 글을 게시하거나 메일을 발송하는 행위</span>
						   <span>11. 컴퓨터 소프트웨어, 하드웨어, 전기통신 장비의 정상적인 가동을 방해, 파괴할 목적으로 고안된 소프트웨어 바이러스, 기타 다른 컴퓨터 코드, 파일, 프로
						       그램을 포함하고 있는 자료를 게시하거나 전자우편으로 발송하는 행위</span>
						   <span>12. 어그로(Aggravation), 분탕질, 스토킹(stalking), 욕설, 글 도배 등 다른 회원의 서비스 이용을 방해하는 행위</span>
						   <span>13. 다른 회원의 개인정보를 그 동의 없이 수집, 저장, 공개하는 행위</span>
						   <span>14. 불특정 다수의 회원을 대상으로 하여 광고 또는 선전을 게시하거나 스팸메일을 전송할 목적으로 회사에서 제공하는 프리미엄 메일 기타 서비스를 이용하
						       여 영리활동을 하는 행위</span>
						   <span>15. 회사가 제공하는 소프트웨어 등을 개작하거나 리버스 엔지니어링, 디컴파일, 디스어셈블 하는 행위</span>
						   <span>16. 현행 법령, 회사가 제공하는 서비스에 정한 약관 기타 서비스 이용에 관한 규정을 위반하는 행위</span>
						 
						<li>② 회사는 회원이 제1항의 행위를 하는 경우 해당 게시물 등을 삭제 또는 임시삭제할 수 있고 서비스의 이용을 제한하거나 일방적으로 본 계약을 해지할 수 있습니다.</li>
						
						 
						 </ul>
						<strong>제 14 조 (양도금지)</strong>
						 
						<p>회원의 서비스 받을 권리는 이를 양도 내지 증여하거나 질권의 목적으로 사용할 수 없습니다.</p>
						 
						 
						<strong>제 15 조 (이용계약의 해지)</strong>
						 <ul>
						<li>① 회원이 서비스 이용계약을 해지하고자 하는 때에는 언제든지 회원정보관리에서 회사가 정한 절차에 따라 회원의 ID를 삭제하고 탈퇴할 수 있습니다.</li>
						 
						<li>② 회원이 제13조의 규정을 위반한 경우 회사는 일방적으로 본 계약을 해지할 수 있고, 이로 인하여 서비스 운영에 손해가 발생한 경우 이에 대한 민, 형사상 책임도 물을 수 있습니다.</li>
						 
						<li>③ 회원이 서비스를 이용하는 도중, 연속하여 일(1)년 동안 서비스를 이용하기 위해 회사의 서비스에 log-in한 기록이 없는 경우 회사는 회원의 회원자격을 상실시킬 수 있습니다.</li>
						  
<li>						④ 본 이용 계약이 해지된 경우 회원의 쪽지, 마이피와 같이 본인 개인 영역에 등록된 ‘쪽지글, 게시글 등’ 일체는 삭제됩니다만 다른 회원에 의해 스크랩되어 게시되거나 공용 게시판에 등록된 ‘게시물 등’은 삭제되지 않습니다.</li>
						 </ul>
					 </div>
					 
					 <div class="sub_txt">
						 
						<h4>제4장 기타</h4>
						 
						 
						<strong>제 16 조 (청소년 보호)</strong>
						<p> 
						회사는 모든 연령대가 자유롭게 이용할 수 있는 공간으로써 유해 정보로부터 청소년을 보호하고 청소년의 안전한 인터넷 사용을 돕기 위해 정보통신망법에서 정한 청소년보호정책을 별도로 시행하고 있으며, 구체적인 내용은 서비스 초기 화면 등에서 확인할 수 있습니다.
						 </p>
						 
						<strong>제 17 조 (면책)</strong>
						 <ul>
						 
						<li>① 회사는 다음 각 호의 경우로 서비스를 제공할 수 없는 경우 이로 인하여 회원에게 발생한 손해에 대해서는 책임을 부담하지 않습니다.</li>
						   <span>1. 천재지변 또는 이에 준하는 불가항력의 상태가 있는 경우</span>
						   <span>2. 서비스 제공을 위하여 회사와 서비스 제휴계약을 체결한 제3자의 고의적인 서비스 방해가 있는 경우</span>
						   <span>3. 회원의 귀책사유로 서비스 이용에 장애가 있는 경우</span>
						   <span>4. 제1호 내지 제3호를 제외한 기타 회사의 고의∙과실이 없는 사유로 인한 경우</span>
						 
						<li>② 회사는 CP가 제공하거나 회원이 작성하는 등의 방법으로 서비스에 게재된 정보, 자료, 사실의 신뢰도, 정확성 등에 대해서는 보증을 하지 않으며 이로 인해 발생한 회원의 손해에 대하여는 책임을 부담하지 아니합니다.</li>
						 </ul>
						 
						<strong>제 18 조 (분쟁의 해결)</strong>
						 
						<p>본 약관은 대한민국법령에 의하여 규정되고 이행되며, 서비스 이용과 관련하여 회사와 회원간에 발생한 분쟁에 대해서는 민사소송법상의 주소지를 관할하는 법원을 합의관할로 합니다.</p>
						 
						 
						<strong>제 19 조 (규정의 준용)</strong>
						 
						<p>본 약관에 명시되지 않은 사항에 대해서는 관련법령에 의하고, 법에 명시되지 않은 부분에 대하여는 관습에 의합니다.</p>
						 
						 
						<p>본 약관은 2016년 6월 27일부터 적용됩니다.</p>
						
					</div>
					
    			</div>
    			
    		</div>
    		
    	</div>
    	<div class="privacy_chk">
			<input type="checkbox" id="privacy_chk" name="privacy"><label for="privacy_chk">동의합니다.</label>
</div>		
    </div>
    <div class="block_wrap">
    <div class="block_title">
    		<h3>회원정보 입력</h3>
    	</div>
    <form name="adminAddMember" id="adminAddMember"  action="#" method="post">
        <fieldset>
            <ul class="adminMemList clear_both">
                <li>
                    <p>
                        <strong>아이디<span class="required">*</span></strong>
                        <input required type="text" name="userId" id="userId" onchange="idPattern()">
                        <input class="btn_type_02" type="button" id="btnOverLapped" onclick="idOverlapped()" value="중복확인">
                    </p>
                </li>
                <li>
                    <p class="pwLap">
                        <b>
                            <strong>패스워드<span class="required">*</span></strong>
                            <input required type="password" name="userPw" id="userPw" >
                        </b>
                        <b>
                            <strong>패스워드 확인<span class="required">*</span></strong>
                            <input required type="password" name="userPwOverLapped" id="userPwOverLapped" >
                        </b>
                    </p>
                </li>
                <li class="float_left">
                    <p>
                        <strong>이름<span class="required">*</span></strong>
                        <input required type="text" name="userName" id="userName">
                    </p>
                </li>
                <li class="float_left">
                    <p>
                        <strong>이메일<span class="required">*</span></strong>
                        <input required  type="text" name="userEmail" id="userEmail">
                    </p>
                </li>
                <li class="float_left">
                    <p>
                        <strong>생년월일<span class="required">*</span></strong>
                        <select name="birthYear" class="birthYear birth" id="birthYear">
                        </select>
                        <select name="birthMonth" class="birthMonth birth" id="birthMonth">    
                        </select>
                        <select name="birthDay" class="birthDay birth" id="birthDay">    
                        </select>
                    </p>
                </li>
                <li class="clear">
                    <p>
                        <strong>전화번호<span class="required">*</span></strong>
                        
                        <select name="userTel1" class="telNum firstTelNum" id="userTel1">
                        <option value="02" selected="select">02</option>
                        <option value="010">010</option>
                        <option value="031">031</option>
                        <option value="032">032</option>
                        <option value="033">033</option>
                        <option value="041">041</option>
                        <option value="042">042</option>
                        <option value="043">043</option>
                        <option value="044">044</option>
                        <option value="051">051</option>
                        <option value="053">053</option>
                        <option value="054">054</option>
                        <option value="055">055</option>
                        <option value="061">061</option>
                        <option value="062">062</option>
                        <option value="063">063</option>
                        <option value="064">064</option>
                        <option value="070">070</option>
                        </select>
                        <input required type="text" name="userTel2" class="telNum" maxlength="4" minlength="3" id="userTel2">
                        <input required type="text" name="userTel3" class="telNum" maxlength="4" minlength="4" id="userTel3">
                    </p>
                </li>
                <li>
                    <p class="addLap">
                        <b>
                            <strong>주소<span class="required">*</span></strong>
                            <input type="text" id="userAdd1" name="userAdd1" disabled="disabled"><input type="button" onclick="execDaumPostcode()" value="우편번호 찾기">
                        </b>
                        <b>
                            <input required  type="text" id="userAdd2" name="userAdd2">
                        </b>
                    </p>
                </li>
                <li>
                	<p>
                        <input class="btn_type_01" type="button" onclick="submitAction()" value="가입하기">
                        <input class="btn_type_01" type="button" value="취소" onclick="windowClose()">
                    </p>
               </li>
            </ul>
        </fieldset>
    </form>
    </div>
    </div>
    </div>
</div>

</body>
</html>