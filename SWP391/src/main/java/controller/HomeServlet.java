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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String roleName = resolveRoleName(session);
        String normalizedRole = normalizeRole(roleName);
        User user = (User) session.getAttribute("user");
        int roleId = (user != null) ? user.getRoleId() : -1;

        if ("trainingdepartment".equals(normalizedRole) || roleId == 4) {
            request.getRequestDispatcher("/view/TrainingDepartment.jsp").forward(request, response);
            return;
        }

        if ("teacher".equals(normalizedRole) || roleId == 3) {
            response.sendRedirect(request.getContextPath() + "/teacher/dashboard");
            return;
        }

        if ("student".equals(normalizedRole) || roleId == 2) {
            request.getRequestDispatcher("/view/home.jsp").forward(request, response);
            return;
        }

        if ("syllabusdesigner".equals(normalizedRole) || roleId == 5) {
            request.getRequestDispatcher("/view/SyllabusDesignerHome.jsp").forward(request, response);
            return;
        }

        if ("admin".equals(normalizedRole) || roleId == 1) {
            try {
                dao.ReportDAO reportDAO = new dao.ReportDAO();
                java.util.Map<String, Integer> dashboardStats = reportDAO.getAdminSummary();
                request.setAttribute("dashboardStats", dashboardStats);
            } catch (Exception e) {
                getServletContext().log("Admin dashboard stats error", e);
                request.setAttribute("dashboardStats", new java.util.LinkedHashMap<String, Integer>());
            }
            request.getRequestDispatcher("/view/AdminHome.jsp").forward(request, response);
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

    private String normalizeRole(String roleName) {
        return roleName == null ? "" : roleName.replaceAll("\\s+", "").toLowerCase();
    }
}
