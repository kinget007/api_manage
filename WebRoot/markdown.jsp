<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	//String path = request.getContextPath();
	//String basePath = request.getScheme() + "://"
	//		+ request.getServerName() + ":" + request.getServerPort()
	//		+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="utf-8">
<title>apiTools</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="">
<meta name="author" content="">

<!--link rel="stylesheet/less" href="common/less/bootstrap.less" type="text/css" /-->
<!--link rel="stylesheet/less" href="common/less/responsive.less" type="text/css" /-->
<!--script src="common/js/less-1.3.3.min.js"></script-->
<!--append ‘#!watch’ to the browser URL, then refresh the page. -->

<link href="common/css/bootstrap.min.css" rel="stylesheet">
<link href="common/css/style.css" rel="stylesheet">
<link href="common/css/bootstrap-markdown.min.css" rel="stylesheet">

<script type="text/javascript" src="common/js/jquery.min.js"></script>
<script type="text/javascript" src="common/js/bootstrap.min.js"></script>
<script type="text/javascript" src="common/js/scripts.js"></script>
<script src="common/js/jsonFormater.js" type="text/javascript"></script>
<script type="text/javascript" src="common/google-code-prettify/prettify.js"></script>
<script src="common/js/bootstrap-markdown.js"></script>
<script src="common/js/markdown.js"></script>
<script src="common/js/main.js"></script>
</head>
<body> 
<div class="container">
	<div class="row clearfix">
		<div class="col-md-12 column">
		<h2>MarkDown文档预览</h2>
		</div>
		<div class="col-md-12 column">
			<div class="row clearfix">
				<div class="col-md-6 column">
				<textarea id="target-editor-twitter"  class="form-control" rows="30"></textarea>
				</div>
				<div class="col-md-6 column">
				 <div id="twitter-footer" class="well" style="height:642px;overflow-y:auto; "></div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>
</body>
</html>


