<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false" %>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html> 
<html>
<head>
<meta charset="UTF-8">
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/board/listBoard.css">
   <style>
   
   	.block_wrap{margin:0;}
   	.board_list > ul{display:table; width:100%;}
   	.board_list > ul > li{display:table-cell;}
   	.board_list ul > li:first-child{ width:10%; }
	.board_list ul > li:nth-child(2){width:70%;}
	
	.board_list ul > li:last-child{width:20%;}
	
	.board_list .list_list{
		margin-bottom: 8px;
	    background-color: #fff;
	    border-radius: 0;
	    box-shadow: 2px 2px 3px rgba(22,22,22,0.1);
	}
	.board_list .list_list.important{
		background-color:#fafafa;
	}
	
	.boardTitle {
		padding:15px; box-sizing:border-box;
	    background-color: #fff;
    	border-bottom: 2px solid #eaeaea;
		
	}
	.boardTitle h3{
		font-size:24px;
	}
	.boardTitle .regDate{
	    text-align: right; display: block; color: #999; font-size: 13px;
	}
	.boardContent{
		padding:35px 15px; box-sizing:border-box;
		background-color:#fff;
	    min-height: 300px;
	}
	.btn_area{
	    background-color: #fff;
	    padding: 15px 15px;
	    text-align: right;
	    border-top: 2px solid #eaeaea;
	}
	.btn_area a{
		background-color: #666;
	    color: #fff;
	    display: inline-block;
	    padding: 8px 25px;
	    font-weight: 500;
	}
   </style>
   
   
   <script>
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
<div class="mContent_wrap">
	<section class='content_top'>
           <div class="img_wrap">
               <div class="width_wrap">
                   <h2>
                       <span>공지사항</span>
                   </h2>
               </div>
               
           </div>
       </section>
        
<div class="boardListWrap">
	<div class="width_wrap">
		<div class="content_block">	
        	<div id="noticeWrap">
	      		<div>
	            	<div class="boardTitle">
	            		<h3>${notice.noticeTitle }</h3>
	            		<span class="regDate"><i class="icon icon-clock"></i>${notice.noticeWriteDate }</span>
	            	</div>
					<div class="boardContent">
					
						<div class="contentArea">
							${notice.noticeContent }
						</div>
					</div>	  
					<div class="btn_area">
							<a href="javascript:history.back()">목록</a>
						</div>          
	        	</div>
	    	</div>
        </div>
	</div>
</div>
</div>
</body>
</html>