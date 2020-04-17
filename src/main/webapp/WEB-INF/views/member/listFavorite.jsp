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
   <link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/member/listFavorite.css">
   <style>
   	.block_wrap{margin:0;}
   </style>
   <script src="${contextPath }/resources/js/loginRequired.js"></script>
   <script>
   	
      $(window).on('load',function(){
   	   $('.side_nav .snb li').eq(3).children('a').addClass('active');
   	   
   	   
   		
   	  	
       });
      
    // questionList
    
    // /addQuestionForm.do 문의 등록창
      
   	function viewFavoCenter(code){
   		var form = document.createElement("form");
        form.setAttribute("encType", "UTF-8");
        form.setAttribute("method", "post");  
        form.setAttribute("action", "${contextPath}/searchCenter.do"); //요청 보낼 주소
		
        
        var _centerCode = code;
        var centerCode = document.createElement("input");
        centerCode.setAttribute("type", "hidden");
        centerCode.setAttribute("name", "centerCode");
        centerCode.setAttribute("value", _centerCode);
        form.appendChild(centerCode);
        
        document.body.appendChild(form);
        form.submit();
    }
   	function delFavoCenter(centerCode){
   		if(!confirm('정말로 즐겨찾기 목록에서 삭제하시겠습니까 ? ')){
   			return;
   		}
   		$.ajax({
			type:'post',
			url:'${contextPath}/favorite/delFavorite.do',
			dataType:'text',
			data:{'centerCode':centerCode},
			success:function(data,textStatus){
				alert("즐겨찾기 목록에서 삭제되었습니다.");
			},
			error:function(data, textStatus){
				
			}
		})
   	}
 	
 	
    
    </script>
</head>
<body>
<div class="content_block">
<div class="block_wrap">
    <div class="adminaddMemberWrap">
        <div class="block_title">
        	<h3>즐겨찾기 목록</h3>
           	 
        </div>
	    <div class="contentArea">
             <div class="board_list ">
             <div class="list_wrap">
                 	<ul class="clear_both">
		             <c:forEach var="board" items="${centerList }" varStatus="status">
		             	<li class="list_box">
                			<div class="box_cover">
                				<a href="javascript:viewFavoCenter('${board.centerCode }')" class="" data-centerCode="${board.centerCode }">
                				<figure class="img_area" >
                				<div style="background:url('${contextPath}/${board.centerPhoto }') no-repeat center center; background-size:cover;">
                					<img src="${contextPath }/${board.centerPhoto}" alt="${board.centerName }" title="${board.centerName }">
                				</div>
                				</figure>
                				<div class="txt_area">
                					<p>
                						<strong>${board.centerName }</strong>
                						<span>
                							${board.centerAdd1 } ${board.centerAdd2 } ${board.centerAdd3 }
                						</span>
                					</p>
                				</div>
                				</a>
                				<span class="delFavo" onclick="javascript:delFavoCenter('${board.centerCode }')"><i class="icon-cross"></i></span>
                			</div>
                		</li>
		            </c:forEach>
                 
                 	</ul>
                 </div>
             
             </div>
        </div>
	</div>
</div>
</div>
</body>
</html>