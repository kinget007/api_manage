<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort();
    if(session.getAttribute("name")==null){response.sendRedirect("/api_manage/loginOauth");}
	String code = "";
	String name = "";
	if(session.getAttribute("code")!=null){code=session.getAttribute("code").toString();}
	if(session.getAttribute("name")!=null){name=session.getAttribute("name").toString();}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="utf-8">
<title>关注列表</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="">
<meta name="author" content="">

<!--link rel="stylesheet/less" href="common/less/bootstrap.less" type="text/css" /-->
<!--link rel="stylesheet/less" href="common/less/responsive.less" type="text/css" /-->
<!--script src="common/js/less-1.3.3.min.js"></script-->
<!--append ‘#!watch’ to the browser URL, then refresh the page. -->

<link href="common/css/bootstrap.min.css" rel="stylesheet">
<link href="common/css/style.css" rel="stylesheet">

<!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
<!--[if lt IE 9]>
    <script src="common/js/html5shiv.js"></script>
  <![endif]-->

<!-- Fav and touch icons -->
<link rel="shortcut icon" href="common/img/apple-touch-icon-114-precomposed.png">
<link href="common/css/jsonFormater.css" type="text/css" rel="stylesheet">

<script src="common/js/jsonFormater.js" type="text/javascript"></script>
<script type="text/javascript" src="common/js/jquery.min.js"></script>
<script type="text/javascript" src="common/js/purl.js"></script>
<script type="text/javascript" src="common/js/bootstrap.min.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
	    // do stuff when DOM is ready
	    var basePath = '<%=basePath%>';
	    var code = '<%=code%>';
	    var apiIDattention="";
		$("#menuActive").find("li").each(function() {
			$(this).removeClass("active");
		});
		$("#menuActive li:nth-child(2)").addClass("active");
		$.getJSON(basePath+"/api_manage/addAttention?code="+code+"&result=select",null,function(data) {  
				var apiInfo = data.apiInfo;
				if(apiInfo==""){
					$('#successMessage').text("未关注任何API，可以去API详情页添加");
					$('#successModal').modal('show');
				}else{
				
				$("#leftMenue").delegate('li', 'click',function() {
							$("#leftMenue").find("li").each(function() {
								$(this).removeClass("active");
							});
							$(this).addClass("active");
							$("#mainContent").find("table").each(function() {
								$(this).remove();
							});
							$("#mainContent").find("h2").each(function() {
								$(this).remove();
							});
							$("#mainContent").find("p").each(function() {
								$(this).remove();
							});
							$("#mainContent").find("h4").each(function() {
								$(this).remove();
							});

							var apiID = $(this).val();
							for(var j=0;j<eval(apiInfo).length;j++){
								if(apiInfo[j].apiID == apiID){
									//alert(apiInfo[j].apiID);
									//var tablehttpHeader = "";
									apiIDattention = apiInfo[j].apiID;
									var tableparamIn = "";
									var tableparamOut = "";
									var tabletableInfo = "";
									
									var paramIn = apiInfo[j].paramIn.paramIn;
									var paramOut = apiInfo[j].paramOut.paramOut;
									var tableInfo = apiInfo[j].tableInfo.tableInfo;
									var resultInfo = JSON.stringify(apiInfo[j].resultInfo);
									
									if (resultInfo==0 || resultInfo==""){
									   resultInfo="{}";
									}									
									 var options = {
								        dom : '#jsonFormate'
								    };
								    var jf = new JsonFormater(options);
								    jf.doFormat(resultInfo);
								    
																		
									for(var k=0;k<eval(paramIn).length;k++){
										if(typeof(paramIn[k].paramDefault)=="object"){
											paramIn[k].paramDefault = JSON.stringify(paramIn[k].paramDefault);
										}
										if((k+1)%3==0){
											tableparamIn = tableparamIn +
											"<tr class=\"danger\" width=\"100%\">"+
												"<td colspan=\"2\">"+paramIn[k].paramName+"</td>"+
												"<td colspan=\"6\">"+paramIn[k].paramDescription+"</div></td>"+
												//"<td colspan=\"2\">"+paramIn[k].paramType.split("*")[0]+"</td>"+
												"<td colspan=\"2\">"+paramIn[k].paramDefault+"</td>"+
												"<td colspan=\"2\">"+paramIn[k].isNeeded+"</td>"+
											"</tr>";
										}
										else if((k+1)%3==1){
											tableparamIn = tableparamIn +
											"<tr class=\"success\" width=\"100%\">"+
												"<td colspan=\"2\">"+paramIn[k].paramName+"</td>"+
												"<td colspan=\"6\">"+paramIn[k].paramDescription+"</div></td>"+
												//"<td colspan=\"2\">"+paramIn[k].paramType.split("*")[0]+"</td>"+
												"<td colspan=\"2\">"+paramIn[k].paramDefault+"</td>"+
												"<td colspan=\"2\">"+paramIn[k].isNeeded+"</td>"+
											"</tr>";
										}
										else{
											tableparamIn = tableparamIn +
											"<tr class=\"warning\" width=\"100%\">"+
												"<td colspan=\"2\">"+paramIn[k].paramName+"</td>"+
												"<td colspan=\"6\">"+paramIn[k].paramDescription+"</div></td>"+
												//"<td colspan=\"2\">"+paramIn[k].paramType.split("*")[0]+"</td>"+
												"<td colspan=\"2\">"+paramIn[k].paramDefault+"</td>"+
												"<td colspan=\"2\">"+paramIn[k].isNeeded+"</td>"+
											"</tr>";
										}
									}
									for(var k=0;k<eval(paramOut).length;k++){
										if((k+1)%3==0){
											tableparamOut = tableparamOut +
											"<tr class=\"danger\">"+
												"<td colspan=\"1\">"+paramOut[k].paramName+"</td>"+
												"<td colspan=\"3\">"+paramOut[k].paramDescription+"</td>"+
											"</tr>";
										}
										else if((k+1)%3==1){
											tableparamOut = tableparamOut +
											"<tr class=\"success\">"+
												"<td colspan=\"1\">"+paramOut[k].paramName+"</td>"+
												"<td colspan=\"3\">"+paramOut[k].paramDescription+"</td>"+
											"</tr>";
										}
										else{
											tableparamOut = tableparamOut +
											"<tr class=\"warning\">"+
												"<td colspan=\"1\">"+paramOut[k].paramName+"</td>"+
												"<td colspan=\"3\">"+paramOut[k].paramDescription+"</td>"+
											"</tr>";
										}
									}
									for(var k=0;k<eval(tableInfo).length;k++){
										if((k+1)%3==0){
											tabletableInfo = tabletableInfo +
											"<tr class=\"danger\">"+
												"<td>"+tableInfo[k].datebaseName+"</td>"+
												"<td>"+tableInfo[k].tableName+"</td>"+
												"<td>"+tableInfo[k].ipAddress+"</td>"+
											"</tr>";
										}
										else if((k+1)%3==1){
											tabletableInfo = tabletableInfo +
											"<tr class=\"success\">"+
												"<td>"+tableInfo[k].datebaseName+"</td>"+
												"<td>"+tableInfo[k].tableName+"</td>"+
												"<td>"+tableInfo[k].ipAddress+"</td>"+
											"</tr>";
										}
										else{
											tabletableInfo = tabletableInfo +
											"<tr class=\"warning\">"+
												"<td>"+tableInfo[k].datebaseName+"</td>"+
												"<td>"+tableInfo[k].tableName+"</td>"+
												"<td>"+tableInfo[k].ipAddress+"</td>"+
											"</tr>";
										}
									}
									var isLoginInfo = "";
									if (apiInfo[j].isLogin==1){isLoginInfo = "是";}else {isLoginInfo = "否";}
									$("#mainContent").append(
											"<table width=\"100%\" style=\"table-layout:fixed;\">"+
												"<tbody>"+
													"<tr>"+
														"<td><h2>API描述信息</h2></td>"+											
														"<td align=\"right\">"+
														"<button type=\"button\" class=\"btn btn-Success\" id=\"attention\" name=\"attention\">取消关注</button>"+
														"<a href=\'apiTools.jsp?apiID=" +apiInfo[j].apiID+"\' target=\"_blank\"><button type=\"button\" class=\"btn btn-Success\" id=\"apiTools\">在线测试</button></a>"+
														"<a href=\'markdownEdit.jsp?apiID=" +apiInfo[j].apiID+"\' target=\"_blank\"><button type=\"button\" class=\"btn btn-Success\" id=\"getMDFile\">预览.md文件</button></a>"+
														"<a href=\'apiEdit.jsp?apiID=" +apiInfo[j].apiID+"\'><button type=\"button\" class=\"btn btn-Success\" id=\"apiEdit\">信息修改</button></a></td>"+
													"</tr>"+
												"</tbody>"+
											"</table>"+
											//"<h2>API描述信息</h2>"+	
											"<p>"+apiInfo[j].editInfo+"</p>"+
											"<table class=\"table table-hover table-striped\" width=\"100%\" style=\"table-layout:fixed;\">"+
												"<thead>" +
													"<tr>"+
														"<th colspan=\"8\">接口基本信息</th>"+
													"</tr>"+
												"</thead>"+
												"<tbody>"+
													"<tr class=\"success\">"+
														"<td colspan=\"1\">接口名</td>"+
														"<td colspan=\"7\">"+apiInfo[j].cnName+"</td>"+
													"</tr>"+
													"<tr class=\"warning\">"+
														"<td colspan=\"1\">访问url</td>"+
														"<td colspan=\"7\">"+apiInfo[j].urlPath+"</td>"+
														//"<td colspan=\"7\">"+$.url(apiInfo[j].urlPath).attr("path")+"</td>"+
													"</tr>"+
													"<tr class=\"danger\">"+
														"<td colspan=\"1\">是否登录</td>"+
														"<td colspan=\"7\">"+isLoginInfo+"</td>"+
													"</tr>"+
													"<tr class=\"success\">"+
														"<td colspan=\"1\">请求方法</td>"+
														"<td colspan=\"7\">"+apiInfo[j].httpMethod+"</td>"+
													"</tr>"+
													"<tr class=\"warning\">"+
														"<td colspan=\"1\">开发人员</td>"+
														"<td colspan=\"7\">"+apiInfo[j].author+"</td>"+
													"</tr>"+
												"</tbody>"+
											"</table>"+
											"<table class=\"table table-hover table-striped\" width=\"100%\" style=\"table-layout:fixed;\">"+
												"<thead>"+
													"<tr>"+
														"<th colspan=\"12\">输入参数</th>"+
													"</tr>"+
													"<tr>"+
														"<th colspan=\"2\">参数名(EN)</th>"+
														"<th colspan=\"6\">参数描述</th>"+
														//"<th colspan=\"2\">参数类型</th>"+
														"<th colspan=\"2\">默认值</th>"+
													    "<th colspan=\"2\">是否必须</th>"+
													"</tr>"+
												"</thead>"+
												"<tbody>"+
													tableparamIn+					
												"</tbody>"+
											"</table>"+
											"<table class=\"table table-hover table-striped\" width=\"100%\" style=\"table-layout:fixed;\">"+
												"<thead>"+
													"<tr>"+
														"<th colspan=\"4\">返回结果字段解释</th>"+
													"</tr>"+
												"</thead>"+
												"<tbody>"+
													tableparamOut+				
												"</tbody>"+
											"</table>"+
											"<table class=\"table\">"+
												"<thead>"+
													"<tr>"+
														"<th colspan=\"3\">数据结构列表</th>"+
													"</tr>"+
												"</thead>"+
												"<tbody>"+
													tabletableInfo +					
												"</tbody>"+
											"</table>"+
											"<h4>返回结果示例(json)</h4>"
									);
								}							
							}
						});
				var liList = "";
				for(var j=0;j<eval(apiInfo).length;j++){
					liList = liList +"<li value=\""+apiInfo[j].apiID+"\"><a href=\"#\" title=\""+apiInfo[j].urlPath+"\">"+apiInfo[j].cnName+"</a></li>";						
				}
				$("#leftMenue").append(
						"<div class=\"panel panel-default\">"+
						"<div class=\"panel-heading\">"+
							"<a class=\"panel-title\" data-toggle=\"collapse\""+
								"data-parent=\"#panel-835660\" href=\"#panel-element-821428\">"+"关注列表"+"</a>"+
						"</div>"+
						"<div id=\"panel-element-821428\" class=\"panel-collapse in\">"+
							"<div class=\"panel-body\" id=\"apiListone\">"+
								"<ul class=\"nav nav-pills nav-stacked\">"+
								 	liList+	
								"</ul>"+
							"</div>"+
						"</div>"+
					"</div>"
				);
				
				var apiID = data.apiInfo[0].apiID;
				for(var j=0;j<eval(apiInfo).length;j++){
					if(apiInfo[j].apiID == apiID){
						apiIDattention = apiInfo[j].apiID;
						var tableparamIn = "";
						var tableparamOut = "";
						var tabletableInfo = "";
						
						var paramIn = apiInfo[j].paramIn.paramIn;
						var paramOut = apiInfo[j].paramOut.paramOut;
						var tableInfo = apiInfo[j].tableInfo.tableInfo;
						var resultInfo = JSON.stringify(apiInfo[j].resultInfo);
						
						if (resultInfo==0 || resultInfo==""){
						   resultInfo="{}";
						}									
						 var options = {
					        dom : '#jsonFormate'
					    };
					    var jf = new JsonFormater(options);
					    jf.doFormat(resultInfo);
															
						for(var k=0;k<eval(paramIn).length;k++){
							if(typeof(paramIn[k].paramDefault)=="object"){
								paramIn[k].paramDefault = JSON.stringify(paramIn[k].paramDefault);
							}
							if((k+1)%3==0){
								tableparamIn = tableparamIn +
								"<tr class=\"danger\">"+
									"<td colspan=\"2\">"+paramIn[k].paramName+"</td>"+
									"<td colspan=\"6\">"+paramIn[k].paramDescription+"</div></td>"+
									//"<td colspan=\"2\">"+paramIn[k].paramType.split("*")[0]+"</td>"+
									"<td colspan=\"2\">"+paramIn[k].paramDefault+"</td>"+
									"<td colspan=\"2\">"+paramIn[k].isNeeded+"</td>"+
								"</tr>";
							}
							else if((k+1)%3==1){
								tableparamIn = tableparamIn +
								"<tr class=\"success\">"+
									"<td colspan=\"2\">"+paramIn[k].paramName+"</td>"+
									"<td colspan=\"6\">"+paramIn[k].paramDescription+"</div></td>"+
									//"<td colspan=\"2\">"+paramIn[k].paramType.split("*")[0]+"</td>"+
									"<td colspan=\"2\">"+paramIn[k].paramDefault+"</td>"+
									"<td colspan=\"2\">"+paramIn[k].isNeeded+"</td>"+
								"</tr>";
							}
							else{
								tableparamIn = tableparamIn +
								"<tr class=\"warning\">"+
									"<td colspan=\"2\">"+paramIn[k].paramName+"</td>"+
									"<td colspan=\"6\">"+paramIn[k].paramDescription+"</div></td>"+
									//"<td colspan=\"2\">"+paramIn[k].paramType.split("*")[0]+"</td>"+
									"<td colspan=\"2\">"+paramIn[k].paramDefault+"</td>"+
									"<td colspan=\"2\">"+paramIn[k].isNeeded+"</td>"+
								"</tr>";
							}
						}
						for(var k=0;k<eval(paramOut).length;k++){
							if((k+1)%3==0){
								tableparamOut = tableparamOut +
								"<tr class=\"danger\">"+
									"<td colspan=\"1\">"+paramOut[k].paramName+"</td>"+
									"<td colspan=\"3\">"+paramOut[k].paramDescription+"</td>"+
								"</tr>";
							}
							else if((k+1)%3==1){
								tableparamOut = tableparamOut +
								"<tr class=\"success\">"+
									"<td colspan=\"1\">"+paramOut[k].paramName+"</td>"+
									"<td colspan=\"3\">"+paramOut[k].paramDescription+"</td>"+
								"</tr>";
							}
							else{
								tableparamOut = tableparamOut +
								"<tr class=\"warning\">"+
									"<td colspan=\"1\">"+paramOut[k].paramName+"</td>"+
									"<td colspan=\"3\">"+paramOut[k].paramDescription+"</td>"+
								"</tr>";
							}
						}
						for(var k=0;k<eval(tableInfo).length;k++){
							if((k+1)%3==0){
								tabletableInfo = tabletableInfo +
								"<tr class=\"danger\">"+
									"<td>"+tableInfo[k].datebaseName+"</td>"+
									"<td>"+tableInfo[k].tableName+"</td>"+
									"<td>"+tableInfo[k].ipAddress+"</td>"+
								"</tr>";
							}
							else if((k+1)%3==1){
								tabletableInfo = tabletableInfo +
								"<tr class=\"success\">"+
									"<td>"+tableInfo[k].datebaseName+"</td>"+
									"<td>"+tableInfo[k].tableName+"</td>"+
									"<td>"+tableInfo[k].ipAddress+"</td>"+
								"</tr>";
							}
							else{
								tabletableInfo = tabletableInfo +
								"<tr class=\"warning\">"+
									"<td>"+tableInfo[k].datebaseName+"</td>"+
									"<td>"+tableInfo[k].tableName+"</td>"+
									"<td>"+tableInfo[k].ipAddress+"</td>"+
								"</tr>";
							}
						}
						var isLoginInfo = "";
						if (apiInfo[j].isLogin==1){isLoginInfo = "是";}else {isLoginInfo = "否";}
						$("#mainContent").append(
								"<table width=\"100%\" style=\"table-layout:fixed;\">"+
									"<tbody>"+
										"<tr>"+
											"<td><h2>API描述信息</h2></td>"+											
											"<td align=\"right\">"+
											"<button type=\"button\" class=\"btn btn-Success\" id=\"attention\" name=\"attention\">取消关注</button>"+
											"<a href=\'apiTools.jsp?apiID=" +apiInfo[j].apiID+"\' target=\"_blank\"><button type=\"button\" class=\"btn btn-Success\" id=\"apiTools\">在线测试</button></a>"+
											"<a href=\'markdownEdit.jsp?apiID=" +apiInfo[j].apiID+"\' target=\"_blank\"><button type=\"button\" class=\"btn btn-Success\" id=\"getMDFile\">预览.md文件</button></a>"+
											"<a href=\'apiEdit.jsp?apiID=" +apiInfo[j].apiID+"\'><button type=\"button\" class=\"btn btn-Success\" id=\"apiEdit\">信息修改</button></a></td>"+
										"</tr>"+
									"</tbody>"+
								"</table>"+
								//"<h2>API描述信息</h2>"+
								"<p>"+apiInfo[j].editInfo+"</p>"+
								"<table class=\"table table-hover table-striped\" width=\"100%\" style=\"table-layout:fixed;\">"+
									"<thead>" +
										"<tr>"+
											"<th colspan=\"8\">接口基本信息</th>"+
										"</tr>"+
									"</thead>"+
									"<tbody>"+
										"<tr class=\"success\">"+
											"<td colspan=\"1\">接口名</td>"+
											"<td colspan=\"7\">"+apiInfo[j].cnName+"</td>"+
										"</tr>"+
										"<tr class=\"warning\">"+
											"<td colspan=\"1\">访问url</td>"+
											"<td colspan=\"7\">"+apiInfo[j].urlPath+"</td>"+
											//"<td colspan=\"7\">"+$.url(apiInfo[j].urlPath).attr("path")+"</td>"+
										"</tr>"+
										"<tr class=\"danger\">"+
											"<td colspan=\"1\">是否登录</td>"+
											"<td colspan=\"7\">"+isLoginInfo+"</td>"+
										"</tr>"+
										"<tr class=\"success\">"+
											"<td colspan=\"1\">请求方法</td>"+
											"<td colspan=\"7\">"+apiInfo[j].httpMethod+"</td>"+
										"</tr>"+
										"<tr class=\"warning\">"+
											"<td colspan=\"1\">开发人员</td>"+
											"<td colspan=\"7\">"+apiInfo[j].author+"</td>"+
										"</tr>"+
									"</tbody>"+
								"</table>"+
								"<table class=\"table table-hover table-striped\" width=\"100%\" style=\"table-layout:fixed;\">"+
									"<thead>"+
										"<tr>"+
											"<th colspan=\"12\">输入参数</th>"+
										"</tr>"+
										"<tr>"+
											"<th colspan=\"2\">参数名(EN)</th>"+
											"<th colspan=\"6\">参数描述</th>"+
											//"<th colspan=\"2\">参数类型</th>"+
											"<th colspan=\"2\">默认值</th>"+
											"<th colspan=\"2\">是否必须</th>"+
										"</tr>"+
									"</thead>"+
									"<tbody>"+
										tableparamIn+					
									"</tbody>"+
								"</table>"+
								"<table class=\"table table-hover table-striped\" width=\"100%\" style=\"table-layout:fixed;\">"+
									"<thead>"+
										"<tr>"+
											"<th colspan=\"4\">返回结果字段解释</th>"+
										"</tr>"+
									"</thead>"+
									"<tbody>"+
										tableparamOut+				
									"</tbody>"+
								"</table>"+
								"<table class=\"table\">"+
									"<thead>"+
										"<tr>"+
											"<th colspan=\"3\">数据结构列表</th>"+
										"</tr>"+
									"</thead>"+
									"<tbody>"+
										tabletableInfo +					
									"</tbody>"+
								"</table>"+
								"<h4>返回结果示例(json)</h4>"
						);
					}							
				}	
				}
		});
		
		$("#successBtn").click(function(){			
			window.location.href=basePath+"/api_manage/index.jsp"; 	
		});
		$("#delBtn").click(function(){			
			window.location.href=basePath+"/api_manage/apiAttention.jsp"; 	
		});
		 $(document).on('click', '#attention', function() {
				$.getJSON(basePath+"/api_manage/addAttention?code="+code+"&apiID="+apiIDattention+"&result=del",null,function(data) {
					    if(data.result=="ok"){
						    $('#delMessage').text("取消关注成功");
							$('#delModal').modal('show');			    	
					    }
					    else{
					    	$('#delMessage').text("取消关注失败");
							$('#delModal').modal('show');
					    }
					});			 
			});
	});
	
	
