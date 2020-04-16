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
   <link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/member/reservMember.css">
   <style>
   	.block_wrap{margin:0;}
   </style>
   <script src="${contextPath }/resources/js/loginRequired.js"></script>
   <script>
   	
      $(window).on('load',function(){
   	   $('.side_nav .snb li').eq(1).children('a').addClass('active');
   	   
   	   
   	   
   	  
   	   
   	   
   	   
   	   
   	   
	   	
       });
      
      
      
   function cancelReserv(keyNum){
	   var answer = confirm("정말 예약을 취소하시겠습니까 ?");
	   if(answer){
		   $.ajax({
			   type:'post',
			   url:'${contextPath}/reserve/delReserve.do',
			   data:{keyNum : keyNum},
			   dataType:'text',
			   success:function(data, textStatus){
				   alert("예약이 취소되었습니다.");
				   location.reload();
			   },
			   error:function(data, textStatus){
				   alert('알수 없는 오류로 별점 등록에 실패했습니다. 잠시 후 다시 시도해 주세요.');
				   location.reload();
			   }
		   })
	   }
   }
        
    
   // ============= 리뷰 ================= //
   // 경로 : /center/rating.do --------------- //
   // 전달할 값 : point - integer, centerCode(매개변수) // 
   // ===================================== //
   function centerReview(centerCode, keyNum){
	   var docWrap = document.createElement('div');
	   docWrap.setAttribute('id','docWrap');
	   
	   
	    var stars = document.createElement("div");
	    	
	   	stars.style.textAlign="center";
	   	stars.style.display="inline-block";
	   	stars.style.margin="auto";
	   
	   	
	   	var clearBtn = document.createElement('span');
	   	clearBtn.setAttribute('class','clearBtn icon-cross');
	   	
	   	var textArea = document.createElement('p');
	   	textArea.style.display="table-cell";
	   	textArea.style.verticalAlign="middle";
	   	textArea.style.boxSizing="border-box"
	   	textArea.style.padding="25px";
	   	
	   	textArea.style.textAlign="center";
		textArea.appendChild(clearBtn);
		
	   	var textTitle = document.createElement('strong');
	   	textTitle.innerHTML ="리뷰 입력";
	   	textArea.appendChild(textTitle);
	   	
	    var reg =  /^[0-9]+(\.[0-9]+)?$/g;
	    stars.setAttribute('class','starRev');
	    for(var i = 0.5; i <= 5; i = i + 0.5){
	        var star = document.createElement('span');
	        
	        if(reg.test(i)){
	            star.setAttribute('class','starR1');
	            star.innerText = i;
	        }else{
	            star.setAttribute('class','starR2');
	            star.innerText = parseFloat(i);
	        }
	        stars.appendChild(star);
	    }
	   
	   textArea.appendChild(stars);
	   
	   var submitBtn = document.createElement('b');
	   submitBtn.setAttribute('class','reviewEnter');
	   submitBtn.innerHTML = "확인";
	   textArea.appendChild(submitBtn);
	   
	   docWrap.appendChild(textArea);
	   document.body.appendChild(docWrap);
	   
	   let point = '0';
	   $("#docWrap").on('click',function(){
		   $(this).remove();
	   })
	   $('#docWrap .clearBtn').on('click',function(){
		   $('#docWrap').remove();
	   })
	   $('#docWrap > p').on('click',function(){
         event.stopPropagation();
       })
	   $('.starRev span').click(function(){
		  	
	     $(this).parent().children('span').removeClass('on');
	     $(this).addClass('on').prevAll('span').addClass('on');
	     
	     
	     point = $(this).html();
	     
	     return false;
	   });
	   $('#docWrap .reviewEnter').on('click',function(){
		   
		   
		   $.ajax({
			   type:'post',
			   url:"${contextPath}/center/rating.do",
			   data:{'centerCode' : centerCode, 'point' : point, 'keyNum' : keyNum},
			   success:function(data, textStatus){
				   alert("별점이 성공적으로 등록되었습니다. 감사합니다.");
				   $('#docWrap').remove();
				   location.reload();
			   },
			   error:function(data, textStatus){
				   alert('알수 없는 오류로 별점 등록에 실패했습니다. 잠시 후 다시 시도해 주세요.');
				   $('#docWrap').remove();
				   location.reload();
			   }
		   })
		  
	   })

   }
   
   
       
       
       

    var isEmpty = function(value){
         if( value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length ) ) { 
             return true ;
         }else{
              return false ;
         }
    } 
    
    </script>
