package com.yyl.api.dao;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

import com.yyl.api.bean.ApiInfo;
import com.yyl.api.bean.HibernateSessionFactory;
import com.yyl.api.bean.UserInfo;

public class UserInfoDao {
	public static void addUserInfo(UserInfo userInfo) {
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		session.beginTransaction();
		session.save(userInfo);
		session.getTransaction().commit();
	}

	public static void updateUserInfo(UserInfo userInfo) {
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		session.beginTransaction();
		session.update(userInfo);
		session.getTransaction().commit();
	}
	
	@SuppressWarnings("unchecked")
	public static List<UserInfo> selectALL(){
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		String hql = "from UserInfo";      
        Query query = session.createQuery(hql);
		List<UserInfo> userInfos = query.list();      
        return userInfos;
	}
	
	@SuppressWarnings("unchecked")
	public static List<UserInfo> selectBycode(String code){
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		String hql = "from UserInfo where code=:code";      
        Query query = session.createQuery(hql);         
        query.setString("code", code);        
        List<UserInfo> userInfos = query.list();         
        return userInfos;
	}
	
	public static void addAttention(String code,int apiID) {
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		session.beginTransaction();
		
		UserInfo userInfo = (UserInfo) session.load(UserInfo.class,code);
		ApiInfo apiInfo = (ApiInfo) session.load(ApiInfo.class,apiID);
		
		userInfo.getApiInfos().add(apiInfo);
		session.update(userInfo);
		session.getTransaction().commit();
	}
	
	public static void delAttention(String code,int apiID) {
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		session.beginTransaction();
		
		UserInfo userInfo = (UserInfo) session.load(UserInfo.class,code);
		ApiInfo apiInfo = (ApiInfo) session.load(ApiInfo.class,apiID);
		
		userInfo.getApiInfos().remove(apiInfo);
		session.update(userInfo);
		session.getTransaction().commit();
	}
}
