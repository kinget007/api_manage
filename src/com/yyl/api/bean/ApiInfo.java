package com.yyl.api.bean;

public class ApiInfo{
	private int apiID;
//	private int categorySecondID;
	private int isLogin;
	private String urlPath;
	private String httpHeader;
	private String httpMethod;
	private String cnName;
	private String paramIn;
	private String paramOut;
	private String resultInfo;
	private String author;
	private String editInfo;
	private String tableInfo;
	private CategorySecond categorySecond;
	
	public ApiInfo(){}

	public int getApiID() {
		return apiID;
	}

	public void setApiID(int apiID) {
		this.apiID = apiID;
	}

	public String getUrlPath() {
		return urlPath;
	}

	public void setUrlPath(String urlPath) {
		this.urlPath = urlPath;
	}

	public String getHttpMethod() {
		return httpMethod;
	}

	public void setHttpMethod(String httpMethod) {
		this.httpMethod = httpMethod;
	}	

	public String getCnName() {
		return cnName;
	}

	public void setCnName(String cnName) {
		this.cnName = cnName;
	}

	public String getHttpHeader() {
		return httpHeader;
	}

	public void setHttpHeader(String httpHeader) {
		this.httpHeader = httpHeader;
	}

	public int getIsLogin() {
		return isLogin;
	}

	public void setIsLogin(int isLogin) {
		this.isLogin = isLogin;
	}

	public String getParamIn() {
		return paramIn;
	}

	public void setParamIn(String paramIn) {
		this.paramIn = paramIn;
	}

	public String getParamOut() {
		return paramOut;
	}

	public void setParamOut(String paramOut) {
		this.paramOut = paramOut;
	}

	public String getResultInfo() {
		return resultInfo;
	}

	public void setResultInfo(String resultInfo) {
		this.resultInfo = resultInfo;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public String getEditInfo() {
		return editInfo;
	}

	public void setEditInfo(String editInfo) {
		this.editInfo = editInfo;
	}

//	public int getCategorySecondID() {
//		return categorySecondID;
//	}
//
//	public void setCategorySecondID(int categorySecondID) {
//		this.categorySecondID = categorySecondID;
//	}

	public String getTableInfo() {
		return tableInfo;
	}

	public void setTableInfo(String tableInfo) {
		this.tableInfo = tableInfo;
	}

	public CategorySecond getCategorySecond() {
		return categorySecond;
	}

	public void setCategorySecond(CategorySecond categorySecond) {
		this.categorySecond = categorySecond;
	}
	
}