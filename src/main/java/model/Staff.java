package model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import enums.Role;

@Entity
@Table(name = "staff")
public class Staff {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String nom;

    @Column(nullable = false, length = 100)
    private String prenom;

    @Column(nullable = false, unique = true, length = 150)
    private String email;

    @Column(nullable = false)
    private String password;

    @Enumerated(EnumType.STRING) // save GENERALISTE note 1
    @Column(nullable = false, length = 20)
    private Role role;

    private String specialite;

    @Column(precision = 10, scale = 2)
    private BigDecimal tarif;

    // Bidirectional
    @OneToMany(mappedBy = "generaliste")
    private List<Consultation> consultations = new ArrayList<>();

    @OneToMany(mappedBy = "specialiste")
    private List<Creneau> creneaux = new ArrayList<>();

    @OneToMany(mappedBy = "specialiste")
    private List<DemandeExpertise> demandesExpertise = new ArrayList<>();

    public Staff() {
    }

    public Staff(String nom, String prenom, String email,
                 String password, Role role,
                 String specialite, BigDecimal tarif) {
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.password = password;
        this.role = role;
        this.specialite = specialite;
        this.tarif = tarif;
    }

    // getters and setters
    public Long getId() {
        return id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public String getSpecialite() {
        return specialite;
    }

    public void setSpecialite(String specialite) {
        this.specialite = specialite;
    }

    public BigDecimal getTarif() {
        return tarif;
    }

    public void setTarif(BigDecimal tarif) {
        this.tarif = tarif;
    }
}