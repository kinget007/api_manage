package com.yyl.api.bean;

import java.util.HashSet;
import java.util.Set;

public class CategorySecond{
	private int categorySecondID;
	private String categorySecondName;
//	private int categoryFirstID;
	private CategoryFirst categoryFirst;
	private Set<ApiInfo> apiInfo = new HashSet<ApiInfo>();
	
	public CategorySecond(){}

	public int getCategorySecondID() {
		return categorySecondID;
	}

	public void setCategorySecondID(int categorySecondID) {
		this.categorySecondID = categorySecondID;
	}

	public String getCategorySecondName() {
		return categorySecondName;
	}

	public void setCategorySecondName(String categorySecondName) {
		this.categorySecondName = categorySecondName;
	}

//	public int getCategoryFirstID() {
//		return categoryFirstID;
//	}
//
//	public void setCategoryFirstID(int categoryFirstID) {
//		this.categoryFirstID = categoryFirstID;
//	}

	public CategoryFirst getCategoryFirst() {
		return categoryFirst;
	}

	public void setCategoryFirst(CategoryFirst categoryFirst) {
		this.categoryFirst = categoryFirst;
	}

	public Set<ApiInfo> getApiInfo() {
		return apiInfo;
	}

	public void setApiInfo(Set<ApiInfo> apiInfo) {
		this.apiInfo = apiInfo;
	}

	

	
}