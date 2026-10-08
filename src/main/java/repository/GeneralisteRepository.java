package repository;

import enums.PrioriteExpertise;
import enums.Role;
import enums.StatutConsultation;
import enums.StatutCreneau;
import enums.StatutExpertise;
import enums.StatutFileAttente;
import jakarta.persistence.EntityManager;
import model.Consultation;
import model.Creneau;
import model.DemandeExpertise;
import model.FileAttente;
import model.Patient;
import model.Utilisateur;
import util.HibernateUtil;

import java.time.LocalDateTime;
import java.util.List;

public class GeneralisteRepository {

    public List<FileAttente> findFileAttenteEnAttente() {
        try (EntityManager em = HibernateUtil.getEntityManagerFactory().createEntityManager()) {
            return em.createQuery(
                            "SELECT f FROM FileAttente f JOIN FETCH f.patient p " +
                            "WHERE f.statut = :statut ORDER BY f.heureArrivee ASC",
                            FileAttente.class)
                    .setParameter("statut", StatutFileAttente.EN_ATTENTE)
                    .getResultList();
        }
    }

    public Patient findPatientAvecSignesVitaux(Long id) {
        try (EntityManager em = HibernateUtil.getEntityManagerFactory().createEntityManager()) {
            return em.createQuery(
                            "SELECT p FROM Patient p LEFT JOIN FETCH p.signesVitaux WHERE p.id = :id",
                            Patient.class)
                    .setParameter("id", id)
                    .getResultStream()
                    .findFirst()
                    .orElse(null);
        }
    }

    public List<Consultation> findConsultationsByPatient(Long patientId) {
        try (EntityManager em = HibernateUtil.getEntityManagerFactory().createEntityManager()) {
            return em.createQuery(
                            "SELECT c FROM Consultation c WHERE c.patient.id = :patientId " +
                            "ORDER BY c.dateConsultation DESC",
                            Consultation.class)
                    .setParameter("patientId", patientId)
                    .getResultList();
        }
    }

