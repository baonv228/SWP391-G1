package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    private static final String TRAINING_DEPARTMENT_ROLE = "Training Department";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String roleName = resolveRoleName(session);
        if (TRAINING_DEPARTMENT_ROLE.equalsIgnoreCase(roleName)) {
            request.getRequestDispatcher("/view/TrainingDepartment.jsp").forward(request, response);
            return;
        }

        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Role nay chua duoc cap trang home.");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private String resolveRoleName(HttpSession session) {
        Object roleName = session.getAttribute("roleName");
        if (roleName instanceof String value && !value.isBlank()) {
            return value.trim();
        }

        Object userObject = session.getAttribute("user");
        if (userObject instanceof User user && user.getRole() != null) {
            String resolvedRoleName = user.getRole().getRoleName();
            if (resolvedRoleName != null) {
                session.setAttribute("roleName", resolvedRoleName);
                session.setAttribute("roleId", user.getRoleId());
                return resolvedRoleName.trim();
            }
        }
        return "";
    }
}
