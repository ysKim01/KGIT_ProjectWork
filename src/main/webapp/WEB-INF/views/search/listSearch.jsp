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
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/search/searchList.css">    
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/slider-pro.css">






<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="${contextPath }/resources/js/loginRequired.js"></script>
<script src="${contextPath }/resources/js/jquery.sliderPro.js"></script>
<script>
	$(function(){
		
		$( '#mCustom-slider' ).sliderPro({
            width:260,
            arrows: true,
            fadeArrows:false,
            autoHeight:true,
            buttons: false,
            visibleSize: '100%',
            loop:true,
            centerSelectedSlide:false,
            //forceSize: 'fullWidth',
            autoplay:false,
            slideDistance:20,
            autoScaleLayers: true
        });

	});
</script>
</head>
<body>
	 <div class="content_block">
                    <div class="block_wrap">
                               
                        <div class="searchList_wrap">
                            <ul>
                                <li class="list_box">
                                    <div class="box_cover">
                                        <div class="img_wrap">
                                            <figure><img src="http://placehold.it/200x200"></figure>
                                        </div>
                                        <div class="txt_wrap">
                                            <div class="box_title">
                                                <h5>르하임 스터디 카페</h5>
                                            </div>
                                            <div class="sub_txt">
                                                <dl class="clear_both">
                                                    <dt>주소</dt>
                                                    <dd><p>서울특별시 종로구 종로동 126-3 3층 302호</p></dd>
                                                </dl>
                                                <dl class="clear_both">
                                                    <dt>평점</dt>
                                                    <dd><p><i class="icon-star yellow"></i></p></dd>
                                                </dl>
                                                <dl class="clear_both">
                                                    <dt>운영시간</dt>
                                                    <dd><p>10:00 ~ 20:00</p></dd>
                                                </dl>
                                                <dl class="equp clear_both">
                                                    <dt>구비물품</dt>
                                                    <dd>
                                                        <p>
                                                            <span class="setPrinter">
                                                                <i class='icon-printer'></i>
                                                                프린터
                                                            </span>
                                                            <span class='setProjecter'>
                                                                <i class='icon-video-camera'></i>
                                                                프로젝터
                                                            </span>
                                                            <span class="setLocker">
                                                                <i class="icon-box-add"></i>
                                                                사물함
                                                            </span>
                                                            <span class="setNotebook">
                                                                <i class="icon-laptop"></i>
                                                                노트북
                                                            </span>
                                                            <span class="setWhiteboard">
                                                                <i class="icon-display"></i>
                                                                화이트보드
                                                            </span>
                                                        </p>
                                                    </dd>
                                                </dl>
                                            </div>
                                            <div class="priceLap">
                                                <h4 class="red align_right">
                                                    <span>\</span><b class="price">89,000</b>
                                                </h4>
                                            </div>
                                        </div>
                                        <div class="btn_wrap">
                                            <div class="">
                                                <!-- centerCode ? -->
                                                <button type="button" class="btn_type_03 " onclick="viewDetail()">상세보기</button> 
                                                <!-- centerCode ? -->
                                                <button type="button" class="btn_type_03" onclick="selectCenter()">선택하기</button>
                                            </div>
                                        </div>
                                    </div>
                                </li>

                                <li class="list_box">
                                    <div class="box_cover">
                                        <div class="img_wrap">
                                            <figure><img src="http://placehold.it/200x200"></figure>
                                        </div>
                                        <div class="txt_wrap">
                                            <div class="box_title">
                                                <h5>르하임 스터디 카페</h5>
                                            </div>
                                            <div class="sub_txt">
                                                <dl>
                                                    <dt>주소</dt>
                                                    <dd><p>서울특별시 종로구 종로동 126-3 3층 302호</p></dd>
                                                </dl>
                                                <dl>
                                                    <dt>평점</dt>
                                                    <dd><p><i class="icon-star yellow"></i></p></dd>
                                                </dl>
                                            </div>
                                            <div class="priceLap">
                                                <h4 class="red">
                                                    \ <b class="price">89,000</b><span>원</span>
                                                </h4>
                                            </div>
                                        </div>
                                        <div class="btn_wrap">
                                            <div class="">
                                                <!-- centerCode ? -->
                                                <button type="button" onclick="viewDetail()">상세보기</button> 
                                                <!-- centerCode ? -->
                                                <button type="button" onclick="selectCenter()">선택하기</button>
                                            </div>
                                        </div>
                                    </div>
                                </li>


                            </ul>
                        </div>
                               
                    </div>
                </div>
                <!-- body end  -->
</body>
</html>