    public Consultation saveConsultation(Long patientId, Long generalisteId, String motif, String observations) {
        try (EntityManager em = HibernateUtil.getEntityManagerFactory().createEntityManager()) {
            em.getTransaction().begin();
            try {
                Consultation consultation = new Consultation();
                consultation.setPatient(em.find(Patient.class, patientId));
                consultation.setGeneraliste(em.find(Utilisateur.class, generalisteId));
                consultation.setMotif(motif);
                consultation.setObservations(observations);
                em.persist(consultation);
                em.getTransaction().commit();
                return consultation;
            } catch (RuntimeException e) {
                if (em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                throw e;
            }
        }
    }

    public Consultation findConsultationAvecPatient(Long id) {
        try (EntityManager em = HibernateUtil.getEntityManagerFactory().createEntityManager()) {
            return em.createQuery(
                            "SELECT c FROM Consultation c JOIN FETCH c.patient JOIN FETCH c.generaliste " +
                            "WHERE c.id = :id",
                            Consultation.class)
                    .setParameter("id", id)
                    .getResultStream()
                    .findFirst()
                    .orElse(null);
        }
    }

    public List<DemandeExpertise> findDemandesByConsultation(Long consultationId) {
        try (EntityManager em = HibernateUtil.getEntityManagerFactory().createEntityManager()) {
            return em.createQuery(
                            "SELECT d FROM DemandeExpertise d JOIN FETCH d.specialiste " +
                            "LEFT JOIN FETCH d.creneau WHERE d.consultation.id = :consultationId " +
                            "ORDER BY d.dateDemande DESC",
                            DemandeExpertise.class)
                    .setParameter("consultationId", consultationId)
                    .getResultList();
        }
    }

    public void cloturerConsultation(Long id, String diagnostic, String traitement) {
        try (EntityManager em = HibernateUtil.getEntityManagerFactory().createEntityManager()) {
            em.getTransaction().begin();
            try {
                Consultation consultation = em.find(Consultation.class, id);
                consultation.setDiagnostic(diagnostic);
                consultation.setTraitement(traitement);
                consultation.setStatut(StatutConsultation.TERMINEE);
                em.getTransaction().commit();
            } catch (RuntimeException e) {
                if (em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                throw e;
            }
        }
    }

    public List<String> findSpecialites() {
        try (EntityManager em = HibernateUtil.getEntityManagerFactory().createEntityManager()) {
            return em.createQuery(
                            "SELECT DISTINCT s.specialite FROM Utilisateur s WHERE s.role = :role " +
                            "AND s.specialite IS NOT NULL ORDER BY s.specialite ASC",
                            String.class)
                    .setParameter("role", Role.SPECIALISTE)
                    .getResultList();
        }
    }

    public List<Utilisateur> findAllSpecialistes() {
        try (EntityManager em = HibernateUtil.getEntityManagerFactory().createEntityManager()) {
            return em.createQuery(
                            "SELECT s FROM Utilisateur s WHERE s.role = :role ORDER BY s.nom ASC",
                            Utilisateur.class)
                    .setParameter("role", Role.SPECIALISTE)
                    .getResultList();
        }
    }

    public Utilisateur findSpecialisteById(Long id) {
        try (EntityManager em = HibernateUtil.getEntityManagerFactory().createEntityManager()) {
            return em.find(Utilisateur.class, id);
        }
    }

    public List<Creneau> findCreneauxDisponiblesFuturs(Long specialisteId, LocalDateTime now) {
        try (EntityManager em = HibernateUtil.getEntityManagerFactory().createEntityManager()) {
            return em.createQuery(
                            "SELECT c FROM Creneau c WHERE c.specialiste.id = :specialisteId " +
                            "AND c.statut = :statut AND c.debut > :now ORDER BY c.debut ASC",
                            Creneau.class)
                    .setParameter("specialisteId", specialisteId)
                    .setParameter("statut", StatutCreneau.DISPONIBLE)
                    .setParameter("now", now)
                    .getResultList();
        }
    }

    public List<Creneau> findAutresCreneaux(Long specialisteId, LocalDateTime now) {
        try (EntityManager em = HibernateUtil.getEntityManagerFactory().createEntityManager()) {
            return em.createQuery(
                            "SELECT c FROM Creneau c WHERE c.specialiste.id = :specialisteId " +
                            "AND (c.statut <> :statut OR c.debut <= :now) ORDER BY c.debut ASC",
                            Creneau.class)
                    .setParameter("specialisteId", specialisteId)
                    .setParameter("statut", StatutCreneau.DISPONIBLE)
                    .setParameter("now", now)
                    .getResultList();
        }
    }

    public void saveDemandeExpertise(Long consultationId, Long specialisteId, Long creneauId,
                                     String question, PrioriteExpertise priorite) {
        try (EntityManager em = HibernateUtil.getEntityManagerFactory().createEntityManager()) {
            em.getTransaction().begin();
            try {
                Consultation consultation = em.find(Consultation.class, consultationId);
                Creneau creneau = em.find(Creneau.class, creneauId);

                DemandeExpertise demande = new DemandeExpertise();
                demande.setConsultation(consultation);
                demande.setSpecialiste(em.find(Utilisateur.class, specialisteId));
                demande.setCreneau(creneau);
                demande.setQuestion(question);
                demande.setPriorite(priorite);
                demande.setStatut(StatutExpertise.EN_ATTENTE);
                em.persist(demande);

                consultation.setStatut(StatutConsultation.EN_ATTENTE_AVIS_SPECIALISTE);
                creneau.setStatut(StatutCreneau.INDISPONIBLE);

                em.getTransaction().commit();
            } catch (RuntimeException e) {
                if (em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                throw e;
            }
        }
    }
}
