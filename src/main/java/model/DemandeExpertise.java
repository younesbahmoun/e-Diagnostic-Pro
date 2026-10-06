package model;

import jakarta.persistence.*;

import java.time.LocalDateTime;

import enums.PrioriteExpertise;
import enums.StatutExpertise;

@Entity
@Table(name = "demandes_expertise")
public class DemandeExpertise {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "consultation_id", nullable = false)
    private Consultation consultation;

    @ManyToOne
    @JoinColumn(name = "specialiste_id", nullable = false)
    private Staff specialiste;

    @ManyToOne
    @JoinColumn(name = "creneau_id")
    private Creneau creneau;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String question;

    @Column(name = "donnees_analyses", columnDefinition = "TEXT")
    private String donneesAnalyses;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PrioriteExpertise priorite;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatutExpertise statut = StatutExpertise.EN_ATTENTE;

    @Column(name = "avis_medical", columnDefinition = "TEXT")
    private String avisMedical;

    @Column(columnDefinition = "TEXT")
    private String recommandations;

    @Column(name = "date_demande")
    private LocalDateTime dateDemande;

    public DemandeExpertise() {
    }

    @PrePersist
    public void prePersist() {
        if (dateDemande == null) {
            dateDemande = LocalDateTime.now();
        }
    }

    public Long getId() {
        return id;
    }

    public Consultation getConsultation() {
        return consultation;
    }

    public void setConsultation(Consultation consultation) {
        this.consultation = consultation;
    }

    public Staff getSpecialiste() {
        return specialiste;
    }

    public void setSpecialiste(Staff specialiste) {
        this.specialiste = specialiste;
    }

    public Creneau getCreneau() {
        return creneau;
    }

    public void setCreneau(Creneau creneau) {
        this.creneau = creneau;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getDonneesAnalyses() {
        return donneesAnalyses;
    }

    public void setDonneesAnalyses(String donneesAnalyses) {
        this.donneesAnalyses = donneesAnalyses;
    }

    public PrioriteExpertise getPriorite() {
        return priorite;
    }

    public void setPriorite(PrioriteExpertise priorite) {
        this.priorite = priorite;
    }

    public StatutExpertise getStatut() {
        return statut;
    }

    public void setStatut(StatutExpertise statut) {
        this.statut = statut;
    }

    public String getAvisMedical() {
        return avisMedical;
    }

    public void setAvisMedical(String avisMedical) {
        this.avisMedical = avisMedical;
    }

    public String getRecommandations() {
        return recommandations;
    }

    public void setRecommandations(String recommandations) {
        this.recommandations = recommandations;
    }
}