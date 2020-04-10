<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false" %>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html> 
<html>
<head>
<meta charset="UTF-8">
<title>관리자 문의 조회</title>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Document</title>
   
   <link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/member/showQuestionForm.css">
   <style>
   	.block_wrap{margin:0;}
   	.reply{ display: none; }
   </style>
   <script src="http://code.jquery.com/jquery-latest.js"></script>
   <script src="${contextPath }/resources/js/loginRequired.js"></script>
   <script>
   	
   	
      $(window).on('load',function(){
   	   $('.side_nav .snb li').eq(2).children('a').addClass('active');
   	   
   	$('.pubSelectbox .textArea').children('input').val($('.pubSelectbox .listArea ul li').eq(0).children('a').text());
   	 console.log('2');
       });
      
    var isEmpty = function(value){
         if( value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length ) ) { 
             return true 
         }else{
              return false 
         }
    };
    
    function onReply(){
    	var onReply = document.getElementById('onReply');
    	onReply.style.display = 'none';
    	var reply = document.getElementById('reply');
    	reply.style.display = 'block';
    }
    
    </script>
</head>
<body>
<div class="content_block">
<div class="block_wrap">
    <div class="adminaddMemberWrap">
	        <div class="block_title">
	        <h3>1:1 문의 내용</h3>
	           	 
	        </div>
	    <form name="QuestionAddForm" id="QuestionAddForm"  action="#" method="post">
	        <fieldset>
	            <ul class="questionList clear_both">
	                <li>
	                    <dl>
	                    	<dt>제목</dt>
	                    	<dd><p>${question.questionTitle }</p></dd>
	                    </dl>
	                </li>
	                <li>
	                    <dl>
	                    	<dt>문의유형</dt>
	                    	<dd>
	                    		<div class="ansClass pubSelectbox">
	                    			<a class="textArea" onclick="">${question.questionClass }<input type="text" class="hidden" name="ansClass" value="${question.questionClass }"></a>
	                    		</div>
	                    	</dd>
	                    </dl>
	                </li>
	                <li class="ansContent">
	                    <div>
	                    <div class="contentArea">
	                    	${question.questionContent}
	                    </div>
	                    </div>
	                </li>
	            </ul>
	            <div class="btn_wrap clear_both">
		            
	             	
	             </div>
	        </fieldset>
	    </form>
	    <c:choose>
	    <c:when test="${not empty question.questionAnswer }">
	    	<div class="ans_wrap">
		    	<div class="block_title">
		        	<h3>답변 내용</h3>
		        </div>
		    	<ul class="questionList clear_both">
	                <li class="ansContent">
	                    <div>
	                    <div class="contentArea">
	                    	${question.questionAnswer}
	                    </div>
	                    </div>
	                </li>
	            </ul>
		    </div>
	    </c:when>
	    <c:otherwise>
	    	<button type="button" onclick="onReply()" value="답변하기" id="onReply">
            <div id="reply">
	            <textarea id="" cols="40" rows="10">
				</textarea>
				<button type="button" onclick="reply()" value="답변완료" >
            </div>
	    </c:otherwise>
	    </c:choose>
	    <c:when test=""></c:when>
	    
	</div>
</div>
</div>
</body>
</html>