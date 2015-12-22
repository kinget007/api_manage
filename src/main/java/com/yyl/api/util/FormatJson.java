package com.yyl.api.util;

import java.util.HashMap;
import java.util.Iterator;

import org.json.com.JSONArray;
import org.json.com.JSONObject;


public class FormatJson {
	private static String SPACE = "   ";

	public String formatJson(String json) {
		StringBuffer result = new StringBuffer();
		int length = json.length();
		int number = 0;
		char key = 0;
		for (int i = 0; i < length; i++) {
			key = json.charAt(i);

			if ((key == '[') || (key == '{')) {
				if ((i - 1 > 0) && (json.charAt(i - 1) == ':')) {
					result.append('\n');
					result.append(indent(number));
				}
				result.append(key);
				result.append('\n');
				number++;
				result.append(indent(number));
				continue;
			}
			if ((key == ']') || (key == '}')) {
				result.append('\n');
				number--;
				result.append(indent(number));
				result.append(key);
				if (((i + 1) < length) && (json.charAt(i + 1) != ',')) {
					result.append('\n');
				}
				continue;
			}
			if ((key == ',')) {
				result.append(key);
				result.append('\n');
				result.append(indent(number));
				continue;
			}
			result.append(key);
		}
		return result.toString();
	}
	
	 public  String jsonTOString(String jsonString){  
		 String jsonBody = "";	
		 JSONArray jsonArray = new JSONArray("["+jsonString+"]");
			for (int i = 0; i < jsonArray.length(); i++) {
				JSONObject jsonObject = jsonArray.getJSONObject(i);
				Iterator<?> iterator = jsonObject.keys();
				String key = null;
				while (iterator.hasNext()) {
					key = iterator.next().toString();
					jsonBody = jsonBody +key+"="+jsonObject.get(key).toString()+"&";
				} 
			}
			return jsonBody.substring(0, jsonBody.length()-1);
	   }  
	 
	 public  HashMap<String, String> jsonTOHeadMap(String jsonString){
		 if(jsonString == null || jsonString.equals("")){
			 return null;
		 }
		 else{
			 HashMap<String, String> headers = new HashMap<String, String>();   	
			 JSONArray jsonArray = new JSONArray("["+jsonString+"]");
				for (int i = 0; i < jsonArray.length(); i++) {
					JSONObject jsonObject = jsonArray.getJSONObject(i);
					Iterator<?> iterator = jsonObject.keys();
					String key = null;
					while (iterator.hasNext()) {
						key = iterator.next().toString();
						headers.put(key, jsonObject.get(key).toString());					
					} 
				}
				return headers;
		 }		 
	   }
	
	private String indent(int number) {
		StringBuffer result = new StringBuffer();
		for (int i = 0; i < number; i++) {
			result.append(SPACE);
		}
		return result.toString();
	}
}