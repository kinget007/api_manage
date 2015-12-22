package com.yyl.api.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.yyl.api.bean.ApiInfo;
import com.yyl.api.dao.ApiInfoDao;

/**
 * Servlet implementation class ModiJobServlet
 */
@WebServlet("/ModiJobServlet")
public class ModiJobServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ModiJobServlet() {
		super();
	}

	/**
	 * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String[] title = {"OrderNum", "Name", "Url", "Method", "Parame", "Assert"};
		List<ApiInfo> apiInfoList = ApiInfoDao.selectAllByField();

		for(ApiInfo apiInfo:apiInfoList){
			System.out.println(apiInfo.getCnName() + ":orderNum = " + apiInfo.getOrderNum() + ", getApiID = " + apiInfo.getApiID());
		}

		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");

		try {
			HttpSession session = request.getSession();
			if (request.getParameter("modi").equals("query")) {
				session.setAttribute("title", title);
				session.setAttribute("apiInfoList", apiInfoList);
				response.sendRedirect("/api_manage/apiJobEdit.jsp");
			} else if(request.getParameter("modi").equals("update")) {
				String apiID;
				String orderNum;
				String chName;
				String urlPath;
				String httpMethod;
				String paramIn;
				String resultInfo;

				for(int i=0;i<apiInfoList.size();i++){
					apiID = request.getParameter("apiInfoList[" + i + "].apiID");
					orderNum = request.getParameter("apiInfoList[" + i + "].orderNum");
					chName = request.getParameter("apiInfoList[" + i + "].cnName");
					urlPath = request.getParameter("apiInfoList[" + i + "].urlPath");
					httpMethod = request.getParameter("apiInfoList[" + i + "].httpMethod");
					paramIn = request.getParameter("apiInfoList[" + i + "].paramIn");
					resultInfo = request.getParameter("apiInfoList[" + i + "].resultInfo");

					System.out.println(apiID);
					System.out.println(orderNum);
					System.out.println(chName);
					System.out.println(urlPath);
					System.out.println(httpMethod);
					System.out.println(paramIn);
					System.out.println(resultInfo);

					ApiInfoDao.updateByCustom(orderNum,chName,urlPath,httpMethod,paramIn,resultInfo,apiID);
				}
				response.sendRedirect("/api_manage/ModiJobServlet?modi=query");
			}
		} catch (Exception e) {
			request.setAttribute("loginError", e.toString());
			PrintWriter out = response.getWriter();
			out.println("<style>.myCss {font-size: 24px; color: #FF0000; font-style: italic;text-align:center}</style>");
			out.println("<div class=\"myCss\">");
			out.println("<p>" + e.toString() + "</p>");
			out.println("</div>");
		}
	}
}