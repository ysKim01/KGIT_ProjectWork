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
   <link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/adminAddMember.css">
   <script src="http://code.jquery.com/jquery-latest.js"></script>

<script>
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
</script>
</head>
<body>
    <div class="adminaddMemberWrap">
        <h3 class="content_title">
       	예약 등록 폼
        </h3>
    <form name="adminAddMember" id="adminAddMember"  action="#" method="post">
        <fieldset>
            <ul class="adminMemList clear_both">
                <li>
                    <p>
                        <strong>아이디</strong>
                        <input required type="text" name="userId" id="userId" onchange="idPattern()">
                        <input class="btn_type_02" type="button" id="btnOverLapped" onclick="idOverlapped()" value="아이디 중복확인">
                    </p>
                </li>
                <li>
                    <p class="pwLap">
                        <b>
                            <strong>패스워드</strong>
                            <input required type="password" name="userPw" id="userPw" >
                        </b>
                        <b>
                            <strong>패스워드 확인</strong>
                            <input required type="password" name="userPwOverLapped" id="userPwOverLapped" >
                        </b>
                    </p>
                </li>
                <li>
                    <p>
                        <strong>이름</strong>
                        <input required type="text" name="userName" id="userName">
                    </p>
                </li>
                <li>
                    <p>
                        <strong>이메일</strong>
                        <input required  type="text" name="userEmail" id="userEmail">
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
                        <input required type="text" name="userTel2" class="telNum" maxlength="4" minlength="3" id="userTel2">
                        <input required type="text" name="userTel3" class="telNum" maxlength="4" minlength="4" id="userTel3">
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
                        <input class="btn_type_01" type="button" value="취소" onclick="windowClose()">
                    </p>
                </li>
            </ul>
        </fieldset>
    </form>
</div>

</body>
</html>