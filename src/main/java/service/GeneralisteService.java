package service;

import enums.PrioriteExpertise;
import model.Consultation;
import model.Creneau;
import model.DemandeExpertise;
import model.FileAttente;
import model.Patient;
import model.SigneVital;
import model.Utilisateur;
import repository.GeneralisteRepository;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;

public class GeneralisteService {

    private final GeneralisteRepository repository = new GeneralisteRepository();

    public List<FileAttente> patientsEnAttente() {
        return repository.findFileAttenteEnAttente();
    }

    public Patient dossierPatient(Long patientId) {
        Patient patient = repository.findPatientAvecSignesVitaux(patientId);
        if (patient == null) {
            throw new RuntimeException("Patient introuvable.");
        }
        return patient;
    }

    public List<SigneVital> signesVitauxRecents(Long patientId) {
        return dossierPatient(patientId).getSignesVitaux().stream()
                .sorted(Comparator.comparing(SigneVital::getDateMesure,
                        Comparator.nullsLast(Comparator.naturalOrder())).reversed())
                .toList();
    }

    public List<Consultation> consultationsPatient(Long patientId) {
        return repository.findConsultationsByPatient(patientId);
    }

    public Consultation creerConsultation(Long patientId, Long generalisteId, String motif, String observations) {
        return repository.saveConsultation(patientId, generalisteId, motif, observations);
    }

    public Consultation consultation(Long consultationId) {
        Consultation consultation = repository.findConsultationAvecPatient(consultationId);
        if (consultation == null) {
            throw new RuntimeException("Consultation introuvable.");
        }
        return consultation;
    }

    public List<DemandeExpertise> demandesConsultation(Long consultationId) {
        return repository.findDemandesByConsultation(consultationId);
    }

    public void cloturerConsultation(Long consultationId, String diagnostic, String traitement) {
        repository.cloturerConsultation(consultationId, diagnostic, traitement);
    }

    public List<String> specialites() {
        return repository.findSpecialites();
    }

    public List<Utilisateur> specialistes(String specialite) {
        return repository.findAllSpecialistes().stream()
                .filter(s -> specialite.equals(s.getSpecialite()))
                .sorted(Comparator.comparing(Utilisateur::getTarif,
                        Comparator.nullsLast(Comparator.naturalOrder())))
                .toList();
    }

    public Utilisateur specialiste(Long specialisteId) {
        return repository.findSpecialisteById(specialisteId);
    }

    public List<Creneau> creneauxDisponibles(Long specialisteId) {
        return repository.findCreneauxDisponiblesFuturs(specialisteId, LocalDateTime.now());
    }

    public List<Creneau> autresCreneaux(Long specialisteId) {
        return repository.findAutresCreneaux(specialisteId, LocalDateTime.now());
    }

    public void demanderExpertise(Long consultationId, Long specialisteId, Long creneauId,
                                  String question, PrioriteExpertise priorite) {
        repository.saveDemandeExpertise(consultationId, specialisteId, creneauId, question, priorite);
    }
}
