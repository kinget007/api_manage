package com.yyl.api.dao;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

import com.yyl.api.bean.CategoryFirst;
import com.yyl.api.bean.HibernateSessionFactory;

public class CategoryFirstDao {
	public static void delCategory(CategoryFirst categoryFirst) {
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		categoryFirst = (CategoryFirst) session.load(CategoryFirst.class,
				categoryFirst.getCategoryFirstID());
		session.beginTransaction();
		session.delete(categoryFirst);
		session.getTransaction().commit();
	}
	
	@SuppressWarnings("unchecked")
	public static List<CategoryFirst> selectALLCategoryFirst(){
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		String hql = "from CategoryFirst";
        Query query = session.createQuery(hql);
		List<CategoryFirst> categoryFirsts = query.list();       
        return categoryFirsts;
	}
	
	@SuppressWarnings("unchecked")
	public static List<CategoryFirst> selectBycategoryFirstID(int categoryFirstID){
		Session session = HibernateSessionFactory.getSessionFactory().openSession();
		String hql = "from CategoryFirst where categoryFirstID=:categoryFirstID";      
        Query query = session.createQuery(hql);         
        query.setInteger("categoryFirstID", categoryFirstID);        
        List<CategoryFirst> categoryFirsts = query.list();        
        return categoryFirsts;
	}
}
