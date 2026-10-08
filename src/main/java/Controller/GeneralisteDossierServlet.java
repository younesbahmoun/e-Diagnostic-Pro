package Controller;

import enums.Role;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Consultation;
import model.Utilisateur;
import service.GeneralisteService;

import java.io.IOException;

@WebServlet("/generaliste/dossier")
public class GeneralisteDossierServlet extends HttpServlet {

    private GeneralisteService generalisteService;

    @Override
    public void init() {
        generalisteService = new GeneralisteService();
    }

    private boolean requireGeneraliste(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        Utilisateur user = session == null ? null : (Utilisateur) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        if (user.getRole() != Role.GENERALISTE) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès réservé au médecin généraliste.");
            return false;
        }
        return true;
    }

    private void chargerDossier(HttpServletRequest request, Long patientId) {
        request.setAttribute("patient", generalisteService.dossierPatient(patientId));
        request.setAttribute("signesVitaux", generalisteService.signesVitauxRecents(patientId));
        request.setAttribute("consultations", generalisteService.consultationsPatient(patientId));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireGeneraliste(request, response)) {
            return;
        }
        try {
            String patientId = request.getParameter("patientId");
            if (patientId == null || patientId.isBlank()) {
                request.setAttribute("fileAttente", generalisteService.patientsEnAttente());
            } else {
                chargerDossier(request, Long.valueOf(patientId));
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Une erreur est survenue, veuillez réessayer.");
        }
        request.getRequestDispatcher("/WEB-INF/JSP/generaliste/dossier.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireGeneraliste(request, response)) {
            return;
        }
        Long patientId = Long.valueOf(request.getParameter("patientId"));
        try {
            Utilisateur generaliste = (Utilisateur) request.getSession().getAttribute("user");
            Consultation consultation = generalisteService.creerConsultation(
                    patientId,
                    generaliste.getId(),
                    request.getParameter("motif"),
                    request.getParameter("observations"));
            response.sendRedirect(request.getContextPath() + "/generaliste/consultation?id=" + consultation.getId());
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Une erreur est survenue, veuillez réessayer.");
            try {
                chargerDossier(request, patientId);
            } catch (Exception ignored) {
            }
            request.getRequestDispatcher("/WEB-INF/JSP/generaliste/dossier.jsp").forward(request, response);
        }
    }
}
