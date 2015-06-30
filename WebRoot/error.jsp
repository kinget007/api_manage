<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page isErrorPage="true"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.io.*"%>
<%
	response.setStatus(HttpServletResponse.SC_OK);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>错误页面</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="">
<meta name="author" content="">
<!--link rel="stylesheet/less" href="common/less/bootstrap.less" type="text/css" /-->
<!--link rel="stylesheet/less" href="common/less/responsive.less" type="text/css" /-->
<!--script src="common/js/less-1.3.3.min.js"></script-->
<!--append ‘#!watch’ to the browser URL, then refresh the page. -->

<link href="common/css/bootstrap.min.css" rel="stylesheet">
<link href="common/css/style.css" rel="stylesheet">
<link href="common/css/errorstyle.css" rel="stylesheet">

<!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
<!--[if lt IE 9]>
<script src="common/js/html5shiv.js"></script>
<![endif]-->
<link href="common/google-code-prettify/prettify.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="common/js/jquery.min.js"></script>
<script type="text/javascript" src="common/js/bootstrap.min.js"></script>
<script type="text/javascript" src="common/js/custom.js"></script>
</head>
<body>

<!-- <div style="background: #AAD5FF;" > -->
    <div id="clouds">
        <img src="common/img/cloud1.png" class="cloud1" alt="cloud" data-speed="8">
        <img src="common/img/cloud3.png" class="cloud3" alt="cloud" data-speed="7">
        <img src="common/img/cloud2.png" class="cloud2" alt="cloud" data-speed="9">
        <img src="common/img/cloud4.png" class="cloud4" alt="cloud" data-speed="10">
	</div>
    <div id="main">    	
        <div class="container">
            <div id="sun"><img src="common/img/sun.png" alt="sun"></div>
			<div class="bubble-text-container">
				<div class="wrapper">				
					<p class="bubble-text"><noscript></noscript></p>					
				</div>
			</div>
				
            <div class="content">
                <div class="error-container">
                    <h1>404</h1>
                    <p>oops!</p>
                </div>
                <button type="button" class="btn btn-xs btn-info"
					data-toggle="modal" data-target="#myModal" id="paramInEnsure">详细错误信息</button>                                   
            </div>
        </div>
    </div>
	<!-- Modal -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">详细错误信息</h4>
				</div>
				<div class="modal-body">
					<table class="table table-bordered" style="overflow:auto;">
						<tbody>
							<pre>
                <%
                	try {
                		//全部内容先写到内存，然后分别从两个输出流再输出到页面和文件
                		ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
                		PrintStream printStream = new PrintStream(byteArrayOutputStream);

                		printStream.println();
                		printStream.println("用户信息");
                		printStream.println("账号："
                				+ request.getSession().getAttribute("userName"));
                		printStream
                				.println("访问的路径: "
                						+ request
                								.getAttribute("javax.servlet.forward.request_uri"));
                		printStream.println();

                		printStream.println("异常信息");
                		printStream.println(exception.getClass() + " : "
                				+ exception.getMessage());
                		printStream.println();

                		Enumeration<String> e = request.getParameterNames();
                		if (e.hasMoreElements()) {
                			printStream.println("请求中的Parameter包括：");
                			while (e.hasMoreElements()) {
                				String key = e.nextElement();
                				printStream.println(key
                						+ "="
                						+ new String(request.getParameter(key)
                								.getBytes("ISO-8859-1"), "UTF-8"));
                			}
                			printStream.println();
                		}

                		printStream.println("堆栈信息");
                		exception.printStackTrace(printStream);
                		printStream.println();

                		out.print(byteArrayOutputStream); //输出到网页

                		File dir = new File(request.getRealPath("/errorLog"));
                		if (!dir.exists()) {
                			dir.mkdir();
                		}
                		String timeStamp = new SimpleDateFormat("yyyyMMddhhmmssS")
                				.format(new Date());
                		FileOutputStream fileOutputStream = new FileOutputStream(
                				new File(dir.getAbsolutePath() + File.separatorChar
                						+ "error-" + timeStamp + ".txt"));
                		new PrintStream(fileOutputStream).print(byteArrayOutputStream); //写到文件

                	} catch (Exception ex) {
                		ex.printStackTrace();
                	}
                %>
            </pre>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>