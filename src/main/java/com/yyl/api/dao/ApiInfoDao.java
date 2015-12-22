package com.yyl.api.dao;

import com.yyl.api.bean.ApiInfo;
import com.yyl.api.bean.CategoryFirst;
import com.yyl.api.bean.CategorySecond;
import com.yyl.api.bean.HibernateSessionFactory;
import org.hibernate.Query;
import org.hibernate.Session;

import java.util.ArrayList;
import java.util.List;

public class ApiInfoDao {
	public static void addApiInfo(CategoryFirst categoryFirst, CategorySecond categorySecond, ApiInfo apiInfo) {
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

	public static void updateByCustom(String... args) {
		String hql = "update ApiInfo set orderNum=?,cnName=?,urlPath=?,httpMethod=?,paramIn=?,resultInfo=? where apiID=?";
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		session.beginTransaction();
		Query query = session.createQuery(hql).setParameter(0, Integer.parseInt(args[0])).setParameter(1, args[1]).setParameter(2, args[2])
				.setParameter(3, args[3]).setParameter(4, args[4]).setParameter(5, args[5]).setParameter(6, Integer.parseInt(args[6]));
		query.executeUpdate();
		session.getTransaction().commit();
	}

	@SuppressWarnings("unchecked")
	public static List<ApiInfo> selectALL() {
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		String hql = "from ApiInfo";
		Query query = session.createQuery(hql);
		List<ApiInfo> apiInfos = query.list();
		return apiInfos;
	}

	public static List<ApiInfo> selectAllByField(){
		List<ApiInfo> apiInfoList = new ArrayList<ApiInfo>();
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		String hql = "select orderNum, apiID, cnName, urlPath, httpMethod, paramIn, resultInfo from ApiInfo";
		Query query = session.createQuery(hql);
        //默认查询出来的list里存放的是一个Object数组，还需要转换成对应的javaBean。
		List<Object[]> objs = query.list();
		for(Object[] obj : objs){
			ApiInfo apiInfo = new ApiInfo();
			int orderNum = (Integer) obj[0];
			int apiID = (Integer) obj[1];
			String cnName = (String) obj[2];
			String urlPath = (String) obj[3];
			String httpMethod = (String) obj[4];
			String paramIn = (String) obj[5];
			String resultInfo = (String) obj[6];
			System.out.println("cnName = " + cnName + ", orderNum = " + orderNum);
			apiInfo.setApiID(apiID);
			apiInfo.setOrderNum(orderNum);
			apiInfo.setCnName(cnName);
			apiInfo.setUrlPath(urlPath);
			apiInfo.setHttpMethod(httpMethod);
			apiInfo.setParamIn(paramIn);
			apiInfo.setResultInfo(resultInfo);
			apiInfoList.add(apiInfo);
		}
		return apiInfoList;
	}

//	public static List<ApiInfo> selectAllByField(){
//		Session session = HibernateSessionFactory.getSessionFactory().openSession();
//		String hql = "select new ApiInfo(orderNum, apiID, cnName, urlPath, httpMethod, paramIn, resultInfo) from ApiInfo";
//		Query query = session.createQuery(hql);
//        //默认查询出来的list里存放的是一个Object对象，但是在这里list里存放的不再是默认的Object对象，而是ApiInfo对象
//		List<ApiInfo> apiInfoList = query.list();
//		return apiInfoList;
//	}

	@SuppressWarnings("unchecked")
	public static List<ApiInfo> selectByapiID(int apiID) {
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		String hql = "from ApiInfo where apiID=:apiID";
		Query query = session.createQuery(hql);
		query.setInteger("apiID", apiID);
		List<ApiInfo> apiInfos = query.list();
		return apiInfos;
	}

	@SuppressWarnings("unchecked")
	public static List<ApiInfo> selectByurlPath(String urlPath) {
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		String hql = "from ApiInfo where urlPath=:urlPath";
		Query query = session.createQuery(hql);
		query.setString("urlPath", urlPath);
		List<ApiInfo> apiInfos = query.list();
		return apiInfos;
	}
}