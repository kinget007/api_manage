<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort();
	if (session.getAttribute("name") == null || session.getAttribute("code") == null) {
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

	<%--<meta http-equiv="pragma" content="no-cache">--%>
	<%--<meta http-equiv="cache-control" content="no-cache">--%>
	<%--<meta http-equiv="expires" content="0">--%>

	<title>api manage logs</title>
<link href="common/css/bootstrap.min.css" rel="stylesheet">
<link href="common/css/bootstrap.css" rel="stylesheet">
<link href="common/css/style.css" rel="stylesheet">
<link href="common/css/jquery.typeahead.css" rel="stylesheet">
</head>
<body>
	<div class="container-fluid">
		<table class="table table-hover table-striped" width="100%"
			style="table-layout: fixed;">
			<thead>
				<tr>
					<c:forEach items="${title}" var="ti">
						<th>${ti}</th>
					</c:forEach>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${data}" var="ds">
					<tr>
						<c:forEach varStatus="i" var="d" items="${ds}">
							<c:choose>
								<c:when test="${i.last}">
									<td><a href="${d}" target="_blank">查看</a></td>
								</c:when>
								<c:otherwise>
									<td>${d}</td>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	<script src="common/js/jquery.min.js"></script>
	<script src="common/js/bootstrap.min.js"></script>
	<script src="common/js/scripts.js"></script>
</body>
</html>