</script>

</head>

<body>
	<div class="container">
		<%@include file="header.jsp"%>		
		<div class="row clearfix">
			<div class="col-md-3 column">
				<h2></h2>
				<div id="leftMenue">
				</div>				
			</div>
			<div class="col-md-9 column">
				<div id="mainContent">
				
				</div>	
				<div id="jsonFormate" style="overflow-y:auto; border:0px solid;"></div>			
			</div>
		</div>
		
		<div class="row clearfix">
			<div class="col-md-12 column">
			<%@include file="footer.jsp"%>
			</div>
		</div>
		
		<div class="row clearfix">
			<div class="col-md-3 column"></div>
			<div class="col-md-9 column"></div>
		</div>
	</div>
	
	
	<!-- Modal success-->
		<div class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true"  id="successModal">
			<div class="modal-dialog modal-sm">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">提示信息</h4>						
					</div>
					<div class="modal-body">
						<table  style="overflow:auto;" border="0px">
							<tr>
								<td id="successMessage"></td>
							</tr>
						</table>
					</div>
					  
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal" id="successBtn">Close</button>
					</div>
					
				</div>
			</div>
		</div>
		
		<!-- Modal del-->
		<div class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true"  id="delModal">
			<div class="modal-dialog modal-sm">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">提示信息</h4>						
					</div>
					<div class="modal-body">
						<table  style="overflow:auto;" border="0px">
							<tr>
								<td id="delMessage"></td>
							</tr>
						</table>
					</div>
					  
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal" id="delBtn">Close</button>
					</div>
					
				</div>
			</div>
		</div>
</body>
</html>
