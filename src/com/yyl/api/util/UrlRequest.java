package com.yyl.api.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.ConnectException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.io.IOUtils;
import org.apache.http.HeaderIterator;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.nio.client.CloseableHttpAsyncClient;
import org.apache.http.impl.nio.client.HttpAsyncClients;
import org.apache.http.message.BasicNameValuePair;

public class UrlRequest {
	
	public static ArrayList<String> getHttpResponseContent(String urlPath,String paramInVauleJson,String httpHeader,String httpMethod) throws UnsupportedEncodingException{
		ArrayList<String> resultInfo = new ArrayList<String>();		
		ArrayList<String> paramInURLs = new ArrayList<String>();					
		JSONArray jsonParamALL = new JSONArray();
		JSONObject jsonURL = new JSONObject();
		JSONObject jsonPost = new JSONObject();	
		JSONObject jsonURLPath = new JSONObject();	
		FormatJson tool = new FormatJson();		
		for(int i =0;i<urlPath.split("\\$").length;i++){			 
			 if(urlPath.split("\\$")[i].contains("}")){				 
			 paramInURLs.add(urlPath.split("\\$")[i]
			 .subSequence(0, urlPath.split("\\$")[i].indexOf("}"))
			 .toString().trim());
			 }
		 }						
		if(paramInVauleJson==null || paramInVauleJson.equals("") || paramInVauleJson.equals("{}") ){
			resultInfo = httpclient_url(urlPath,tool.jsonTOHeadMap(httpHeader),httpMethod,jsonPost);			
		}else{	
			
			jsonParamALL = JSONArray.fromObject("["+paramInVauleJson+"]");
			String urlPath2 = urlPath;
			for (int i = 0; i < jsonParamALL.size(); i++) {
				JSONObject jsonObject = jsonParamALL.getJSONObject(i);
				Iterator<?> iterator = jsonObject.keys();
				String key = null;
				while (iterator.hasNext()) {
					key = iterator.next().toString();
					if(key.contains("*")){
						if(key.contains("post")){
							jsonPost.accumulate(key.substring(0, key.indexOf("*")),URLDecoder.decode(jsonObject.get(key).toString(), "utf-8") );
						}else{
							if(paramInURLs.contains(key.substring(0, key.indexOf("*")))){
								jsonURLPath.accumulate(key.substring(0, key.indexOf("*")), URLDecoder.decode(jsonObject.get(key).toString(), "utf-8"));								
							}else{
								jsonURL.accumulate(key.substring(0, key.indexOf("*")), URLDecoder.decode(jsonObject.get(key).toString(), "utf-8"));
							}						
							}
					}else{
//						jsonURL.accumulate(key, jsonObject.get(key).toString());//
						jsonURL.accumulate(key, URLDecoder.decode(jsonObject.get(key).toString(), "utf-8"));
					}
					
				} 
			}
			paramInVauleJson = tool.jsonTOString(jsonURL.toString());
			
			Iterator<?> iteratorparamPath = jsonURLPath.keys();
			String keyPath = null;
			while (iteratorparamPath.hasNext()) {
				keyPath = iteratorparamPath.next().toString();
				urlPath2 = urlPath2.replace("{$"+keyPath+"}", jsonURLPath.get(keyPath).toString());					
				}
			
			urlPath2 = urlPath2+"?"+paramInVauleJson;
			resultInfo = httpclient_url(urlPath2,tool.jsonTOHeadMap(httpHeader),httpMethod,jsonPost);

		}
		
		return resultInfo;
	}
	
	
	public static  ArrayList<String> httpclient_url(String url,HashMap<String, String> headers, String method,JSONObject jsonPost){
		String headStr = "";
		String result = "";
		ArrayList<String> resultList = new ArrayList<String>();
		String urlquery = "";
		CloseableHttpAsyncClient httpclient = HttpAsyncClients.createDefault();
		Future<HttpResponse> future;
		StringEntity entityPost = new StringEntity(jsonPost.toString(),"utf-8");//解决中文乱码问题    
//		entityPost.setContentEncoding("UTF-8");    
//		entityPost.setContentType("application/json");

		try {
			httpclient.start();
			if (url.contains("?")) {
				urlquery = url.substring(url.indexOf("?") + 1, url.length())
						.replace("=", "*_*").replace("&", "*__*");
				urlquery = URLEncoder.encode(urlquery, "UTF-8");
				urlquery = urlquery.replace("*_*", "=").replace("*__*", "&");
				url = url.substring(0, url.indexOf("?") + 1) + urlquery;
			}
			
			if (method.equalsIgnoreCase("get")) {
				HttpGet request = new HttpGet(url);
				request.addHeader("Content-Type","application/json; charset=utf-8");
//				request.addHeader("Content-Type","application/json");
				if (headers != null) {
					Iterator<Entry<String, String>> it = headers.entrySet()
							.iterator();
					while (it.hasNext()) {
						Map.Entry<String, String> entry = (Map.Entry<String, String>) it
								.next();
						String key = entry.getKey().toString();
						String value = entry.getValue().toString();
						request.setHeader(key, value);
					}
				}
				future = httpclient.execute(request, null);
			} else {
				HttpPost request = new HttpPost(url);
				request.addHeader("Content-Type","application/json; charset=utf-8");
//				request.addHeader("Content-Type","application/json");
				request.setEntity(entityPost);
				if (headers != null) {
					Iterator<Entry<String, String>> it = headers.entrySet().iterator();
					while (it.hasNext()) {
						Map.Entry<String, String> entry = (Map.Entry<String, String>) it.next();
						String key = entry.getKey().toString();
						String value = entry.getValue().toString();
						request.setHeader(key, value);
					}
				}
				future = httpclient.execute(request, null);
				
				// request = new HttpPost(url);
			}
			try {
				// HttpResponse response = httpClient.execute(request);
				HttpResponse response;
				try {
					response = future.get();
					HttpEntity entity = response.getEntity();
					InputStream stream = entity.getContent();
					HeaderIterator headit = response.headerIterator();
					while (headit.hasNext()) {
						headStr = headit.next().toString();
					}

					try {
						result = decode(convertStreamToString(stream).replace("/n","").toCharArray());
						if (result != null) {
							Pattern p = Pattern.compile("\\s*|\t|\r|\n");
							Matcher m = p.matcher(result);
							result = m.replaceAll("");
						}
						resultList.add(0, headStr);;
						resultList.add(1,result);
						//result = headStr + "*" + result;
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				} catch (InterruptedException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				} catch (ExecutionException e1) {
					// TODO Auto-generated catch block
					//e1.printStackTrace();
					resultList.add(0, "请求超时");
					resultList.add(1,"{\"result\":\"请求超时\"}");
					
				}				

			} catch (ClientProtocolException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} 
			catch (ConnectException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				httpclient.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return resultList;

	}

	public static String decode(char[] in) throws Exception {
		int off = 0;
		char c;
		char[] out = new char[in.length];
		int outLen = 0;
		while (off < in.length) {
			c = in[off++];
			if (c == '\\') {
				if (in.length > off) {
					c = in[off++];
				} else {
					out[outLen++] = '\\';
					break;
				}
				if (c == 'u') {
					int value = 0;
					if (in.length > off + 4) {
						boolean isUnicode = true;
						for (int i = 0; i < 4; i++) {
							c = in[off++];
							switch (c) {
							case '0':
							case '1':
							case '2':
							case '3':
							case '4':
							case '5':
							case '6':
							case '7':
							case '8':
							case '9':
								value = (value << 4) + c - '0';
								break;
							case 'a':
							case 'b':
							case 'c':
							case 'd':
							case 'e':
							case 'f':
								value = (value << 4) + 10 + c - 'a';
								break;
							case 'A':
							case 'B':
							case 'C':
							case 'D':
							case 'E':
							case 'F':
								value = (value << 4) + 10 + c - 'A';
								break;
							default:
								isUnicode = false;
							}
						}
						if (isUnicode) {
							out[outLen++] = (char) value;
						} else {
							off = off - 4;
							out[outLen++] = '\\';
							out[outLen++] = 'u';
							out[outLen++] = in[off++];
						}
					} else {
						out[outLen++] = '\\';
						out[outLen++] = 'u';
						continue;
					}
				} else {
					switch (c) {
					case 't':
						c = '\t';
						out[outLen++] = c;
						break;
					case 'r':
						c = '\r';
						out[outLen++] = c;
						break;
					case 'n':
						c = '\n';
						out[outLen++] = c;
						break;
					case 'f':
						c = '\f';
						out[outLen++] = c;
						break;
					default:
						out[outLen++] = '\\';
						out[outLen++] = c;
						break;
					}
				}
			} else {
				out[outLen++] = (char) c;
			}
		}
		return new String(out, 0, outLen);
	}

	public URI getURL_() {
		List<BasicNameValuePair> params = new ArrayList<BasicNameValuePair>();
		params.add(new BasicNameValuePair("param1", "value1"));
		params.add(new BasicNameValuePair("param2", "value2"));
		String param = URLEncodedUtils.format(params, "UTF-8");
		URI uri = null;
		try {
			uri = new URI("http", null, "localhost", 8080,
					"/sshsky/index.html", param, null);
		} catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return uri;
	}

	public static String convertStreamToString(InputStream is) {
		String result = "";
		try {
			result = IOUtils.toString(is, "UTF-8");
			//System.out.println(result);
			
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		return result;
		
//		StringBuffer out = new StringBuffer();
//		byte[] b = new byte[4096];
//		try {
//			for (int n; (n = is.read(b)) != -1;) {
//				out.append(new String(b, 0, n, "UTF-8"));
//			}
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		System.out.println(out.toString());
//		return out.toString();
	}
}