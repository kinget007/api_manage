package com.yyl.api.bean;

import java.util.HashSet;
import java.util.Set;

public class UserInfo{
	private String name ;//余益龙
	private String code ; //SHH6325
	private String email ; //yilongyu@anjuke.com
	private String mobile ; //15618971625
	private String department_name ; //用户移动质量保障部
	private String job_name ; //质量保障工程师
	private String username ;// yilongyu
	
	private Set<ApiInfo> apiInfos = new HashSet<ApiInfo>();
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	
	public String getDepartment_name() {
		return department_name;
	}
	public void setDepartment_name(String department_name) {
		this.department_name = department_name;
	}
	public String getJob_name() {
		return job_name;
	}
	public void setJob_name(String job_name) {
		this.job_name = job_name;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public Set<ApiInfo> getApiInfos() {
		return apiInfos;
	}
	public void setApiInfos(Set<ApiInfo> apiInfos) {
		this.apiInfos = apiInfos;
	}
}