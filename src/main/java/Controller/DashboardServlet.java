package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Utilisateur;
import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Utilisateur user = (session != null) ? (Utilisateur) session.getAttribute("user") : null;

        // Verifier si utilisateur est connecte
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String jspPage;
        switch (user.getRole()) {
            case INFIRMIER:
                jspPage = "/WEB-INF/JSP/infirmier/dashboard.jsp";
                break;
            case GENERALISTE:
                jspPage = "/WEB-INF/JSP/generaliste/dashboard.jsp";
                break;
            case SPECIALISTE:
                jspPage = "/WEB-INF/JSP/specialiste/dashboard.jsp";
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/login");
                return;
        }

        request.getRequestDispatcher(jspPage).forward(request, response);
    }
}
