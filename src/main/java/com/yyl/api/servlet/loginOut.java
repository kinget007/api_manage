package com.yyl.api.servlet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class loginOut extends HttpServlet {

	/**
	 *
	 */
	private static final long serialVersionUID = 7145842393925411110L;

	/**
	 * Constructor of the object.
	 */
	public loginOut() {
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

		String page = "login.jsp";

		try{
			request.getSession().removeAttribute("code");
			request.getSession().removeAttribute("name");
			request.getSession().invalidate();
		}catch(Exception e){
			request.setAttribute("loginOutError",e.toString());
		}finally{
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request,response);
		}
	}
}
