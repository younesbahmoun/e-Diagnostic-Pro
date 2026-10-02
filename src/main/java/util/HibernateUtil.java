package util;

import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class HibernateUtil {

    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("teleExpertisePU");

    public static EntityManagerFactory getEntityManagerFactory() {
        return emf;
    }
}