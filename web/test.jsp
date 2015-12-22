<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort();
   // if(session.getAttribute("name")==null){response.sendRedirect("/api_manage/loginOauth");}
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
<link rel="apple-touch-icon-precomposed" sizes="144x144"
	href="common/img/apple-touch-icon-144-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="114x114"
	href="common/img/apple-touch-icon-114-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="72x72"
	href="common/img/apple-touch-icon-72-precomposed.png">
<link rel="apple-touch-icon-precomposed"
	href="common/img/apple-touch-icon-57-precomposed.png">
<link rel="shortcut icon" href="common/img/favicon.png">

<script type="text/javascript" src="common/js/jquery.min.js"></script>
<script type="text/javascript" src="common/js/bootstrap.min.js"></script>
<script type="text/javascript" src="common/js/jsonFormater.js"></script>
<script type="text/javascript" src="common/js/purl.js"></script>
<script type="text/javascript" src="common/js/jquery.typeahead.js"></script>

</head>
<script>
	$(document).ready(function() {

		$("#progressModal").modal('show');
	});
	var p = 0;
	$(function() {
		run();
	});
	function run() {
		p += 5;
		$("#progress").css("width", p + "%");
		if (p < 100) {
			setTimeout("run()", 300);
		} else {
			$("#progressModal").modal('hide');
		}
	}
	
	
</script>

<script type="text/javascript" language="javascript">
        $(function() {

            $("#test").click(function() {
                $.ajax({
                    type: "GET",
                    url: "http://auth.corp.anjuke.com/oauth/2.0/user",
                    beforeSend: function(request) {
                        request.setRequestHeader("Authorization", "bearer tjzk1cd3kuwhscx6g6m5nij0qzvqtti36t051mgx");
                    },
                    success: function(result) {
                        alert(result);
                    }
                });
            });
        });
    </script>

<body>

<form id="form1" runat="server">
<span class="input-group-addon">
        <input type="checkbox">
      </span>


    <div id="v">
    </div>
    <input type="button" value="测试" id="test" />
    </form>


	<!-- Modal progress-->
	<div class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog"
		aria-labelledby="mySmallModalLabel" aria-hidden="true"
		id="progressModal">
		<div class="modal-dialog modal-sm">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">玩命加载中...</h4>
				</div>
				<div class="modal-body">
					<table style="overflow:auto;" border="0px" width="100%">
						<tr>
							<td id="progressMessage">

								<div class="progress">
									<div id="progress" name="progress"
										class="progress-bar progress-bar-success progress-bar-striped"
										role="progressbar" aria-valuenow="40" aria-valuemin="0"
										aria-valuemax="100" style="width: 0%"></div>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>

</body>
</html>