<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	request.setCharacterEncoding("utf-8");
%>
<c:set var="contextPath" value="${pageContext.request.contextPath }"></c:set>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인페이지</title>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<style>
.content_block{
	text-align: center;
	padding-top: 20px;
}
.top_block {
	display: inline-block;
}

.top_block ul li {
    padding: 10px 30px;
    box-sizing: border-box;
    color: #777;
    text-align: center;
    font-size: 15px;
    box-sizing: border-box;
    float: left;
    width: 33.33333%;
}

.ing_list .txt_wrap strong {
    font-size: 20px;
    font-weight: 600;
    color: #156bc1;
    padding-top: 10px;
}

.me1{
	font-size: 18px;
	width: 150px;
}

.adminImg {
	width: 50%;
}

</style>
</head>
<body>
	<div class="mContent_wrap">
        

        <!-- contentWrap -->
        <div class="">
            
                <div class="content_block">
                    <div class="top_block">
                        <img class="adminImg" src="${contextPath }/resources/image/adminMain.png" alt="admin메인">
                        <div>
                        <h1>관리자(admin) 페이지입니다.</h1>
                <div class="content_block">
                    <div class="top_block">        
                        <ul>
                        <li>
                        <dl class="ing_list">
                            <dt>
                                <p class="me1">
                                    <i class="icon-clock"></i>
                                    <strong>회원수/관리자수</strong>
                                </p>
                                
                            </dt>
                            <dd class="txt_wrap">
                                <p>
									<i>회원수</i>
                                    <strong>${normalMemCnt}</strong><span>명</span>
                                </p>
                                <p>
                                    <i>관리자수</i>
                                    <strong>  ${adminMemCnt} </strong><span>명</span>
                                </p>
                            </dd>
                        </dl>
                        <li>
                        <dl class="ing_list">
                            <dt>
                                <p class="me1">
                                    <i class="icon-bubbles4"></i>
                                    <strong>원데이클래스 수</strong>
                                </p>
                            </dt>
                            <dd class="txt_wrap">
                                <p>
                                   <strong>${oneDayCnt}</strong><span>개</span>
                                </p>
                            </dd>
                        </dl>
                        </li>
                        <li>
                        <dl class="ing_list">
                            <dt>
                                <p class="me1">
                                    <i class="icon-bubbles4"></i>
                                    <strong>업체수</strong>
                                </p>
                            </dt>
                            <dd class="txt_wrap">
                                <p>
                                    <strong>${centerCnt}</strong><span>개</span>
                               </p>
                            </dd>
                        </dl>
                        <li>
                        </ul>
                    </div>
                    </div><!-- in content_block  -->
                </div>
            </div><!-- out content_block -->
        </div>
    </div>
</body>
</html>