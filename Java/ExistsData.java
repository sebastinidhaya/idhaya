package com.user.service;

import com.pojo.SearchCriteria;
import com.pojo.SearchInput;
import com.util.HibernateUtil;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Restrictions;

public class ExistsData {

    

    public static List getUsingOr(SearchInput searchinputs) {

    Session session = null;
    Transaction transaction = null;
    List<Object> Result = new ArrayList<>();
    List<Criterion> Checkcriterion = new ArrayList<>();
        
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            Criteria cr = session.createCriteria(searchinputs.getSearchClass());

            for (Iterator it = searchinputs.getSearchCriteria().iterator(); it.hasNext();) {
                SearchCriteria criteria = (SearchCriteria) it.next();
                System.out.println("COLUMN NAME :" + criteria.getColumnName());
                System.out.println("COLUMN VALUE : " + criteria.getColumnValue());
                System.out.println("COLUMN TYPE : " + criteria.getOperationType());
                if (criteria.getOperationType().equalsIgnoreCase("eq")) {
                    Checkcriterion.add(Restrictions.eq(criteria.getColumnName(), criteria.getColumnValue()));
                    }
             }
            System.out.println(" LIST OF CRITERION " + Checkcriterion);
            Criterion[] item = Checkcriterion.toArray(new Criterion[Checkcriterion.size()]);
            System.out.println(" ARRAY OF CRITERION " + Checkcriterion);
            cr.add(Restrictions.or(item));
            Result = cr.list();
            System.out.println(" RESULT" + Result);
            Checkcriterion.clear();

        } catch (HibernateException e) {
            System.out.println(e);
            if (transaction != null) {
                transaction.rollback();
                System.out.println("transaction is rollback");
            }
            throw e;
        } finally {
            if (session != null) {
                session.close();
                System.out.println("session close");
            }
        }

        return Result;
    }

}
