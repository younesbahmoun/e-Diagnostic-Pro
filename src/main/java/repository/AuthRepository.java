package repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import model.Utilisateur;
import util.HibernateUtil;

import java.util.Optional;

public class AuthRepository {

    public Optional<Utilisateur> findByEmail(String email) {
        // EntityManager em = HibernateUtil.getEntityManagerFactory().createEntityManager();
        EntityManager em = HibernateUtil.getEntityManagerFactory().createEntityManager();
        try {
            // JPQL (Java Persistence Query Language)
            Utilisateur staff = em.createQuery("SELECT s FROM Utilisateur s WHERE s.email = :email", Utilisateur.class)
                .setParameter("email", email)
                .getSingleResult();
            return Optional.of(staff);
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    public void save(Utilisateur staff) {
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
