<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort();
	if(session.getAttribute("name")==null || session.getAttribute("code")==null){response.sendRedirect("/api_manage/login.jsp");}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="utf-8">
<title>关于</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="">
<meta name="author" content="">

<!--link rel="stylesheet/less" href="common/less/bootstrap.less" type="text/css" /-->
<!--link rel="stylesheet/less" href="common/less/responsive.less" type="text/css" /-->
<!--script src="common/js/less-1.3.3.min.js"></script-->
<!--append ‘#!watch’ to the browser URL, then refresh the page. -->

<link href="common/css/bootstrap.min.css" rel="stylesheet">
<link href="common/css/bootstrap.css" rel="stylesheet">
<link href="common/css/style.css" rel="stylesheet">
<link href="common/css/jquery.typeahead.css" rel="stylesheet">
<script type="text/javascript" src="common/js/jquery.typeahead.js"></script>
<!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
<!--[if lt IE 9]>
    <script src="common/js/html5shiv.js"></script>
  <![endif]-->

<!-- Fav and touch icons -->
<link rel="shortcut icon" href="common/img/apple-touch-icon-114-precomposed.png">

<script type="text/javascript" src="common/js/jquery.min.js"></script>
<script type="text/javascript" src="common/js/bootstrap.min.js"></script>
<script type="text/javascript" src="common/js/jsonFormater.js"></script>
<script type="text/javascript" src="common/js/purl.js"></script>
<script type="text/javascript" src="common/js/jquery.typeahead.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	$("#menuActive").find("li").each(function() {
			$(this).removeClass("active");
		});
	$("#menuActive li:nth-child(6)").addClass("active");
		});
</script>
</head>
<body>
<div class="container" id="container">	
<%@include file="header.jsp"%>
		<h2></h2>		
		<div class="row clearfix">
			<div class="col-md-12 column">
				<h2>注意</h2>
				<ul>
					<li style="background-color: #CCC"><font color="red">建议使用google、火狐浏览器访问，ie内核的浏览器界面显示会出现问题！！！</font></li>	
				</ul>
				<h2>出发点</h2>
				<ul>
					<li style="background-color: #CCC">目前API通过GitLab管理，不同API开发团队放文档的地址不同，文档格式也不相同，造成管理和阅读的不便。</li>
					<li style="background-color: #CCC">MarkDown文档编写需要固定的格式，占用开发的一部分时间。</li>
					<li style="background-color: #CCC">方便测试的同学进行测试。</li>	
				</ul>
				
				<h2>功能介绍</h2>
				<h4>主页：</h4>
				<ul>
					<li style="background-color: #CCC">展示API的分类与各分类中的具体的API。</li>
					<li style="background-color: #CCC">支持模糊搜索。（输入部分API链接自动补全进行提示）。</li>	
				</ul>
				
				<h4>新增：</h4>
				<ul>
					<li style="background-color: #CCC">添加新的API。</li>
					<li style="background-color: #CCC">参数的输入由链接自动生成或者填入json格式的参数。</li>	
					<li style="background-color: #CCC">提交之前会根据输入的参数返回请求结果，便于判断录入API的正确性。</li>
				</ul>
				
				<h4>关注：</h4>
				<ul>
					<li style="background-color: #CCC">便于快速查看API。</li>
				</ul>
				
				<h4>在线测试：</h4>
				<ul>
					<li style="background-color: #CCC">自动生成测试数据，一键测试。</li>
					<li style="background-color: #CCC">根据用户输入的url参数、post参数与http头中的参数返回测试结果。</li>
					<li style="background-color: #CCC">可修改输入的参数值，便于多次测试。</li>
				</ul>
				
				<h4>Markdown：</h4>
				<ul>
					<li style="background-color: #CCC">通过录入的API数据，自动生成对应的文档。</li>
					<li style="background-color: #CCC">给予常用书写格式的提示，可实时查看编写的文档是否有误。</li>
				</ul>
				
				<h4>位置查询：</h4>
				<ul>
					<li style="background-color: #CCC">计算高德地图返回的坐标与公司标注小区坐标的偏差。</li>
				</ul>	
				
				<h2>待续</h2>
				<ul>
					<li style="background-color: #CCC">API状态管理。</li>
					<li style="background-color: #CCC">API测试计划。</li>					
					<li style="background-color: #CCC">...</li>	
				</ul>		
		</div>
		
		</div>
		
		<div class="row clearfix">
			<div class="col-md-12 column">
			<%@include file="footer.jsp"%>
			</div>
		</div>
	</div>
</body>
</html>