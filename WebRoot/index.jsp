<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort();
    //if(session.getAttribute("name")==null){response.sendRedirect("/api_manage/loginOauth");}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="utf-8">
<title>API_HOME</title>
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
	    // do stuff when DOM is ready
	    var basePath = '<%=basePath%>';
		$.getJSON(basePath+"/api_manage/ApiManageInitServlet?result=categorys",null,function(data) {
			for(var i=0;i<eval(data).length;i++){
				var categorySecond = new Array();
				categorySecond = data[i].categorySecond.split("|");	
				if(i==0){
					$("#leftMenue").append(
							"<div class=\"panel panel-default\">"+
								"<div class=\"panel-heading\" role=\"tab\">"+
									"<a class=\"panel-title\" data-toggle=\"collapse\" data-parent=\"#leftMenue\" href=\"#panel-element-"+i+"\" >"+data[i].categoryFirstName+"</a>"+
								"</div>"+
								"<div id=\"panel-element-"+i+"\" class=\"collapse in\" role=\"tabpanel\">"+
									"<div class=\"panel-body\" id=\"apiListone"+i+"\"  style=\"height:480px;overflow:auto;\" >"+//
										"<ul class=\"nav nav-pills nav-stacked\" id=\"apiListonechild"+i+"\">");
				}
				else{
					$("#leftMenue").append(
							"<div class=\"panel panel-default\">"+
								"<div class=\"panel-heading\" role=\"tab\">"+
									"<a class=\"panel-title\" data-toggle=\"collapse\" data-parent=\"#leftMenue\" href=\"#panel-element-"+i+"\" >"+data[i].categoryFirstName+"</a>"+
								"</div>"+
								"<div id=\"panel-element-"+i+"\" class=\"collapse\" role=\"tabpanel\">"+
									"<div class=\"panel-body\" id=\"apiListone"+i+"\"  style=\"height:480px;overflow:auto;\" >"+//
										"<ul class=\"nav nav-pills nav-stacked\" id=\"apiListonechild"+i+"\">");
				}
								
				for(var j=1;j<categorySecond.length;j++){
                    $("#apiListonechild"+i).append("<li value=\""+categorySecond[j].split("*")[0]+"\"><a href=\"#\">"+categorySecond[j].split("*")[1]+"</a></li>");
                } 
				$("#leftMenue").append(									
									"</ul>"+
								"</div>"+
							"</div>"+
						"</div>"
				);
			}
		});
		$.getJSON(basePath+"/api_manage/ApiManageInitServlet?result=categoryFirst_apiInfo&categorySecondID=1",null,function(data) {  
			for(var i=0;i<eval(data).length;i++){
				var apiInfo = new Array();
				apiInfo = data[i].apiInfo;
				var tableTr = "";
				for(var j=0;j<eval(apiInfo).length;j++){
					if((j+1)%3==0){
						tableTr = tableTr +
						"<tr class=\"warning\">"+
							"<td  colspan=\"1\">"+(j+1)+"</td>"+
							"<td  colspan=\"6\"><a href=\"/api_manage/apiDetail.jsp?categorySecondID=1&apiID="+apiInfo[j].apiID+"\" title=\""+apiInfo[j].urlPath+"\">"+apiInfo[j].urlPath+"</a></td>"+
							"<td  colspan=\"5\">"+apiInfo[j].cnName+"</td>"+
							"<td  colspan=\"2\">"+apiInfo[j].httpMethod+"</td>"+
							"<td  colspan=\"2\">"+apiInfo[j].author+"</td>"+
							"<tr>";
					}
					else if((j+1)%3==1){
						tableTr = tableTr +
						"<tr class=\"success\">"+
						"<td  colspan=\"1\">"+(j+1)+"</td>"+
						"<td  colspan=\"6\"><a href=\"/api_manage/apiDetail.jsp?categorySecondID=1&apiID="+apiInfo[j].apiID+"\" title=\""+apiInfo[j].urlPath+"\">"+apiInfo[j].urlPath+"</a></td>"+
						"<td  colspan=\"5\">"+apiInfo[j].cnName+"</td>"+
						"<td  colspan=\"2\">"+apiInfo[j].httpMethod+"</td>"+
						"<td  colspan=\"2\">"+apiInfo[j].author+"</td>"+
							"<tr>";
					}
					else{
						tableTr = tableTr +
						"<tr class=\"danger\">"+
						"<td  colspan=\"1\">"+(j+1)+"</td>"+
						"<td  colspan=\"6\"><a href=\"/api_manage/apiDetail.jsp?categorySecondID=1&apiID="+apiInfo[j].apiID+"\" title=\""+apiInfo[j].urlPath+"\">"+apiInfo[j].urlPath+"</a></td>"+
						"<td  colspan=\"5\">"+apiInfo[j].cnName+"</td>"+
						"<td  colspan=\"2\">"+apiInfo[j].httpMethod+"</td>"+
						"<td  colspan=\"2\">"+apiInfo[j].author+"</td>"+
							"<tr>";
					}
							
				}
				$("#mainContent").append(
						"<h2>"+data[i].categorySecondName+"</h2>"+
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
			}
		});
		
		$.getJSON(basePath+"/api_manage/ApiManageInitServlet?result=searchAll",null,function(dataAll) {
			var data = dataAll;
	        $("#q").typeahead({
	            minLength: 1,
	            order: "asc",
	            group: true,
	            groupMaxItem: 5,
	            hint: true,
	            filter: "所有",
	            selector: {
	                filter: "input-group-btn",
	                filterButton: "btn btn-default",
	                dropdown: "dropdown-menu dropdown-menu-right",
	                list: "dropdown-menu",
	                hint: "form-control"
	            },
	            source: {
	            	"安居客": {
	                    data: data.anjuke
	                },
	                "经纪人": {
	                    data: data.broker
	                },
	                "开发商": {
	                    data: data.developers
	                }
	            },
                callback: {
                    onClick: function (node, a, obj, e,val) {
                    	 window.location.href="/api_manage/apiDetail.jsp?categorySecondID="+obj.id.split("*")[0]+"&apiID="+obj.id.split("*")[1];             
                    }
                },
	            debug: true
	        });
		});  
		
		
		
		
	    });
	
	$(function() {
		$("#leftMenue").delegate('li', 'click',function() {
			var basePath = '<%=basePath%>';
			$("#leftMenue").find("li").each(function() {
				$(this).removeClass("active");
			});
			$(this).addClass("active");
			var categorySecondID = $(this).val();
			$("#mainContent").find("table").each(function() {
				$(this).remove();
			});
			$("#mainContent").find("h2").each(function() {
				$(this).remove();
			});
			$.getJSON(basePath+"/api_manage/ApiManageInitServlet?result=categoryFirst_apiInfo&categorySecondID="+categorySecondID,null,function(data) {  
				for(var i=0;i<eval(data).length;i++){
					var apiInfo = new Array();
					apiInfo = data[i].apiInfo;
					var tableTr = "";
					for(var j=0;j<eval(apiInfo).length;j++){
						if((j+1)%3==0){
							tableTr = tableTr +
							"<tr class=\"warning\">"+
								"<td colspan=\"1\">"+(j+1)+"</td>"+
								"<td colspan=\"6\"><a href=\"/api_manage/apiDetail.jsp?categorySecondID="+categorySecondID+"&apiID="+apiInfo[j].apiID+"\" title=\""+apiInfo[j].urlPath+"\">"+apiInfo[j].urlPath +"</a></td>"+
								"<td colspan=\"5\">"+apiInfo[j].cnName+"</td>"+
								"<td colspan=\"2\">"+apiInfo[j].httpMethod+"</td>"+
								"<td colspan=\"2\">"+apiInfo[j].author+"</td>"+
							"<tr>";
						}
						else if((j+1)%3==1){
							tableTr = tableTr +
							"<tr class=\"success\">"+
								"<td colspan=\"1\">"+(j+1)+"</td>"+
								"<td colspan=\"6\"><a href=\"/api_manage/apiDetail.jsp?categorySecondID="+categorySecondID+"&apiID="+apiInfo[j].apiID+"\" title=\""+apiInfo[j].urlPath+"\">"+apiInfo[j].urlPath +"</a></td>"+
								"<td colspan=\"5\">"+apiInfo[j].cnName+"</td>"+
								"<td colspan=\"2\">"+apiInfo[j].httpMethod+"</td>"+
								"<td colspan=\"2\">"+apiInfo[j].author+"</td>"+
							"<tr>";
						}
						else{
							tableTr = tableTr +
							"<tr class=\"danger\">"+
								"<td colspan=\"1\">"+(j+1)+"</td>"+
								"<td colspan=\"6\"><a href=\"/api_manage/apiDetail.jsp?categorySecondID="+categorySecondID+"&apiID="+apiInfo[j].apiID+"\" title=\""+apiInfo[j].urlPath+"\">"+apiInfo[j].urlPath +"</a></td>"+
								"<td colspan=\"5\">"+apiInfo[j].cnName+"</td>"+
								"<td colspan=\"2\">"+apiInfo[j].httpMethod+"</td>"+
								"<td colspan=\"2\">"+apiInfo[j].author+"</td>"+
							"<tr>";
						}
								
					}
					$("#mainContent").append(
							"<h2>"+data[i].categorySecondName+"</h2>"+
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
				}
			});
		});
	});	
</script>
</head>

<body>
	<div class="container" id="container">
		<%@include file="header.jsp"%>
		<h2></h2>		
		<div class="row clearfix">
			<div class="col-md-3 column"></div>
			<div class="col-md-8 column">
				<div class="typeahead-container">
					<div class="input-group">
						<span class="typeahead-query"> <input id="q" name="q" class="form-control" type="search" placeholder="Search" autocomplete="off"></span> 
						<span class="input-group-btn">
						<button type="submit" class="btn btn-default">
						<span class="glyphicon glyphicon-search" style="height: 20px;"></span></button>
						</span>
					</div>
				</div>	
			</div>	
			<div class="col-md-1 column">			
				<div>
					<table width="100%">
						<tbody>
							<tr>
								<td align="right">
									<a href='/api_manage/apiAdd.jsp' ><button type="button" class="btn btn-Success">新增API</button></a>
								</td>
							</tr>
						</tbody>
					</table>
				</div>					
			</div>

			<div class="col-md-3 column"><div class="panel-group" id="leftMenue" role="tablist" aria-multiselectable="true"></div></div>

			<div class="col-md-9 column">
							
				<div id="mainContent"></div>
			</div>
		</div>
		
		<div class="row clearfix">
			<div class="col-md-12 column">
			<%@include file="footer.jsp"%>
			</div>
		</div>
	</div>
	
	
	<!-- Modal alert-->
		<div class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true"  id="alertModal">
			<div class="modal-dialog modal-sm">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title" id="myModalLabel">提示信息</h4>						
					</div>
					<div class="modal-body">
						<table  style="overflow:auto;" border="0px">
							<tr>
								<td id="alertMessage"></td>
							</tr>
						</table>
					</div>
					  
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
						<!--
						<button type="button" class="btn btn-primary">Save changes</button>
						-->
					</div>
					
				</div>
			</div>
		</div>
</body>
</html>
