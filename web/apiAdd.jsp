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

<!-- Fav and touch icons-->
<link rel="shortcut icon" href="common/img/apple-touch-icon-114-precomposed.png">

<link href="common/css/jsonFormater.css" type="text/css" rel="stylesheet">

<script type="text/javascript" src="common/js/jquery.min.js"></script>
<script type="text/javascript" src="common/js/bootstrap.min.js"></script>
<script type="text/javascript" src="common/js/jsonFormater.js"></script>
<script type="text/javascript" src="common/js/purl.js"></script>
<script type="text/javascript" src="common/google-code-prettify/prettify.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		var basePath = '<%=basePath%>';
	    var Request = new Object();
		Request = GetRequest();
		var result_ = Request["dealiInfo"];
		if(result_=="ok"){
			$('#successMessage').text("录入数据成功");
			$('#successModal').modal('show');
		}
		if(result_=="duplicate"){
			$('#duplicateMessage').text("录入数据重复");
			$('#duplicateModal').modal('show');
		}
		
		$("#duplicateBtn").click(function() {
			window.history.back(); 			
		});
		
		$("#successBtn").click(function() {
			window.location.href=basePath+"/api_manage/apiAdd.jsp"; 			
		});
	    
	    function GetRequest(){
			var url = location.search;
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
		
	    var categorySecondArray = new Array();
		$.getJSON(basePath+"/api_manage/ApiManageInitServlet?result=categorys",null,function(data) {   
			for(var i=0;i<eval(data).length;i++){
				$("#categoryFirstID").append("<option value='"+data[i].categoryFirstID+"'>"+data[i].categoryFirstName+"</option>");
				categorySecondArray[i] = new Array(data[i].categorySecond.split("|")[0],data[i].categorySecond);
			}
		});
		
		$("#categoryFirstID").change(function(){  
	        try{  
	            var pro=$(this).val();  
	            var i,j,tmpcity=new Array();  
	            for(i=0;i<categorySecondArray.length;i++){ 	            	
	                if(pro.toString().replace(/[ ]/g,"")==categorySecondArray[i][0].toString().replace(/[ ]/g,"")){ 	                	 
	                    tmpcity=categorySecondArray[i][1].split("|");  
	                    $("#categorySecondID").html("");  
	                    for(j=1;j<tmpcity.length;j++){
	                        $("#categorySecondID").append("<option value='"+tmpcity[j].split("*")[0]+"'>"+tmpcity[j].split("*")[1]+"</option>");
	                    }  
	                }  
	            }  
	        }catch(e){  
	            alert(e);     
	        }  
	    });	
		$("#menuActive").find("li").each(function() {
			$(this).removeClass("active");
		});
		$("#menuActive li:nth-child(1)").addClass("active");
	    });
	  
	function paramCheck() {
		var categoryFirstID =   $("#categoryFirstID").val();
		var categorySecondID =  $("#categorySecondID").val();
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
		var count = 0;
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
			count--;
			$("#paramInTb tbody tr:last-child").remove();
		});
		$("#tableInfoDel").click(function() {
			$("#tableInfoTb tbody tr:last-child").remove();
		});
		
		$("#httpHeader").blur(function() {
			if($("#httpHeader").val()=="{\"AuthToken\":\"value\"}"){
				$("#httpHeader").val("");
			}
		});
		
		$("#httpHeader").focus(function() {
			$("#httpHeader").val("{\"AuthToken\":\"value\"}");
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
            $('#paramInValue').val(t_data.replace(/\"{/g, "{").replace(/}\"/g,"}").replace(/\"\[/g, "\[").replace(/\]\"/g, "\]"));
            $('#paramInBody').collapse('hide');
            
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
            $("#paramInValueJson2").val(jsonBody);
            
		});
		
		$("#urlPath").focus(function() {
			if($("#urlPath").val()==""){
				$("#urlPath").val("http://");
			}			
		});
		$("#urlPath").blur(function() {
			count=0;
	    	var urlInfo = $("#urlPath").val();
	    	var url = $.url(urlInfo);
			var strRegex = "((http|ftp|https)://)(([a-zA-Z0-9\._-]+\.[a-zA-Z]{2,6})|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\&%_\./\$-~-]*)?";
			var re = new RegExp(strRegex);
			if (!re.test(encodeURI(urlInfo))) {
				$('#alertMessage').text("URL地址 格式错误");
				$('#alertModal').modal('show');
				return false;
			}
			var specilaParamsTr = "";
	    	if(urlInfo.indexOf("\$")>0){
	    		var specilaParamsArray = new Array();
	    		specilaParamsArray = urlInfo.split("\$");
	    		for(var i=0;i<specilaParamsArray.length;i++){
	    			if(specilaParamsArray[i].indexOf("}")>0){
	    				specilaParamsTr = specilaParamsTr +
	    				"<tr class=\"warning\">" +
				    	"<td><input type=\"checkbox\" checked=\"checked\"></td>"+
				    	"<td><input type=\"text\" class=\"form-control\" value=\""+specilaParamsArray[i].substr(0,specilaParamsArray[i].indexOf("}"))+"\"></td>" +
				    	"<td><input type=\"text\" class=\"form-control\"></td>" +
				    	"<td><select class=\"form-control\"><option selected=\"selected\">url</option><option>post</option></select></td>" +
				    	"<td><input type=\"text\" class=\"form-control\"></td>" +		    	
				    	"<td><select class=\"form-control\"><option>否</option><option>是</option></select></td>" +
				    	"</tr>";
	    			}
	    			}
			
	    	}
			//$("#urlPath").val(url.attr("protocol")+"://"+url.attr("host")+url.attr("path"));
	    	if (urlInfo.indexOf("?")>0){
	    		var urlPath = urlInfo.substr(0,urlInfo.indexOf("?"));
				$("#urlPath").val(urlPath);
				}
	    	
	 	    var urlParam = url.attr("query");
	 	    	var urlParamJson = "";
	 	    	if(urlParam == ""){urlParamJson="";}
	 	    	else{
	 	    		urlParamJson = "{\""+urlParam.replace(/\=/g,"\":\"").replace(/&/g,"\",\"")+"\"}";
	 	    		urlParamJson = urlParamJson.replace(/\"{/g, "{").replace(/\"\[/g, "\[").replace(/\]\"/g, "\]").replace(/}\"/g,"}").replace(/\"\"/g, "\"");
	 	    	}

	 	    	var jsonParamIn = $.parseJSON(urlParamJson);
		    	var jsonStringTr = "";		        
		        for(var key in jsonParamIn){
			    	jsonStringTr = jsonStringTr + 
			    	"<tr class=\"warning\">" +
			    	"<td><input type=\"checkbox\" checked=\"checked\"></td>"+
			    	"<td><input type=\"text\" class=\"form-control\" value=\""+key+"\"></td>" +
			    	"<td><input type=\"text\" class=\"form-control\"></td>" +
			    	"<td><select class=\"form-control\"><option selected=\"selected\">url</option><option>post</option></select></td>" +
			    	"<td><input type=\"text\" class=\"form-control\" value=\'";
			    	
			    	if(typeof(jsonParamIn[key])=="object"){
			    		jsonStringTr = jsonStringTr + JSON.stringify(jsonParamIn[key])+
			    		"\'></td>" +		    	
				    	"<td><select class=\"form-control\"><option>否</option><option>是</option></select></td>" +
				    	"</tr>";
			    	}
			    	else{
			    		jsonStringTr = jsonStringTr + jsonParamIn[key]+
			    		"\'></td>" +		    	
				    	"<td><select class=\"form-control\"><option>否</option><option>是</option></select></td>" +
				    	"</tr>";
			    	}
		        }
		        $("#paramInTb tbody").find("tr").each(function() {
					$(this).remove();
				});
				 $("#paramInTb").append(specilaParamsTr);	 
		        $("#paramInTb").append(jsonStringTr);	    	
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
            $('#tableInfoValue').val(t_data);
            $('#tableInfoBody').collapse('hide');
		});

		$("#paramInValueJson").blur(function() {
			for(var i=0;i<count;i++){
				$("#paramInTb tbody tr:last-child").remove();
			}
			count=0;
		    var paramInValueJson = $("#paramInValueJson").val();
		    if(paramInValueJson == 0 || paramInValueJson == ""){$("#paramInValueJson").hide();return false;}
		    if (paramInValueJson != 0 || paramInValueJson != "") {
				try {
					$.parseJSON(paramInValueJson);
				} catch (err) {
					$('#alertMessage').text("请求参数  JSON 格式错误\n" + err);
					$('#alertModal').modal('show');
					return false;
				}
			}			
		    var jsonParamIn = $.parseJSON(paramInValueJson);
		    var jsonStringTr = "";
		    for(var key in jsonParamIn){
		    	count++;
		    	jsonStringTr = jsonStringTr + 
		    	"<tr class=\"warning\">" +
		    	"<td><input type=\"checkbox\" checked=\"checked\"></td>"+
		    	"<td><input type=\"text\" class=\"form-control\" value=\""+key+"\"></td>" +
		    	"<td><input type=\"text\" class=\"form-control\"></td>" +
		    	"<td><select class=\"form-control\"><option>post</option><option>url</option></select></td>" +
		    	"<td><input type=\"text\" class=\"form-control\" value=\'";
		    	if(typeof(jsonParamIn[key])=="object"){
		    		//alert(JSON.stringify(jsonParamIn[key]));
		    		jsonStringTr = jsonStringTr + JSON.stringify(jsonParamIn[key])+
		    		"\'></td>" +		    	
			    	"<td><select class=\"form-control\"><option>否</option><option>是</option></select></td>" +
			    	"</tr>";
		    	}
		    	else{
		    		jsonStringTr = jsonStringTr + jsonParamIn[key]+
		    		"\'></td>" +		    	
			    	"<td><select class=\"form-control\"><option>否</option><option>是</option></select></td>" +
			    	"</tr>";
		    	}
	        }
		    //$("#paramInTb tbody").find("tr").each(function() {
			//	$(this).remove();
			//});
		    $("#paramInTb").append(jsonStringTr);
		    $("#paramInValueJson").hide();
		});		
		$("#paramOutValueJson").blur(function() {    		
			 var paramOutValueJson = $("#paramOutValueJson").val();	
			 if(paramOutValueJson == 0 || paramOutValueJson == ""){ $("#paramOutValueJson").hide();return false;}
			 if (paramOutValueJson != 0 || paramOutValueJson != "") {
					try {
						$.parseJSON(paramOutValueJson);
					} catch (err) {
						$('#alertMessage').text("返回字段  JSON 格式错误\n" + err);
						$('#alertModal').modal('show');
						return false;
					}
				}
				
			    var jsonParamOut = $.parseJSON(paramOutValueJson);
			    var jsonStringTr = "";
			    var jsonStringValue = "";
		    	var i = 1;
			    for(var key in jsonParamOut){
			    	jsonStringTr = jsonStringTr + 
			    	"<tr class=\"warning\">" +
			    	"<td><input type=\"text\" class=\"form-control\" value=\""+key+"\"></td>" +
			    	"<td><input type=\"text\" class=\"form-control\"></td>" +
			    	"</tr>";
			    	jsonStringValue =jsonStringValue +
			    	"\""+key+"\":" +"\"\","; 	
			    	i++;
		        }
			    jsonStringValue = "{"+jsonStringValue.substring(0, jsonStringValue.length-1) +"}";
			    $("#paramOutValueJson").val(jsonStringValue);
			    $("#paramOutTb tbody").find("tr").each(function() {
					$(this).remove();
				});
			    $("#paramOutTb").append(jsonStringTr);
			    $('#paramOutValueJson').hide();
		});
		
		$("#reslutBtn").click(function() {
			if($("#showResult").val().length>65535){
				$("#resultModal").modal('hide');
				$("#alertMessage").text("返回结果过长(超过64KB)，请增加搜索条件或者联系管理员添加需求\n");
				$("#alertModal").modal('show');
				$("#showResult").val("");
					return false;
			}
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
			var urlInfo = $("#urlPath").val();
	    	var url = $.url(urlInfo);
			
			//alert(url.attr("protocol")+"://"+url.attr("host")+url.attr("path"));
			
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
            //alert(jsonBody);
            $("#paramInValueJson2").val(jsonBody);
			 var urlPath = $("#urlPath").val();			 
			 var headIn = $("#httpHeader").val();
			 var urlMethod = $("#httpMethod").val();
			/* var strRegex = "^((https|http|ftp|rtsp|mms)?://)"
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
			*/ 
			 $.getJSON(basePath+"/api_manage/ApiToolsServlet?URLPath="+encodeURIComponent(urlPath)+"&jsonBody="+encodeURIComponent(jsonBody)+"&headIn="+encodeURIComponent(headIn)+"&urlMethod="+urlMethod,null,function(data) {   
				 var resultInfo = JSON.stringify(data.result);
					if (resultInfo==0 || resultInfo==""){
					   resultInfo="{}";
					}									
					 var options = {
				        dom : '#jsonFormate'
				    };
					$("#showResult").val(resultInfo);
				    var jf = new JsonFormater(options);
				    jf.doFormat(resultInfo);
				    $("#resultModal").modal('show');
				    $("showResult").val(resultInfo);
				    $("#showResult").attr('disabled',false);
				});			 
		});
		
		$("#paramInQuick").click(function(){			            
            $("#paramInValueJson").show();
            $("#paramInValueJson").focus();
		});
		$("#paramOutQuick").click(function(){			            
            $("#paramOutValueJson").show();
            $("#paramOutValueJson").focus();
		});		
	});
