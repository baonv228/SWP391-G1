package controller;

import dao.SyllabusDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebServlet(name = "RequestListServlet", urlPatterns = {"/request-list"})
public class RequestListServlet extends HttpServlet {

    private final SyllabusDAO syllabusDAO = new SyllabusDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = getAllowedUser(request, response);
        if (user == null) {
            return;
        }

        request.setAttribute("requests", syllabusDAO.getPendingApprovalSyllabuses());
        request.getRequestDispatcher("/view/RequestList.jsp").forward(request, response);
    }

    private User getAllowedUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }

        User user = (User) session.getAttribute("user");
        String roleName = resolveRoleName(session, user);
        if (!isAllowedRole(roleName)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Ban khong co quyen truy cap.");
            return null;
        }
        return user;
    }

    private boolean isAllowedRole(String roleName) {
        if (roleName == null) {
            return false;
        }
        String normalizedRole = roleName.replaceAll("\\s+", "").toLowerCase();
        return "trainingdepartment".equals(normalizedRole) || "admin".equals(normalizedRole);
    }

    private String resolveRoleName(HttpSession session, User user) {
        Object roleName = session.getAttribute("roleName");
        if (roleName instanceof String value && !value.isBlank()) {
            return value.trim();
        }
        if (user != null && user.getRole() != null && user.getRole().getRoleName() != null) {
            String resolvedRoleName = user.getRole().getRoleName().trim();
            session.setAttribute("roleName", resolvedRoleName);
            session.setAttribute("roleId", user.getRoleId());
            return resolvedRoleName;
        }
        return "";
    }
}
