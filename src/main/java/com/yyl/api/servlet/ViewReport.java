package com.yyl.api.servlet;

import com.yyl.api.util.FileUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Servlet implementation class ViewReport
 */
@WebServlet("/ViewReport")
public final class ViewReport extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String report = null;
		String baseDir = "/Users/apple/Documents/gitlab/api_manage/web/result/";
		List<String> reports = null;

		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
//		response.setDateHeader("Expires", 0);
//		response.addHeader("Cache-Control", "no-cache");//浏览器和缓存服务器都不应该缓存页面信息
//		response.addHeader("Cache-Control", "no-store");//请求和响应的信息都不应该被存储在对方的磁

		response.setHeader("Pragma", "No-cache");//HTTP 1.1
		response.setHeader("Cache-Control", "no-cache");//HTTP 1.0

		try {
			PrintWriter out = response.getWriter();
			reports = FileUtil.getDirs(baseDir, 1);
			report = "/api_manage/result/" + reports.get(0) + "/report/html/index.html?timestamp=" + System.currentTimeMillis();
//			report = "/api_manage/result/" + reports.get(0) + "/report/html/index.html";
//			report = "file:///Users/apple/Documents/pro/api_manage/web/result/report/report/html/index.html";
			if (null != report && !report.equals("")) {
				response.sendRedirect(report);
//				out.println("<script type='text/javascript'>");
//				out.println("window.open('" + report + "')");
//				out.println("</script>");
			} else {
				out.println("<style>.myCss {font-size: 24px; color: #FF0000; font-style: italic;text-align:center}</style>");
				out.println("<div class=\"myCss\">");
				out.println("<p>报告正在处理中，请稍后查看...</p>");
				out.println("</div>");
			}
		} catch (Exception e) {
			request.setAttribute("loginError", e.toString());
		}
	}
}