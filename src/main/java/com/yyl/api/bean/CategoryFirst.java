package com.yyl.api.bean;

import java.util.HashSet;
import java.util.Set;

public class CategoryFirst{
	private int categoryFirstID;
	private String categoryFirstName;
	private String categoryENFirstName;
	private Set<CategorySecond> categorySecond = new HashSet<CategorySecond>();
	
	public CategoryFirst(){}

	public int getCategoryFirstID() {
		return categoryFirstID;
	}

	public void setCategoryFirstID(int categoryFirstID) {
		this.categoryFirstID = categoryFirstID;
	}

	public String getCategoryFirstName() {
		return categoryFirstName;
	}

	public void setCategoryFirstName(String categoryFirstName) {
		this.categoryFirstName = categoryFirstName;
	}

	public Set<CategorySecond> getCategorySecond() {
		return categorySecond;
	}

	public void setCategorySecond(Set<CategorySecond> categorySecond) {
		this.categorySecond = categorySecond;
	}

	public String getCategoryENFirstName() {
		return categoryENFirstName;
	}

	public void setCategoryENFirstName(String categoryENFirstName) {
		this.categoryENFirstName = categoryENFirstName;
	}

	
	
}