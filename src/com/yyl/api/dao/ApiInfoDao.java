package com.yyl.api.dao;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

import com.yyl.api.bean.ApiInfo;
import com.yyl.api.bean.CategoryFirst;
import com.yyl.api.bean.CategorySecond;
import com.yyl.api.bean.HibernateSessionFactory;

public class ApiInfoDao {
	public static void addApiInfo(CategoryFirst categoryFirst,
			CategorySecond categorySecond, ApiInfo apiInfo) {
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		categorySecond.setCategoryFirst(categoryFirst);
		apiInfo.setCategorySecond(categorySecond);
		session.beginTransaction();
		session.save(apiInfo);
		session.getTransaction().commit();
	}

	public static void updateApiInfo(ApiInfo apiInfo) {
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		session.beginTransaction();
		session.update(apiInfo);
		session.getTransaction().commit();
	}
	
	@SuppressWarnings("unchecked")
	public static List<ApiInfo> selectALL(){
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		String hql = "from ApiInfo";      
        Query query = session.createQuery(hql);
		List<ApiInfo> apiInfos = query.list();      
        return apiInfos;
	}
	
	@SuppressWarnings("unchecked")
	public static List<ApiInfo> selectByapiID(int apiID){
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		String hql = "from ApiInfo where apiID=:apiID";      
        Query query = session.createQuery(hql);         
        query.setInteger("apiID", apiID);        
        List<ApiInfo> apiInfos = query.list();         
        return apiInfos;
	}
	   
    @SuppressWarnings("unchecked")
	public static List<ApiInfo> selectByurlPath(String urlPath){
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		String hql = "from ApiInfo where urlPath=:urlPath";      
        Query query = session.createQuery(hql);         
        query.setString("urlPath", urlPath);
		List<ApiInfo> apiInfos = query.list();         
        return apiInfos;
	}

}
