package model;

import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Table(name = "consultations")
public class Consultation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false) // owning side
    private Patient patient; // unidirectional

    @ManyToOne
    @JoinColumn(name = "generaliste_id", nullable = false)
    private Staff generaliste;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String motif;

    @Column(columnDefinition = "TEXT")
    private String observations;

    @Column(columnDefinition = "TEXT")
    private String diagnostic;

    @Column(columnDefinition = "TEXT")
    private String traitement;

    @Column(precision = 10, scale = 2)
    private BigDecimal cout = new BigDecimal("150.00");

    @Enumerated(EnumType.STRING)
    private StatutConsultation statut = StatutConsultation.EN_COURS;

    @Column(name = "date_consultation")
    private LocalDateTime dateConsultation;

    @OneToMany(mappedBy = "consultation")
    private List<DemandeExpertise> demandesExpertise = new ArrayList<>();

    @ManyToMany
    @JoinTable(
        name = "consultation_actes",
        joinColumns = @JoinColumn(name = "consultation_id"), // entity this class
        inverseJoinColumns = @JoinColumn(name = "acte_id") // entity other class
    )
    private Set<ActeTechnique> actes = new HashSet<>();

    public Consultation() {
    }

    @PrePersist // creation object
    public void prePersist() {
        if (dateConsultation == null) {
            dateConsultation = LocalDateTime.now();
        }
    }

    public Long getId() {
        return id;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public Staff getGeneraliste() {
        return generaliste;
    }

    public void setGeneraliste(Staff generaliste) {
        this.generaliste = generaliste;
    }

    public String getMotif() {
        return motif;
    }

    public void setMotif(String motif) {
        this.motif = motif;
    }

    public String getObservations() {
        return observations;
    }

    public void setObservations(String observations) {
        this.observations = observations;
    }

    public String getDiagnostic() {
        return diagnostic;
    }

    public void setDiagnostic(String diagnostic) {
        this.diagnostic = diagnostic;
    }

    public String getTraitement() {
        return traitement;
    }

    public void setTraitement(String traitement) {
        this.traitement = traitement;
    }

    public BigDecimal getCout() {
        return cout;
    }

    public void setCout(BigDecimal cout) {
        this.cout = cout;
    }

    public StatutConsultation getStatut() {
        return statut;
    }

    public void setStatut(StatutConsultation statut) {
        this.statut = statut;
    }

    public Set<ActeTechnique> getActes() {
        return actes;
    }
}