package Controller;

import enums.PrioriteExpertise;
import enums.Role;
import enums.StatutConsultation;
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

@WebServlet("/generaliste/consultation")
public class GeneralisteConsultationServlet extends HttpServlet {

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

    private void chargerConsultation(HttpServletRequest request, Long consultationId) {
        Consultation consultation = generalisteService.consultation(consultationId);
        request.setAttribute("consultation", consultation);
        request.setAttribute("signesVitaux",
                generalisteService.signesVitauxRecents(consultation.getPatient().getId()));
        request.setAttribute("demandes", generalisteService.demandesConsultation(consultationId));
        if (consultation.getStatut() == StatutConsultation.EN_COURS) {
            request.setAttribute("specialites", generalisteService.specialites());
            String specialite = request.getParameter("specialite");
            if (specialite != null && !specialite.isBlank()) {
                request.setAttribute("specialiteChoisie", specialite);
                request.setAttribute("specialistes", generalisteService.specialistes(specialite));
            }
            String specialisteId = request.getParameter("specialisteId");
            if (specialisteId != null && !specialisteId.isBlank()) {
                Long sid = Long.valueOf(specialisteId);
                request.setAttribute("specialisteChoisi", generalisteService.specialiste(sid));
                request.setAttribute("creneauxDisponibles", generalisteService.creneauxDisponibles(sid));
                request.setAttribute("autresCreneaux", generalisteService.autresCreneaux(sid));
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireGeneraliste(request, response)) {
            return;
        }
        try {
            chargerConsultation(request, Long.valueOf(request.getParameter("id")));
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Une erreur est survenue, veuillez réessayer.");
        }
        request.getRequestDispatcher("/WEB-INF/JSP/generaliste/consultation.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireGeneraliste(request, response)) {
            return;
        }
        Long consultationId = Long.valueOf(request.getParameter("id"));
        try {
            String action = request.getParameter("action");
            if ("cloturer".equals(action)) {
                generalisteService.cloturerConsultation(
                        consultationId,
                        request.getParameter("diagnostic"),
                        request.getParameter("traitement"));
                response.sendRedirect(
                        request.getContextPath() + "/generaliste/consultation?id=" + consultationId);
            } else if ("demande".equals(action)) {
                generalisteService.demanderExpertise(
                        consultationId,
                        Long.valueOf(request.getParameter("specialisteId")),
                        Long.valueOf(request.getParameter("creneauId")),
                        request.getParameter("question"),
                        PrioriteExpertise.valueOf(request.getParameter("priorite")));
                response.sendRedirect(
                        request.getContextPath() + "/generaliste/consultation?id=" + consultationId + "&demandeOk=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/generaliste/dossier");
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Une erreur est survenue, veuillez réessayer.");
            try {
                chargerConsultation(request, consultationId);
            } catch (Exception ignored) {
            }
            request.getRequestDispatcher("/WEB-INF/JSP/generaliste/consultation.jsp").forward(request, response);
        }
    }
}
