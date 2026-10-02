package repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import model.Staff;
import util.HibernateUtil;

import java.util.Optional;

public class AuthRepository {

    public Optional<Staff> findByEmail(String email) {
        EntityManager em = HibernateUtil.getEntityManagerFactory().createEntityManager();
        try {
            // JPQL (Java Persistence Query Language)
            Staff staff = em.createQuery("SELECT s FROM Staff s WHERE s.email = :email", Staff.class)
                .setParameter("email", email)
                .getSingleResult();
            return Optional.of(staff);
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    public void save(Staff staff) {
        EntityManager em = HibernateUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(staff);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
}