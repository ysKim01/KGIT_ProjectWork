<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" type="text/css" href="${contextPath }/resources/css/oneday/ListOnedayClass.css">
<style type="text/css">
.boardTitle {
	padding:15px; box-sizing:border-box;
	background-color: #fff;
   	border-bottom: 2px solid #eaeaea;		
}

.boardTitle h3{
	font-size:24px;
}

.boardTitle .regDate{
	text-align: right; 
	display: block; 
	color: #999; 
	font-size: 13px;
}

.ter img{
width: 50%;
margin-bottom: 20px;
margin-top: 20px;
}

</style>
<script>
	var isEmpty = function(value) {
		if (value == ""
				|| value == null
				|| value == undefined
				|| (value != null && typeof value == "object" && !Object
						.keys(value).length)) {
			return true;
		} else {
			return false;
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
						<span>OneDay Class</span>
					</h2>
				</div>

			</div>
		</section>
		
		</div>
		<div class="cen"><div class="ter"><div class="body_content">
			<h1 class="onedayTitle">${oneDay.classTitle }<span></span></h1>
			<div class="pdDetail">
			</div>
		</div>	
		<div class="cen"><div class="ter"><div class="w3-content w3-display-container">
			<c:choose>
			<c:when test="${ not empty oneDay.classPhoto1}">
				<div class="w3-display-container mySlides">
				  <img src="${contextPath}${oneDay.classPhoto1}" alt="원데이클래스이미지">
				  <div class="w3-display-bottomleft w3-large w3-container w3-padding-16 w3-black">
				  </div>
				</div>
			</c:when>
			</c:choose>
			</div></div>
		</div>
	</div>
</div>
	<div class="tb_wrap">
		<div class="width_wrap">
			<h4 class="tb_title" data-lan-false="phpx can not be used">OneDayClass</h4>
				<table>
					<tbody>
						<tr>
							<th><span>클래스 제목</span></th>
							<td>${oneDay.classTitle }</td>
						</tr>
						<tr>
							<th><span>강사명 </span></th>
							<td>${oneDay.lector }</td>
						</tr>
						<tr>
							<th><span>강사 전화번호</span></th>
							<td>${oneDay.lectorTel }</td>
						</tr>
						<tr>
							<th><span>모집현황</span></th>
							<c:choose>
			                <c:when test="${oneDay.classStatus == 0}">
			                    <td>모집중</td>
			                </c:when>
			                <c:otherwise>
			                    <td>모집완료</td>
			                </c:otherwise>
							</c:choose>
						</tr>
						<tr>
							<th><span>강의 날짜</span></th>
							<td>${oneDay.classDate }</td>
						</tr>
						<tr>
							<th><span>강의 시간 </span></th>
							<td>
								<script>
									var str = '${oneDay.classTime}';
									var astr = str.split(' ~ ');
									document.write(astr[0]+':00'+' ~ '+astr[1]+':00');
								</script>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	<div class="onedayListWrap">
	<div class="width_wrap">
		<div class="content_block">	
        	<div id="onedayWrap">
	      		<div>
					<div class="cen">
						<div class="ter">
							<c:choose>
							<c:when test="${ not empty oneDay.classPhoto2}">
								<div class="w3-display-container mySlides">
								  <img src="${contextPath}${oneDay.classPhoto2}" alt="원데이클래스이미지">
								  <div class="w3-display-bottomright w3-large w3-container w3-padding-16 w3-black">
								  </div>
								</div>
							</c:when>
							</c:choose>
							<c:choose>
							<c:when test="${ not empty oneDay.classPhoto3}">
								<div class="w3-display-container mySlides">
								  <img src="${contextPath}${oneDay.classPhoto3}" alt="원데이클래스이미지">
								  <div class="w3-display-topleft w3-large w3-container w3-padding-16 w3-black">
								  </div>
								</div>
							</c:when>
							</c:choose>
							<c:choose>
							<c:when test="${ not empty oneDay.classPhoto4}">
								<div class="w3-display-container mySlides">
								  <img src="${contextPath}${oneDay.classPhoto4}" alt="원데이클래스이미지">
								  <div class="w3-display-topright w3-large w3-container w3-padding-16 w3-black">
								  </div>
								</div>
							</c:when>
							</c:choose>
							<c:choose>
							<c:when test="${ not empty oneDay.classPhoto5}">
								<div class="w3-display-container mySlides">
								  <img src="${contextPath}${oneDay.classPhoto5}" alt="원데이클래스이미지">
								  <div class="w3-display-middle w3-large w3-container w3-padding-16 w3-black">
								  </div>
								</div>
							</c:when>
							</c:choose>
						</div>
					</div>
				<div class="onedayContent">
					<div class="contentArea">
						${oneDay.classContent}
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
</body>
</html>