</script>
</head>
<body>
	<form method="post" onsubmit="return paramCheck();" action="/api_manage/AddapiInfoServlet">
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
														<span class="input-group-addon">所属部门</span> <select
															class="form-control" id="categoryFirstID"
															name="categoryFirstID">
															<option value="0">请选择</option>
														</select>
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
														<span class="input-group-addon">所属分类</span> <select
															class="form-control" id="categorySecondID"
															name="categorySecondID">
															<option value="0">请选择</option>
														</select>
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
															placeholder="添加参数xxxxxx" id="editInfo"
															name="editInfo">
													</div>
												</td>
											</tr>
											<tr>
												<td>
													<div class="input-group">
														<span class="input-group-addon">URL地址</span> <input
															type="text" class="form-control"
															placeholder="http://api.test.com/path/{$param}?param1=value1&param2=value2"
															id="urlPath" name="urlPath">
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
																		<input type="text" class="form-control" placeholder='{"paramIn": [{"paramName":"value1","paramDescription":"value2","paramType":"value3","paramDefault":"value4","isNeeded":"value5"},{}]}'
																			id="paramInValue" name="paramInValue" readonly="readonly">
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
																				<td width="60%" align="right">
																					<input type="text" style="display:none;" class="form-control" id="paramInValueJson" name="paramInValueJson" placeholder='失去焦点后自动添加 POST请求参数   {"param1":"value1","param2":"value2","param3":"value3"}'>
																					<input type="text" style="display:none;" class="form-control" id="paramInValueJson2" name="paramInValueJson2">
																				</td>
																				<td width="10%" align="right">
																					<button type="button" id="paramInQuick" class="btn btn-xs btn-info">快速添加</button>
																				</td>
																			</tr>
																			<tr class="active">
																				<td colspan="3">
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
																							<!--  
																							<tr class="warning">
																							    <td><input type="checkbox"></td>
																								<td><input type="text" class="form-control"></td>
																								<td><input type="text" class="form-control"></td>
																								<td><select class="form-control"><option>url</option><option>post</option></select></td>
																								<td><input type="text" class="form-control"></td>
																								<td><select class="form-control"><option>是</option><option>否</option></select></td>
																							</tr>
																							-->
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
																				<td width="30%">
																					<button type="button" id="paramOutAdd"
																						class="btn btn-xs btn-info">添加一行参数</button>
																					<button type="button" id="paramOutDel"
																						class="btn btn-xs btn-info">删除最后一行</button>
																					<button type="button" id="paramOutEnsure"
																						class="btn btn-xs btn-info">参数确认</button>
																				</td>
																				<td width="60%" align="right">
																					<input type="text" style="display:none;" class="form-control" id="paramOutValueJson" name="paramOutValueJson" placeholder='失去焦点后自动添加    {"param1":"value1","param2":"value2","param3":"value3"}'>
																				</td>
																				<td width="10%" align="right">
																					<button type="button" id="paramOutQuick" class="btn btn-xs btn-info">快速添加</button>
																				</td>
																			</tr>
																			<tr class="active">
																				<td colspan="3">
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
													<!--
													<a href="markdownEdit.jsp?value=1111" target="_blank"><button
															type="button" class="btn btn-Success" id="getMDFile">预览.md文件</button></a>
													-->
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
		</form>
		
		

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
		
		
		<!-- Modal duplicate-->
		<div class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true"  id="duplicateModal">
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
								<td id="duplicateMessage"></td>
							</tr>
						</table>
					</div>
					  
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal" id="duplicateBtn">Close</button>
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
	
</body>
</html>