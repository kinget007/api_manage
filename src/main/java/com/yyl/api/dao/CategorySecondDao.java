package com.yyl.api.dao;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

import com.yyl.api.bean.CategorySecond;
import com.yyl.api.bean.HibernateSessionFactory;

public class CategorySecondDao {
	public static void delCategorySecond(CategorySecond categorySecond) {
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		categorySecond = (CategorySecond) session.load(CategorySecond.class,
				categorySecond.getCategorySecondID());
		session.beginTransaction();
		session.delete(categorySecond);
		session.getTransaction().commit();
	}
	
	@SuppressWarnings("unchecked")
	public static List<CategorySecond> selectALLCategorySecond(){
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		String hql = "from CategorySecond";      
        Query query = session.createQuery(hql);
		List<CategorySecond> categorySeconds = query.list();       
        return categorySeconds;
	}
	
	@SuppressWarnings("unchecked")
	public static List<CategorySecond> selectBycategorySecondID(int categorySecondID){
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		String hql = "from CategorySecond where categorySecondID=:categorySecondID";      
        Query query = session.createQuery(hql);         
        query.setInteger("categorySecondID", categorySecondID);       
        List<CategorySecond> categorySeconds = query.list();         
        return categorySeconds;
	}


}
