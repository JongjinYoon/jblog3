<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JBlog</title>
<Link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/jblog.css">
<script src="${pageContext.servletContext.contextPath }/assets/js/jquery/jquery-1.9.0.js" type="text/javascript"></script>
<script>
	$(function() {
		$("#input-email").change(function(){
			$("#btn-check-email").show();
			$("#img-checked").hide();
		});
		var $btnCheckEmail = $("#btn-check-email");
		$btnCheckEmail.click(function() {
			var email = $("#input-email").val();
			console.log(email);
			if (email == "") {
				return;
			}

			// ajax 통신
			$.ajax({
				url: "${pageContext.servletContext.contextPath }/api/user/checkemail?email=" + email,
				type: "get",
				dataType: "json",
				data: "",
				success: function(response) {
					if (response.result == "fail") {
						console.error(response.message);
						return;
					}
					console.log(response.data);
	
					if (response.data == true) {
						alert("이미 존재하는 메일입니다.");
						$("#input-email").val("");
						$("#input-email").focus();
						return;
					}
					$("#btn-check-email").hide();
					$("#img-checked").show();
				},
				error: function(xhr, error){
					console.error("error:"+error);
				}
			});
		});
	});
</script>
</head>
<body>
	<div id="container">
		<c:import url="/WEB-INF/views/includes/blogheader.jsp" />
		<div id="wrapper">
			<div id="content" class="full-screen">
				<c:import url="/WEB-INF/views/includes/adminheader.jsp" />
		      	<table class="admin-cat">
		      		<tr>
		      			<th>번호</th>
		      			<th>카테고리명</th>
		      			<th>포스트 수</th>
		      			<th>설명</th>
		      			<th>삭제</th>      			
		      		</tr>
					<tr>
						<td>3</td>
						<td>미분류</td>
						<td>10</td>
						<td>카테고리를 지정하지 않은 경우</td>
						<td><img src="${pageContext.request.contextPath}/assets/images/delete.jpg"></td>
					</tr>  
					<tr>
						<td>2</td>
						<td>스프링 스터디</td>
						<td>20</td>
						<td>어쩌구 저쩌구</td>
						<td><img src="${pageContext.request.contextPath}/assets/images/delete.jpg"></td>
					</tr>
					<tr>
						<td>1</td>
						<td>스프링 프로젝트</td>
						<td>15</td>
						<td>어쩌구 저쩌구</td>
						<td><img src="${pageContext.request.contextPath}/assets/images/delete.jpg"></td>
					</tr>					  
				</table>
      	
      			<h4 class="n-c">새로운 카테고리 추가</h4>
      			<form:form 
					modelAttribute="categoryVo"
					id="category-form" 
					name="categoryForm" 
					method="post" 
					action="${pageContext.servletContext.contextPath }/blog/blog-admin-category">
		      	<table id="admin-cat-add">
		      		<tr>
		      			<td class="t">카테고리명</td>
		      			<td><form:input path="name"/></td>
		      		</tr>
		      		<tr>
		      			<td class="t">설명</td>
		      			<td><form:input path="explain"/></td>
		      		</tr>
		      		<tr>
		      			<td class="s">&nbsp;</td>
		      			<td><input type="submit" value="카테고리 추가"></td>
		      		</tr>      		      		
		      	</table> 
		      	</form:form>
			</div>
		</div>
		<c:import url="/WEB-INF/views/includes/footer.jsp" />
	</div>
</body>
</html>