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
<title>位置查询</title>
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
<link rel="stylesheet" type="text/css" href="http://developer.amap.com/Public/css/demo.Default.css" /> 
<script src="http://webapi.amap.com/maps?v=1.3&key=0fafeeb222cf528f110eecc62bad5200"></script>
<script language="javascript">
var basePath = '<%=basePath%>';
$(document).ready(function() {
	$("#locationDistanceTB").hide();
	$("#xyLocationTB").hide();
	$("#menuActive").find("li").each(function() {
			$(this).removeClass("active");
		});
	$("#menuActive li:nth-child(5)").addClass("active");
	
	$(document).on("click", "#locationResultAJK tr", function() {	
		 //geocoder($(this).find("td:eq(0)").text().split(":")[1],0);
		 $("#gaodeLocation").val("");
		 $("#localLocation").val("");
		 $("#locationDistance").val("");
		 $("#locationDistanceTB").show();
		 $("#xyLocationTB").show();
		 var locationname = $(this).find("td:eq(0)").text().split(":")[1];		 
		 geocoder($("#locationName").val().split(" ")[0]+locationname+"",1);
		
		 var sosoX=$(this).find("td:eq(1)").text().split(":")[1].split(",")[0];
		 var sosoY=$(this).find("td:eq(1)").text().split(":")[1].split(",")[1];
		 $("#localLocation").val(sosoX+","+sosoY);		 
	    });
	 
	 $("#searchLocation").click(function(){
		 mapInit();
		 $("#gaodeLocation").val("");
		 $("#localLocation").val("");
		 $("#locationDistance").val("");
		 $("#locationDistanceTB").hide();
		 $("#xyLocationTB").hide();
		 var locationname = $("#locationName").val().split(" ")[1];
		 var cityName = $("#locationName").val().split(" ")[0];
		 if(locationName=="" || cityName==""){
		    $("#alertMessage").text("请输入查询小区!");
			$("#alertModal").modal('show');
			return false;
		  }
		  $("#locationResultAJK").find("tr").each(function() {
			$(this).remove();
		  });
		  
		  $.getJSON(basePath+"/api_manage/localLocation?locationname="+encodeURI(encodeURI(locationname))+"&cityName="+encodeURI(encodeURI(cityName)),null,function(data) { 
		    	var resultInfo = JSON.stringify(data);
				if (resultInfo=="[]"){
					$("#alertMessage").text("检查格式是否正确 or本地未搜索到数据，请检查是否存在该小区!");
					$("#alertModal").modal('show');
					return false;
				}else{
					var resultStr = "";
					for(var i=0;i<eval(data).length;i++){
						 resultStr += "<tr><td><span style=\"font-size: 12px;padding:0px 0 4px 2px;solid #C1FFC1;\"><b>地址</b>:"+data[i].comm_local+"</span></td><td>"+"<span style=\"font-size: 12px;padding:0px 0 4px 2px;solid #C1FFC1;\"><b>坐标</b>:" + data[i].sosolng +","+ data[i].sosolat+"</span></td></tr>";					        
					}
					$("#locationResultAJK").append(resultStr);
				}													 
			});
		 // geocoder(locationName,1);		    
		});
	});
	var mapObj;
	var route_text, steps;
	var polyline;
	var marker = new Array();
	var windowsArr = new Array(); 
	function mapInit() { 		
		mapObj = new AMap.Map("iCenter", {
	        view: new AMap.View2D({
	        center:new AMap.LngLat(121.472644, 31.231706),//地图中心点
	        zoom:13 //地图显示的缩放级别
	        })
	    }); 
	}
		
	function geocoder(locationAddress,flag) {
	    var MGeocoder;
	    //加载地理编码插件
	    AMap.service(["AMap.Geocoder"], function() {        
	        MGeocoder = new AMap.Geocoder({ 
	            //city:"010", //城市，默认：“全国”
	            radius:1000 //范围，默认：500
	        });
	        //返回地理编码结果  
	        //地理编码
	        MGeocoder.getLocation(locationAddress, function(status, result){
	        	if(status === 'complete' && result.info === 'OK'){
	        		geocoder_CallBack(result,flag);
	        	}
	        });
	    });
	}  
	function addmarker(i, d) {
	    var lngX = d.location.getLng();
	    var latY = d.location.getLat();
	    var markerOption = {
	        map:mapObj,                 
	        icon:"http://webapi.amap.com/images/"+(i+1)+".png",  
	        position:new AMap.LngLat(lngX, latY)
	    };            
	    var mar = new AMap.Marker(markerOption);  
	    marker.push(new AMap.LngLat(lngX, latY));
	
	    var infoWindow = new AMap.InfoWindow({  
	        content:d.formattedAddress, 
	        autoMove:true, 
	        size:new AMap.Size(150,0),  
	        offset:{x:0,y:-30}
	    });  
	    windowsArr.push(infoWindow);  
	    
	    var aa = function(e){infoWindow.open(mapObj,mar.getPosition());};  
	    AMap.event.addListener(mar,"click",aa);  
	}
	//地理编码返回结果展示   
	function geocoder_CallBack(data,flag){
	    var resultStr="";
	    //地理编码结果数组
	    var geocode = new Array();
	    geocode = data.geocodes;  
	    for (var i = 0; i < geocode.length; i++) {
	        //拼接输出html 
	        $("#gaodeLocation").val(geocode[i].location.getLng() +","+ geocode[i].location.getLat());
	        //resultStr += "<tr><td><span style=\"font-size: 12px;padding:0px 0 4px 2px;solid #C1FFC1;\"><b>地址</b>:"+geocode[i].formattedAddress+"</span></td><td>"+"<span style=\"font-size: 12px;padding:0px 0 4px 2px;solid #C1FFC1;\"><b>坐标</b>:" + geocode[i].location.getLng() +","+ geocode[i].location.getLat()+"</span></td></tr>";
	       // mapInit();
	        //addmarker(i, geocode[i]);
	    }  
	    mapObj.setFitView();   
	    //document.getElementById("result").innerHTML = resultStr;
	    if(flag==1){//$("#localLocation").val(sosoX+","+sosoY);
	    	 var sosoX=$("#localLocation").val().split(",")[0];
			 var sosoY=$("#localLocation").val().split(",")[1];
			 var gaodeX= $("#gaodeLocation").val().split(",")[0];
			 var gaodeY= $("#gaodeLocation").val().split(",")[1];
			 var start_xy = new AMap.LngLat(gaodeX,gaodeY);
			 var end_xy = new AMap.LngLat(sosoX,sosoY);
			 walking_route(start_xy,end_xy);
	    	}
	}  
	
	
	
	//var start_xy = new AMap.LngLat(116.480355,39.989783);
	//var end_xy = new AMap.LngLat(116.469766,39.998731);
	//步行导航
	function walking_route(start_xy,end_xy) {
		var MWalk;
		mapInit();
	    AMap.service(["AMap.Walking"], function() {        
	        MWalk = new AMap.Walking(); //构造路线导航类 
	        //根据起终点坐标规划步行路线
	        MWalk.search(start_xy, end_xy, function(status, result){
	        	if(status === 'complete'){
	        		walk_routeCallBack(result,start_xy,end_xy);
	        	}
	        }); 
	    });
	}
	//导航结果展示
	function walk_routeCallBack(data,start_xy,end_xy) {
		var distanceALL=0;
		var routeS = data.routes;
			if (routeS.length <= 0) {
				//document.getElementById("result").innerHTML = "未查找到任何结果!<br />建议：<br />1.请确保所有字词拼写正确。<br />2.尝试不同的关键字。<br />3.尝试更宽泛的关键字。";
			} 
			else { 
				route_text="";
			 	for(var v =0; v< routeS.length;v++){
			 		//步行导航路段数
					steps = routeS[v].steps;
					var route_count = steps.length;
					//步行距离（米）
					var distance = routeS[v].distance;
					distanceALL +=routeS[v].distance;
					//拼接输出html
					//for(var i=0 ;i< steps.length;i++) {
					//	route_text += "<tr><td align=\"left\" onMouseover=\"walkingDrawSeg('" + i + "')\">" + i +"." +steps[i].instruction  + "</td></tr>";
					//}
				}
				//输出步行路线指示
				$("#locationDistance").val(distanceALL+"米");
				//route_text = "<table cellspacing=\"5 px\" ><tr><td style=\"background:#e1e1e1;\">路线</td></tr><tr><td><img src=\"http://code.mapabc.com/images/start.gif\" />&nbsp;&nbsp;方恒国际中心</td></tr>" + route_text + "<tr><td><img src=\"http://code.mapabc.com/images/end.gif\" />&nbsp;&nbsp;望京地铁站</td></tr></table>";
				//document.getElementById("result").innerHTML = route_text;
				walkingDrawLine(start_xy,end_xy);
			}
		}
	//绘制步行导航路线
	function walkingDrawLine(start_xy,end_xy) {
	    //起点、终点图标
		var sicon = new AMap.Icon({
			image: "http://api.amap.com/Public/images/js/poi.png",
			size:new AMap.Size(44,44),
			imageOffset: new AMap.Pixel(-334, -180)
		});
		var startmarker = new AMap.Marker({
			icon : sicon, //复杂图标
			visible : true, 
			position : start_xy,
			map:mapObj,
			offset : {
				x : -16,
				y : -40
			}
		});
		var eicon = new AMap.Icon({
			image: "http://api.amap.com/Public/images/js/poi.png",
			size:new AMap.Size(44,44),
			imageOffset: new AMap.Pixel(-334, -134)
		});
		var endmarker = new AMap.Marker({
			icon : eicon, //复杂图标
			visible : true, 
			position : end_xy,
			map:mapObj,
			offset : {
				x : -16,
				y : -40
			}
		}); 
		//起点到路线的起点 路线的终点到终点 绘制无道路部分
		var extra_path1 = new Array();
		extra_path1.push(start_xy);
		extra_path1.push(steps[0].path[0]);
		var extra_line1 = new AMap.Polyline({
			map: mapObj,
			path: extra_path1,
			strokeColor: "#9400D3",
			strokeOpacity: 0.7,
			strokeWeight: 4,
			strokeStyle: "dashed",
			strokeDasharray: [10, 5]
		});

		var extra_path2 = new Array();
		var path_xy = steps[(steps.length-1)].path;
		extra_path2.push(end_xy);
		extra_path2.push(path_xy[(path_xy.length-1)]);
		var extra_line2 = new AMap.Polyline({
			map: mapObj,
			path: extra_path2,
			strokeColor: "#9400D3",
			strokeOpacity: 0.7,
			strokeWeight: 4,
			strokeStyle: "dashed",
			strokeDasharray: [10, 5]
		});

		var drawpath = new Array(); 
		for(var s=0; s<steps.length; s++) {
			var plength = steps[s].path.length;
			for (var p=0; p<plength; p++) {
				drawpath.push(steps[s].path[p]);
			}
		}
		var polyline = new AMap.Polyline({
			map: mapObj,
			path: drawpath,
			strokeColor: "#9400D3",
			strokeOpacity: 0.7,
			strokeWeight: 4,
			strokeDasharray: [10, 5]
		});
		mapObj.setFitView();
	}	
	//绘制步行导航路段
	function walkingDrawSeg(num) {
		var drawpath1 = new Array();
		drawpath1 = steps[num].path;
		if(polyline != null) {
			polyline.setMap(null);
		}
		polyline = new AMap.Polyline({
				map: mapObj,
				path: drawpath1,
				strokeColor: "#FF3030",
				strokeOpacity: 0.9,
				strokeWeight: 4,
				strokeDasharray: [10, 5]
			});

		mapObj.setFitView(polyline);
	}
