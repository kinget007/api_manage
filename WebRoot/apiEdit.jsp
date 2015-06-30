<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort();
    if(session.getAttribute("name")==null){response.sendRedirect("/api_manage/loginOauth");}
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


<!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
<!--[if lt IE 9]>
    <script src="common/js/html5shiv.js"></script>
  <![endif]-->

<!-- Fav and touch icons -->
<link rel="shortcut icon" href="common/img/apple-touch-icon-114-precomposed.png">
<link href="common/css/jsonFormater.css" type="text/css" rel="stylesheet">
<script type="text/javascript" src="common/js/jquery.min.js"></script>
<script type="text/javascript" src="common/js/bootstrap.min.js"></script>
<script type="text/javascript" src="common/js/jsonFormater.js"></script>
<script type="text/javascript" src="common/js/purl.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		var basePath = '<%=basePath%>';
	    var Request = new Object();
		Request = GetRequest();
		var result_ = Request["dealiInfo"];
		
		if(result_=="ok"){
			$('#successMessage').text("修改数据成功");
			$('#successModal').modal('show');
		}
		
		$("#successBtn").click(function() {
			window.location.href=basePath+"/api_manage/apiDetail.jsp?categorySecondID="+Request["categorySecondID"]+"&apiID="+Request["apiID"]; 			
		});		
	    
	   
		$("#urlPath").blur(function() {    		
	    	var urlInfo = $("#urlPath").val();
	    	if (urlInfo.indexOf("?")>0){
	    		var urlPath = urlInfo.substr(0,urlInfo.indexOf("?"));
				$("#urlPath").val(urlPath);
				}
	        });
		
		$("#menuActive").find("li").each(function() {
			$(this).removeClass("active");
		});
		$("#menuActive li:nth-child(1)").addClass("active");
	    });
	
		$.getJSON('<%=basePath%>'+"/api_manage/ApiManageInitServlet?result=apiEdit&apiID="+GetRequest()["apiID"],null,function(data) {
			for(var i=0;i<eval(data).length;i++){
				$("#categoryFirstID").val(data[i].categoryFirst.categoryFirstID);
				$("#categorySecondID").val(data[i].categorySecond.categorySecondID);
				$("#categoryFirstName").val(data[i].categoryFirst.categoryFirstName);
				$("#categorySecondName").val(data[i].categorySecond.categorySecondName);
				$("#apiID").val(GetRequest()["apiID"]);
				for(var j=0;i<1;j++){
					var paramInValueJsonparamIn = "";
					var tableparamIn = "";
					var tableparamOut = "";
					var tabletableInfo = "";
					
					var paramIn = data[i].apiInfo.apiInfo[j].paramIn.paramIn;
					var paramOut = data[i].apiInfo.apiInfo[j].paramOut.paramOut;
					var tableInfo = data[i].apiInfo.apiInfo[j].tableInfo.tableInfo;
					
					$("#paramInValue").val(JSON.stringify(data[i].apiInfo.apiInfo[j].paramIn));
					$("#paramOutValue").val(JSON.stringify(data[i].apiInfo.apiInfo[j].paramOut));
					$("#tableInfoValue").val(JSON.stringify(data[i].apiInfo.apiInfo[j].tableInfo));
										
					for(var k=0;k<eval(paramIn).length;k++){
						if(typeof(paramIn[k].paramDefault)=="object"){
							paramIn[k].paramDefault = JSON.stringify(paramIn[k].paramDefault);
						}
						paramInValueJsonparamIn = paramInValueJsonparamIn + "\""+paramIn[k].paramName+"\":\"" +paramIn[k].paramDefault+"\",";
						
						tableparamIn = tableparamIn +"<tr class=\"warning\">";
						if(paramIn[k].paramType.split("*")[1]=="1"){
							tableparamIn = tableparamIn + "<td><input type=\"checkbox\" checked=\"checked\"></td>";
						}
						else{
							tableparamIn = tableparamIn + "<td><input type=\"checkbox\"></td>";
						}						
						
						tableparamIn = tableparamIn + 
							"<td><input type=\"text\" class=\"form-control\" value="+paramIn[k].paramName+">"+"</td>"+
							"<td><input type=\"text\" class=\"form-control\" value="+paramIn[k].paramDescription+">"+"</td>";
						if(paramIn[k].paramType.split("*")[0]=="url"){
							tableparamIn = tableparamIn + "<td><select class=\"form-control\"><option selected=\"selected\">url</option><option>post</option></select>"+"</td>";
						}
						else{
							tableparamIn = tableparamIn + "<td><select class=\"form-control\"><option>url</option><option selected=\"selected\">post</option></select>"+"</td>";
						}
							
						tableparamIn = tableparamIn + "<td><input type=\"text\" class=\"form-control\" value="+paramIn[k].paramDefault+">"+"</td>";
							
						if(paramIn[k].isNeeded=="是"){
							tableparamIn = tableparamIn + "<td><select class=\"form-control\"><option selected=\"selected\">是</option><option>否</option></select>"+"</td></tr>";
						}
						else{
							tableparamIn = tableparamIn + "<td><select class=\"form-control\"><option>是</option><option selected=\"selected\">否</option></select>"+"</td></tr>";
						}
					}
					$("#paramInTb tbody").find("tr").each(function() {
							$(this).remove();
							});
					$("#paramInTb").append(tableparamIn.replace(/\"{/g, "{").replace(/\"\[/g, "\[").replace(/\]\"/g, "\]").replace(/}\"/g,"}"));
					$("#paramInValueJson").val("{"+paramInValueJsonparamIn.substring(0, paramInValueJsonparamIn.length-1).replace(/\"\[/g, "\[").replace(/\]\"/g, "\]").replace(/\"{/g, "{").replace(/}\"/g,"}")+"}");
					
					
					for(var k=0;k<eval(paramOut).length;k++){						
						tableparamOut = tableparamOut +
						"<tr class=\"warning\">"+
							"<td><input type=\"text\" class=\"form-control\" value="+paramOut[k].paramName+">"+"</td>"+
							"<td><input type=\"text\" class=\"form-control\" value="+paramOut[k].paramDescription+">"+"</td></tr>";						
					}
					$("#paramOutTb tbody").find("tr").each(function() {
							$(this).remove();
							});
					$("#paramOutTb").append(tableparamOut);
					
					
					for(var k=0;k<eval(tableInfo).length;k++){	
						tabletableInfo = tabletableInfo +
						"<tr class=\"warning\">"+
							"<td><input type=\"text\" class=\"form-control\" value="+tableInfo[k].datebaseName+">"+"</td>"+
							"<td><input type=\"text\" class=\"form-control\" value="+tableInfo[k].tableName+">"+"</td>"+
							"<td><input type=\"text\" class=\"form-control\" value="+tableInfo[k].ipAddress+">"+"</td>"+
						"</tr>";						
					}
					$("#tableInfoTb tbody").find("tr").each(function() {
							$(this).remove();
							});
					$("#tableInfoTb").append(tabletableInfo);
					
	
					
					var httpHeader = JSON.stringify(data[i].apiInfo.apiInfo[j].httpHeader);
					if (httpHeader=="{}"){$("#httpHeader").val("");}
					else {$("#httpHeader").val(httpHeader);}
					
					$("#cnName").val(data[i].apiInfo.apiInfo[j].cnName);
					$("#author").val(data[i].apiInfo.apiInfo[j].author);
					$("#editInfo").val(data[i].apiInfo.apiInfo[j].editInfo);
					$("#urlPath").val(data[i].apiInfo.apiInfo[j].urlPath);
					
					$("#httpMethod option[value='"+data[i].apiInfo.apiInfo[j].httpMethod+"']").removeAttr("selected");
					$("#httpMethod option[value='"+data[i].apiInfo.apiInfo[j].httpMethod+"']").attr("selected","selected");
					
					$("#isLogin option[value='"+data[i].apiInfo.apiInfo[j].isLogin+"']").removeAttr("selected");
					$("#isLogin option[value='"+data[i].apiInfo.apiInfo[j].isLogin+"']").attr("selected","selected");					
				}
			}
		});
		
	
	
	 function GetRequest(){
			var url = location.search; //获取url中"?"符后的字串
					var theRequest = new Object();
			if (url.indexOf("?") != -1) {
				var str = url.substr(1);
				strs = str.split("&");
				for(var i = 0; i < strs.length; i ++) {
					theRequest[strs[i].split("=")[0]]=(strs[i].split("=")[1]);
					}
				}
			return theRequest;
			}
	  
	function paramCheck() {
		var categoryFirstID =   $("#categoryFirstID").val();
		var categorySecondID =  $("#categorySecondID").val();
		var strRegex = "^((https|http|ftp|rtsp|mms)?://)"
				+ "?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?"
				+ "(([0-9]{1,3}\.){3}[0-9]{1,3}"
				+ "|"
				+ "([0-9a-z_!~*'()-]+\.)*"
				+ "([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\."
				+ "[a-z]{2,6})"
				+ "(:[0-9]{1,4})?"
				+ "((/?)|"
				+ "(/{[$][0-9a-zA-Z_-]+}{1}/?)|(/[0-9a-zA-Z_!~*'().;?:@&=+$,%#-]+)+/?)+$";
		var re = new RegExp(strRegex);
		var cnName = $("#cnName").val();
		var author = $("#author").val();
		var editInfo = $("#editInfo").val();
		var urlPath = $("#urlPath").val();
		var httpHeader = $("#httpHeader").val();
		var paramIn = $("#paramInValue").val();
		var paramOut = $("#paramOutValue").val();
		var tableInfo = $("#tableInfoValue").val();
		var resultInfo = $("#showResult").val();
	
		if (categoryFirstID == "0") {
			$('#alertMessage').text("所属部门 不能为空");
			$('#alertModal').modal('show');								
			$("#cnName").focus();
			return false;
		}
		if (categorySecondID == "0") {
			$('#alertMessage').text("所属分类 不能为空");
			$('#alertModal').modal('show');								
			$("#cnName").focus();
			return false;
		}
		if (cnName == 0 || cnName == "") {
			$('#alertMessage').text("接口名称 不能为空");
			$('#alertModal').modal('show');								
			$("#cnName").focus();
			return false;
		}
		if (author == 0 || author == "") {
			$('#alertMessage').text("开发人员 不能为空");
			$('#alertModal').modal('show');
			return false;
		}
		if (editInfo == 0 || editInfo == "") {
			$('#alertMessage').text("描述信息 不能为空");
			$('#alertModal').modal('show');
			return false;
		}
		if (urlPath == 0 || urlPath == "") {
			$('#alertMessage').text("URL地址 不能为空");
			$('#alertModal').modal('show');
			return false;
		}
		if (!re.test(urlPath)) {
			$('#alertMessage').text("URL地址 格式错误");
			$('#alertModal').modal('show');
			return false;
		}
		if (httpHeader != 0 || httpHeader != "") {
			try {
				$.parseJSON(httpHeader);
			} catch (err) {
				$('#alertMessage').text("HTTP头  JSON 格式错误\n" + err);
				$('#alertModal').modal('show');
				return false;
			}
		}
		if (paramIn != 0 || paramIn != "") {
			try {
				$.parseJSON(paramIn);
			} catch (err) {
				$('#alertMessage').text("请求参数  JSON 格式错误\n" + err);
				$('#alertModal').modal('show');
				return false;
			}
		}
		if (paramOut != 0 || paramOut != "") {
			try {
				$.parseJSON(paramOut);
			} catch (err) {
				$('#alertMessage').text("返回字段  JSON 格式错误\n" + err);
				$('#alertModal').modal('show');
				return false;
			}
		}
		if (tableInfo != 0 || tableInfo != "") {
			try {
				$.parseJSON(tableInfo);
			} catch (err) {
				$('#alertMessage').text("数据表  JSON 格式错误\n" + err);
				$('#alertModal').modal('show');
				return false;
			}
		}	
		if (resultInfo == 0 || resultInfo == "") {
			$('#alertMessage').text("返回结果 不能为空");
			$('#alertModal').modal('show');
			return false;
		}
	}
	 
	    
	$(function() {
		var basePath = '<%=basePath%>';
		$("#paramOutAdd")
				.click(
						function() {
							var tr = '<tr class="warning"><td><input type="text" class="form-control"></td><td><input type="text" class="form-control"></td></tr>';
							$("#paramOutTb").append(tr);
						});
		$("#paramInAdd")
				.click(
						function() {
							var tr = '<tr class="warning"><td><input type=\"checkbox\"></td><td><input type="text" class="form-control"></td><td><input type="text" class="form-control"></td><td><select class="form-control"><option>url</option><option>post</option></select></td><td><input type="text" class="form-control"></td><td><select class="form-control"><option>否</option><option>是</option></select></td></tr>';
							$("#paramInTb").append(tr);
						});
		$("#tableInfoAdd")
				.click(
						function() {
							var tr = '<tr class="warning"><td><input type="text" class="form-control"></td><td><input type="text" class="form-control"></td><td><input type="text" class="form-control"></td></tr>';
							$("#tableInfoTb").append(tr);
						});
		$("#paramOutDel").click(function() {
			$("#paramOutTb tbody tr:last-child").remove();
		});
		$("#paramInDel").click(function() {
			$("#paramInTb tbody tr:last-child").remove();
		});
		$("#tableInfoDel").click(function() {
			$("#tableInfoTb tbody tr:last-child").remove();
		});
		$("#paramInEnsure").click(function(){
			var t_data = "";  
            $("#paramInTb").find("tbody tr").each(function(i) {
            	var checkBoxStatus = 0;
            	if($("#paramInTb").find("tbody tr:eq(" + i + ")").find("td:eq(0) input[type='checkbox']").prop("checked")==true){checkBoxStatus=1;}
            	t_data = t_data + "{\"paramName\":\"" + $("#paramInTb").find("tbody tr:eq(" + i + ")").find("td:eq(1) input[type='text']").val()+"\","
            		+"\"paramDescription\":\"" + $("#paramInTb").find("tbody tr:eq(" + i + ")").find("td:eq(2) input[type='text']").val()+"\","
            		+"\"paramType\":\"" + $("#paramInTb").find("tbody tr:eq(" + i + ")").find("td:eq(3) select").val()+"*"+checkBoxStatus+"\","
            		+"\"paramDefault\":\"" + $("#paramInTb").find("tbody tr:eq(" + i + ")").find("td:eq(4) input[type='text']").val()+"\","
            		+"\"isNeeded\":\"" + $("#paramInTb").find("tbody tr:eq(" + i + ")").find("td:eq(5) select").val()+"\"},"
            		;           	                 
            }); 
            t_data = "{\"paramIn\": [" + t_data.substr(0,t_data.length-1) +"]}";
            $("#paramInValue").val(t_data);
            $("#paramInBody").collapse('hide');
            var jsonBody = "";  
            $("#paramInTb").find("tbody tr").each(function(i) {
            	if($("#paramInTb").find("tbody tr:eq(" + i + ")").find("td:eq(0) input[type='checkbox']").prop("checked")==true){
            		jsonBody = jsonBody + "\"" + $("#paramInTb").find("tbody tr:eq(" + i + ")").find("td:eq(1) input[type='text']").val()+"\":\""
            		+ $("#paramInTb").find("tbody tr:eq(" + i + ")").find("td:eq(4) input[type='text']").val()+"\","
            		;
            	}           	           	                 
            });
            jsonBody = "{"+jsonBody.substring(0, jsonBody.length-1)+"}";
         $("#paramInValueJson").val(jsonBody);
		});
		$("#paramOutEnsure").click(function(){
			var t_data = "";  
            $("#paramOutTb").find("tbody tr").each(function(i) {
            	t_data = t_data + "{\"paramName\":\"" + $("#paramOutTb").find("tbody tr:eq(" + i + ")").find("td:eq(0) input[type='text']").val()+"\","
            		+"\"paramDescription\":\"" + $("#paramOutTb").find("tbody tr:eq(" + i + ")").find("td:eq(1) input[type='text']").val()+"\"},"
            		;                 
            }); 
            t_data = "{\"paramOut\": [" + t_data.substr(0,t_data.length-1) +"]}";
            $('#paramOutValue').val(t_data);
            $('#paramOutBody').collapse('hide');
		});
		$("#tableInfoEnsure").click(function(){
			var t_data = "";  
            $("#tableInfoTb").find("tbody tr").each(function(i) {
            	t_data = t_data + "{\"datebaseName\":\"" + $("#tableInfoTb").find("tbody tr:eq(" + i + ")").find("td:eq(0) input[type='text']").val()+"\","
            		+"\"tableName\":\"" + $("#tableInfoTb").find("tbody tr:eq(" + i + ")").find("td:eq(1) input[type='text']").val()+"\","
            		+"\"ipAddress\":\"" + $("#tableInfoTb").find("tbody tr:eq(" + i + ")").find("td:eq(2) input[type='text']").val()+"\"},"
            		;                
            }); 
            t_data = "{\"tableInfo\": [" + t_data.substr(0,t_data.length-1) +"]}";
            $("#tableInfoValue").val(t_data);
            $("#tableInfoBody").collapse('hide');
		});
		
		$("#reslutBtn").click(function() {
			try {
				$.parseJSON($("#showResult").val());
				} catch (err) {
			$("#resultModal").modal('hide');
			$("#alertMessage").text("返回结果有误\n");
			$("#alertModal").modal('show');
			$("#showResult").val("{}");
				return false;
			}
		});
		
		$("#showResult").focus(function() { 
			$("#showResult").attr('disabled',"true");
			$("#showResult").val("api请求中，请稍等...");
			 var jsonBody = "";  
	            $("#paramInTb").find("tbody tr").each(function(i) {
	            	if($("#paramInTb").find("tbody tr:eq(" + i + ")").find("td:eq(0) input[type='checkbox']").prop("checked")==true){
	            		jsonBody = jsonBody + "\"" + $("#paramInTb").find("tbody tr:eq(" + i + ")").find("td:eq(1) input[type='text']").val()+"*" +
                        $("#paramInTb").find("tbody tr:eq(" + i + ")").find("td:eq(3) select").val()+"\":"+"\"" +
                        $("#paramInTb").find("tbody tr:eq(" + i + ")").find("td:eq(4) input[type='text']").val()+"\",";        
	            	}	            	   	                 
	            }); 
	            jsonBody = "{" + jsonBody.substr(0,jsonBody.length-1) +"}";
	            jsonBody = jsonBody.replace(/\"{/g, "{").replace(/\"\[/g, "\[").replace(/\]\"/g, "\]").replace(/}\"/g,"}");
	         $("#paramInValueJson").val(jsonBody);
	            
			 var headIn = $("#httpHeader").val();
			 var urlMethod = $("#httpMethod").val();
			 var urlPath = $("#urlPath").val();
			var strRegex = "^((https|http|ftp|rtsp|mms)?://)"
					+ "?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?"
					+ "(([0-9]{1,3}\.){3}[0-9]{1,3}"
					+ "|"
					+ "([0-9a-z_!~*'()-]+\.)*"
					+ "([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\."
					+ "[a-z]{2,6})"
					+ "(:[0-9]{1,4})?"
					+ "((/?)|"
					+ "(/{[$][0-9a-zA-Z_-]+}{1}/?)|(/[0-9a-zA-Z_!~*'().;?:@&=+$,%#-]+)+/?)+$";
			var re = new RegExp(strRegex);
			if (!re.test(urlPath)) {
				$('#alertMessage').text("URL地址 格式错误");
				$('#alertModal').modal('show');
				return false;
			}
			 if (urlPath == 0 || urlPath == "") {
					$('#alertMessage').text("URL地址 不能为空");
					$('#alertModal').modal('show');
					return false;
				}
			 
			 $.getJSON(basePath+"/api_manage/ApiToolsServlet?URLPath="+encodeURIComponent(urlPath)+"&jsonBody="+encodeURIComponent(jsonBody)+"&headIn="+encodeURIComponent(headIn)+"&urlMethod="+urlMethod,null,function(data) {  
					var resultInfo = JSON.stringify(data.result);
				    $('#resultInfo').val(resultInfo);
					if (resultInfo==0 || resultInfo==""){
					   resultInfo="{}";
					}	
					$("#showResult").val(resultInfo);
					 var options = {
				        dom : '#jsonFormate'
				    };
				    var jf = new JsonFormater(options);
				    jf.doFormat(resultInfo);
				    $('#resultModal').modal('show');
				    $("#showResult").attr('disabled',false);
				});			 
		});
	});
</script>
</head>
<body>
	<form method="post" onsubmit="return paramCheck();" action="/api_manage/EditapiInfoServlet">
	<input type="text" class="form-control" placeholder="接口名称 " id="categoryFirstID" name="categoryFirstID"  style="display: none;">
	<input type="text" class="form-control" placeholder="接口名称 " id="categorySecondID" name="categorySecondID"  style="display: none;">
	<input type="text" class="form-control" placeholder="接口名称 " id="apiID" name="apiID" style="display: none;">
		<div class="container">
			<%@include file="header.jsp"%>
			<h2></h2>
			<div class="row clearfix">
				<div class="col-md-12 column">
					<div class="panel panel-default">
						<div class="panel-heading">
							<table>
								<tr>
									<td><h3 class="panel-title">API参数</h3></td>
								</tr>
							</table>
						</div>
						<div class="panel-body">
							<div class="row clearfix">
								<div class="col-md-6 column">
									<table class="table">
										<tbody>
											<tr>
												<td>
													<div class="input-group">
														<span class="input-group-addon">所属部门</span>
														<input type="text" class="form-control" placeholder="接口名称 " id="categoryFirstName" name="categoryFirstName"  readonly="readonly">
													</div>
												</td>
											</tr>
											<tr>
												<td>
													<div class="input-group">
														<span class="input-group-addon">请求方法</span> <select
															class="form-control" id="httpMethod" name="httpMethod">	
															<option value="get">get</option>														
															<option value="post">post</option>
														</select>
													</div>
												</td>
											</tr>
											<tr>
												<td>
													<div class="input-group">
														<span class="input-group-addon">接口名称</span> <input
															type="text" class="form-control" placeholder="接口名称 "
															id="cnName" name="cnName">
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<div class="col-md-6 column">
									<table class="table">
										<tbody>
											<tr>
												<td>
													<div class="input-group">
														<span class="input-group-addon">所属分类</span>
														<input type="text" class="form-control" placeholder="接口名称 " id="categorySecondName" name="categorySecondName"  readonly="readonly">
													</div>
												</td>
											</tr>
											<tr>
												<td>
													<div class="input-group">
														<span class="input-group-addon">是否登录</span> <select
															class="form-control" id="isLogin" name="isLogin">
															<option value="1">是</option>
															<option value="0">否</option>
														</select>
													</div>
												</td>
											</tr>
											<tr>
												<td>
													<div class="input-group">
														<span class="input-group-addon">开发人员</span> <input
															type="text" class="form-control" placeholder="负责开发该接口的人员"
															id="author" name="author">
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="row clearfix">
								<div class="col-md-12 column">
									<table class="table">
										<tbody>
											<tr>
												<td>
													<div class="input-group">
														<span class="input-group-addon">描述信息</span> <input
															type="text" class="form-control"
															placeholder="安居客8.2 添加参数xxxxxx" id="editInfo"
															name="editInfo">
													</div>
												</td>
											</tr>
											<tr>
												<td>
													<div class="input-group">
														<span class="input-group-addon">URL地址</span> <input
															type="text" class="form-control"
															placeholder="http://api.anjuke.com/path?param1=value1&param2=value2"
															id="urlPath" name="urlPath" readonly="readonly">
													</div>
												</td>
											</tr>
											<tr>
												<td>
													<div class="input-group">
														<span class="input-group-addon">HTTP 头</span> <input
															type="text" class="form-control"
															placeholder='{"AuthToken":"value1","param2":"value2","param3":"value3"}'
															id="httpHeader" name="httpHeader">
													</div>
												</td>
											</tr>
											<tr>
												<td>
													<div class="panel-group" id="paramIn" role="tablist" aria-multiselectable="true">
														<div class="panel panel-default" style="border: 0px">
															<div class="" role="tab" id="headingparamIn">
																<a class="collapsed" data-toggle="collapse" data-parent="#paramIn" href="#paramInBody" aria-expanded="false" aria-controls="paramInBody">
																	<div class="input-group">
																		<span class="input-group-addon">请求参数</span> 
																		<input type="text"  class="form-control" placeholder='{"paramIn": [{"paramName":"value1","paramDescription":"value2","paramType":"value3","paramDefault":"value4","isNeeded":"value5"},{}]}' id="paramInValue" name="paramInValue" readonly="readonly">
																	</div>
																</a>
															</div>
															<div id="paramInBody" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingparamIn">
																<div class="panel-body">
																	<table class="table" width="100%">
																		<tbody>
																			<tr class="active">
																				<td width="30%">
																					<button type="button" id="paramInAdd"
																						class="btn btn-xs btn-info">添加一行参数</button>
																					<button type="button" id="paramInDel"
																						class="btn btn-xs btn-info">删除最后一行</button>
																					<button type="button" id="paramInEnsure"
																						class="btn btn-xs btn-info">参数确认</button>
																				</td>
																				<td width="70%" align="right">
																					<input type="text" class="form-control" id="paramInValueJson" name="paramInValueJson" style="display: none;"> 
																				</td>
																			</tr>
																			<tr class="active">
																				<td  colspan="2">
																					<table class="table table-bordered" id="paramInTb"
																						bgcolor="#00FF00"  width="100%">
																						<thead>
																							<tr class="success">
																								<th align="justify">																									
																								</th>
																								<th align="justify">
																									<h4>
																										<span class="label label-primary">参数名(EN)</span>
																									</h4>
																								</th>
																								<th align="justify">
																									<h4>
																										<span class="label label-primary">参数描述</span>
																									</h4>
																								</th>
																								<th align="justify">
																									<h4>
																										<span class="label label-primary">参数类型</span>
																									</h4>
																								</th>
																								<th align="justify">
																									<h4>
																										<span class="label label-primary">参数默认值</span>
																									</h4>
																								</th>
																								<th align="justify">
																									<h4>
																										<span class="label label-primary">是否必须</span>
																									</h4>
																								</th>
																							</tr>
																						</thead>
																						<tbody>
																							<tr class="warning">
																								<td><input type="checkbox"></td>
																								<td><input type="text" class="form-control"></td>
																								<td><input type="text" class="form-control"></td>
																								<td><input type="text" class="form-control"></td>
																								<td><input type="text" class="form-control"></td>
																								<td><select class="form-control"><option>是</option>
																										<option>否</option></select></td>
																							</tr>
																						</tbody>
																					</table>
																				</td>
																			</tr>
																		</tbody>

																	</table>
																</div>
															</div>
														</div>
													</div>
												</td>
											</tr>
											<tr>
												<td>
													<div class="panel-group" id="paramOut" role="tablist"
														aria-multiselectable="true">
														<div class="panel panel-default" style="border: 0px">
															<div class="" role="tab" id="headingparamOut">
																<a class="collapsed" data-toggle="collapse"
																	data-parent="#paramOut" href="#paramOutBody"
																	aria-expanded="false" aria-controls="paramOutBody">
																	<div class="input-group">
																		<span class="input-group-addon">返回字段</span> <input
																			type="text" class="form-control"
																			placeholder='{"paramOut": [{"paramName":"value1","paramDescription":"value2"},{}]}'
																			id="paramOutValue" name="paramOutValue" readonly="readonly">
																	</div>
																</a>
															</div>
															<div id="paramOutBody" class="panel-collapse collapse"
																role="tabpanel" aria-labelledby="headingparamOut">
																<!--<div class="panel-body">-->
																<div class="panel-body">
																	<table class="table" width="100%">
																		<tbody>
																			<tr class="active">
																				<td>
																					<button type="button" id="paramOutAdd"
																						class="btn btn-xs btn-info">添加一行参数</button>
																					<button type="button" id="paramOutDel"
																						class="btn btn-xs btn-info">删除最后一行</button>
																					<button type="button" id="paramOutEnsure"
																						class="btn btn-xs btn-info">参数确认</button>
																				</td>
																			</tr>
																			<tr class="active">
																				<td>
																					<table class="table table-bordered" id="paramOutTb">
																						<thead>
																							<tr class="success">
																								<th>
																									<h4>
																										<span class="label label-info">参数名(EN)</span>
																									</h4>
																								</th>
																								<th>
																									<h4>
																										<span class="label label-primary">参数描述</span>
																									</h4>
																								</th>
																							</tr>
																						</thead>
																						<tbody>
																							<tr class="warning">
																								<td><input type="text" class="form-control"></td>
																								<td><input type="text" class="form-control"></td>
																							</tr>
																						</tbody>
																					</table>
																				</td>
																			</tr>
																		</tbody>

																	</table>
																</div>
															</div>
														</div>
													</div>
												</td>
											</tr>
											<tr>
												<td>
													<div class="panel-group" id="tableInfo" role="tablist"
														aria-multiselectable="true">
														<div class="panel panel-default" style="border: 0px">
															<div class="" role="tab" id="headingtableInfo">
																<a class="collapsed" data-toggle="collapse"
																	data-parent="#tableInfo" href="#tableInfoBody"
																	aria-expanded="false" aria-controls="tableInfoBody">
																	<div class="input-group">
																		<span class="input-group-addon">数据库表</span> <input
																			type="text" class="form-control"
																			placeholder='{"tableInfo": [{"datebaseName":"value1","tableName":"value2","ipAddress":"value3"},{}]}'
																			id="tableInfoValue" name="tableInfoValue" readonly="readonly">
																	</div>
																</a>
															</div>
															<div id="tableInfoBody" class="panel-collapse collapse"
																role="tabpanel" aria-labelledby="headingtableInfo">
																<!--<div class="panel-body">-->
																<div class="panel-body">
																	<table class="table">
																		<tbody>
																			<tr class="active">
																				<td>
																					<button type="button" id="tableInfoAdd"
																						class="btn btn-xs btn-info">添加一行参数</button>
																					<button type="button" id="tableInfoDel"
																						class="btn btn-xs btn-info">删除最后一行</button>
																					<button type="button" id="tableInfoEnsure"
																						class="btn btn-xs btn-info">参数确认</button>
																				</td>
																			</tr>
																			<tr class="active">
																				<td>
																					<table class="table table-bordered"
																						id="tableInfoTb">
																						<thead>
																							<tr class="success">
																								<th>
																									<h4>
																										<span class="label label-info">数据库名</span>
																									</h4>
																								</th>
																								<th>
																									<h4>
																										<span class="label label-primary">数据表</span>
																									</h4>
																								</th>
																								<th>
																									<h4>
																										<span class="label label-primary">地址</span>
																									</h4>
																								</th>
																							</tr>
																						</thead>
																						<tbody>
																							<tr class="warning">
																								<td><input type="text" class="form-control"></td>
																								<td><input type="text" class="form-control"></td>
																								<td><input type="text" class="form-control"></td>
																							</tr>
																						</tbody>
																					</table>

																				</td>
																			</tr>
																		</tbody>

																	</table>
																</div>
															</div>
														</div>
													</div>
												</td>
											</tr>
											<tr>
												<td>
													<div class="input-group">
														<span class="input-group-addon">返回结果</span> 
														<input type="text" class="form-control" placeholder='点击查看返回结果  ' readonly="readonly" id="showResult" name="showResult">
													</div>
												</td>
											</tr>
											<tr>
												<td>
													<button type="submit" class="btn btn-Success" id="submitbtn">Submit</button>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
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
		
		<!-- Modal reslut-->
		<div class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true"  id="resultModal">
			<div class="modal-dialog modal-sm">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">提示信息</h4>						
					</div>
					<div class="modal-body">
						<table  style="overflow:auto;" border="0px" width="100%">
							<tr>
								<td id="reslutMessage">
									<div id="jsonFormate" style="height:275px; overflow-y:auto; border:0px solid;"></div>
								</td>
							</tr>
						</table>
					</div>
					  
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal" id="reslutBtn" name="reslutBtn">Close</button>
					</div>
					
				</div>
			</div>
		</div>
		

		<!-- Modal -->
		<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
			aria-labelledby="myModalLabel" aria-hidden="true"
			data-backdrop="static">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title" id="myModalLabel">参数确认</h4>
						<button type="button" id="paramData" class="btn btn-xs btn-info">+</button>
					</div>
					<div class="modal-body">
						<table class="table table-bordered" id="appendTr" style="overflow:auto;">
							<tr class="active">
								<td>Anjuke</td>
								<td>Broker</td>
							</tr>
						</table>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
						<button type="button" class="btn btn-primary">Save
							changes</button>
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>


