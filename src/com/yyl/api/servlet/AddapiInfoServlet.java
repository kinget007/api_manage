package com.yyl.api.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.yyl.api.bean.ApiInfo;
import com.yyl.api.bean.CategoryFirst;
import com.yyl.api.bean.CategorySecond;
import com.yyl.api.dao.ApiInfoDao;
import com.yyl.api.dao.CategoryFirstDao;
import com.yyl.api.dao.CategorySecondDao;

public class AddapiInfoServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * Constructor of the object.
	 */
	public AddapiInfoServlet() {
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
	 * @param request
	 *            the request send by the client to the server
	 * @param response
	 *            the response send by the server to the client
	 * @throws ServletException
	 *             if an error occurred
	 * @throws IOException
	 *             if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		doPost(request, response);
	}

	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");

		ApiInfo apiInfo = new ApiInfo();
		CategoryFirst categoryFirst = new CategoryFirst();
		CategorySecond categorySecond = new CategorySecond();
		
		int categoryFirstID =  Integer.parseInt(request.getParameter("categoryFirstID"));
		int categorySecondID = Integer.parseInt(request.getParameter("categorySecondID"));
		int isLogin = Integer.parseInt(request.getParameter("isLogin"));
		String httpMethod = request.getParameter("httpMethod");
		String cnName = new String(request.getParameter("cnName").getBytes("ISO-8859-1"), "UTF-8");
		String author = new String(request.getParameter("author").getBytes("ISO-8859-1"), "UTF-8");
		String editInfo = new String(request.getParameter("editInfo").getBytes("ISO-8859-1"), "UTF-8");
		String urlPath = new String(request.getParameter("urlPath").getBytes("ISO-8859-1"), "UTF-8");
		String httpHeader = new String(request.getParameter("httpHeader").getBytes("ISO-8859-1"), "UTF-8");
		String paramIn = new String(request.getParameter("paramInValue").getBytes("ISO-8859-1"), "UTF-8");
		String paramOut = new String(request.getParameter("paramOutValue").getBytes("ISO-8859-1"), "UTF-8");
		//String resultInfo = new String(request.getParameter("resultInfo").getBytes("ISO-8859-1"), "UTF-8");
		//String paramInValueJson = new String(request.getParameter("paramInValueJson").getBytes("ISO-8859-1"), "UTF-8");
		//String paramInValueJson2 = new String(request.getParameter("paramInValueJson2").getBytes("ISO-8859-1"), "UTF-8");
		String tableInfo = new String(request.getParameter("tableInfoValue").getBytes("ISO-8859-1"), "UTF-8");
		
		String resultInfo = new String(request.getParameter("showResult").getBytes("ISO-8859-1"), "UTF-8");
		
		//String resultInfo = UrlRequest.getHttpResponseContent(urlPath, paramInValueJson2, httpHeader, httpMethod);
		//resultInfo = resultInfo.substring(resultInfo.indexOf("*")+1, resultInfo.length());		

		if(httpHeader.equals("")){
			httpHeader="{}";
		}
		if(paramIn.equals("")){
			paramIn="{\"paramIn\": [{\"paramName\":\"\",\"paramDescription\":\"\",\"paramType\":\"\",\"paramDefault\":\"\",\"isLogin\":\"\"}]}";
		}
		if(paramOut.equals("")){
			paramOut="{\"paramOut\": [{\"paramName\":\"\",\"paramDescription\":\"\"}]}";
		}
		if(tableInfo.equals("")){
			tableInfo="{\"tableInfo\": [{\"datebaseName\":\"\",\"tableName\":\"\",\"ipAddress\":\"\"}]}";
		}
		
		apiInfo.setHttpMethod(httpMethod);
		apiInfo.setCnName(cnName);
		apiInfo.setIsLogin(isLogin);
		apiInfo.setAuthor(author);
		apiInfo.setEditInfo(editInfo);
//		apiInfo.setUrlPath(new URL(urlPath).getPath());
		apiInfo.setUrlPath(urlPath);
		apiInfo.setHttpHeader(httpHeader);
		apiInfo.setParamIn(paramIn);
		apiInfo.setParamOut(paramOut);
		apiInfo.setResultInfo(resultInfo);
		apiInfo.setTableInfo(tableInfo);
		
		categoryFirst = CategoryFirstDao.selectBycategoryFirstID(categoryFirstID).get(0);		
		categorySecond = CategorySecondDao.selectBycategorySecondID(categorySecondID).get(0);
		
		int duplicate = ApiInfoDao.selectByurlPath(urlPath).size();
		
		if(duplicate > 0){
			response.sendRedirect("/api_manage/apiAdd.jsp?dealiInfo=duplicate");
		}
		else if (duplicate == 0){
			ApiInfoDao.addApiInfo(categoryFirst, categorySecond, apiInfo);		
			response.sendRedirect("/api_manage/apiAdd.jsp?dealiInfo=ok");
		}	
	}

	/**
	 * Initialization of the servlet. <br>
	 * 
	 * @throws ServletException
	 *             if an error occurs
	 */
	public void init() throws ServletException {
		// Put your code here
	}

}
