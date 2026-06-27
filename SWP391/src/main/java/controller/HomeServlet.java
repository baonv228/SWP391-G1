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
        User user = (User) session.getAttribute("user");
        int roleId = (user != null) ? user.getRoleId() : -1;

        if ("Admin".equalsIgnoreCase(roleName) || "Training Department".equalsIgnoreCase(roleName) || roleId == 1 || roleId == 4) {
            request.getRequestDispatcher("/view/TrainingDepartment.jsp").forward(request, response);
            return;
        } else if ("Teacher".equalsIgnoreCase(roleName) || roleId == 3) {
            response.sendRedirect(request.getContextPath() + "/teacher/dashboard");
            return;
        } else if ("Student".equalsIgnoreCase(roleName) || roleId == 2) {
            request.getRequestDispatcher("/view/home.jsp").forward(request, response);
            return;
        }

        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Vai trò này chưa được cấp trang Home.");
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
