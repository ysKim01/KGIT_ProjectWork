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
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/mypage.css">    
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
	<div class="mContent_wrap">
        

        <!-- contentWrap -->
        <div class="">
            
                
                <div class="content_block">
                    <div class="top_block">
                        <dl class="ing_list">
                            <dt>
                                <p>
                                    <i class="icon-clock"></i>
                                    <strong>예약현황</strong>
                                </p>
                                
                            </dt>
                            <dd class="txt_wrap">
                                <ul class="clear_both">
                                    <li>
                                        <p>
                                            <i>대기중</i>
                                            <strong>1</strong><span>건</span>
                                        </p>
                                    </li>
                                    <li>
                                        <p>
                                            <i>결제완료</i>
                                            <strong>1</strong><span>건</span>
                                        </p>
                                    </li>
                                    <li>
                                        <p>
                                            <i>총 예약건</i>
                                            <strong>1</strong><span>건</span>
                                        </p>
                                    </li>
                                </ul>
                            </dd>
                        </dl>
                        <dl class="ing_list">
                            <dt>
                                <p>
                                    <i class="icon-bubbles4"></i>
                                    <strong>1:1문의</strong>
                                </p>
                            </dt>
                            <dd class="txt_wrap">
                                <ul class="clear_both">
                                    <li>
                                        <p>
                                            <i>대기중</i>
                                            <strong>1</strong><span>건</span>
                                        </p>
                                    </li>
                                    <li>
                                        <p>
                                            <i>답변 완료</i>
                                            <strong>1</strong><span>건</span>
                                        </p>
                                    </li>
                                    <li>
                                        <p>
                                            <i>총 문의</i>
                                            <strong>1</strong><span>건</span>
                                        </p>
                                    </li>
                                </ul>
                            </dd>
                        </dl>
                    </div>

                    <div class="block_wrap bookmark">
                        <div>
                            <div class="block_title">
                                <h4>BookMark</h4>
                            </div>
                            <div class="mOnClass_slider" id="mCustom-slider">
                                <div class="sp-slides">
                                    <!-- Slide 1 -->
                                    <div class="sp-slide">
                                        <div class="slider_cover">
                                            <figure><img class="sp-image" src="${contextPath }/resources/image/onedayclass_01.jpg"/></figure>
                                            <div class="txt_wrap">
                                                <p>
                                                    <strong class="centerName">강남구 스터디카페</strong>
                                                    <span>서울특별시 강남구 00동</span>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="sp-slide">
                                        <div class="slider_cover">
                                            <figure><img class="sp-image" src="${contextPath }/resources/image/onedayclass_01.jpg"/></figure>
                                            <div class="txt_wrap">
                                                <p>
                                                    <strong class="centerName">강남구 스터디카페</strong>
                                                    <span>서울특별시 강남구 00동</span>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="sp-slide">
                                        <div class="slider_cover">
                                            <figure><img class="sp-image" src="${contextPath }/resources/image/onedayclass_01.jpg"/></figure>
                                            <div class="txt_wrap">
                                                <p>
                                                    <strong class="centerName">강남구 스터디카페</strong>
                                                    <span>서울특별시 강남구 00동</span>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="sp-slide">
                                        <div class="slider_cover">
                                            <figure><img class="sp-image" src="${contextPath }/resources/image/onedayclass_01.jpg"/></figure>
                                            <div class="txt_wrap">
                                                <p>
                                                    <strong class="centerName">강남구 스터디카페</strong>
                                                    <span>서울특별시 강남구 00동</span>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="sp-slide">
                                        <div class="slider_cover">
                                            <figure><img class="sp-image" src="${contextPath }/resources/image/onedayclass_01.jpg"/></figure>
                                            <div class="txt_wrap">
                                                <p>
                                                    <strong class="centerName">강남구 스터디카페</strong>
                                                    <span>서울특별시 강남구 00동</span>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="sp-slide">
                                        <div class="slider_cover">
                                            <figure><img class="sp-image" src="${contextPath }/resources/image/onedayclass_01.jpg"/></figure>
                                            <div class="txt_wrap">
                                                <p>
                                                    <strong class="centerName">강남구 스터디카페</strong>
                                                    <span>서울특별시 강남구 00동</span>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>  
                            </div>
                            <!-- slider end-->
                        </div>
                    
                </div>
            </div>
        </div>
    </div>
	
	
	
</body>
</html>