package com.yyl.api.servlet;

import com.yyl.api.util.FileUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet implementation class ViewLogs
 */
@WebServlet("/ViewLogs")
public final class ViewLogs extends HttpServlet {

	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ViewLogs() {
		super();
	}

	/**
	 * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String encodeStr;
		String baseDir = "/Users/apple/Documents/gitlab/api_manage/web/result/";
		String[] title = { "序号", "接口", "结果" };
		List<String[]> data = null;
		List<String> reports = null;
		List<String> logs = null;

		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
//		response.addHeader("Cache-Control", "no-cache");//浏览器和缓存服务器都不应该缓存页面信息
//		response.addHeader("Cache-Control", "no-store");//请求和响应的信息都不应该被存储在对方的磁

//		response.setHeader("Expires", "0");//防止被proxy
//		response.setDateHeader("Expires", 0);
		response.setHeader("Cache-Control", "no-cache");
		response.setHeader("Pragma", "no-cache");

//		System.out.println(request.getContextPath());
//		System.out.println(request.getSession().getServletContext().getRealPath(""));
//		System.out.println(new java.io.File(application.getRealPath(request.getRequestURI())).getParent());
//		System.out.println(this.getClass().getClassLoader().getResource("").getPath());
//		System.out.println(request.getServletContext().getRealPath(""));

		try {
			reports = FileUtil.getDirs(baseDir, 1);
			logs = FileUtil.getFiles(baseDir + reports.get(0) + "/log", "html", 1);
//
			data = new ArrayList<String[]>();
			for(int i = 0;i<logs.size();i++){
				encodeStr = URLEncoder.encode(logs.get(i),"utf-8");
				data.add(new String[] { Integer.toString(i + 1), logs.get(i).split("\\.")[0].split("_")[1], "/api_manage/result/" + reports.get(0) + "/log/" + encodeStr });
			}

			if (null != data && data.size() != 0) {
				HttpSession session = request.getSession();
				session.setAttribute("title", title);
				session.setAttribute("data", data);
				response.sendRedirect("/api_manage/ViewLogs.jsp?timestamp=" + System.currentTimeMillis());
			} else {
				PrintWriter out = response.getWriter();
				out.println("<style>.myCss {font-size: 24px; color: #FF0000; font-style: italic;text-align:center}</style>");
				out.println("<div class=\"myCss\">");
				out.println("<p>日志信息正在处理中，请稍后查看...</p>");
				out.println("</div>");
			}
		} catch (Exception e) {
			request.setAttribute("loginError", e.toString());
		}
	}
}