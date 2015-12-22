package com.yyl.api.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import com.yyl.api.bean.UserInfo;
import com.yyl.api.dao.UserInfoDao;

public class addAttention extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6844339936924018022L;

	/**
	 * Constructor of the object.
	 */
	public addAttention() {
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

		doPost(request, response);
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

		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		
		String select = request.getParameter("result");
		PrintWriter out = response.getWriter();
		
		
		if(select.equals("add")){
			String code = new String(request.getParameter("code").getBytes("ISO-8859-1"), "UTF-8");
			int apiID =  Integer.parseInt(request.getParameter("apiID"));
			UserInfoDao.addAttention(code, apiID);
			JSONObject result = new JSONObject();
			result.accumulate("result", "ok");
			out.println(result);			
		}
		
		if(select.equals("del")){
			String code = new String(request.getParameter("code").getBytes("ISO-8859-1"), "UTF-8");
			int apiID =  Integer.parseInt(request.getParameter("apiID"));
			UserInfoDao.delAttention(code, apiID);
			JSONObject result = new JSONObject();
			result.accumulate("result", "ok");
			out.println(result);			
		}
		
		if(select.equals("select")){
			String code = new String(request.getParameter("code").getBytes("ISO-8859-1"), "UTF-8");
			JSONArray apiInfoJson = new JSONArray();
			JsonConfig jsonConfigapiInfo = new JsonConfig();
			jsonConfigapiInfo.setExcludes(new String[] { "categorySecond" });
			List<UserInfo> userInfos = UserInfoDao.selectBycode(code);
			for(int i = 0; i<userInfos.size();i++){
				apiInfoJson =  JSONArray.fromObject(userInfos.get(i).getApiInfos(), jsonConfigapiInfo);
			}			
			JSONObject result = new JSONObject();
			result.accumulate("apiInfo", apiInfoJson);
			out.println(result);			
		}
		out.flush();
		out.close();	
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
