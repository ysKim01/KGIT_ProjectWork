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
   	.block_wrap{margin:0 auto;}
   	#onReply{margin:15px 0;}
   	#reply{ display: none; margin-top:40px;}
   	#reply button{margin:15px 0;}
   	#reply textarea{
   	    width: 100%;
    	min-height: 350px;
	    border: 1px solid #f5f5f5;
	    box-sizing: border-box;
	    padding: 10px;
	    background-color: #fafafa;
   	}
   	.questionList li dd,
   	.questionList li dt{
	   	position: relative;
	    /* height: 100%; */
	    /* width: 100px; */
	    padding: 8px 15px;
	    box-sizing: border-box;
	    /* line-height: 29px; */
	    float: left;
   	}
   	.questionList li dd a{
   	display: block;
    line-height: 29px;
   	}
   </style>
   <script src="http://code.jquery.com/jquery-latest.js"></script>
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
    
    
    
    /* ===========================================================================
	 * 1. 문의 검색
	 * ---------------------------------------------------------------------------
	 * > 입력 : searchInfo
	 * > 출력 : searchInfo
	 * > 이동 페이지 : /admin/searchQuestion.do
	 * > 설명 : 
		 	- 검색필터 전달 후 문의 검색창으로
	 ===========================================================================*/
	function searchQuestion(){
		var form = document.createElement("form");
        form.setAttribute("charset", "UTF-8");
        form.setAttribute("method", "Get");  //Get 방식
        form.setAttribute("action", "${contextPath}/admin/searchQuestion.do"); //요청 보낼 주소
        
        // searchInfo
        var searchObj = new Object();
        searchObj['searchFilter'] = '${searchInfo.searchFilter}';
        searchObj['searchContent'] = '${searchInfo.searchContent}';
        searchObj['questionClass'] = '${searchInfo.questionClass}';
        searchObj['isAnswered'] = '${searchInfo.isAnswered}';
        searchObj['page'] = '${searchInfo.page}';
        
        var searchInfo = document.createElement("input");
        searchInfo.setAttribute("type", "hidden");
        searchInfo.setAttribute("name", "searchInfo");
        searchInfo.setAttribute("value", encodeURI(JSON.stringify(searchObj)));
        form.appendChild(searchInfo);
        
        document.body.appendChild(form);
        form.submit();
	}
	 
    /* ===========================================================================
	 * 2. 답변 활성화
	 ===========================================================================*/
    function onReply(){
    	var onReply = document.getElementById('onReply');
    	onReply.style.display = 'none';
    	var reply = document.getElementById('reply');
    	reply.style.display = 'block';
    }
    
    /* ===========================================================================
	 * 3. 답변 하기
	 * ---------------------------------------------------------------------------
	 * > 입력 : keyNum, replyText
	 * > 출력 : -
	 * > 이동 페이지 : /admin/replyQuestion.do
	 * > 설명 : 
		 	- 문의 내용 답변
	 ===========================================================================*/
	 function reply(){
        var keyNum = '${question.keyNum}';
        var answer = document.getElementById('replyText').value;
        console.log("keyNum : " + keyNum);
        console.log("reply : " + answer);
        
        $.ajax({
			type:"post",
			async: false,
			url:"${contextPath}/admin/replyQuestion.do",
			dataType:"text",
			data:{
				"keyNum" : keyNum,
				"answer" : answer	
			},
			success:function(data, status){
				alert("답변에 성공했습니다.");
				searchQuestion();
			},
			error: function(data, status) {
				alert("error");
	        }
		});
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
	                    <dl class="clear_both">
	                    	<dt>제목</dt>
	                    	<dd><p>${question.questionTitle }</p></dd>
	                    </dl>
	                </li>
	                <li>
	                    <dl class="clear_both">
	                    	<dt>문의유형</dt>
	                    	<dd>
	                    		<div>
	                    			<a class="textArea" onclick="">${question.questionClass }</a>
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
	                    <div class="contentArea">${question.questionAnswer}</div>
	                    </div>
	                </li>
	            </ul>
		    </div>
	    </c:when>
	    <c:otherwise>
	    	<div id="onReply">
	            <button type="button" onclick="onReply()" value="답변하기" class="btn_type_01" id="onReply" >답변하기</button>
            </div>
            <div id="reply">
	            <textarea id="replyText" cols="40" rows="10" placeholder="답변하기"></textarea>
				<button type="button" onclick="reply()" value="답변완료" class="btn_type_01">답변완료</button>
            </div>
	    </c:otherwise>
	    </c:choose>
	</div>
</div>
</div>
</body>
</html>