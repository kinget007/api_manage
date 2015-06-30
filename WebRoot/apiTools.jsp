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

<!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
<!--[if lt IE 9]>
    <script src="common/js/html5shiv.js"></script>
  <![endif]-->

<!-- Fav and touch icons -->
<link rel="shortcut icon" href="common/img/apple-touch-icon-114-precomposed.png">
<link href="common/css/jsonFormater.css" type="text/css" rel="stylesheet">
<link href="common/google-code-prettify/prettify.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="common/js/jquery.min.js"></script>
<script type="text/javascript" src="common/js/bootstrap.min.js"></script>
<script src="common/js/jsonFormater.js" type="text/javascript"></script>
<script type="text/javascript" src="common/google-code-prettify/prettify.js"></script>
<script type="text/javascript" src="common/js/purl.js"></script>
<script type="text/javascript">	
	$(document).ready(function() {
		var basePath = '<%=basePath%>';
		var Request = new Object();
		var oldURLPATH = "";
		Request = GetRequest();
		var apiID = Request["apiID"];
		if(typeof(apiID)!="undefined"){
			$.getJSON(basePath+"/api_manage/ApiManageInitServlet?result=apiInfo&apiID="+apiID,null,function(data) {				
				for(var i=0;i<eval(data.apiInfo).length;i++){
					var apiInfo = data.apiInfo[i];
					$("#author").text(apiInfo.author);
					$("#cnName").text(apiInfo.cnName);					
					if(apiInfo.isLogin=="1"){
						$("#isLogin").text("是");
					}else{
						$("#isLogin").text("否");
					}
					var headInInfo = JSON.stringify(apiInfo.httpHeader);
					if(headInInfo=="{}"){
						headInInfo="";
					}
					$("#headIn").val(headInInfo);
			    	$("#URLPath").val(apiInfo.urlPath);
			    	oldURLPATH =  $.url(apiInfo.urlPath).attr("path");
			    	$("input[name='urlMethod'][value='"+apiInfo.httpMethod+"']").attr("checked",true);				
					
			    	var paramIn = apiInfo.paramIn.paramIn;
			    	var paramInsALL = "";
			    	var paramInReponse = "";
			    	for(var k=0;k<eval(paramIn).length;k++){
						if(paramIn[k].paramName==""){
							break;
						}
						else{
							if(typeof(paramIn[k].paramDefault)=="object"){
								paramIn[k].paramDefault = JSON.stringify(paramIn[k].paramDefault);
							}
							if(+paramIn[k].paramType.split("*")[1]==1){
								paramInReponse = paramInReponse + "\""+ paramIn[k].paramName+"*"+paramIn[k].paramType.split("*")[0]+"\":"+"\""+paramIn[k].paramDefault+"\",";
							}
							paramInsALL = paramInsALL + "\""+ paramIn[k].paramName+"*"+paramIn[k].paramType+"\":"+"\""+paramIn[k].paramDefault+"\",";								
						}						
					}
			    	if(paramInReponse==""){
			    		$("#jsonBodyResult").val(paramInReponse);
			    	}else{
			    		$("#jsonBodyResult").val("{" + paramInReponse.substring(0, paramInReponse.length-1).replace(/\"{/g, "{").replace(/\"\[/g, "\[").replace(/\]\"/g, "\]").replace(/}\"/g,"}") + "}");
			    		$("#jsonBody").val($("#jsonBodyResult").val().replace(/\*url/g,"").replace(/\*post/g,""));
			    	}
			    	if(paramInsALL==""){
			    		$("#jsonBodyALL").val(paramInsALL);
			    	}else{
			    		$("#jsonBodyALL").val("{" + paramInsALL.substring(0, paramInsALL.length-1).replace(/\"{/g, "{").replace(/\"\[/g, "\[").replace(/\]\"/g, "\]").replace(/}\"/g,"}") + "}");
			    	}
			    	}
				});
		}				
		
		prettyPrint(); 
		$("#menuActive").find("li").each(function() {
			$(this).removeClass("active");
		});
		$("#menuActive li:nth-child(3)").addClass("active");
		
		$("#headIn").blur(function() {
			if($("#headIn").val()=="{\"AuthToken\":\"value\"}"){
				$("#headIn").val("");
			}
		});
		
		$("#headIn").focus(function() {
			$("#headIn").val("{\"AuthToken\":\"value\"}");
		});
		
		$("#URLPath").focus(function() {
			if($("#URLPath").val()==""){
				$("#URLPath").val("http://");
			}			
		});

	    $("#URLPath").blur(function() {
			
	    	var strRegex = "((http|ftp|https)://)(([a-zA-Z0-9\._-]+\.[a-zA-Z]{2,6})|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\&%_\./\$-~-]*)?";
			var re = new RegExp(strRegex);		
			//var re=/^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/;
			if (!re.test(encodeURI($("#URLPath").val().toLowerCase()))) {
				$('#alertMessage').text("URL地址 格式错误");
				$('#alertModal').modal('show');
				return false;
			}
			var jsonBodyURLCurrent2="";
			if(oldURLPATH==""){oldURLPATH = $.url($("#URLPath").val()).attr("path");} 
	    	if($.url($("#URLPath").val()).attr("path")!=oldURLPATH){
	    		$("#jsonBodyALL").val("");		    	
	    	}else{
		    	jsonBodyURLCurrent2=$("#jsonBodyURLCurrent").val();
		    	}
	    	var urlInfo = $("#URLPath").val();
	    	var url = $.url(urlInfo);	    	
	    	var urlParam = url.attr("query");
	    	var jsonBodyURLCurrent="";    	
	    	if(urlParam != ""){
	    		urlParamJson = ("{\""+urlParam.replace(/\=/g,"\":\"").replace(/&/g,"\",\"")+"\"}").replace(/\"\"/g, "\"");
	    		jsonBodyURLCurrent = ("{\""+urlParam.replace(/\=/g,"*url*1\":\"").replace(/&/g,"\",\"")+"\"}").replace(/\"\"/g, "\"");
	    		jsonBodyURLCurrent2 = jsonBodyURLCurrent;
	    	}
	    	var port = url.attr("port");
	    	if(port!=""){port=":"+port;}
			$("#URLPath").val(url.attr("protocol")+"://"+url.attr("host")+port+url.attr("path"));			
			//$("#jsonBody").val(urlParamJson);			
			var jsonBodyALL = $("#jsonBodyALL").val();	
			if(jsonBodyALL==""){jsonBodyALL="{}";}
			if(jsonBodyURLCurrent2==""){jsonBodyURLCurrent2="{}";}			
			jsonBodyURLCurrent = JSON.stringify($.extend({},$.parseJSON(jsonBodyALL),$.parseJSON(jsonBodyURLCurrent2)));			
			$("#jsonBodyURLCurrent").val(jsonBodyURLCurrent);
			$("#jsonBodyResult").val(jsonBodyURLCurrent.replace(/\*url\*1/g,"\*url").replace(/\*url\*0/g,"\*url").replace(/\*post\*1/g,"\*post").replace(/\*post\*0/g,"\*post"));
			$("#jsonBody").val(jsonBodyURLCurrent.replace(/\*url\*1/g,"").replace(/\*url\*0/g,"").replace(/\*post\*1/g,"").replace(/\*post\*0/g,""));
			oldURLPATH = $.url($("#URLPath").val()).attr("path");
	        });	    
	    
	    $("#paramInEnsure").click(function() {	    	
	    	$("#appendTr tbody").find("tr").each(function() {
				$(this).remove();
			});
	    	var stringParamIn = $("#jsonBodyURLCurrent").val();	
	    	if(stringParamIn==""){
	    		var jsonBodyALL = $("#jsonBodyALL").val();
	    		if(jsonBodyALL==""){jsonBodyALL="{}";}
	    		$("#jsonBodyURLCurrent").val(jsonBodyALL);
	    		stringParamIn = jsonBodyALL;
	    	}
	    	var jsonParamIn = $.parseJSON(stringParamIn);
	    	var jsonStringTr = "";
	        for(var key in jsonParamIn){
	        	if(typeof(jsonParamIn[key])=="object"){jsonParamIn[key] = JSON.stringify(jsonParamIn[key]);}
	        	if(key.split("*")[2]==1){
	        		jsonStringTr = jsonStringTr +
					"<tr class=\"success\">"+
						"<td><input type=\"checkbox\" checked=\"checked\"></td>"+
						"<td>"+key.split("*")[0]+"</td><td><input  type=\"text\" class=\"form-control\" style=\"width:100%;\" value="+jsonParamIn[key]+"></td><td>"+key.split("*")[1]+"</td>"+
					"</tr>";
	        	}else if(key.split("*")[2]==0){
	        		jsonStringTr = jsonStringTr +
					"<tr class=\"success\">"+
						"<td><input type=\"checkbox\"></td>"+
						"<td>"+key.split("*")[0]+"</td><td><input  type=\"text\" class=\"form-control\" style=\"width:100%;\" value="+jsonParamIn[key]+"></td><td>"+key.split("*")[1]+"</td>"+
					"</tr>";
	        	}
	        }
	        $("#appendTr tbody").append(jsonStringTr);
	        
	        });
	    	    
	    var count = 0;
	    $("#jsonPost").blur(function() { 
	    	var jsonPost = $("#jsonPost").val();    	
	    	if (jsonPost != 0 || jsonPost != "") {
				try {
					$.parseJSON(jsonPost);
				} catch (err) {
					$('#alertMessage').text("POST输入参数  JSON 格式错误\n" + err);
					$('#alertModal').modal('show');
					return false;
				}
			}	
	    	
	    	var jsonPostKey  = new Array();			
	        $("#appendTr").find("tbody tr").each(function(i) {
	        	jsonPostKey. push($("#appendTr").find("tbody tr:eq(" + i + ")").find("td:eq(1)").text());
            });
    	
	    	for(var i=0;i<count;i++){
	    		$("#appendTr tbody tr:last-child").remove();
	    	}
	    	count = 0;	    		    	    	
	    	var jsonStringTr = "";
	    	
	    	if($("#jsonPost").val()!=""){
	    		var jsonPostParamIn = $.parseJSON($("#jsonPost").val());
		        for(var key in jsonPostParamIn){
		        	for(var i =0;i<jsonPostKey.length;i++){
		        		if(jsonPostKey[i]==key){
		        			$('#alertMessage2').text("输入参数重复元素"+key+"，请重新输入！！！");		        			
		        			$('#myModal').modal('hide');
		    				$('#alertModal2').modal('show');
		    				return false;
		        		}
		        	}		        		        	
		        	count++;
		        	if(typeof(jsonPostParamIn[key])=="object"){jsonPostParamIn[key] = JSON.stringify(jsonPostParamIn[key]);}
		        	jsonStringTr = jsonStringTr +
						"<tr class=\"success\">"+
							"<td><input type=\"checkbox\" checked=\"checked\"></td>"+
							"<td>"+key+"</td><td><input  type=\"text\" class=\"form-control\" style=\"width:100%;\" value="+jsonPostParamIn[key]+"></td><td>post</td>"+
						"</tr>";	        	
		        }
	    	}	        	        
	        $("#appendTr tbody").append(jsonStringTr);
	        });
	    

		
		 $("#duplateKey").click(function(){ 
			 $('#myModal').modal('show');
		 });
	    
	    $("#changeParamIn").click(function(){ 
			var t_data = "";
			var jsonBodyURLCurrent = "";			
	        $("#appendTr").find("tbody tr").each(function(i) {
	        	var ischecked = 0;
	        	if($("#appendTr").find("tbody tr:eq(" + i + ")").find("td:eq(0) input[type='checkbox']").prop("checked")==true){ischecked=1;}
	        	jsonBodyURLCurrent = jsonBodyURLCurrent+ "\""  + $("#appendTr").find("tbody tr:eq(" + i + ")").find("td:eq(1)").text()+"*"
					+ $("#appendTr").find("tbody tr:eq(" + i + ")").find("td:eq(3)").text()
					+"*"+ ischecked +"\":\""
					+ $("#appendTr").find("tbody tr:eq(" + i + ")").find("td:eq(2) input[type='text']").val()+"\",";
	        	if($("#appendTr").find("tbody tr:eq(" + i + ")").find("td:eq(0) input[type='checkbox']").prop("checked")==true){
            		t_data = t_data + "\""  + $("#appendTr").find("tbody tr:eq(" + i + ")").find("td:eq(1)").text()+"*"
					+ $("#appendTr").find("tbody tr:eq(" + i + ")").find("td:eq(3)").text()+"\":\""
   					+ $("#appendTr").find("tbody tr:eq(" + i + ")").find("td:eq(2) input[type='text']").val()+"\",";  
            	} 	         	                 
            });
	        
	        t_data = "{" + t_data.substring(0, t_data.length-1) + "}";
	        jsonBodyURLCurrent = "{" + jsonBodyURLCurrent.substring(0, jsonBodyURLCurrent.length-1) + "}";
	        $("#jsonBodyResult").val(t_data.replace(/\"{/g, "{").replace(/}\"/g, "}").replace(/\"\[/g,"\[").replace(/\]\"/g,"\]"));
	        $("#jsonBodyURLCurrent").val(jsonBodyURLCurrent.replace(/\"{/g, "{").replace(/}\"/g, "}").replace(/\"\[/g,"\[").replace(/\]\"/g,"\]"));
	        $("#jsonBody").val(jsonBodyURLCurrent.replace(/\"{/g, "{").replace(/}\"/g, "}").replace(/\"\[/g,"\[").replace(/\]\"/g,"\]").replace(/\*url\*1/g,"").replace(/\*url\*0/g,"").replace(/\*post\*1/g,"").replace(/\*post\*0/g,""));
		});
	
	    
	    $("#submitbtn").click(function() {
	    	$("#resultTB").find("tr").each(function() {
				$(this).remove();
			});
	    	$("#submitbtn").text("api请求中，请稍等...");
	    	$("#submitbtn").attr('disabled',"true");
	    	var urlPath = $("#URLPath").val();
	    	var jsonBody = $("#jsonBodyResult").val();
	    	var headIn = $("#headIn").val();
	    	var urlMethod =$('input:radio[name=urlMethod]:checked').val();
	    	
			if (jsonBody != 0 || jsonBody != "") {
				try {
					$.parseJSON(jsonBody);
				} catch (err) {
					$('#alertMessage').text("JSON输入参数  JSON 格式错误\n" + err);
					$('#alertModal').modal('show');
					return false;
				}
			}
			if (headIn != 0 || headIn != "") {
				try {
					$.parseJSON(headIn);
				} catch (err) {
					$('#alertMessage').text("Head额外信息  JSON 格式错误\n" + err);
					$('#alertModal').modal('show');
					return false;
				}
			}
			
			var resultJsons = $.parseJSON(jsonBody);
			var resultArray =  new Array();
			var resultArrayStart =  new Array();
			for(key in resultJsons){
				var values = resultJsons[key].split(",");
				if(resultArray.length==0){
					for(var i=0;i<values.length;i++){
						if(typeof(values[i])=="object"){values[i] = JSON.stringify(values[i]);}
						resultArray[i]="\""+key+"\":\""+values[i]+"\",";
						resultArray[i]=resultArray[i].replace(/\"{/g, "{").replace(/\"\[/g, "\[").replace(/\]\"/g, "\]").replace(/}\"/g,"}");
					}
					resultArrayStart = resultArray.concat();
				}else{
					var resultArraylength =resultArrayStart.length;
					for(var j=0;j<values.length;j++){
						for(var k=0;k<resultArraylength;k++){							
							//alert(resultArray[resultArray.length+k] = resultArray[k] +"\""+key+"\":\""+values[j]+"\",");
							resultArray[resultArraylength*j+k] = resultArrayStart[k] +"\""+key+"\":\""+values[j]+"\",";	
						}
					}
					resultArrayStart = resultArray.concat();					
				}
				} 
			if(resultArray.length>10){
				$('#alertMessage2').text("测试数目多余10条，请修改参数");		        			
    			$('#myModal').modal('hide');
				$('#alertModal2').modal('show');
				return false;
			}
			var reslutArray = new Array();
			var jsonBodyArray = new Array();
			if(resultArray.length<2){
				jsonBody = "{"+resultArray[0].substring(0, resultArray[0].length-1) + "}";
				$.getJSON(basePath+"/api_manage/ApiToolsServlet?URLPath="+encodeURIComponent(urlPath)+"&jsonBody="+encodeURIComponent(jsonBody)+"&headIn="+encodeURIComponent(headIn)+"&urlMethod="+urlMethod,null,function(data) {  
					var resultInfo = JSON.stringify(data.result);
					if(resultInfo.toLowerCase().indexOf("\"status\""+":"+"\"ok\"")==-1){
						$("#resultTB").append("<tr class=\"danger\"><td>"+1+"</td><td>"+jsonBody.replace(/\*url/g,"").replace(/\*post/g,"")+"</td><td>error</td></tr>"+"<tr><td colspan=\"3\"><div id=\"jsonFormate\"></div></td></tr>");
						
					}else{
						$("#resultTB").append("<tr class=\"success\"><td>"+1+"</td><td>"+jsonBody.replace(/\*url/g,"").replace(/\*post/g,"")+"</td><td>ok</td></tr>"+"<tr><td colspan=\"3\"><div id=\"jsonFormate\"></div></td></tr>");						
					}
					if (resultInfo==0 || resultInfo==""){
					   resultInfo="{}";
					}
					 var options = {
				        dom : "#jsonFormate"
				    };
				    var jf = new JsonFormater(options);
				    jf.doFormat(resultInfo);				    
				    //$('#headerRequest').text(data.header);					    	
					$("#submitbtn").attr('disabled',false);	
					$("#submitbtn").text("Submit");
				});	
			}else{
				for(var i=0;i<resultArray.length;i++){					
					var jsonFormateindex = i+1+"";
					jsonBody = "{"+resultArray[i].substring(0, resultArray[i].length-1) + "}";
					jsonBodyArray.push(jsonBody);
					$.getJSON(basePath+"/api_manage/ApiToolsServlet?URLPath="+encodeURIComponent(urlPath)+"&jsonBody="+encodeURI(encodeURI(jsonBody))+"&headIn="+encodeURIComponent(headIn)+"&urlMethod="+urlMethod,null,function(data) {  
						var resultInfo = JSON.stringify(data.result);
						reslutArray.push(resultInfo);
						if(resultInfo.toLowerCase().indexOf("\"status\""+":"+"\"ok\"")==-1){
							$("#resultTB").append("<tr class=\"danger\"><td>"+reslutArray.length+"</td><td>"+decodeURIComponent(data.jsonBody).replace(/\*url/g,"").replace(/\*post/g,"")+"</td><td>error</td></tr>"+"<tr style=\"display:none\"><td colspan=\"3\"><div id=\"jsonFormate"+reslutArray.length+"\"></div></td></tr>");
							
						}else{
							$("#resultTB").append("<tr class=\"success\"><td>"+reslutArray.length+"</td><td>"+decodeURIComponent(data.jsonBody).replace(/\*url/g,"").replace(/\*post/g,"")+"</td><td>ok</td></tr>"+"<tr style=\"display:none\"><td colspan=\"3\"><div id=\"jsonFormate"+reslutArray.length+"\"></div></td></tr>");						
						}
						if (resultInfo==0 || resultInfo==""){
						   resultInfo="{}";
						}
						 var options = {
					        dom : "#jsonFormate"+reslutArray.length
					    };
					    var jf = new JsonFormater(options);
					    jf.collapseAll();
					    jf.doFormat(resultInfo);				    
					    //$('#headerRequest').text(data.header);	
					    if(reslutArray.length==jsonFormateindex){				    	
							$("#submitbtn").attr('disabled',false);	
							$("#submitbtn").text("Submit");
							}
					});					
				}
			}										
		   });
	    var countClick = 0;
	    $(document).on("click", "#resultTB tr", function() {	    	
	        if(countClick==0){
	        	$("#resultTB tr:gt(0):eq("+$(this).index()+")").show();
	        	countClick=1;
	        }else{
	        	$("#resultTB tr:gt(0):eq("+$(this).index()+")").hide();
	        	countClick=0;
	        }	    	 
	    });
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
</script>
</head>

<body>
	<form>
		<div class="container">
			<%@include file="header.jsp"%>			
			<h2></h2>
			<div class="row clearfix">
				<div class="col-md-12 column">
					<div class="panel panel-default">
						<div class="panel-heading">
							<table width="100%">
								<tr>
									<td><h3 class="panel-title">URL(链接地址)</h3></td>
									<td align="right"><a href="apiTools.jsp"><button type="button" class="btn btn-xs btn-info">清空数据</button></a></td>
								</tr>
							</table>
						</div>
						<div class="panel-body">
							<div id="protocol_host_path">
							<table width="100%">
								<tbody>
									<tr>
										<td><input name="URLPath" type="text" id="URLPath" style="width:100%;" placeholder="http://api.anjuke.com/path?param1=value1&param2=value2"></td>
									</tr>
									</tbody>
							</table>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="row clearfix">
				<div class="col-md-6 column">
					<div class="panel panel-default">
						<div class="panel-heading">
							<table  width="100%">
								<tr>
									<td><h3 class="panel-title">请求参数</h3></td>
									<td align="right">
										<button type="button" class="btn btn-xs btn-info" data-toggle="modal" data-target="#myModal" id="paramInEnsure">参数修改</button></td>
								</tr>
							</table>
						</div>
						<div class="panel-body">
							<input name="jsonBody" type="text" class="form-control" style="width:100%;" id="jsonBody" placeholder='{"param1":"value1","param2":"value2","param3":"value3"}'>
							<input name="jsonBodyURLCurrent" type="text" style="width:100%;display: none" id="jsonBodyURLCurrent">
							<input name="jsonBodyALL" type="text" style="width:100%;display: none" id="jsonBodyALL">
							<input name="jsonBodyResult" type="text" style="width:100%;display: none" id="jsonBodyResult">
						</div>
					</div>
				</div>
				<div class="col-md-6 column">
					<div class="panel panel-default">
						<div class="panel-heading">
							<table>
								<tr>
									<td><h3 class="panel-title">Head额外信息</h3></td>
									<td><h2></h2>
									</td>
								</tr>
							</table>
						</div>
						<div class="panel-body">
							<!--<input name="para_out" type="text" style="width:100%;" value="${para_out}">-->
							<input name="headIn" id="headIn" type="text" style="width:100%;" placeholder='{"AuthToken":"value1","param2":"value2","param3":"value3"}'>
						</div>
					</div>
				</div>
			</div>



			<div class="row clearfix">
				<div class="col-md-6 column">
					<div class="row clearfix">
						<div class="col-md-12 column">
							<div class="panel panel-default">
								<div class="panel-heading">
									<h3 class="panel-title">基本参数</h3>
								</div>
								<div class="panel-body">
									<table class="table table-bordered">
										<tbody>
											<tr class="active">
												<td>API接口名称</td>
												<td id="cnName"></td>
											</tr>
											<tr>
												<td>开发人员</td>
												<td id="author"></td>
											</tr>
											<tr class="active">
												<td>是否登录</td>
												<td id="isLogin"></td>
											</tr>
											<tr>
												<td>请求方法</td>
												<td>
												<label class="radio-inline"><input type="radio" name="urlMethod" id="urlMethod" value="get" checked="checked" />get </label> 
												<label class="radio-inline"><input type="radio" name="urlMethod" id="urlMethod" value="post" />post</label>
												</td>
											</tr>
											
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
					<div class="row clearfix">
						<div class="col-md-12 column">
							<div class="panel panel-default">
								<div class="panel-heading">
									<h3 class="panel-title">submit</h3>
								</div>
								<div class="panel-body">
									<button type="button" class="btn btn-Success" id="submitbtn">Submit</button>
									<!--  
									<label class="radio-inline"><input type="radio" name="inlineRadioOptions" id="inlineRadio1" value="all"> 全量测试</label> 
									<label class="radio-inline"><input type="radio" name="inlineRadioOptions" id="inlineRadio2" value="rabdom">随机测试</label> 
									<label class="radio-inline"><input type="radio" name="inlineRadioOptions" id="inlineRadio3" value="onlyone" checked="checked"> 单条测试</label>
									-->
								</div>
							</div>
						</div>
					</div>

				</div>
				<div class="col-md-6 column">
					<div class="panel panel-default">
						<div class="panel-heading">
							<h3 class="panel-title">结果</h3>
						</div>
						<div class="panel-body" style="height:332px; overflow-y:auto; border:0px solid;">
							<table width="100%" id="resultTB" class="table table-hover table-striped">
								<!--
								<tr>
									<td>
									<div id="responseHeader" style="height:24px; border:0px solid;">
									<span class="label label-info">Header</span>
									<font size="2" color="blue" id="headerRequest"></font>											
									</div>
									</td>
								</tr>  
								<tr>
									<td>
									<div id="jsonFormate" style="height:275px; overflow-y:auto; border:0px solid;"></div>
									</td>
								</tr>
								-->
							</table>
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
						<h4 class="modal-title" id="myModalLabel">错误提示</h4>						
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
		
		<!-- Modal alert-->
		<div class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true"  id="alertModal2">
			<div class="modal-dialog modal-sm">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title" id="myModalLabel2">错误提示</h4>						
					</div>
					<div class="modal-body">
						<table  style="overflow:auto;" border="0px">
							<tr>
								<td id="alertMessage2"></td>
							</tr>
						</table>
					</div>
					  
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal" id="duplateKey">Close</button>
						<!--
						<button type="button" class="btn btn-primary">Save changes</button>
						-->
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
						<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
						<h4 class="modal-title" id="myModalLabel">参数设置</h4>
					</div>
					<div class="modal-body"  style="overflow:auto;" >
						<table class="table table-bordered" id="jsonPostTr" width="100%">
						<tbody>
						<tr>
						<td width="100%"><input name="jsonPost" width="300px"  class="form-control" "text" id="jsonPost" placeholder='POST BODY {"param1":"value1","param2":"value2","param3":"value3"}'></td>
						</tr>
						</tbody>
						</table>
						
						<div style="height:400px;overflow:scroll;">
						<table class="table table-bordered" id="appendTr">
							<thead>
								<tr class="active">
									<th align="justify"></th>
									<th align="justify">参数名</th>
									<th align="justify">参数取值</th>
									<th align="justify">参数类型</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
						<button type="button" class="btn btn-primary" data-dismiss="modal" id="changeParamIn">Save changes</button>
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>
