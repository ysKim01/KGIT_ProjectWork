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
<meta charset="UTF-8">
<title>사이드 메뉴</title>
</head>
<body>
	<div class="side_nav">
                    <div class="side_box">
                    <div class="side_top">
                        <h4>
                            <i class="icon-question"></i>
                            <span>Hong gil dong</span>
                            <!--<%-- ${userInfo.name } --%>-->
                        </h4>
                    </div>
                    <div class="searchOpt">
                        <ul class="">
                            <li class="dateArea">
                                <strong>날짜</strong>
                                <input type="text" class="searchDate" name="scale" value="">
                            </li>
                            <li class="addrArea">
                                <strong>지역</strong>
                                <select name="city" id="city">
                                    <option value="서울">서울</option>
                                </select>
                                <select name="gu" id="gu">
                                    <option value="종로구">종로구</option>
                                </select>
                            </li>
                            <li class="scaleArea">
                                <strong>인원</strong>
                                <span><input type="text" class="scale" name="scale" value=""><i>인</i></span>
                            </li>
                            <li><button type="button">검색하기</button></li>
                            <li></li>
                        </ul>
                    </div>
                    </div>
                    <div class="side_box">
                        <div class="side_top">
                            <h4>
                                <i class="icon-question"></i>
                                <span>Hong gil dong</span>
                                <!--<%-- ${userInfo.name } --%>-->
                            </h4>
                        </div>
                        <div class="searchFilter">
                            <div class="side_title">
                                <h4>필터링</h4>
                            </div>
                            <ul class="facility">
                                <li class="printerLap">
                                    <input type="checkbox" id="printer" name="printer"><label for="printer" >프린터</label>
                                </li>
                                <li class="lockerLap">
                                    <input type="checkbox" id="locker" name="locker"><label for="locker">사물함</label>
                                </li>
                                <li class="projectorLap">
                                    <input type="checkbox" id="projector" name="projector"><label for="projector">프로젝터</label>
                                </li>
                                <li class="notebookLap">
                                    <input type="checkbox" id="notebook" name="notebook"><label for="notebook">노트북</label>
                                </li>
                                <li class="whiteboardLap">
                                    <input type="checkbox" id="whiteboard" name="whiteboard"><label for="whiteboard">화이트보드</label>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <!-- sideNav end-->
</body>
</html>










