
package com.user.service;

import com.hbr.session.SessionCreation;
import com.pojo.SearchCriteria;
import com.pojo.SearchInput;
import com.util.HibernateUtil;
import java.util.Iterator;
import java.util.List;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.Restrictions;


public class Test{
    
    private static SessionCreation sessioncreation = new SessionCreation();
    private static Session session = null;
    private static Transaction transaction;
    private static List Result;
    
   

 public static List Exists_Data(SearchInput searchinputs){
        
        try{
        session = HibernateUtil.getSessionFactory().openSession();
        transaction = session.beginTransaction();
        int count =1; 
        Criteria cr = session.createCriteria(searchinputs.getSearchClass());
        
        
            for (Iterator it = searchinputs.getSearchCriteria().iterator(); it.hasNext();) {
                SearchCriteria criteria = (SearchCriteria) it.next();
                System.out.println("COLUMN NAME :" +criteria.getColumnName());
                System.out.println("COLUMN VALUE : " +criteria.getColumnValue());
                System.out.println("COLUMN TYPE : " +criteria.getOperationType());
                if(criteria.getOperationType().equalsIgnoreCase("eq")){
                    cr.add(Restrictions.eq(criteria.getColumnName(),criteria.getColumnValue()));
                  System.out.println(" IF COUNT :" +count++); 
                }
                 System.out.println(" FOR COUNT :" +count++); 
            }
        Result = cr.list();
        System.out.println("RESULTTTTTTT;;;;;;;;;"+Result);
        }
        catch(HibernateException e){
            System.out.println(e);
            throw e;
        }
        
        return Result;
    }
    
    
    
}



    

