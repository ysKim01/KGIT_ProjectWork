<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false" %>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<c:set var="contextPath" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html> 
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 창</title>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Document</title>
   <link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/adminAddMember.css">
   <style>
   	#adminAddMember .btn_type_01{
   		width:100px;
   	}
   	#adminAddMember .pwLap{
	   	text-align:center;
   	}
   	#adminAddMember #userPw{
   		border:0; box-shadow:none;
   		border-bottom:2px solid #ccc;
   		margin-right:8px;    height: 38px;
   	}
   </style>
   <script src="http://code.jquery.com/jquery-latest.js"></script>
   
   <script>
    
    function submitAction(){
		
    	var getPw = '${member.userPw}';
    	if($('#userPw').val() == getPw){
    		var last = confirm('정말로 탈퇴하시겠습니까 ?');
    		if(last){
    			 $.ajax({
   		            type:"post",
   		            url:"${contextPath}/member/delMember.do",
   		            dataType:"text",
   		            data:{'userPw':$('#userPw').val()},
   		            success:function(data, textStatus){
   		                if(data == 'true'){
   		                	alert('탈퇴처리가 완료되었습니다.');
   		                	location.href="${contextPath}/member/logoutAndMain.do";
   		                }else{
   		                	alert('알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.');
   		                }
   		            },
   					error: function(data, status) {
   						alert('알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.');
   						console.log(data);
   						console.log(status);
   			        }

   		        })
    		}
    	}
    	

        
       
    }

    

       
    </script>
</head>
<body>



    
    
<div class="content_block">
<div class="block_wrap">
    <div class="adminaddMemberWrap">
	        <div class="block_title">
	        <h3>회원탈퇴 창</h3>
	           	 
	        </div>
	        <p class="subExc">
	        <strong>회원탈퇴를 진행하시려면 비밀번호를 한번 더 입력해주세요.</strong>
	        </p>
    	<form name="adminAddMember" id="adminAddMember"  action="#" method="post">
        <fieldset>
            <ul class="adminMemList clear_both">
                
                <li>
                    <p class="pwLap">
                        <b>
                            
                            <input required type="password" name="userPw" id="userPw" > <input class="btn_type_01" type="button" onclick="submitAction()" value="완료">
                        </b>
                    </p>
                </li>
                
            </ul>
        </fieldset>
    </form>
    </div>
    </div>
    </div>
</div>

</body>
</html>