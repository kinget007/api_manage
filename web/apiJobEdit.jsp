<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort();
	if (session.getAttribute("name") == null
			|| session.getAttribute("code") == null) {
		response.sendRedirect("/api_manage/login.jsp");
	} else {
		if (!session.getAttribute("code").equals("admin")) {
			response.sendRedirect("/api_manage/index.jsp");
		}
	}
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>api manage job</title>
	<link href="common/css/bootstrap.min.css" rel="stylesheet">
	<link href="common/css/bootstrap.css" rel="stylesheet">
	<link href="common/css/style.css" rel="stylesheet">
	<link href="common/css/jquery.typeahead.css" rel="stylesheet">
	<script language="javascript" type="text/javascript">
		function showdiv() {
			document.getElementById("bg").style.display = "block";
			document.getElementById("show").style.display = "block";
		}
		function hidediv() {
			document.getElementById("bg").style.display = 'none';
			document.getElementById("show").style.display = 'none';
		}
	</script>
	<style type="text/css">
		#bg {
			display: none;
			position: absolute;
			top: 0%;
			left: 0%;
			width: 100%;
			height: 100%;
			overflow:hidden;
			/*overflow:auto;*/
			margin:0px;
			padding:0px;
		    background-color: white;
			z-index: 1001;
			-moz-opacity: 0.7;
			opacity: .70;
			filter: alpha(opacity = 70);
		}

		#show {
			display: none;
			position: absolute;
			top: 25%;
			left: 42%;
			width: 20%;
			height: 20%;
			padding: 8px;
			border: 1px solid #D3D3D3;
			background-color: white;
			z-index: 1002;
			overflow: hidden;
		}

		html{height:100%;}
		body{height:100%; overflow:auto;}
	</style>
</head>
<body>
<div id="divJob" class="container">
	<form id="modiJob" name="modiJob" action="/api_manage/ModiJobServlet"
		  method="post">
		<div class="container-fluid">
		<div class="row clearfix" style="height: 80%;overflow: auto">
			<%--<div class="col-md-12 column" style="height: 80%;overflow: auto">--%>
		<table class="table table-hover table-striped" width="100%" style="table-layout: fixed;">
			<thead>
			<tr>
				<c:forEach items="${title}" var="ti">
					<th>${ti}</th>
				</c:forEach>
			</tr>
			</thead>
			<tbody>
			<c:forEach varStatus="i" items="${apiInfoList}" var="apiInfo">
				<input type="hidden" id="apiID"
					   name="apiInfoList[${i.index}].apiID" value="${apiInfo.apiID}">
				<tr>
					<td><input type="text" id="orderNum"
							   name="apiInfoList[${i.index}].orderNum" class="form-control"
							   style="width: 100%;" value="${apiInfo.orderNum}"></td>
					<td><input type="text" id="cnName"
							   name="apiInfoList[${i.index}].cnName" class="form-control"
							   style="width: 100%;" value="${apiInfo.cnName}"></td>
					<td><input type="text" id="urlPath"
							   name="apiInfoList[${i.index}].urlPath" class="form-control"
							   style="width: 100%;" value="${apiInfo.urlPath}"></td>
					<td><input type="text" id="httpMethod"
							   name="apiInfoList[${i.index}].httpMethod" class="form-control"
							   style="width: 100%;" value="${apiInfo.httpMethod}"></td>
					<td><input type="text" id="paramIn"
							   name="apiInfoList[${i.index}].paramIn" class="form-control"
							   style="width: 100%;" value='${apiInfo.paramIn}'></td>
					<td><input type="text" id="resultInfo"
							   name="apiInfoList[${i.index}].resultInfo" class="form-control"
							   style="width: 100%;" value='${apiInfo.resultInfo}'></td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
		</div></div>
			<div iclass="container-fluid" style="margin-top: 10px">
		<input type="hidden" name="modi" value="update">
		<button type="button" class="btn btn-default" onclick="showdiv();">提交</button>
		<button type="reset" class="btn btn-default">重置</button>
			</div>
		<div id="bg"></div>
		<div id="show">
			<div style="margin-top: 10px;text-align: center;">是否提交?</div>
			<div style="margin-top: 30px; text-align: center;">
				<button type="submit" class="btn btn-default" onclick="hidediv();">确认</button>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<button type="button" class="btn btn-default" onclick="hidediv();">取消</button>
			</div>
		</div>
	</form>
</div>

<script src="common/js/jquery.min.js"></script>
<script src="common/js/bootstrap.min.js"></script>
<script src="common/js/scripts.js"></script>
</body>
</html>