package com.yyl.api.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.yyl.api.bean.ApiInfo;
import com.yyl.api.bean.CategorySecond;
import com.yyl.api.dao.ApiInfoDao;
import com.yyl.api.dao.CategorySecondDao;

public class EditapiInfoServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1686088387965798886L;

	/**
	 * Constructor of the object.
	 */
	public EditapiInfoServlet() {
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

		ApiInfo apiInfo = new ApiInfo();
		CategorySecond categorySecond = new CategorySecond();
		
		int categorySecondID = Integer.parseInt(request.getParameter("categorySecondID"));
		int apiID =  Integer.parseInt(request.getParameter("apiID"));
		
		int isLogin = Integer.parseInt(request.getParameter("isLogin"));
		String httpMethod = request.getParameter("httpMethod");
		String cnName = new String(request.getParameter("cnName").getBytes("ISO-8859-1"), "UTF-8");
		String author = new String(request.getParameter("author").getBytes("ISO-8859-1"), "UTF-8");
		String editInfo = new String(request.getParameter("editInfo").getBytes("ISO-8859-1"), "UTF-8");
		String urlPath = new String(request.getParameter("urlPath").getBytes("ISO-8859-1"), "UTF-8");
		String httpHeader = new String(request.getParameter("httpHeader").getBytes("ISO-8859-1"), "UTF-8");
		String paramIn = new String(request.getParameter("paramInValue").getBytes("ISO-8859-1"), "UTF-8");
		String paramOut = new String(request.getParameter("paramOutValue").getBytes("ISO-8859-1"), "UTF-8");
		//String paramInValueJson = new String(request.getParameter("paramInValueJson").getBytes("ISO-8859-1"), "UTF-8");
		String tableInfo = new String(request.getParameter("tableInfoValue").getBytes("ISO-8859-1"), "UTF-8");//
		String resultInfo = new String(request.getParameter("showResult").getBytes("ISO-8859-1"), "UTF-8");
		
		//String resultInfo = UrlRequest.getHttpResponseContent(urlPath, paramInValueJson, httpHeader, httpMethod);
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
	
		apiInfo.setApiID(apiID);
		apiInfo.setHttpMethod(httpMethod);
		apiInfo.setCnName(cnName);
		apiInfo.setIsLogin(isLogin);
		apiInfo.setAuthor(author);
		apiInfo.setEditInfo(editInfo);
		apiInfo.setUrlPath(urlPath);
//		apiInfo.setUrlPath(new URL(urlPath).getPath());
		apiInfo.setHttpHeader(httpHeader);
		apiInfo.setParamIn(paramIn);
		apiInfo.setParamOut(paramOut);
		apiInfo.setResultInfo(resultInfo);
		apiInfo.setTableInfo(tableInfo);
				
		categorySecond = CategorySecondDao.selectBycategorySecondID(categorySecondID).get(0);
		
		apiInfo.setCategorySecond(categorySecond);
		
		ApiInfoDao.updateApiInfo(apiInfo);
		response.sendRedirect("/api_manage/apiEdit.jsp?dealiInfo=ok&categorySecondID="+categorySecondID+"&apiID="+apiID);		
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
