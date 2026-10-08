package service;

import model.FileAttente;
import model.Patient;
import model.SigneVital;
import repository.InfirmierRepository;

import java.util.List;
import java.util.Optional;

public class InfirmierService {

    private final InfirmierRepository infirmierRepository = new InfirmierRepository();

    public Optional<Patient> rechercherPatient(String numeroSecuriteSociale) {
        return infirmierRepository.findPatientByNumeroSecuriteSociale(numeroSecuriteSociale);
    }

    public void enregistrerNouveauPatient(Patient patient, SigneVital signeVital) {
        FileAttente fileAttente = new FileAttente();
        infirmierRepository.save(patient, signeVital, fileAttente);
    }

    public void enregistrerPatientExistant(Patient patient, SigneVital signeVital) {
        FileAttente fileAttente = new FileAttente();
        infirmierRepository.saveSigneVitalAndFileAttente(patient, signeVital, fileAttente);
    }

    public List<FileAttente> afficherFileAttenteDuJour() {
        return infirmierRepository.findFileAttenteToday();
    }
}
