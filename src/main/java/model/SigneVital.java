package model;

import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "signes_vitaux")
public class SigneVital {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @Column(name = "tension_arterielle")
    private String tensionArterielle;

    @Column(name = "frequence_cardiaque")
    private Integer frequenceCardiaque;

    @Column(precision = 4, scale = 1)
    private BigDecimal temperature;

    @Column(name = "frequence_respiratoire")
    private Integer frequenceRespiratoire;

    @Column(precision = 5, scale = 2)
    private BigDecimal poids;

    @Column(precision = 5, scale = 2)
    private BigDecimal taille;

    @Column(name = "date_mesure")
    private LocalDateTime dateMesure;

    public SigneVital() {
    }

    @PrePersist
    public void prePersist() {
        dateMesure = LocalDateTime.now();
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

    public String getTensionArterielle() {
        return tensionArterielle;
    }

    public void setTensionArterielle(String tensionArterielle) {
        this.tensionArterielle = tensionArterielle;
    }

    public Integer getFrequenceCardiaque() {
        return frequenceCardiaque;
    }

    public void setFrequenceCardiaque(Integer frequenceCardiaque) {
        this.frequenceCardiaque = frequenceCardiaque;
    }

    public BigDecimal getTemperature() {
        return temperature;
    }

    public void setTemperature(BigDecimal temperature) {
        this.temperature = temperature;
    }

    public Integer getFrequenceRespiratoire() {
        return frequenceRespiratoire;
    }

    public void setFrequenceRespiratoire(Integer frequenceRespiratoire) {
        this.frequenceRespiratoire = frequenceRespiratoire;
    }

    public BigDecimal getPoids() {
        return poids;
    }

    public void setPoids(BigDecimal poids) {
        this.poids = poids;
    }

    public BigDecimal getTaille() {
        return taille;
    }

    public void setTaille(BigDecimal taille) {
        this.taille = taille;
    }
}