package repository;

import jakarta.persistence.EntityManager;
import model.FileAttente;
import model.Patient;
import model.SigneVital;
import util.HibernateUtil;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class InfirmierRepository {

    public Optional<Patient> findPatientByNumeroSecuriteSociale(String numero) {
        try (EntityManager em = HibernateUtil.getEntityManagerFactory().createEntityManager()) {
            return em.createQuery(
                            "SELECT p FROM Patient p WHERE p.numeroSecuriteSociale = :numero",
                            Patient.class)
                    .setParameter("numero", numero)
                    .getResultStream()
                    .findFirst();
        }
    }

    public void save(Patient patient, SigneVital signeVital, FileAttente fileAttente) {
        try (EntityManager em = HibernateUtil.getEntityManagerFactory().createEntityManager()) {
            em.getTransaction().begin();
            try {
                em.persist(patient);
                signeVital.setPatient(patient);
                em.persist(signeVital);
                fileAttente.setPatient(patient);
                em.persist(fileAttente);
                em.getTransaction().commit();
            } catch (RuntimeException e) {
                if (em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                throw e;
            }
        }
    }

    public void saveSigneVitalAndFileAttente(Patient patient, SigneVital signeVital, FileAttente fileAttente) {
        try (EntityManager em = HibernateUtil.getEntityManagerFactory().createEntityManager()) {
            em.getTransaction().begin();
            try {
                Patient patientManaged = em.find(Patient.class, patient.getId());
                signeVital.setPatient(patientManaged);
                em.persist(signeVital);
                fileAttente.setPatient(patientManaged);
                em.persist(fileAttente);
                em.getTransaction().commit();
            } catch (RuntimeException e) {
                if (em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                throw e;
            }
        }
    }

    public List<FileAttente> findFileAttenteToday() {
        LocalDate today = LocalDate.now();
        LocalDateTime debut = today.atStartOfDay();
        LocalDateTime fin = today.plusDays(1).atStartOfDay();
        try (EntityManager em = HibernateUtil.getEntityManagerFactory().createEntityManager()) {
            return em.createQuery(
                            """
                            SELECT f
                            FROM FileAttente f
                            JOIN FETCH f.patient
                            WHERE f.heureArrivee >= :debut
                            AND f.heureArrivee < :fin
                            ORDER BY f.heureArrivee ASC
                            """,
                            FileAttente.class)
                    .setParameter("debut", debut)
                    .setParameter("fin", fin)
                    .getResultList();
        }
    }
}
