<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String path = request.getContextPath();
  String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort();
%>

<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <title>api manage login</title>

  <meta name="description" content="">
  <meta name="author" content="!">

  <link href="common/css/bootstrap.min.css" rel="stylesheet">
  <link href="common/css/style.css" rel="stylesheet">

  <style>
    html,body{text-align:center;margin:0px auto;}
  </style>

</head>
<body onload= "document.all.username.select() ">

<div class="container-fluid">
  <div class="row">
    <div class="col-md-12">
      <h3 class="text-center">
        API测试管理系统
      </h3>
    </div>
  </div>
</div>
<div class="container-fluid">
  <div class="row">
    <div class="col-md-12">
      <form role="form" name = "login" id = "login" action="/api_manage/loginOauth" method="post">
        <div class="form-group">
          <label for="username">
            用户名：
          </label>
          <input type="text" id="username" name="username" value="${requestScope.username}" size="20" maxlength="20" style="width:200px">
          &nbsp;&nbsp;&nbsp;<font color = "#FF0000">${requestScope.loginError}</font>
          <!--<input type="email" class="form-control" id="username" size="20" maxlength="20" style="width:200px">-->
        </div>
        <%--<div class="form-group">--%>
          <%--<label for="password">--%>
            <%--&nbsp;&nbsp;&nbsp;密码：--%>
          <%--</label>--%>
        <%--<input type="password" id="password" size="20" maxlength="20" style="width:200px">--%>
        <%--</div>--%>
        <button type="submit" class="btn btn-default">
          登录
        </button>
      </form>
    </div>
  </div>
</div>

<script src="common/js/jquery.min.js"></script>
<script src="common/js/bootstrap.min.js"></script>
<script src="common/js/scripts.js"></script>
</body>
</html>