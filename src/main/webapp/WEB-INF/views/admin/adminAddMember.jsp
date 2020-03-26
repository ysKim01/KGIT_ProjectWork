<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />	
<!DOCTYPE html> 
<html>
<head>
<meta charset="UTF-8">
<title>관리자 회원가입 창</title>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Document</title>
   <link rel="stylesheet" type="text/css" href="css/reset.css">
   <link rel="stylesheet" type="text/css" href="css/adminAddMember.css">
   <script src="http://code.jquery.com/jquery-latest.js"></script>
   <script src="script/main.js"></script>
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

        var idOverLap = false;
        // 아이디 중복확인 확인 변수        
        function idOverlapped(){
            var inputId = adminAddMember.userId.value;
            if(inputId == ''){
                alert("아이디를 입력하세요.");
                return;
            }
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
                    }else{
                        alert("사용할 수 없는 ID입니다.");
                        idOverLap = false;
                    }
                },
                error:function(data,textStatus){
					alert("에러발생");	
				}
            })
        }

    
    function submitAction(){
        console.log(adminAddMember.userId.value);
        var userBirth = $('.birthYear').val();
        userBirth += $('.birthMonth').val();
        userBirth += $('.birthDay').val();
        if($("#adminMode").prop("checked")){
            adminMode = 1;
        } else{
            adminMode = 0;
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
            userAdd1 : adminAddMember.userAdd1.value,
            userAdd2 : adminAddMember.userAdd2.value,
            userAdd3 : adminAddMember.userAdd3.value,
            adminMode : adminMode
        }
        $.ajax({
            type:"post",
            async:false,
            url:"${contextPath}/admin/addMember.do",
            contentType:"application/json",
            data:JSON.stringify(adminAddMemberInfo),
            success:function(data, textStatus){
                alert(userName+"님의 가입을 환영합니다.");
            },
            error:function(data, textStatus){
                alert("알수없는 에러가 발생하였습니다.");
            }


        })
    }

       
    </script>
</head>
<body>
    <div class="adminaddMemberWrap">
        <h3 class="content_title">
           회원등록 폼 
        </h3>
        <!-- action="${contentPath}/member/addMember.do" -->
    <form name="adminAddMember" id="adminAddMember"  action="#" method="post">
        <fieldset>
            <ul class="adminMemList clear_both">
                <li>
                    <p>
                        <strong>아이디</strong>
                        <input type="text" name="userId">
                        <input class="btn_type_02" type="button" id="btnOverLapped" onclick="idOverlapped()" value="아이디 중복확인">
                    </p>
                </li>
                <li>
                    <p>
                        <strong>패스워드</strong>
                        <input type="password" name="userPw">
                        <input type="password" name="userPwOverLapped">
                    </p>
                </li>
                <li>
                    <p>
                        <strong>이름</strong>
                        <input type="text" name="userName">
                    </p>
                </li>
                <li>
                    <p>
                        <strong>이메일</strong>
                        <input type="text" name="userEmail">
                    </p>
                </li>
                <li>
                    <p>
                        <strong>생년월일</strong>
                        <select name="birthYear" class="birthYear birth" >    
                        </select>
                        <select name="birthMonth" class="birthMonth birth" >    
                        </select>
                        <select name="birthDay" class="birthDay birth" >    
                        </select>
                    </p>
                </li>
                <li>
                    <p>
                        <strong>전화번호</strong>
                        <select name="userTel1" class="telNum firstTelNum" >
                            <option value="010" selected="select">010</option>
                            <option value="011">011</option>
                            <option value="011">017</option>
                        </select>
                        <input type="text" name="userTel2" class="telNum" maxlength="4">
                        <input type="text" name="userTel3" class="telNum" maxlength="4">
                    </p>
                </li>
                <li>
                    <p>
                        <strong>주소</strong>
                        <input type="text" name="userAdd1">
                        <input type="text" name="userAdd2">
                        <input type="text" name="userAdd3">
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
                        <input class="btn_type_01" type="submit" onclick="submitAction()" value="가입하기">
                        <input class="btn_type_01" type="button" value="취소" onclick="windowClose()">
                    </p>
                </li>
            </ul>
        </fieldset>
    </form>
</div>

</body>
</html>