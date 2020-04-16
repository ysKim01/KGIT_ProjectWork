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
   
   <link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/member/addQuestionForm.css">
   <style>
   	.block_wrap{margin:0;}
   </style>
   <script src="http://code.jquery.com/jquery-latest.js"></script>
   <script src="${contextPath }/resources/js/loginRequired.js"></script>
   <script>
   	
   	
      $(window).on('load',function(){
   	   $('.side_nav .snb li').eq(2).children('a').addClass('active');
   	   
   	$('.pubSelectbox .textArea').children('input').val($('.pubSelectbox .listArea ul li').eq(0).children('a').text());
   	 console.log('2');
       });
        
    // 1. userId
	// 2. questionClass
	// 3. questionTitle
	// 4. questionContent
	// 5. mailMode
    // 경로 : addQuestion.do
    function onNext(){
    	const questionTitle = document.QuestionAddForm.title.value;
    	const questionClass = document.QuestionAddForm.ansClass.value;
    	const questionContent = document.QuestionAddForm.contentArea.value;
    	const returnMail = document.QuestionAddForm.checkMailMode;
    	let mailMode = '0';
        if(questionTitle == '' || questionTitle == null){
        	alert('제목을 입력해주세요.');
        	document.QuestionAddForm.title.focus();
        	return;
        }
        if(questionClass == '' || questionClass == null){
        	alert('유형을 선택해주세요.');
        	document.QuestionAddForm.ansClass.focus();
        	return;
        }
        if(questionContent == '' || questionContent == null){
        	alert('내용을 입력해주세요.');
        	document.QuestionAddForm.contentArea.focus();
        	return;
        }
        
        if(returnMail.checked==true) mailMode = '1';
        let question = {
        		'questionTitle' : questionTitle,
        		'questionClass' : questionClass,
        		'questionContent' : questionContent,
        		'mailMode' : mailMode
        }
        console.log(question);
        $.ajax({
        	type:'post',
        	url:'${contextPath}/question/addQuestion.do',
        	dataType:'text',
        	data:{
        		'question' : JSON.stringify(question)
       		},
        	success:function(data, textStatus){
        		location.href="${contextPath}/question/listQuestion.do";
        		alert("문의가 접수되었습니다. 감사합니다.");
        		//document.location.replace("");
        		
        	},
        	error:function(data,textStatus){
        		alert("알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
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
    
    
    </script>
</head>
<body>
<div class="content_block">
<div class="block_wrap">
    <div class="adminaddMemberWrap">
	        <div class="block_title">
	        <h3>1:1 문의 등록</h3>
	           	 
	        </div>
	    <form name="QuestionAddForm" id="QuestionAddForm"  action="#" method="post">
	        <fieldset>
	            <ul class="questionList clear_both">
	                <li>
	                    <dl>
	                    	<dt>제목</dt>
	                    	<dd><input type="text" name="title" id="boardTitle"></dd>
	                    </dl>
	                </li>
	                <li>
	                    <dl>
	                    	<dt>문의유형</dt>
	                    	<dd>
	                    		<div class="ansClass pubSelectbox">
	                    			<a class="textArea" onclick="">예약문의<input type="text" class="hidden" name="ansClass"><i class="icon-play3"></i></a>
	                    			<div class="listArea">
	                    				<ul>
	                    					<li><a href="#">예약문의</a></li>
	                    					<li><a href="#">원데이클레스 문의</a></li>
	                    					<li><a href="#">환불문의</a></li>
	                    					<li><a href="#">기타문의</a></li>
	                    				</ul>
	                    			</div>
	                    		</div>
	                    	</dd>
	                    </dl>
	                </li>
	                <li class="ansContent">
	                    <div>
	                    <textarea class="contentArea" name="contentArea" value="">
	                    	
	                    </textarea>
	                    </div>
	                </li>
	            </ul>
	            <div class="btn_wrap clear_both">
		            <p class="mailMode float_left">
	                	<input type="checkbox" id="checkMailMode" name="checkMailMode"><label for="checkMailMode">메일로 답변 받기</label>
	                </p>
	             	<button type="button" class="btn_type_03 submitBtn float_right" onclick="onNext()">문의하기</button>
	             </div>
	        </fieldset>
	    </form>
	</div>
</div>
</div>
</body>
</html>