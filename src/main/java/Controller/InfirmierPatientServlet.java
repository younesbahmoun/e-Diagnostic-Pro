package Controller;

import enums.Role;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Patient;
import model.SigneVital;
import model.Utilisateur;
import service.InfirmierService;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Optional;

@WebServlet("/infirmier/patient")
public class InfirmierPatientServlet extends HttpServlet {

    private InfirmierService infirmierService;

    @Override
    public void init() {
        infirmierService = new InfirmierService();
    }

    private boolean requireInfirmier(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        Utilisateur user = session == null ? null : (Utilisateur) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        if (user.getRole() != Role.INFIRMIER) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès réservé au personnel infirmier.");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireInfirmier(request, response)) {
            return;
        }
        try {
            String numero = request.getParameter("numero");
            if (numero != null && !numero.isBlank()) {
                Optional<Patient> patient = infirmierService.rechercherPatient(numero);
                if (patient.isPresent()) {
                    request.setAttribute("patient", patient.get());
                } else {
                    request.setAttribute("numeroRecherche", numero);
                    request.setAttribute("patientNonTrouve", true);
                }
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Une erreur est survenue, veuillez réessayer.");
        }
        request.getRequestDispatcher("/WEB-INF/JSP/infirmier/patient.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireInfirmier(request, response)) {
            return;
        }
        try {
            String action = request.getParameter("action");
            if ("nouveau".equals(action)) {
                Patient patient = new Patient();
                patient.setNom(request.getParameter("nom"));
                patient.setPrenom(request.getParameter("prenom"));
                patient.setDateNaissance(LocalDate.parse(request.getParameter("dateNaissance")));
                patient.setNumeroSecuriteSociale(request.getParameter("numeroSecuriteSociale"));
                patient.setTelephone(request.getParameter("telephone"));
                patient.setAdresse(request.getParameter("adresse"));
                patient.setMutuelle(request.getParameter("mutuelle"));
                patient.setAntecedents(request.getParameter("antecedents"));
                patient.setAllergies(request.getParameter("allergies"));
                patient.setTraitementsEnCours(request.getParameter("traitementsEnCours"));
                SigneVital signeVital = creerSigneVital(request);
                infirmierService.enregistrerNouveauPatient(patient, signeVital);
            }
            if ("existant".equals(action)) {
                String numero = request.getParameter("numeroSecuriteSociale");
                Optional<Patient> patient = infirmierService.rechercherPatient(numero);
                if (patient.isPresent()) {
                    SigneVital signeVital = creerSigneVital(request);
                    infirmierService.enregistrerPatientExistant(patient.get(), signeVital);
                }
            }
            response.sendRedirect(request.getContextPath() + "/infirmier/file-attente");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Une erreur est survenue, veuillez réessayer.");
            request.getRequestDispatcher("/WEB-INF/JSP/infirmier/patient.jsp").forward(request, response);
        }
    }

    private SigneVital creerSigneVital(HttpServletRequest request) {
        SigneVital signeVital = new SigneVital();
        signeVital.setTensionArterielle(request.getParameter("tensionArterielle"));
        signeVital.setFrequenceCardiaque(Integer.valueOf(request.getParameter("frequenceCardiaque")));
        signeVital.setTemperature(new BigDecimal(request.getParameter("temperature")));
        signeVital.setFrequenceRespiratoire(Integer.valueOf(request.getParameter("frequenceRespiratoire")));
        signeVital.setPoids(new BigDecimal(request.getParameter("poids")));
        signeVital.setTaille(new BigDecimal(request.getParameter("taille")));
        return signeVital;
    }
}
