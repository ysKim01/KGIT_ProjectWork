<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false" %>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html> 
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 등록</title>
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
        
	// 1. noticeTitle
	// 2. noticeContent
	// 3. noticeTop
    // 경로 : addNotice.do
    function onNext(){
    	const noticeTitle = document.QuestionAddForm.title.value;
    	const noticeContent = document.QuestionAddForm.contentArea.value;
    	const noticeTopChk = document.QuestionAddForm.checkImportant;
    	let noticeTop = '0';
        if(noticeTitle == '' || noticeTitle == null){
        	alert('제목을 입력해주세요.');
        	document.QuestionAddForm.title.focus();
        	return;
        }
        if(noticeContent == '' || noticeContent == null){
        	alert('내용을 입력해주세요.');
        	document.QuestionAddForm.contentArea.focus();
        	return;
        }
        
        if(noticeTopChk.checked==true) noticeTop = '1';
        let notice = {
        		'noticeTitle' : noticeTitle,
        		'noticeContent' : noticeContent,
        		'noticeTop' : noticeTop
        }
        console.log(notice);
        $.ajax({
        	type:'post',
        	url:'${contextPath}/admin/addNotice.do',
        	dataType:'text',
        	data:{
        		'notice' : encodeURI(JSON.stringify(notice))
       		},
        	success:function(data, textStatus){
        		console.log("공지 등록 결과 : " + data);
        		alert("공지가 생성되었습니다.");
        		location.href="${contextPath}/admin/listNotice.do";
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
	        <h3>공지 사항</h3>
	           	 
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
	                <li class="ansContent">
	                    <div>
	                    <textarea class="contentArea" name="contentArea" value=""></textarea>
	                    </div>
	                </li>
	            </ul>
	            <div class="btn_wrap clear_both">
		            <p class="mailMode float_left">
	                	<input type="checkbox" id="checkImportant" name="checkImportant"><label for="checkImportant">중요</label>
	                </p>
	             	<button type="button" class="btn_type_03 submitBtn float_right" onclick="onNext()">글쓰기</button>
	             </div>
	        </fieldset>
	    </form>
	</div>
</div>
</div>
</body>
</html>