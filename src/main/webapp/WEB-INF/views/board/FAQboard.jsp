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
   <link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/board/listBoard.css">
   <style>
   	.block_wrap{margin:0;}
   	.board_list ul > li:first-child{ width:5%; padding:8px;}
	.board_list ul > li:nth-child(2){width:85%;}
	.board_list ul > li:last-child{width:10%;}

   </style>
   <script>
 
      
    // questionList
    
    // /addQuestionForm.do 문의 등록창
    function isLogon(){
    	var _isLogOn=document.getElementById("logon").value;
    	console.log(_isLogOn);
    	if(_isLogOn=='false' || _isLogOn == ''){
    		alert("로그인이 필요한 페이지입니다.")
    		activeLogon();
    		return;
    	}else{
    		location.href='${contextPath}/question/listQuestion.do';
    	}
    }
   	
 	
    
    $(function(){
        $('.list_list').on('click',function(){
            var target = $(this).children('ul').children('li').eq('2').children('strong').children('button');
            target.toggleClass('view');
            if(target.hasClass('view')){
                $(this).children('.faq_content').show();
            }else{
                $(this).children('.faq_content').hide();
            }
            
        })
    })
    
    </script>
</head>
<body>
<div class="mContent_wrap">
	<section class='content_top'>
           <div class="img_wrap">
               <div class="width_wrap">
                   <h2>
                       <span>자주묻는 질문</span>
                   </h2>
               </div>
               
           </div>
       </section>
        
    <div class="boardListWrap">
    <div class="width_wrap">
	    <div class="content_block">
             <div class="board_list ">
           
            <div class="list_list">
                <ul class=" clear_both">
                        <li><i class="typo">Q</i></li>
                        <li class="title"><strong>스터디센터 허가부분이 복잡하고 어려운게 사실인가요?</strong></li>
                        <li><strong><button type="button" class="bottom_arrow" onclick=""><i class="none">상세보기</i></button></strong></li>
                </ul>
                <div class="faq_content">
                <i class="typo">A</i>
                    <p>
                       	스터디센터는 타 업종에 비하여 인허가 부분이 까다로운것이 사실입니다.
                       	 매장의 종류에 따라 인허가의 형태가 상이하기도 하며 스터디센터의 경우 
                       	 "학원의 설립·운영 및 과외교습에 관한 법률", 이하 "학원법"의 영향을 받고 있기 때문에 면적에 따른 "유해업소"와의 거리제한,
                       	 "최소열람실의 면적기준","소방시설 및 허가기준","건축물 용도" 등의 사항들을 꼼꼼히 체크해야 합니다.
                       	  그루스터디센터는 위 사항들을 기준으로 상권개발팀의 점포분석부터 인허가,
                       	   그리고 오픈까지 창업에 관련된 모든사항들을 주도하여 도움을 드리고 있습니다.
                    </p>
                </div>
            </div>
            <div class="list_list">
            <ul class=" clear_both">
                    <li><i class="typo">Q</i></li>
                    <li class="title"><strong>가맹점 홍보마케팅은 어떻게 해주나요?</strong></li>
                    <li><strong><button type="button" class="bottom_arrow" onclick="hideAndShow()"><i class="none">상세보기</i></button></strong></li>
            </ul>
            <div class="faq_content">
            <i class="typo">A</i>
                    <p>
                       	그루스터디센터는 가맹점의 매출 증대와 고객 재방문 효과를 높이기 위하여 전문상담가를 통한 정기적인 MBTI(진로적성검사)를 진행하고 있습니다.
                       	 또한 다양한 이벤트를 페이스북, 유투브, 인스타그램 등 SNS를 통해  고객들과 소통하고 있습니다.
                       	  오픈 후 이벤트 프로모션 및 매장 홍보에 대한  홍보전략을 세워 안정적인 매출을 극대화시키기 위한 단계별 컨설팅도 지원하고 있습니다.

                    </p>
                </div>
        </div>
        <div class="list_list">
            <ul class=" clear_both">
                    <li><i class="typo">Q</i></li>
                    <li class="title"><strong>가맹계약 후 매장 오픈까지 소요되는 기간은 어느 정도 인가요?</strong></li>
                    <li><strong><button type="button" class="bottom_arrow" onclick="hideAndShow()"><i class="none">상세보기</i></button></strong></li>
            </ul>
             <div class="faq_content">
             <i class="typo">A</i>
                <p>
                인테리어 담당자가 직접 체크하여 안내드리고 있습니다.
                 그리고, 스터디센터는 등록제 업종이기에 인허가기간이 1주일 정도 소요되며 처리과정이 다소 까다롭습니다.
                  저희 그루스터디센터는 전문적인 교육이 이루어진 오픈매니저를 파견하여 운영교육과 더불어 사업자발급까지 도움을 드리고 있습니다.
                
                </p>
          	 </div>
        </div>
        <div class="list_list">
            <ul class=" clear_both">
                    <li><i class="typo">Q</i></li>
                    <li class="title"><strong>본사에서 점포를 직접 개발해주시나요?</strong></li>
                    <li><strong><button type="button" class="bottom_arrow" onclick="hideAndShow()"><i class="none">상세보기</i></button></strong></li>
            </ul>
             <div class="faq_content">
             <i class="typo">A</i>
                <p>
                창업에 있어서 가장 중요한 과정중에 하나가 입지선정에 있습니다. 상권의 좋고 나쁨이 결정되기 때문에 꼭 전문가에게 맡기셔야 합니다.그루스터디센터는 오랜 경험과 전문 실무지식을 갖춘 상권분석팀이 구성되어 있으며 입점 예정지 주변의 경쟁매장 및 유사업종들의 가동율 분석등을 통하여 정확하고 신뢰할 수 있는 예정지를 추천하여 드리고 있습니다
                </p>
             </div>
        </div>
        <div class="list_list">
            <ul class=" clear_both">
                    <li><i class="typo">Q</i></li>
                    <li class="title"><strong>본사와의 가맹 계약기간은 어떻게 되나요?</strong></li>
                    <li><strong><button type="button" class="bottom_arrow" onclick="hideAndShow()"><i class="none">상세보기</i></button></strong></li>
            </ul>
            <div class="faq_content">
            <i class="typo">A</i>
                <p>
                가맹계약 기간은 기본 2년을 단위로 하며, 그 이후 가맹점의 별다른 의사가 없을 시 1년씩 자동 연장되는 시스템 입니다.
                </p>
            </div>
        </div>
             </div>
             
             <div class="btn_wrap clear_both">
             	<button type="button" class="btn_type_03 submitBtn float_right" onclick="isLogon()">문의하기</button>
             </div>
        </div>
	</div>
</div>
</div>
</body>
</html>