package com.yyl.api.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
		// Put your code here
	}

	/**
	 * The doGet method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
		//https://auth.corp.anjuke.com/oauth/2.0/login?return_to=%2Flogin%2Fauthorize%3Fclient_id%3Dmqjinq77y2q3guvc64n8
		
		String OAUTH2_BASE_URL = "https://auth.corp.anjuke.com";
		String OAUTH2_CODE_URI = "/oauth/2.0/login/authorize";
		//online
		String client_id="mqjinq77y2q3guvc64n8";
		//localhost
//		String client_id="nadeb3d2yc137jokckg6";
		
		OAUTH2_CODE_URI = OAUTH2_BASE_URL + OAUTH2_CODE_URI + "?client_id=" + client_id;

		response.setStatus(HttpServletResponse.SC_MOVED_TEMPORARILY);
		response.setHeader("Location", OAUTH2_BASE_URL+"/oauth/2.0/login?return_to=%2Flogin%2Fauthorize%3Fclient_id%3D"+client_id);
	}

	/**
	 * The doPost method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to post.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doPost(request, response);
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
