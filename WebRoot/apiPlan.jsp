<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort();

	if(session.getAttribute("code")==null){response.sendRedirect("/api_manage/loginOauth");}
	String code = "";
	String name = "";
	if(session.getAttribute("code")!=null){code=session.getAttribute("code").toString();}
	if(session.getAttribute("name")!=null){name=session.getAttribute("name").toString();}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="utf-8">
<title>apiPlan</title>
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
<link rel="shortcut icon"
	href="common/img/apple-touch-icon-114-precomposed.png">
<link href="common/css/jsonFormater.css" type="text/css"
	rel="stylesheet">
<script src="common/js/jsonFormater.js" type="text/javascript"></script>
<script type="text/javascript" src="common/js/jquery.min.js"></script>
<script type="text/javascript" src="common/js/bootstrap.min.js"></script>
<script type="text/javascript" src="common/js/purl.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	var basePath = '<%=basePath%>';
	var code = '<%=code%>';
		$("#menuActive").find("li").each(function() {
			$(this).removeClass("active");
		});
		$("#menuActive li:nth-child(4)").addClass("active");
		$("#leftMenue").delegate('li', 'click', function() {
			$("#leftMenue").find("li").each(function() {
				$(this).removeClass("active");
			});
			$(this).addClass("active");
		});
		$("#makePlan").click(function() {
			$("#chooseModal").modal('show');

		});
		
		$("#apiAttentionList").delegate('li', 'click',function() {			
			$(this).addClass("active");
			$("#apiPlanListUL").append("<li value=\""+$(this).val()+"\"><a href=\"#\" title=\"\">"+$(this).text()+"</a></li>");
			$(this).remove();
			
			
		});
		
		$("#apiPlanList").delegate('li', 'click',function() {
			$(this).addClass("active");
			$("#apiAttentionListUL").append("<li value=\""+$(this).val()+"\"><a href=\"#\" title=\"\">"+$(this).text()+"</a></li>");
			$(this).remove();			
		});
		
		$.getJSON(basePath+"/api_manage/addAttention?code="+code+"&result=select",null,function(data) {  
			var apiInfo = data.apiInfo;
			if(apiInfo==""){
				$('#successMessage').text("未关注任何API，可以去API详情页添加");
				$('#successModal').modal('show');
			}else{
				var apiAttentionListULLI = "";
				for(var j=0;j<eval(apiInfo).length;j++){
					apiAttentionListULLI = apiAttentionListULLI + "<li value=\""+apiInfo[j].apiID+"\"><a href=\"#\" title=\"\">"+$.url(apiInfo[j].urlPath).attr("path")+"</a></li>";
				}
				$("#apiAttentionListUL").append(apiAttentionListULLI);
			}
			
			var apiPlanLists = new Array();	        
			$("#chooseBtn").click(function(){	
				var count = 0;
				$("#apiPlanList li").each(function(){
				    apiPlanLists[count] = $(this).val();
				    count++;
				  });

				var tableTr = "";
				for(var j=0;j<eval(apiInfo).length;j++){
					for(var i=0;i<apiPlanLists.length;i++){
						if(apiPlanLists[i]==apiInfo[j].apiID){
							if((i+1)%3==0){
								tableTr = tableTr +
								"<tr class=\"warning\">"+
									"<td colspan=\"1\">"+(i+1)+"</td>"+
									"<td colspan=\"6\"><a href=\"#\" title=\""+apiInfo[j].urlPath+"\">"+apiInfo[j].urlPath +"</a></td>"+
									"<td colspan=\"7\">"+apiInfo[j].cnName+"</td>"+
									"<td colspan=\"2\">"+"<button type=\"button\" class=\"btn btn-primary btn-xs\" id=\"makePlan\" name=\"makePlan\">参数确认</button>"+"</td>"+
								"<tr>";
							}
							else if((i+1)%3==1){
								tableTr = tableTr +
								"<tr class=\"success\">"+
									"<td colspan=\"1\">"+(i+1)+"</td>"+
									"<td colspan=\"6\"><a href=\"#\" title=\""+apiInfo[j].urlPath+"\">"+apiInfo[j].urlPath +"</a></td>"+
									"<td colspan=\"7\">"+apiInfo[j].cnName+"</td>"+
									"<td colspan=\"2\">"+"<button type=\"button\" class=\"btn btn-primary btn-xs\" id=\"makePlan\" name=\"makePlan\">参数确认</button>"+"</td>"+
								"<tr>";
							}
							else{
								tableTr = tableTr +
								"<tr class=\"danger\">"+
									"<td colspan=\"1\">"+(i+1)+"</td>"+
									"<td colspan=\"6\"><a href=\"#\" title=\""+apiInfo[j].urlPath+"\">"+apiInfo[j].urlPath +"</a></td>"+
									"<td colspan=\"7\">"+apiInfo[j].cnName+"</td>"+
									"<td colspan=\"2\">"+"<button type=\"button\" class=\"btn btn-primary btn-xs\" id=\"makePlan\" name=\"makePlan\">参数确认</button>"+"</td>"+
								"<tr>";
							}
							i = apiPlanLists.length;
						}
					}					
				}
				$("#mainContent").find("table").each(function() {
					$(this).remove();
				});
				$("#mainContent").append(
						"<table class=\"table table-hover table-striped\" width=\"100%\" style=\"table-layout:fixed;\">"+
							"<thead>"+
								"<tr>"+
									"<th colspan=\"16\">API列表</th>"+
								"</tr>"+
							"</thead>"+
							"<tbody>"+
							tableTr+
							"</tbody>"+
							"</table>"
							);	
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
					<div class="panel panel-default">
						<div class="panel-heading">
							<a class="panel-title" data-toggle="collapse"
								"data-parent="#panel-835660" href="#panel-element-821428">测试计划</a>
						</div>
						<div id="panel-element-821428" class="panel-collapse in">
							<div class="panel-body" id="planList" style="height: 600px;overflow:auto;">
								<ul class="nav nav-pills nav-stacked">
									<li value=""><a href="#" title="">计划1</a></li>
									<li value=""><a href="#" title="">计划2</a></li>
									<li value=""><a href="#" title="">计划3</a></li>
									<li value=""><a href="#" title="">计划4</a></li>
									<li value=""><a href="#" title="">计划5</a></li>
									<li value=""><a href="#" title="">计划6</a></li>
									<li value=""><a href="#" title="">计划7</a></li>
									<li value=""><a href="#" title="">计划1</a></li>
									<li value=""><a href="#" title="">计划2</a></li>
									<li value=""><a href="#" title="">计划3</a></li>
									<li value=""><a href="#" title="">计划4</a></li>
									<li value=""><a href="#" title="">计划5</a></li>
									<li value=""><a href="#" title="">计划6</a></li>
									<li value=""><a href="#" title="">计划7</a></li>
									<li value=""><a href="#" title="">计划1</a></li>
									<li value=""><a href="#" title="">计划2</a></li>
									<li value=""><a href="#" title="">计划3</a></li>
									<li value=""><a href="#" title="">计划4</a></li>
									<li value=""><a href="#" title="">计划5</a></li>
									<li value=""><a href="#" title="">计划6</a></li>
									<li value=""><a href="#" title="">计划7</a></li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="col-md-9 column">
				<div>
					<table width="100%">
						<tbody>
							<tr>
								<td align="right">
									<button type="button" class="btn btn-Success" id="makePlan" name="makePlan">创建新计划</button>
									<button type="button" class="btn btn-Success" id="savePlan" name="savePlan">保存新计划</button>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div id="mainContent"></div>
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

	<!-- Modal choose api-->
	<div class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog"
		aria-labelledby="mySmallModalLabel" aria-hidden="true"
		id="chooseModal">
		<div class="modal-dialog modal-lg" style="width: 800px;height: 550px">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
					</button>
					<h4 class="modal-title">选择待测API</h4>
				</div>
				<div class="modal-body">
					<table style="width: 700px;height: 500px" border="0px">
						<tr>
							<td>
								<table id="apiAttentions" border="1px" width="345px"
									height="100%">
									<tbody>
										<tr>
											<td>
												<div id="apiAttentionList" style="width:345px;height:500px;overflow:auto;">
													<ul class="nav nav-pills nav-stacked" ID="apiAttentionListUL">
														
													</ul>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
							<td>
								<table id="planApis" border="1px" width="350px"
									height="100%">
									<tbody>
										<tr>
											<td>
												<div id="apiPlanList" style="width:350px;height:500px;overflow:auto;">
													<ul class="nav nav-pills nav-stacked" id="apiPlanListUL">
													</ul>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
					</table>
				</div>

				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal" id="chooseBtn">Save</button>
				</div>

			</div>
		</div>
	</div>
</body>
</html>
