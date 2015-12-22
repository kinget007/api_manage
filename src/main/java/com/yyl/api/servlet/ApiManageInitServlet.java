package com.yyl.api.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import com.yyl.api.bean.ApiInfo;
import com.yyl.api.bean.CategoryFirst;
import com.yyl.api.bean.CategorySecond;
import com.yyl.api.dao.ApiInfoDao;
import com.yyl.api.dao.CategoryFirstDao;
import com.yyl.api.dao.CategorySecondDao;

public class ApiManageInitServlet extends HttpServlet {

    /**
     *
     */
    private static final long serialVersionUID = 1L;

    /**
     * Constructor of the object.
     */
    public ApiManageInitServlet() {
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
     * <p>
     * This method is called when a form has its tag value method equals to get.
     *
     * @param request  the request send by the client to the server
     * @param response the response send by the server to the client
     * @throws ServletException if an error occurred
     * @throws IOException      if an error occurred
     */
    public void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String result = request.getParameter("result");

        if (result.equals("categorys")) {
            // categoryFirstJson
            JSONArray categoryFirstJson = new JSONArray();
            List<CategoryFirst> categoryFirsts = CategoryFirstDao
                    .selectALLCategoryFirst();
            String jsonCategorySecondString = " ";
            JSONObject jsonCategoryFirst = new JSONObject();

//            JsonConfig jsonConfigSecond = new JsonConfig();
//            jsonConfigSecond.setExcludes(new String[]{"apiInfo", "categoryFirst"});

            for (int i = 0; i < categoryFirsts.size(); i++) {
                Iterator<CategorySecond> categoryFirst = categoryFirsts.get(i).getCategorySecond().iterator();
                while (categoryFirst.hasNext()) {
                    CategorySecond categorySecond = categoryFirst.next();
                    jsonCategorySecondString = jsonCategorySecondString + "|" + categorySecond.getCategorySecondID() + "*" + categorySecond.getCategorySecondName();
                }
                jsonCategorySecondString = categoryFirsts.get(i).getCategoryFirstID() + jsonCategorySecondString;
                jsonCategoryFirst.accumulate("categoryFirstID", categoryFirsts.get(i).getCategoryFirstID());
                jsonCategoryFirst.accumulate("categoryFirstName", categoryFirsts.get(i).getCategoryFirstName());
                jsonCategoryFirst.accumulate("categorySecond", jsonCategorySecondString);
                categoryFirstJson.add(i, jsonCategoryFirst);
                jsonCategorySecondString = " ";
                jsonCategoryFirst.clear();

            }
            out.println(categoryFirstJson);
            System.out.println(categoryFirstJson);
        } else if (result.equals("categoryFirst_apiInfo")) {

            // categoryFirst_apiInfo
            int categorySecondID = Integer.parseInt(request.getParameter("categorySecondID"));
            JSONArray categorySecondJson = new JSONArray();
            JSONArray apiInfoJson = new JSONArray();
            List<CategorySecond> categorySeconds = CategorySecondDao.selectBycategorySecondID(categorySecondID);
            JSONObject jsonCategorySecond = new JSONObject();

            JsonConfig jsonConfigapiInfo = new JsonConfig();
            jsonConfigapiInfo.setExcludes(new String[]{"categorySecond"});

            for (int i = 0; i < categorySeconds.size(); i++) {
                apiInfoJson = JSONArray.fromObject(categorySeconds.get(i).getApiInfo(), jsonConfigapiInfo);
                jsonCategorySecond.accumulate("categoryFirstID", categorySeconds.get(i).getCategoryFirst().getCategoryFirstID());
                jsonCategorySecond.accumulate("categorySecondID", categorySeconds.get(i).getCategorySecondID());
                jsonCategorySecond.accumulate("categorySecondName", categorySeconds.get(i).getCategorySecondName());
                jsonCategorySecond.accumulate("apiInfo", apiInfoJson);
                categorySecondJson.add(i, jsonCategorySecond);
                jsonCategorySecond.clear();

            }
            out.println(categorySecondJson);
            System.out.println(categorySecondJson);

        } else if (result.equals("apiInfo")) {
            int apiID = Integer.parseInt(request.getParameter("apiID"));
            JSONArray apiInfoJson = new JSONArray();
            JSONObject jsonApiInfo = new JSONObject();
            List<ApiInfo> apiInfos = ApiInfoDao.selectByapiID(apiID);

            JsonConfig jsonConfigapiInfo = new JsonConfig();
            jsonConfigapiInfo.setExcludes(new String[]{"categorySecond"});
            for (int i = 0; i < apiInfos.size(); i++) {
                apiInfoJson = JSONArray.fromObject(apiInfos.get(i), jsonConfigapiInfo);
                jsonApiInfo.accumulate("apiInfo", apiInfoJson);
                apiInfoJson.clear();
            }

            out.println(jsonApiInfo);
        } else if (result.equals("searchAll")) {
            JSONObject jsonSearchOneInfo = new JSONObject();
            JSONObject jsonSearchApiOneInfo = new JSONObject();
            JSONArray jsonSearchApiAllInfo = new JSONArray();
            List<CategoryFirst> categoryFirsts = CategoryFirstDao.selectALLCategoryFirst();
            for (int i = 0; i < categoryFirsts.size(); i++) {
                Iterator<CategorySecond> CategorySeconds = categoryFirsts.get(i).getCategorySecond().iterator();
                while (CategorySeconds.hasNext()) {
                    CategorySecond categorySecond = CategorySeconds.next();
                    Iterator<ApiInfo> apiInfos = categorySecond.getApiInfo().iterator();
                    while (apiInfos.hasNext()) {
                        ApiInfo apiInfo = apiInfos.next();
                        jsonSearchApiOneInfo.accumulate("id", categorySecond.getCategorySecondID() + "*" + apiInfo.getApiID());
                        jsonSearchApiOneInfo.accumulate("display", apiInfo.getUrlPath());
                        jsonSearchApiAllInfo.add(jsonSearchApiOneInfo);
                        jsonSearchApiOneInfo.clear();
                    }
                }
                jsonSearchOneInfo.accumulate(categoryFirsts.get(i).getCategoryENFirstName(), jsonSearchApiAllInfo);
                jsonSearchApiAllInfo.clear();
            }
            out.println(jsonSearchOneInfo);
        } else if (result.equals("apiEdit")) {
            int apiID = Integer.parseInt(request.getParameter("apiID"));
            JSONObject jsonApiInfo = new JSONObject();
            JSONArray jsonApiInfos = new JSONArray();

            JSONObject jsonApiInfoJSON = new JSONObject();
            JSONObject categoryFirstJSON = new JSONObject();
            JSONObject categorySecondJSON = new JSONObject();
            List<ApiInfo> apiInfos = ApiInfoDao.selectByapiID(apiID);

            JsonConfig jsonConfigapiInfo = new JsonConfig();
            jsonConfigapiInfo.setExcludes(new String[]{"categorySecond"});
            for (int i = 0; i < apiInfos.size(); i++) {
                categorySecondJSON.accumulate("categorySecondID", apiInfos.get(i).getCategorySecond().getCategorySecondID());
                categorySecondJSON.accumulate("categorySecondName", apiInfos.get(i).getCategorySecond().getCategorySecondName());

                categoryFirstJSON.accumulate("categoryFirstID", apiInfos.get(i).getCategorySecond().getCategoryFirst().getCategoryFirstID());
                categoryFirstJSON.accumulate("categoryFirstName", apiInfos.get(i).getCategorySecond().getCategoryFirst().getCategoryFirstName());

                jsonApiInfoJSON.accumulate("apiInfo", JSONArray.fromObject(apiInfos.get(i), jsonConfigapiInfo));

                jsonApiInfo.accumulate("apiInfo", jsonApiInfoJSON);
                jsonApiInfo.accumulate("categoryFirst", categoryFirstJSON);
                jsonApiInfo.accumulate("categorySecond", categorySecondJSON);

                jsonApiInfoJSON.clear();
                categoryFirstJSON.clear();
                categorySecondJSON.clear();

                jsonApiInfos.add(i, jsonApiInfo);
                jsonApiInfo.clear();
            }

            out.println(jsonApiInfos);
        }

        out.flush();
        out.close();
    }

    /**
     * The doPost method of the servlet. <br>
     * <p>
     * This method is called when a form has its tag value method equals to
     * post.
     *
     * @param request  the request send by the client to the server
     * @param response the response send by the server to the client
     * @throws ServletException if an error occurred
     * @throws IOException      if an error occurred
     */
//    public void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        doPost(request, response);
//    }

    /**
     * Initialization of the servlet. <br>
     *
     * @throws ServletException if an error occurs
     */
    public void init() throws ServletException {
        // Put your code here
    }

}
