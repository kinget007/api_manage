package com.yyl.api.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.yyl.api.util.UrlRequest;

public class localLocation extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -377416766375026658L;

	/**
	 * Constructor of the object.
	 */
	public localLocation() {
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
		ArrayList<String> resultInfoList = new ArrayList<String>();
		//http://api.anjuke.com/web/comm?name=绿地国际SOHO城&cookie_version=9528_02_01
		
		String name = new String(request.getParameter("locationname").getBytes("ISO-8859-1"), "UTF-8");
		String cityName = new String(request.getParameter("cityName").getBytes("ISO-8859-1"), "UTF-8");
//		String name = request.getParameter("locationname");
//		String cityName = request.getParameter("cityName");
		
//		System.out.println(name + "XXXXXXXXXXXXX"+cityName);//URLDecoder.decode(value, "utf-8");
		
		String urlPath = "http://api.anjuke.com/web/comm";		
		String paramInValueJson = "{\"name\":\""+name+"\",\"cookie_version\":\"9528_02_01\",\"city\":\""+cityName+"\"}";
		resultInfoList = UrlRequest.getHttpResponseContent(urlPath, paramInValueJson, "", "get");
		JSONArray resultInfoArray = new JSONArray();

		if(JSONObject.fromObject(resultInfoList.get(1)).get("result").toString().equals("[]") || JSONObject.fromObject(resultInfoList.get(1)).get("result").toString().equals("参数错误")){
			PrintWriter out = response.getWriter();		
//			JSONObject jsonResult = new JSONObject();
//			jsonResult.accumulate("sosolng", "");
//			jsonResult.accumulate("sosolat", "");
			out.println(resultInfoArray);
			out.flush();
			out.close();
		}else{
			//JSONObject resultInfoJson = JSONObject.fromObject(JSONArray.fromObject(JSONObject.fromObject(resultInfoList.get(1)).get("result")).get(0));
			resultInfoArray = JSONArray.fromObject(JSONObject.fromObject(resultInfoList.get(1)).get("result"));
			PrintWriter out = response.getWriter();		
//			JSONObject jsonResult = new JSONObject();
//			jsonResult.accumulate("sosolng", resultInfoJson.get("sosolng"));
//			jsonResult.accumulate("sosolat", resultInfoJson.get("sosolat"));
			out.println(resultInfoArray);
			out.flush();
			out.close();
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
