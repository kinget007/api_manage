package com.yyl.api.servlet;

import java.io.IOException;
import java.util.Enumeration;
import java.util.Iterator;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.yyl.api.bean.UserInfo;
import com.yyl.api.dao.UserInfoDao;
import com.yyl.api.util.FormatJson;
import com.yyl.api.util.UrlRequest;

public class CallBackServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1343172121755599932L;

	/**
	 * Constructor of the object.
	 */
	public CallBackServlet() {
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

		@SuppressWarnings("rawtypes")
		Enumeration enu=request.getParameterNames();  
		while(enu.hasMoreElements()){  
		String paraName=(String)enu.nextElement();
		//System.out.println(paraName+": "+request.getParameter(paraName)); 
		
		String code = request.getParameter("code");		
		String OAUTH2_BASE_URL = "https://auth.corp.anjuke.com";
		//String OAUTH2_CODE_URI = "/oauth/2.0/login/authorize";
		String OAUTH2_TOKEN_URI = "/oauth/2.0/login/token";
		String OAUTH2_USER_URI = "/oauth/2.0/user";
		//online
		String client_id="mqjinq77y2q3guvc64n8";
		String client_secret = "0bzide2jibebbekauhzu4napacglx20mj1efed7p";
		
		//localhost
//		String client_id="nadeb3d2yc137jokckg6";
//		String client_secret = "whym54qxfurr65bg8gz2oojxgf1vyfosrcsx967v";
		
		if(paraName.equals("code")){			
			String tokenResult = "";
			String AuthorizationInfo = "";
			String userInfosStr = "";
			
			JSONObject tokenJsonObject = new JSONObject();
			JSONObject AuthorizationjsonObject = new JSONObject();
			JSONArray userInfosJsonArray = new JSONArray();
			
			OAUTH2_TOKEN_URI = OAUTH2_BASE_URL + OAUTH2_TOKEN_URI + "?client_id="+client_id+"&client_secret="+client_secret+"&code="+code;
					
			FormatJson tool = new FormatJson();		
					
		
				tokenResult = UrlRequest.httpclient_url(OAUTH2_TOKEN_URI,tool.jsonTOHeadMap(""),"post",new JSONObject()).get(1);			
				tokenResult = "{\"" + tokenResult.substring(tokenResult.indexOf("*")+1, tokenResult.length()).replace("=", "\":\"").replace("&", "\",\"") + "\"}";			

				tokenJsonObject = JSONObject.fromObject(tokenResult);		
				@SuppressWarnings("rawtypes")
				Iterator it = tokenJsonObject.keys();			
				 while (it.hasNext()) { 
					 AuthorizationInfo =  tokenJsonObject.getString((String) it.next())+" " +AuthorizationInfo;
					 }
				AuthorizationjsonObject.accumulate("Authorization", AuthorizationInfo);
				OAUTH2_USER_URI = OAUTH2_BASE_URL + OAUTH2_USER_URI;			
				userInfosStr = UrlRequest.httpclient_url(OAUTH2_USER_URI,tool.jsonTOHeadMap(AuthorizationjsonObject.toString()),"get",new JSONObject()).get(1);			
				userInfosStr = userInfosStr.substring(userInfosStr.indexOf("*")+1, userInfosStr.length());
				userInfosJsonArray = JSONArray.fromObject(userInfosStr);			
				JSONObject jsonObject = userInfosJsonArray.getJSONObject(0);
				
				int duplicate = UserInfoDao.selectBycode(jsonObject.get("code").toString()).size();
				if(duplicate==0){
					UserInfo userInfo = new UserInfo();
					userInfo.setName(jsonObject.get("name").toString());
					userInfo.setCode(jsonObject.get("code").toString());
					userInfo.setEmail(jsonObject.get("email").toString());
					userInfo.setMobile(jsonObject.get("mobile").toString());
					userInfo.setDepartment_name(jsonObject.get("department_name").toString());
					userInfo.setJob_name(jsonObject.get("job_name").toString());
					userInfo.setUsername(jsonObject.get("username").toString());				
					UserInfoDao.addUserInfo(userInfo);
				}		
				
				HttpSession session=request.getSession();
				session.setAttribute("name", jsonObject.get("name").toString());
				session.setAttribute("code", jsonObject.get("code").toString());
				
				response.sendRedirect("/api_manage/index.jsp");
			
		}
		else if(paraName.equals("error")){
			response.setStatus(HttpServletResponse.SC_MOVED_TEMPORARILY);
			response.setHeader("Location", OAUTH2_BASE_URL+"/oauth/2.0/login?return_to=%2Flogin%2Fauthorize%3Fclient_id%3D"+client_id);
		}
		
		} 
		
		
		
			
//HttpURLConnection  method  get

//			  String LIMEI_HTTP="https://auth.corp.anjuke.com/oauth/2.0/user";
//			  String requestUrl=LIMEI_HTTP;
//			  System.out.println(requestUrl);
//			  String result="";
//			  try {
//			   URL url=new URL(requestUrl);
//			   HttpURLConnection connection=(HttpURLConnection)url.openConnection();
//			   connection.setDoOutput(true);
//			   connection.setDoInput(true);
//			   connection.setRequestMethod("GET");
//			   connection.setUseCaches(true);
//			   connection.setInstanceFollowRedirects(false);
//			   connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
//			   connection.setRequestProperty("Authorization", headInfo);
//			   connection.connect();
//			   //发送执行请求
//			   
//			   //接收返回请求
//			   BufferedReader reader=new BufferedReader(new InputStreamReader(connection.getInputStream(),"UTF-8"));
//			   String line="";
//			   StringBuffer buffer=new StringBuffer();
//			   while((line=reader.readLine())!=null){
//			    buffer.append(line);
//			   }
//			   result=buffer.toString();
//			   System.out.println("result="+result);
//			   connection.disconnect();
//			  } catch (Exception e) {
//			   e.printStackTrace();
//			  }
			
		
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
