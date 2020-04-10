<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false" %>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html> 
<html>
<head>
<meta charset="UTF-8">
<title>회원정보 수정</title>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Document</title>
   <link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/member/listQuestion.css">
   <style>
   	.block_wrap{margin:0;}
   </style>
   <script src="${contextPath }/resources/js/loginRequired.js"></script>
   <script>
   	
      $(window).on('load',function(){
   	   $('.side_nav .snb li').eq(2).children('a').addClass('active');
   	   
   	   
   		
   	  	
       });
      
    // questionList
    
    // /addQuestionForm.do 문의 등록창
      
 	function showQuestion(keyNum){
    	let setForm = document.createElement('form');
    	setForm.setAttribute('action','${contextPath}/question/showQuestionForm.do');
    	setForm.setAttribute('method','post');
    	setForm.setAttribute('name','showQuestion');
    	
    	let setKeyNum = document.createElement('input');
    	setKeyNum.setAttribute('name','keyNum');
    	setKeyNum.setAttribute('value',keyNum);
    	setKeyNum.setAttribute('type','hidden');
    	setForm.appendChild(setKeyNum);
    	document.body.appendChild(setForm);
    	setForm.submit();
    }
    
    </script>
</head>
<body>
<div class="content_block">
<div class="block_wrap">
    <div class="adminaddMemberWrap">
        <div class="block_title">
        	<h3>1:1 문의</h3>
           	 
        </div>
	    <div class="content_block">
             <div class="board_list ">
                 <ul class="list_header clear_both">
                     <li><strong>번호</strong></li>
                     <li><strong>문의유형</strong></li>
                     <li><strong>제목</strong></li>
                     <li><strong>날짜</strong></li>
                     <li><strong>답변상태</strong></li>
                 </ul>
                 
                 
             <c:forEach var="board" items="${questionList }" varStatus="status">
             	<ul class="list_list clear_both" onclick="showQuestion('${board.keyNum}')">
                     <li><strong>${status.index}</strong></li>
                     <li><strong>${board.questionClass}</strong></li>
                     <li class="title"><strong>${board.questionTitle }</strong></li>
                     <li class="dateType"><strong>${board.questionDate }</strong></li>
                     <c:choose>
                     	<c:when test="${board.questionAnswer == '' || empty board.questionAnswer}">
                     		<li class="answer green"><strong>대기중</strong></li>
                     	</c:when>
                     	<c:otherwise>
                     		<li class="answer green"><strong>답변완료</strong></li>
                     	</c:otherwise>
                     </c:choose>
                     
                     
                     
                 </ul>
             </c:forEach>
                 
                 <!-- <ul class="list_list clear_both">
                     <li><strong>르하임스터디카페</strong></li>
                     <li><strong>시스터디룸</strong></li>
                     <li class="dateType"><strong>2020-03-20</strong><i>11:00 ~ 14:00</i></li>
                     <li><strong>4인실</strong></li>
                     <li class="price setWon"><strong>80000</strong></li>
                     <li class="status"><strong>Apply</strong></li>
                     <li><strong><button type="button" class="icon-cross red" onclick="cancelReserv()"><i class="none">예약취소</i></button></strong></li>
                 </ul>
                 <ul class="list_list clear_both">
                     <li><strong>르하임스터디카페</strong></li>
                     <li><strong>시스터디룸</strong></li>
                     <li class="dateType"><strong>2020-03-20</strong><i>11:00 ~ 14:00</i></li>
                     <li><strong>4인실</strong></li>
                     <li class="price setWon"><strong>80000</strong></li>
                     <li class="status"><strong>Apply</strong></li>
                     <li><strong><button type="button" class="icon-star red" onclick="centerReview('acac1')"><i class=""></i></button></strong></li>
                 </ul> -->
             </div>
             
             <div class="btn_wrap clear_both">
             	<button type="button" class="btn_type_03 submitBtn float_right" onclick="location.href='${contextPath}/question/addQuestionForm.do'">문의하기</button>
             </div>
        </div>
	</div>
</div>
</div>
</body>
</html>