</script>  
</head>  
<body onload="mapInit();">   
<div class="container">
		<%@include file="header.jsp"%>
		<h2></h2>
		<br/>
			<div class="row clearfix">
				<div class="col-md-12 column">
					<div class="panel panel-default">
						<div class="panel-heading">
							<table>
								<tr>
									<td><h3 class="panel-title">地址查询</h3></td>
								</tr>
							</table>
						</div>
						<div class="panel-body">
							<div class="col-md-12 column">
								<div class="row clearfix">									
									<div class="col-md-6 column">										
    									<table width="100%">
    										<tbody>
    											<tr>
    												<td>
    													<div class="input-group">
															<span class="input-group-addon">小区名字 (精确)</span> 
															<input type="text" class="form-control" placeholder="城市名称+一个空格+小区名称 " id="locationName" name="locationName">											
														</div>
													</td>
    												<td><button type="button" class="btn btn-Success" id="searchLocation">搜索</button></td>
    											</tr>
    										</tbody>
    									</table>
    									<table width="100%" id="xyLocationTB">
    										<tbody>	
    											<tr>
    												<td>
    													<div class="input-group">
															<span class="input-group-addon">高德数据 (起点)</span> 
															<input type="text" class="form-control" id="gaodeLocation" name="gaodeLocation">											
														</div>
													</td>
												</tr>
												<tr>
    												<td>
    													<div class="input-group">
															<span class="input-group-addon">Anjuke数据 (终)</span> 
															<input type="text" class="form-control" id="localLocation" name="localLocation">											
														</div>
    												</td>
    											</tr>
    										</tbody>
    									</table> 
    									<table width="100%" id="locationDistanceTB">
    										<tbody>    											
    											<tr>
    												<td>
    													<div class="input-group">
															<span class="input-group-addon">步行距离偏差值</span> 
															<input type="text" class="form-control"  id="locationDistance" name="locationDistance">											
														</div>
													</td>
    											</tr>
    										</tbody>
    									</table>   									
    									<div id="r_title"><b>Anjuke数据结果:</b></div>
    									<div style="height:230px; overflow-y:auto; border:0px solid;">
    									<table id="locationResultAJK" class="table table-hover table-striped">
    										<tbody>
    										
    										</tbody>
    									</table>
    									</div>	    								    															
									</div>
									<div class="col-md-6 column">										
    									<div id="iCenter"></div>						
									</div>
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
</body>  
</html>						

	
