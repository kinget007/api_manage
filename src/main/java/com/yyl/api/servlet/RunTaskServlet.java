package com.yyl.api.servlet;

import com.yyl.api.util.CmdInvoke;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class RunTaskServlet extends HttpServlet {

	/**
	 *
	 */
	private static final long serialVersionUID = 7145842393925411110L;

	/**
	 * Constructor of the object.
	 */
	public RunTaskServlet() {
		super();
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
	}

	/**
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
//		response.setDateHeader("Expires", 0);
//		response.addHeader("Cache-Control", "no-cache");//浏览器和缓存服务器都不应该缓存页面信息
//		response.addHeader("Cache-Control", "no-store");//请求和响应的信息都不应该被存储在对方的磁

//		response.setHeader("Pragma", "No-cache");//HTTP 1.1
//		response.setHeader("Cache-Control", "no-cache");//HTTP 1.0
//		response.setHeader("Expires", "0");//防止被proxy

//		response.setDateHeader("Expires", 0);
//		response.setHeader("Cache-Control", "no-cache");
//		response.setHeader("Pragma", "no-cache");

		try{
			String cmd = null;
			String os = System.getProperty("os.name");

			if (os.toLowerCase().startsWith("win")) {
//				cmd = "cmd /c ant run -DENV_CHOICE={0} -buildfile {1}";
			} else {
				cmd = "sh /Users/apple/Documents/pro/api_manage/runApi.sh";
			}
			CmdInvoke.run(cmd);
		}catch(Exception e){
			System.out.println(e.getStackTrace());
			request.setAttribute("loginOutError",e.toString());
		}finally{
			RequestDispatcher rd = request.getRequestDispatcher("runTask.jsp?timestamp=" + System.currentTimeMillis());
			rd.forward(request, response);
		}
	}
}