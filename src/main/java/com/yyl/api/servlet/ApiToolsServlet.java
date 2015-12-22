package com.yyl.api.servlet;

import com.yyl.api.util.UrlRequest;
import net.sf.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;

public class ApiToolsServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public ApiToolsServlet() {
		super();
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");		
		String responseHeader = "";
		String resultInfo ="";
		ArrayList<String> resultInfoList = new ArrayList<String>();
		
		String urlPath = new String(request.getParameter("URLPath").getBytes("ISO-8859-1"), "UTF-8");
		String httpMethod = new String(request.getParameter("urlMethod").getBytes("ISO-8859-1"), "UTF-8");
		String paramInValueJson = new String(request.getParameter("jsonBody").getBytes("ISO-8859-1"), "UTF-8");
		String httpHeader = new String(request.getParameter("headIn").getBytes("ISO-8859-1"), "UTF-8");

//		System.out.println(URLDecoder.decode(urlPath, "utf-8"));
//		System.out.println(httpMethod);
//		System.out.println(URLDecoder.decode(paramInValueJson, "utf-8"));
//		System.out.println(URLDecoder.decode(httpHeader, "utf-8"));

//		resultInfoList = UrlRequest.getHttpResponseContent(urlPath, URLDecoder.decode(paramInValueJson, "utf-8"), httpHeader, httpMethod);
		resultInfoList = UrlRequest.getHttpResponseContent(urlPath, paramInValueJson, httpHeader, httpMethod);

//		resultInfoList = UrlRequest.getHttpResponseContent(urlPath, paramInValueJson, httpHeader, httpMethod);
		responseHeader = resultInfoList.get(0);	
		resultInfo = resultInfoList.get(1);	
		PrintWriter out = response.getWriter();
		JSONObject jsonResult = new JSONObject();
		jsonResult.accumulate("header", responseHeader);
		jsonResult.accumulate("result", resultInfo);
//		jsonResult.accumulate("jsonBody", paramInValueJson);//URLDecoder.decode(paramInValueJson, "utf-8")
		jsonResult.accumulate("jsonBody", URLEncoder.encode(URLDecoder.decode(paramInValueJson, "utf-8"), "utf-8"));//
		out.println(jsonResult);
		out.flush();
		out.close();
	}

}
