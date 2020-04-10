<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
	
</style>
<title><tiles:insertAttribute name="title" /></title>
</head>
<body>
	<div id="container">
		<div id="header">
			<tiles:insertAttribute name="header" />
		</div>
		<div id="content">
			<section class='content_top'>
	            <div class="img_wrap">
	                <div class="width_wrap">
	                    <h2>
	                        <span>My Page</span>
	                    </h2>
	                </div>
	                
	            </div>
	        </section>
	        <div class="main_content ">
            	<div class="width_wrap clear_both">
            		<tiles:insertAttribute name="leftSide" />	
					<tiles:insertAttribute name="body" />
				</div>
			</div>
		</div>
		<div id="footer">
			<tiles:insertAttribute name="footer" />
		</div>
	</div>
</body>
</html>






