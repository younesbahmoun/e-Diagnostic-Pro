package Controller;

import enums.Role;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Utilisateur;
import service.InfirmierService;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/infirmier/file-attente")
public class FileAttenteServlet extends HttpServlet {

    private final InfirmierService infirmierService = new InfirmierService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setHeader("Cache-Control", "no-store");
        HttpSession session = request.getSession(false);
        Utilisateur user = session == null ? null : (Utilisateur) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (user.getRole() != Role.INFIRMIER) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès réservé au personnel infirmier.");
            return;
        }

        try {
            request.setAttribute("fileAttente", infirmierService.afficherFileAttenteDuJour());
        } catch (RuntimeException exception) {
            getServletContext().log("Échec du chargement de la file d'attente", exception);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            request.setAttribute("errorMessage", "La file d'attente n'a pas pu être chargée. Veuillez réessayer.");
        }
        request.setAttribute("today", LocalDate.now());
        request.getRequestDispatcher("/WEB-INF/JSP/infirmier/file-attente.jsp").forward(request, response);
    }
}
