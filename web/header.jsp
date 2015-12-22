<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<div class="row clearfix">
	<div class="col-md-12 column" id="menuActive">
		<table width="100%">
			<tbody>
				<tr>
					<td width="100%">
						<ul class="nav nav-tabs">
							<li class="active"><a href="/api_manage/index.jsp">首页</a></li>
							<%
								if(null != session.getAttribute("code") && "admin".equals(session.getAttribute("code"))){
							%>
							<li><a href="/api_manage/runTask.jsp">任务管理</a></li>
							<%
								}else{
							%>
							<li><a href="javascript:void(0);"  onclick="this.setAttribute('disabled','disabled')">任务管理</a></li>
							<%
									}
							%>
							<li><a href="/api_manage/apiAttention.jsp">关注列表</a></li>
							<%--<li><a href="/api_manage/apiAdd.jsp">新增</a></li>--%>
							<li><a href="/api_manage/apiTools.jsp">在线测试工具</a></li>
							<%--<li><a href="/api_manage/apiPlan.jsp">测试计划</a></li>--%>
							<li><a href="javascript:void(0);"  onclick="this.setAttribute('disabled','disabled')">测试计划</a></li>
							<%--<li><a href="/api_manage/markdownEdit.jsp">MarkDown</a></li>--%>
							<%--<li><a href="/api_manage/anjukeLocation.jsp">位置查询</a></li>--%>
							<li><a href="/api_manage/about.jsp">About</a></li>
							<%
								if(null != session.getAttribute("code") && null != session.getAttribute("name")){
							%>
							<li class="pull-right"><a href="/api_manage/loginOut"> 您好 <%=session.getAttribute("name")%> 注销</a></li>
							<%
								} else {
							%>
							<li class="pull-right"><a href=/api_manage/login.jsp> Login </a></li>
							<%
								}
							%>
							
						</ul>

					</td>					
				</tr>
			</tbody>
		</table>

		<!--  
		<ul class="nav nav-pills" role="tablist">
			<li role="presentation" class="active"><a href="/api_manage/index.jsp">Home</a></li>
			<li role="presentation"><a href="/api_manage/apiDetail.jsp">API详情</a></li>
			<li role="presentation"><a href="/api_manage/apiTools.jsp">ApiTools</a></li>
			<li role="presentation" class="dropdown pull-right">
			<a href="#" data-toggle="dropdown" class="dropdown-toggle">Dropdown
			<strong class="caret"></strong>
			</a>
				<ul class="dropdown-menu">
					<li><a href="#">Action</a></li>
					<li><a href="#">Another action</a></li>
					<li><a href="#">Something else here</a></li>
					<li class="divider"></li>
					<li><a href="#">Separated link</a></li>
				</ul></li>
		</ul>
		-->
	</div>
</div>

