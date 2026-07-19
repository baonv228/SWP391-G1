package controller;

import dao.SyllabusDAO;
import dto.SyllabusDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import model.User;

@WebServlet(name = "ProcessRequestServlet", urlPatterns = {"/process-request"})
public class ProcessRequestServlet extends HttpServlet {

    private final SyllabusDAO syllabusDAO = new SyllabusDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = getAllowedUser(request, response);
        if (user == null) {
            return;
        }

        int syllabusId = parseInt(request.getParameter("syllabusId"), 0);
        if (syllabusId <= 0) {
            response.sendRedirect(request.getContextPath() + "/request-list");
            return;
        }

        try {
            SyllabusDTO syllabus = syllabusDAO.getSyllabusDtoById(syllabusId);
            if (syllabus == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Syllabus not found.");
                return;
            }
            request.setAttribute("syllabus", syllabus);
            request.getRequestDispatcher("/view/ProcessRequest.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Cannot load syllabus request.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        User user = getAllowedUser(request, response);
        if (user == null) {
            return;
        }

        int syllabusId = parseInt(request.getParameter("syllabusId"), 0);
        String action = safeTrim(request.getParameter("action"));
        if (syllabusId <= 0) {
            response.sendRedirect(request.getContextPath() + "/request-list");
            return;
        }

        boolean success;
        if ("approve".equalsIgnoreCase(action)) {
            success = syllabusDAO.approveSyllabus(syllabusId, user.getUserId());
        } else if ("reject".equalsIgnoreCase(action)) {
            String reason = safeTrim(request.getParameter("rejectReason"));
            if (reason.isBlank()) {
                forwardWithError("Reject reason is required.", syllabusId, request, response);
                return;
            }
            success = syllabusDAO.rejectSyllabus(syllabusId, user.getUserId(), reason);
        } else {
            response.sendRedirect(request.getContextPath() + "/process-request?syllabusId=" + syllabusId);
            return;
        }

        if (!success) {
            forwardWithError("Cannot process this request. Please check database.", syllabusId, request, response);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/request-list");
    }

    private void forwardWithError(String error, int syllabusId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("error", error);
            request.setAttribute("syllabus", syllabusDAO.getSyllabusDtoById(syllabusId));
            request.getRequestDispatcher("/view/ProcessRequest.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Cannot reload syllabus request.", e);
        }
    }

    private User getAllowedUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        User user = (User) session.getAttribute("user");
        String roleName = resolveRoleName(session, user).replaceAll("\\s+", "").toLowerCase();
        if (!"trainingdepartment".equals(roleName) && !"admin".equals(roleName)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Ban khong co quyen truy cap.");
            return null;
        }
        return user;
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

    private int parseInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return defaultValue;
        }
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
