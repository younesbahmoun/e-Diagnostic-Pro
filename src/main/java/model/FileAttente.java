package model;

import jakarta.persistence.*;

import java.time.LocalDateTime;

import enums.StatutFileAttente;

@Entity
@Table(name = "file_attente")
public class FileAttente {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @Column(name = "heure_arrivee")
    private LocalDateTime heureArrivee;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatutFileAttente statut = StatutFileAttente.EN_ATTENTE;

    public FileAttente() {
    }

    @PrePersist
    public void prePersist() {
        if (heureArrivee == null) {
            heureArrivee = LocalDateTime.now();
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

    public LocalDateTime getHeureArrivee() {
        return heureArrivee;
    }

    public StatutFileAttente getStatut() {
        return statut;
    }

    public void setStatut(StatutFileAttente statut) {
        this.statut = statut;
    }
}