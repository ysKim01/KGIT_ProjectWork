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
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/search/searchSide.css">
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/mDcalendar.picker.css">
<style>
	.no-underline{
		text-decoration: none;
	}
</style>
<script src="${contextPath }/resources/js/mDcalendar.picker.js"></script>
<script>

$(function(){
	$('.searchDate').dcalendarpicker({
       // default: mm/dd/yyyy
       format:'yyyy-mm-dd'
       });
	
	$('.filter').on('click',function(){
		if($(this).prop('checked')){
			$(this).next().addClass('check');
		}else if(!$(this).prop('checked')){
			$(this).next().removeClass('check');
		}
	})
	$('.facility li input[type=checkbox]').on('click',function(){
		var facilityObj = new Object();
		$('.facility li').each(function(e){
			
			if($(this).children('input').prop('checked')){
				facilityObj[$(this).children('input').attr('name')] = '1';
			}else{
				facilityObj[$(this).children('input').attr('name')] = '0';
			}
		});	
		
		setSearch('1',facilityObj);
	})
})
$(window).on('load',function(){
	var setAddr1 = '${searchInfo.searchAdd1}';
	var setAddr2 = '${searchInfo.searchAdd2}';
	$('.addr1 option[value="'+setAddr1+'"]').prop('selected',true);
	$('.addr2 option[value="'+setAddr2+'"]').prop('selected',true);
})


function setSearch(page ,facilityObj){
    //searchDate
    // searchAdd city gu
    // roomScale
    var getDate = $('.searchDate').val()
    var getAddCity = $('.addrArea #city').val();
    var getAddGu = $('.addrArea #gu').val();
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
    var page = page;
    if(page == null || page == 'NaN' || page == '0'){
    	page = '1';
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
        'page' : page
    }
    var setDate = document.createElement('input');
    setDate.setAttribute('type','hidden');
    setDate.setAttribute('name','searchInfo');
    setDate.setAttribute('value',encodeURI(JSON.stringify(searchInfo)));
    setForm.appendChild(setDate);
    
    var $facilityObj = facilityObj;
    if($facilityObj == 'undefined' || $facilityObj == null || Object.keys($facilityObj).length == 0){
    	$facilityObj = {
  			'locker' : '0',
      		'projector' : '0',
      		'printer' : '0',
      		'noteBook' : '0',
      		'whiteBoard' : '0'
    	}
    }
    
    var facility = document.createElement('input');
    facility.setAttribute('type','hidden');
    facility.setAttribute('name','facility');
    facility.setAttribute('value',encodeURI(JSON.stringify($facilityObj)));
    setForm.appendChild(facility);
    
    
    document.body.appendChild(setForm);
    setForm.submit();
    
}
</script>
<meta charset="UTF-8">
<title>사이드 메뉴</title>
</head>
<body>
	<div class="side_nav">
                    <div class="side_box">
                    <div class="side_top">
                        <h4>
                            <span>검색</span>
                            
                        </h4>
                    </div>
                    <div class="searchOpt">
                        <ul class="">
                            <li class="dateArea">
                                <strong>날짜</strong>
                                <input type="text" class="searchDate" name="searchDate" value="">
                            </li>
                            <li class="addrArea">
                                <strong>지역</strong>
                                <select name="city" id="city" class="addr1">
                                    <option value="서울" selected="selected">서울시</option>
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
                                <select name="gu" id="gu" class="addr2">
                                    <option value="종로구">종로구</option>
                                </select>
                            </li>
                            <li class="scaleArea">
                                <strong>인원</strong>
                                <span><input type="text" class="scale" name="scale" value=""><i>인</i></span>
                            </li>
                            <li class="btn_wrap clear_both"><button class="btn_type_03 submitBtn float_right" onclick="setSearch()" type="button">검색하기</button></li>
                            <li></li>
                        </ul>
                    </div>
                    </div>
                    <div class="side_box">
                        <div class="side_top">
                            <h4>
                                <span>검색 필터</span>
                                
                            </h4>
                        </div>
                        <div class="searchFilter">
                            <ul class="facility">
                                <li class="printerLap ">
                                    <input type="checkbox" class="filter" id="printer" name="printer"><label for="printer" ><span class="designCheck"></span><b>프린터</b></label>
                                </li>
                                <li class="lockerLap">
                                    <input type="checkbox"  class="filter" id="locker" name="locker"><label for="locker"><span class="designCheck"></span><b>사물함</b></label>
                                </li>
                                <li class="projectorLap">
                                    <input type="checkbox"  class="filter" id="projector" name="projector"><label for="projector"><span class="designCheck"></span><b>프로젝터</b></label>
                                </li>
                                <li class="notebookLap">
                                    <input type="checkbox"  class="filter" id="noteBook" name="noteBook"><label for="noteBook"><span class="designCheck"></span><b>노트북</b></label>
                                </li>
                                <li class="whiteboardLap">
                                    <input type="checkbox"  class="filter" id="whiteBoard" name="whiteBoard"><label for="whiteBoard"><span class="designCheck"></span><b>화이트보드</b></label>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <!-- sideNav end-->
</body>
</html>










