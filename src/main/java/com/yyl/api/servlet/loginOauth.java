package com.yyl.api.servlet;

import com.yyl.api.bean.UserInfo;
import com.yyl.api.dao.UserInfoDao;

import java.io.IOException;

import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class loginOauth extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7145842393925411110L;

	/**
	 * Constructor of the object.
	 */
	public loginOauth() {
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
			String username = request.getParameter("username");
//			String password = request.getParameter("password");

			HttpSession session = request.getSession();
			List<UserInfo> userInfo = UserInfoDao.selectBycode(username);
			if(null!=userInfo && userInfo.size() == 1){
				if(userInfo.get(0).getCode().equals("admin")){
					page = "runTask.jsp";
				}else{
					page = "index.jsp";
				}
				session.setAttribute("code", userInfo.get(0).getCode());
				session.setAttribute("name", userInfo.get(0).getName());
			}else{
				page = "login.jsp";
				request.getSession().removeAttribute("code");
				request.getSession().removeAttribute("name");
				request.getSession().invalidate();
				request.setAttribute("loginError","登录失败，用户不存在！");
			}
		}catch(Exception e){
			request.setAttribute("loginError",e.toString());
		}finally{
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request,response);
		}
	}


	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException if an error occurs
	 */
	public void init() throws ServletException {
		// Put your code here
	}

}