</head>
<body>
<div class="content_block">
<div class="block_wrap">
    <div class="adminaddMemberWrap">
        <div class="block_title">
        	<h3>회원 수정</h3>
           	 
        </div>
	    <div class="content_block">
             
             <div class="top_block">
                 <ul>
                 	<c:choose>
                 		<c:when test="${pageStatus == 'before' }">
	                 	 <li><a href="${contextPath}/reserve/listReserveBefore.do" class="select">대관 예정</a></li>
	                     <li><a href="${contextPath}/reserve/listReserveAfter.do">만료된 예약</a></li>
                 		</c:when>
                 		<c:when test="${pageStatus == 'after' }">
	                 	 <li><a href="${contextPath}/reserve/listReserveBefore.do" >대관 예정</a></li>
	                     <li><a href="${contextPath}/reserve/listReserveAfter.do" class="select">만료된 예약</a></li>
                 		</c:when>
                 	</c:choose>
                     
                 </ul>
             </div>

             <div class="board_list ">
                 <ul class="list_header clear_both">
                     <li><strong>스터디룸</strong></li>
                     <li><strong>방이름</strong></li>
                     <li><strong>대관일</strong></li>
                     <li><strong>룸정보</strong></li>
                     <li><strong>결제금액</strong></li>
                     <li><strong>예약 상태</strong></li>
                     <li><strong>예약관리</strong></li>
                 </ul>
                 
                 
             <c:forEach var="board" items="${reserveList }">
             	<ul class="list_list clear_both">
                     <li><strong>${board.centerName }</strong></li>
                     <li><strong>${board.roomName }</strong></li>
                     <li class="dateType"><strong>${board.reserveDate }</strong><i>${board.usingTimeString }</i></li>
                     <li><strong>${board.scale }인실</strong></li>
                     <li class="price setWon"><strong>${board.reservePrice }</strong></li>
                     <c:choose>
                     	<c:when test="${board.reserveStatus == 'Apply'}">
                     		<li class="reservStatus"><strong>예약신청</strong></li>
                     	</c:when>
                     	<c:when test="${board.reserveStatus == 'Payment'}">
                     		<li class="reservStatus"><strong>결재완료</strong></li>
                     	</c:when>
                     	<c:when test="${board.reserveStatus == 'Checkout'}">
                     		<li class="reservStatus"><strong>사용완료</strong></li>
                     	</c:when>
                     	<c:when test="${board.reserveStatus == 'Rating'}">
                     		<li class="reservStatus"><strong>평가완료</strong></li>
                     	</c:when>
                     </c:choose>
                     
                     
                     <c:choose>
                     	<c:when test="${pageStatus == 'before' }">
                     		<li class="reservAction"><strong><button type="button" class="icon-cross red" onclick="cancelReserv(${board.keyNum})"><i class="none">예약취소</i></button></strong></li>
                     	</c:when>
                     	<c:when test="${pageStatus == 'after' }">
                     	<c:choose>
                     		<c:when test="${board.reserveStatus == 'Rating'}">
                     			<li  class="reservAction"><strong><button type="button" class="icon-check green" onclick=""><i class="none"></i></button></strong></li>
                     		</c:when>
                     		<c:otherwise>
                     			<li  class="reservAction"><strong><button type="button" class="icon-star blue" onclick="centerReview('${board.centerCode}','${board.keyNum }')"><i class="none"></i></button></strong></li>
                     		</c:otherwise>
                     	</c:choose>
                     	
                     	</c:when>
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
             
             
         </div>
	</div>
</div>
</div>
</body>
</html>