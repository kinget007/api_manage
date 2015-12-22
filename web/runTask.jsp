<%@ page contentType="text/html;charset=UTF-8" language="java"%>
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
	<title>api manage admin</title>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="description" content="">
	<meta name="author" content="!">

	<link href="common/css/bootstrap.min.css" rel="stylesheet">
	<link href="common/css/style.css" rel="stylesheet">
</head>
<body>
<%@include file="header.jsp"%>
<div class="container-fluid">
	<div class="row">
		<div class="col-md-12">
			<div class="jumbotron">
				<p>启动测试任务，会全量运行api接口案例，完成后可查看测试结果.</p>
				<form name="modiJob" id="modiJob"
					  action="/api_manage/ModiJobServlet" method="post" target="_blank">
					<input type="hidden" name="modi" value="query">
					<button type="submit" class="btn btn-default">管理测试任务</button>
				</form>
				<form name="run" id="run" action="/api_manage/RunTaskServlet"
					  method="post">
					<button type="submit" class="btn btn-default">启动测试任务</button>
				</form>
				<form id="viewlogs" action="/api_manage/ViewLogs" method="post"
					  target="_blank">
					<!-- <button type="submit" class="btn btn-default">查看日志</button> -->
				</form>
				<form id="viewReport" action="/api_manage/ViewReport" method="post"
					  target="_blank"></form>
				<p />
				<div class="form-group">
					<a href="#" onclick="go('viewlogs')" id="viewLogs">查看日志</a>
					&nbsp;&nbsp;&nbsp; <a href="#" onclick="go('viewReport')"
										  id="viewLogs">查看api报告</a>
				</div>
			</div>
		</div>
	</div>
</div>
<script src="common/js/jquery.min.js"></script>
<script src="common/js/bootstrap.min.js"></script>
<script src="common/js/scripts.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$("#menuActive").find("li").each(function() {
			$(this).removeClass("active");
		});
		$("#menuActive li:nth-child(2)").addClass("active");
	});

	function go(formId) {
		var obj = document.getElementById(formId);
		obj.submit();
	};
</script>
</body>
</html>