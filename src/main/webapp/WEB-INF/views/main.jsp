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
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/main.css">    
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/mDcalendar.picker.css">
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/slider-pro.css">

<style>
	.sp-slide{overflow:hidden; background-color: #fff;}
</style>




<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="${contextPath }/resources/js/mDcalendar.picker.js"></script>
<script src="${contextPath }/resources/js/jquery.sliderPro.js"></script>
<script>
        $(function(){
            var week = ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'];
            var getDate = new Date();
            var getYear = getDate.getFullYear();
            var getMonth = getDate.getMonth()+1;
            var getDate = getDate.getDate()+1;
            var dayOfWeek = week[new Date().getDay()+1];
            if(getMonth < 10) getMonth = '0'+getMonth;
            if(getDate < 10) getDate = '0'+getDate;

            $('.searchDate').val(getYear+'-'+getMonth+'-'+getDate);
            $('.dateWeek').text(dayOfWeek);

            $('.searchDate').dcalendarpicker({
            // default: mm/dd/yyyy
            format:'yyyy-mm-dd'
            });

            $('.searchDate').on('propertychange change paste input',function(){
                console.log('1');
                $(this).css('padding','15px 60px 30px');
            })


            $( '#mCustom-slider' ).sliderPro({
                width:380,
                arrows: true,
                fadeArrows:false,
                autoHeight:true,
                buttons: false,
                visibleSize: '100%',
                loop:false,
                centerSelectedSlide:false,
                //forceSize: 'fullWidth',
                autoplay:false,
                slideDistance:20,
                autoScaleLayers: true
            });
            $('#mCustom-slider').on('gotoSlide',function(e){
            	var totalSlider = $( '#mCustom-slider' ).data( 'sliderPro' ).getTotalSlides();
            	var nowSlide = e.index;
            	if(totalSlider - 3 <= nowSlide){
            		$('.sp-arrow.sp-next-arrow').css('display','none');
            		if(totalSlider - 3 < nowSlide){
                		$('#mCustom-slider').sliderPro('gotoSlide',0);
                	}
            	}
            	
            	
            })
            
            let scrollH = (parseInt($('.regCompany .caption p').css('height')) + 15) * -1;
            console.log(scrollH);
            $('.regCompany .bg_cover .caption').css('bottom',scrollH);
            $('.regCompany .bg_cover').on('mouseenter',function(){
            	$(this).children('.caption').stop().animate({bottom:'0'},200);
            }).on('mouseleave',function(){
            	
            	$(this).children('.caption').stop().animate({bottom:scrollH},200);
            })
            
            
            
            
            $('#mSearchBtn').on('click',function(){
                setSearch();
            })
            
            
        })
		
        function viewNotice(keyNum){
        	// form 생성
        	var form = document.createElement("form");
            form.setAttribute("charset", "UTF-8");
            form.setAttribute("method", "Post");  //Post 방식
            form.setAttribute("action", "${contextPath}/notice/showNotice.do "); //요청 보낼 주소
        	
            // keyNum
        	var key = document.createElement("input");
        	key.setAttribute("type", "hidden");
        	key.setAttribute("name", "keyNum");
        	key.setAttribute("value", keyNum);
            form.appendChild(key);
               
            document.body.appendChild(form);
            form.submit();
        }
        
        
     
        function centerAction(centerCode){
        	var setForm = document.createElement('form');
        	setForm.setAttribute('action','${contextPath}/searchCenter.do');
        	setForm.setAttribute('method','post');
        	
        	var setCode =document.createElement('input');
        	setCode.setAttribute('name','centerCode');
        	setCode.setAttribute('value',centerCode);
        	setForm.appendChild(setCode);
        	document.body.appendChild(setForm);
        	setForm.submit();
        }
        
        
        
        
        
        let noticeInterval = '';
        window.onload = function(){
        	
        	// 뒤로가기 
        	$('.vertical_slide_wrap > ul li:last').prependTo($('.vertical_slide_wrap > ul'));
        	$('.vertical_slide_wrap > ul').css('top','-145px');
        	
        	noticeInterval = setInterval(function(){
        		noticeSlide();
        	}, 5000);
        	
        	$('.vertical_slide_wrap').on('mouseenter',function(){
        		clearInterval(noticeInterval);
        	}).on('mouseleave',function(){
        		noticeInterval = setInterval(function(){
            		noticeSlide();
            	}, 5000);
        	})
        	$('.notice_rarr').on('click',function(){
        		slide_top = parseInt($('.vertical_slide_wrap').find('li').css('height')) * -1;
            	$('.vertical_slide_wrap > ul').stop().animate({marginTop:slide_top+'px'},400 , function(){
            		$('.vertical_slide_wrap > ul').css('margin-top','0');
            		$('.vertical_slide_wrap > ul > li:first').appendTo($('.vertical_slide_wrap > ul'));
            	});
            	return false;
        	})
        	$('.notice_larr').on('click',function(){
        		slide_top = parseInt($('.vertical_slide_wrap').find('li').css('height'));
            	$('.vertical_slide_wrap > ul').stop().animate({marginTop:slide_top+'px'},400 , function(){
            		$('.vertical_slide_wrap > ul').css('margin-top','0');
            		$('.vertical_slide_wrap > ul > li:last').prependTo($('.vertical_slide_wrap > ul'));
            	});
            	return false;
        	})
        }
        function noticeSlide(){
        	slide_top = parseInt($('.vertical_slide_wrap').find('li').css('height')) * -1;
        	$('.vertical_slide_wrap > ul').animate({marginTop:slide_top+'px'},400 , function(){
        		$('.vertical_slide_wrap > ul').css('margin-top','0');
        		$('.vertical_slide_wrap > ul > li:first').appendTo($('.vertical_slide_wrap > ul'));
        	});
        }
        
   		// 1. searchDate
		// 2. searchAdd1
		// 3. searchAdd2
		// 4. scale
		// 5. sort
		// 6. page
        
        function setSearch(){
            //searchDate
            // searchAdd city gu
            // roomScale
            var getDate = $('.searchDate').val()
            var getAddCity = $('.searchAdd #city').val();
            var getAddGu = $('.searchAdd #gu').val();
            var roomScale = $('.scale').val();
            if(getDate == '' || getDate == null){
                alert("날짜를 선택해주세요.");
                return;
            }
            if(getAddCity == '' || getAddCity == null){
                alert("시를 선택해주세요.");
                return;
            }
            if(getAddGu == '' || getAddGu == null){
                alert("구를 선택해주세요.");
                return;
            }
            var reg = /^[0-9]*$/;
            
            if(roomScale == '' || roomScale == null || !reg.test(roomScale)){
                alert('인원수를 입력해 주세요.');
                return;
            }
 
            let setForm = document.createElement('form');
            setForm.setAttribute('action','${contextPath}/listSearch.do');
            setForm.setAttribute('method','get');
            setForm.setAttribute('encType','UTF-8');
 
            const searchInfo = {
                'searchDate' : getDate,
                'searchAdd1' :  getAddCity, 
                'searchAdd2' : getAddGu,
                'scale' :  roomScale,
                'sort' : '0',
                'page' : '1'
            }
            
            var setDate = document.createElement('input');
            setDate.setAttribute('type','hidden');
            setDate.setAttribute('name','searchInfo');
            setDate.setAttribute('value',encodeURI(JSON.stringify(searchInfo)));
            setForm.appendChild(setDate);
            
            
            const facilityObj = {
            		'locker' : '0',
            		'projector' : '0',
            		'printer' : '0',
            		'noteBook' : '0',
            		'whiteBoard' : '0'
            };
            var facility = document.createElement('input');
            facility.setAttribute('type','hidden');
            facility.setAttribute('name','facility');
            facility.setAttribute('value',encodeURI(JSON.stringify(facilityObj)));
            setForm.appendChild(facility);
            
            
            document.body.appendChild(setForm);
            setForm.submit();
        }
    </script>
</head>
<body>
	<div class="">
        <section class='content mSearch_wrap'>
            <div class="width_wrap">
                <div class="search_form">
                    <form id="mSearch" action="#" method="get" enctype="UTF-8">
                        <div class="dcalendar">
                            <div class="" style="position:relative;">
                                <input class="searchDate form-controller" readonly type="text" class="" value="">
                                <span class="dateWeek">
                                    
                                </span>
                            </div>
                        </div>
                        <div class="searchAdd clear_both">
                            <p class="align_right">
                                <select name="city" id="city" class="addr1">
                                    <option value="서울">서울시</option>
			                        <option value="경기">경기도</option>
			                        <option value="강원">강원도</option>
			                        <option value="경남">경상남도</option>
			                        <option value="경북">경상북도</option>
			                        <option value="전남">전라남도</option>
			                        <option value="전북">전라북도</option>
			                        <option value="대전">대전시</option>
			                        <option value="제주특별자치도">제주시</option>
			                        <option value="충남">충청남도</option>
			                        <option value="충북">충청북도</option>
                                </select>
                            </p>
                            <p class="align_right">
                                <select name="gu" id="gu"  class="addr2">
                                    
                                </select>
                            </p>
                        </div>
                        <div class="searchRoom clear_both">
                            <p>
                                <input type="text" name="roomScale" class="scale" value="4">
                                <span>인</span>
                            </p>
                            <p>
                                <input type="button" value="검색하기" id="mSearchBtn" name="mSearchBtn">
                            </p>
                        </div>
                    </form>
                </div>
            </div>
        </section>

        <!-- contentWrap -->


        <section class='content mOneClass_wrap'>
            <div class="width_wrap">
                <div class="mTitle_wrap">
                    <h2>
                        <span class="sub">NEW</span>
                        One Day Class
                    </h2>
                </div>
                <!-- title end-->
                <div class="mOnClass_slider" id="mCustom-slider">
                    <div class="sp-slides">
                        <!-- Slide 1 -->
                        <div class="sp-slide">
                            <div class="slider_cover">
                                <figure><img class="sp-image" src="${contextPath }/resources/image/onedayclass_01.jpg"/></figure>
                                <div class="txt_wrap">
                                    <p>
                                        <strong class="txt_title">반응형 자바 웹 개발자</strong>
                                        <dl>
                                            <dt>모집 기간 : </dt>
                                            <dd>2020년 03월 20일 ~ 2020년 04월 13일</dd>
                                        </dl>
                                        <dl>
                                            <dt>정원 : </dt>
                                            <dd>
                                                <span class="block">최소 인원 : 10명</span>
                                                <span class="block">최대 인원 : 20명</span>
                                            </dd>
                                        </dl>
                                    </p>
                                </div>
                                <a class="more_btn">
                                    <span class="">
                                        More
                                    </span>
                                </a>
                                
                            </div>
                            
                            

                        </div>
                        
                        <!-- Slide 2 -->
                        <div class="sp-slide">
                            <div class="slider_cover">
                                <figure><img class="sp-image" src="${contextPath }/resources/image/onedayclass_01.jpg"/></figure>
                                <div class="txt_wrap">
                                    <p>
                                        <strong class="txt_title">반응형 자바 웹 개발자</strong>
                                        <dl>
                                            <dt>모집 기간 : </dt>
                                            <dd>2020년 03월 20일 ~ 2020년 04월 13일</dd>
                                        </dl>
                                        <dl>
                                            <dt>정원 : </dt>
                                            <dd>
                                                <span class="block">최소 인원 : 10명</span>
                                                <span class="block">최대 인원 : 20명</span>
                                            </dd>
                                        </dl>
                                    </p>
                                </div>
                                <a class="more_btn">
                                    <span class="">
                                        More
                                    </span>
                                </a>
                                
                            </div>
                        </div>
                        
                        <!-- Slide 3 -->
                        <div class="sp-slide">
                            <div class="slider_cover">
                                <figure><img class="sp-image" src="${contextPath }/resources/image/onedayclass_01.jpg"/></figure>
                                <div class="txt_wrap">
                                    <p>
                                        <strong class="txt_title">반응형 자바 웹 개발자</strong>
                                        <dl>
                                            <dt>모집 기간 : </dt>
                                            <dd>2020년 03월 20일 ~ 2020년 04월 13일</dd>
                                        </dl>
                                        <dl>
                                            <dt>정원 : </dt>
                                            <dd>
                                                <span class="block">최소 인원 : 10명</span>
                                                <span class="block">최대 인원 : 20명</span>
                                            </dd>
                                        </dl>
                                    </p>
                                </div>
                                <a class="more_btn">
                                    <span class="">
                                        More
                                    </span>
                                </a>
                                
                            </div>
                        </div>
                        <div class="sp-slide">
                            <div class="slider_cover">
                                <figure><img class="sp-image" src="${contextPath }/resources/image/onedayclass_01.jpg"/></figure>
                                <div class="txt_wrap">
                                    <p>
                                        <strong class="txt_title">반응형 자바 웹 개발자</strong>
                                        <dl>
                                            <dt>모집 기간 : </dt>
                                            <dd>2020년 03월 20일 ~ 2020년 04월 13일</dd>
                                        </dl>
                                        <dl>
                                            <dt>정원 : </dt>
                                            <dd>
                                                <span class="block">최소 인원 : 10명</span>
                                                <span class="block">최대 인원 : 20명</span>
                                            </dd>
                                        </dl>
                                    </p>
                                </div>
                                <a class="more_btn">
                                    <span class="">
                                        More
                                    </span>
                                </a>
                                
                            </div>
                        </div>
                        <div class="sp-slide">
                            <div class="slider_cover">
                                <figure><img class="sp-image" src="${contextPath }/resources/image/onedayclass_01.jpg"/></figure>
                                <div class="txt_wrap">
                                    <p>
                                        <strong class="txt_title">반응형 자바 웹 개발자</strong>
                                        <dl>
                                            <dt>모집 기간 : </dt>
                                            <dd>2020년 03월 20일 ~ 2020년 04월 13일</dd>
                                        </dl>
                                        <dl>
                                            <dt>정원 : </dt>
                                            <dd>
                                                <span class="block">최소 인원 : 10명</span>
                                                <span class="block">최대 인원 : 20명</span>
                                            </dd>
                                        </dl>
                                    </p>
                                </div>
                                <a class="more_btn">
                                    <span class="">
                                        More
                                    </span>
                                </a>
                                
                            </div>
                        </div>
                        <div class="sp-slide">
                            <div class="slider_cover">
                                <figure><img class="sp-image" src="${contextPath }/resources/image/onedayclass_01.jpg"/></figure>
                                <div class="txt_wrap">
                                    <p>
                                        <strong class="txt_title">반응형 자바 웹 개발자</strong>
                                        <dl>
                                            <dt>모집 기간 : </dt>
                                            <dd>2020년 03월 20일 ~ 2020년 04월 13일</dd>
                                        </dl>
                                        <dl>
                                            <dt>정원 : </dt>
                                            <dd>
                                                <span class="block">최소 인원 : 10명</span>
                                                <span class="block">최대 인원 : 20명</span>
                                            </dd>
                                        </dl>
                                    </p>
                                </div>
                                <a class="more_btn">
                                    <span class="">
                                        More
                                    </span>
                                </a>
                                
                            </div>
                        </div>

                        <div class="sp-slide slide_add_more">
                            <div class="slider_cover">
                                <figure><img class="sp-image" src="${contextPath }/resources/image/onedayclass_01.jpg"/></figure>
                                <div class="txt_wrap">
                                    <p>
                                        <strong class="txt_title">반응형 자바 웹 개발자</strong>
                                        <dl>
                                            <dt>모집 기간 : </dt>
                                            <dd>2020년 03월 20일 ~ 2020년 04월 13일</dd>
                                        </dl>
                                        <dl>
                                            <dt>정원 : </dt>
                                            <dd>
                                                <span class="block">최소 인원 : 10명</span>
                                                <span class="block">최대 인원 : 20명</span>
                                            </dd>
                                        </dl>
                                    </p>
                                </div>
                                <a class="more_btn">
                                    <span class="">
                                        More
                                    </span>
                                </a>
                                <div class="more_layer">
                                    <div class="cross_icon">
                                        <span class="img-border">
                                            <i class="icon-plus"></i>
                                        </span>
                                        <p>더 보기</p>
                                    </div>
                                </div>
                            </div>
                            
                        </div>


                    </div>
                </div>
            </div>
        </section>



        <section class='content regCompany'>
            <div class="width_wrap">
                <div class="mTitle_wrap">
                    <h2>
                        <span class="sub">NEW</span>
                        Registered Companies
                    </h2>
                </div>
                <!-- title end-->

                <div class="clear_both float_sec">
                <c:forEach var="item" items="${top5Center }" varStatus="status" >
                	<c:if test="${status.index == 0}">
                		<div class="left">
	                        <div class="bg_cover" onclick="centerAction('${item.centerCode}')">
	                            <figure><img src="${contextPath }/${item.centerPhoto}" alt="${item.centerName }"></figure>
	                            <div class="caption" data-centerCode="${item.centerCode }" data-centerName="${item.centerName }">
	                                <h4 class="caption_title">
	                                    <span>${item.centerAdd1 } ${item.centerAdd2 }</span>
	                                    <strong>${item.centerName }</strong>
	                                </h4>
	                                <p>
	                                    강남역 10분 거리에 위치한 스터디 카페
	                                </p>
	                            </div>
	                        </div>
                    	</div>
                    	<!-- left end-->
                	</c:if>
                	<c:if test="${status.index != 0 }">
                		<c:if test="${status.index == '1' }">
	                		<div class="right">
                       			<div class="clear_both float_sec">
                		</c:if>
                		<c:choose>
	                		<c:when test="${status.index % 2 != 0 }">
	                            <div class="left small_box">
	                                <div class="box_border" onclick="centerAction('${item.centerCode}')">
	                                    <dl data-centerCode="${item.centerCode }" data-centerName="${item.centerName }">
	                                        <dt>
	                                            <i>${item.centerAdd1 } ${item.centerAdd2 }</i>
	                                            <strong>${item.centerName }</strong>
	                                        </dt>
	                                        <dd>
	                                            <p>
	                                                강북역에 위치한 신규 리모델링 스터피 카페
	                                            </p>
	                                        </dd>
	                                    </dl>
	
	                                </div>
	                            </div>
	                		</c:when>
                		<c:otherwise>
                			<div class="right small_box">
                                <div class="box_border">
                                    <dl data-centerCode="${item.centerCode }" data-centerName="${item.centerName }">
                                        <dt>
                                            <i>${item.centerAdd1 } ${item.centerAdd2 }</i>
                                            <strong>${item.centerName }</strong>
                                        </dt>
                                        <dd>
                                            <p>
                                                강북역에 위치한 신규 리모델링 스터피 카페
                                            </p>
                                        </dd>
                                    </dl>

                                </div>
                            </div>
                			
                		</c:otherwise>
                	</c:choose>
                		
                	
                	</c:if>
                </c:forEach>
                			</div>
               			</div>
                   	</div>
                </div>
            </div>
        </section>
        
        
        <section class='content qa_wrap'>
        	<div class="bg_wrap">
        	<div class="width_wrap">
		        <div class="clear_both">
					<div class="left">
						<div class="txt_wrap">
							<h3 class="qa_title">
								<i>자주묻는 질문을 한번에 !</i>
								<strong>자주묻는 질문</strong>
							</h3>
							<p class="btn_wrap">
								<a href="${contextPath }/question/showFAQ.do"><span>자세히 보기<i class="icon-rarr icon_arrow"></i></span></a>
							</p>
						</div>				
					</div>
					<div class="right">
						<div class="txt_wrap">
							<h3 class="qa_title">
								<i>궁금하신 사항을 문의해주세요 !</i>
								<strong>질문과 답변</strong>
							</h3>
							<p class="btn_wrap">
								<a href="${contextPath }/question/listQuestion.do"><span>자세히 보기<i class="icon-rarr icon_arrow"></i></span></a>
							</p>
						</div>				
					</div>	        
		        </div>
		        </div>
	        </div>
	        
        	
        </section>
        
        
        
        
        <section class='content notice_wrap'>
        	<div class="bg_wrap">
        	
        	</div>
        	<div class="notice">
        	<div class="width_wrap">
        		<div class="notice_border clear_both">
        			<div class="img_wrap">
        				<h4 class="img_title">
        					<i>안내드립니다.</i>
        					<strong>공지사항</strong>
        				</h4>
        				<p class="btn_wrap">
        					<a href="${contextPath }/notice/listNotice.do"><span>자세히 보기<i class="icon-rarr icon_arrow"></i></span></a>
        				</p>
        			</div>
        			<div class="txt_wrap">
        				<div class="vertical_slide_wrap">
	        				<ul>
	        				<c:forEach var="item" items="${noticeNewList }">
	        					<li><a href="javascript:viewNotice('${item.keyNum }')" class="viewNotice" data-keyNum="${item.keyNum }"><strong class="cate">Notice</strong>
	        						<p><b class="noticeTitle">${item.noticeTitle }</b><span class="noticeDate">${item.noticeWriteDate }</span></p>
        						</a></li>
	        				</c:forEach>
	        				</ul>
	        				<p class="slide_btn">
	        					<a href="#" class="notice_larr"><span></span></a>
	        					<a href="#" class="notice_rarr"><span></span></a>
	        				</p>
        				</div>
        			</div>
        		</div>
        		</div>
        	</div>
        </section>
    </div>
	
	
	
</body>
</html>