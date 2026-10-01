package model;

import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "creneaux")
public class Creneau {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "specialiste_id", nullable = false)
    private Staff specialiste;

    @Column(nullable = false)
    private LocalDateTime debut;

    @Column(nullable = false)
    private LocalDateTime fin;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatutCreneau statut = StatutCreneau.DISPONIBLE;

    @OneToMany(mappedBy = "creneau")
    private List<DemandeExpertise> demandesExpertise = new ArrayList<>();

    public Creneau() {
    }

    public Long getId() {
        return id;
    }

    public Staff getSpecialiste() {
        return specialiste;
    }

    public void setSpecialiste(Staff specialiste) {
        this.specialiste = specialiste;
    }

    public LocalDateTime getDebut() {
        return debut;
    }

    public void setDebut(LocalDateTime debut) {
        this.debut = debut;
    }

    public LocalDateTime getFin() {
        return fin;
    }

    public void setFin(LocalDateTime fin) {
        this.fin = fin;
    }

    public StatutCreneau getStatut() {
        return statut;
    }

    public void setStatut(StatutCreneau statut) {
        this.statut = statut;
    }
}