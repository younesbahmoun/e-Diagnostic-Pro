package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import enums.Role;
import model.Utilisateur;
import service.AuthService;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/JSP/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String roleStr = request.getParameter("role");
            String specialite = request.getParameter("specialite");
            String tarifStr = request.getParameter("tarif");

            Utilisateur staff = new Utilisateur();
            staff.setNom(nom);
            staff.setPrenom(prenom);
            staff.setEmail(email);
            staff.setRole(Role.valueOf(roleStr));
            
            if (specialite != null && !specialite.isEmpty()) staff.setSpecialite(specialite);
            if (tarifStr != null && !tarifStr.isEmpty()) staff.setTarif(new BigDecimal(tarifStr));

            authService.register(staff, password);

            response.sendRedirect(request.getContextPath() + "/login?success=registered");

        } catch (Exception e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/JSP/register.jsp").forward(request, response);
        }
    }
}
