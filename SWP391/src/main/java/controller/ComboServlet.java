package controller;

import dao.ComboDAO;
import dao.CurriculumDAO;
import dao.SubjectDAO;
import dto.CurriculumDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import model.Combo;
import model.ComboSubject;
import model.Subject;
import model.User;

@WebServlet(name = "ComboServlet", urlPatterns = {"/combo"})
public class ComboServlet extends HttpServlet {

    private static final String TRAINING_DEPARTMENT_ROLE = "Training Department";
    private final ComboDAO comboDAO = new ComboDAO();
    private final CurriculumDAO curriculumDAO = new CurriculumDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = safeTrim(request.getParameter("action"));
        if (action.isEmpty() || "list".equals(action)) {
            showList(request, response);
            return;
        }
        if ("detail".equals(action)) {
            showDetail(request, response);
            return;
        }
        if ("create".equals(action)) {
            User user = getLoggedInTrainingDepartment(request, response);
            if (user == null) {
                return;
            }
            showCreateForm(request, response);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/curriculum");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = safeTrim(request.getParameter("action"));
        if ("create".equals(action)) {
            User user = getLoggedInTrainingDepartment(request, response);
            if (user == null) {
                return;
            }
            processCreate(request, response);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/curriculum");
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int curriculumId = parsePositiveInt(request.getParameter("curriculumId"), 0);
        if (curriculumId <= 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid curriculum ID.");
            return;
        }

        try {
            CurriculumDTO curriculum = curriculumDAO.getCurriculumById(curriculumId);
            if (curriculum == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Curriculum not found.");
                return;
            }

            List<Combo> combos = comboDAO.getCombosByCurriculumId(curriculumId);
            request.setAttribute("curriculum", curriculum);
            request.setAttribute("combos", combos);
            request.setAttribute("canCreateCombo", isTrainingDepartment(request));
            request.getRequestDispatcher("/view/comboList.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("Database error in ComboServlet", e);
            request.getRequestDispatcher("/view/error/dbError.jsp").forward(request, response);
        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int curriculumId = parsePositiveInt(request.getParameter("curriculumId"), 0);
        if (curriculumId <= 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid curriculum ID.");
            return;
        }

        try {
            CurriculumDTO curriculum = curriculumDAO.getCurriculumById(curriculumId);
            if (curriculum == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Curriculum not found.");
                return;
            }

            request.setAttribute("curriculum", curriculum);
            request.setAttribute("subjects", subjectDAO.getAllSubjects());
            request.getRequestDispatcher("/view/createCombo.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("Database error in ComboServlet", e);
            request.getRequestDispatcher("/view/error/dbError.jsp").forward(request, response);
        }
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int comboId = parsePositiveInt(request.getParameter("comboId"), 0);
        if (comboId <= 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid combo ID.");
            return;
        }

        try {
            Combo combo = comboDAO.getComboById(comboId);
            if (combo == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Combo not found.");
                return;
            }

            CurriculumDTO curriculum = curriculumDAO.getCurriculumById(combo.getCurriculumId());
            if (curriculum == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Curriculum not found.");
                return;
            }

            request.setAttribute("combo", combo);
            request.setAttribute("curriculum", curriculum);
            request.setAttribute("subjects", comboDAO.getSubjectsByComboId(comboId));
            request.getRequestDispatcher("/view/comboDetail.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("Database error in ComboServlet", e);
            request.getRequestDispatcher("/view/error/dbError.jsp").forward(request, response);
        }
    }

    private void processCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int curriculumId = parsePositiveInt(request.getParameter("curriculumId"), 0);
        Combo combo = new Combo();
        combo.setCurriculumId(curriculumId);
        combo.setComboName(safeTrim(request.getParameter("comboName")));
        combo.setDescription(safeTrim(request.getParameter("description")));
        combo.setStatus(safeTrim(request.getParameter("status")));
        combo.setDisplayOrder(parseNullablePositiveInt(request.getParameter("displayOrder")));
        List<ComboSubject> comboSubjects = parseComboSubjects(request);

        String validationError = validateCreate(combo, comboSubjects);
        if (validationError != null) {
            request.setAttribute("error", validationError);
            request.setAttribute("combo", combo);
            showCreateForm(request, response);
            return;
        }

        int comboId = comboDAO.createCombo(combo, comboSubjects);
        if (comboId <= 0) {
            request.setAttribute("error", "Khong the tao combo. Vui long kiem tra database.");
            request.setAttribute("combo", combo);
            showCreateForm(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/combo?action=list&curriculumId=" + curriculumId);
    }

    private List<ComboSubject> parseComboSubjects(HttpServletRequest request) {
        List<ComboSubject> subjects = new ArrayList<>();
        String[] subjectIds = request.getParameterValues("subjectIds");
        String[] semesterNos = request.getParameterValues("semesterNos");
        if (subjectIds == null) {
            return subjects;
        }

        for (int i = 0; i < subjectIds.length; i++) {
            int subjectId = parsePositiveInt(subjectIds[i], 0);
            if (subjectId <= 0) {
                continue;
            }
            ComboSubject subject = new ComboSubject();
            subject.setSubjectId(subjectId);
            if (semesterNos != null && i < semesterNos.length) {
                subject.setSemesterNo(parseNullablePositiveInt(semesterNos[i]));
            }
            subjects.add(subject);
        }
        return subjects;
    }

    private String validateCreate(Combo combo, List<ComboSubject> comboSubjects) {
        if (combo.getCurriculumId() <= 0) {
            return "Curriculum khong hop le.";
        }
        if (combo.getComboName() == null || combo.getComboName().isBlank()) {
            return "Vui long nhap ten combo.";
        }
        if (combo.getDescription() == null || combo.getDescription().isBlank()) {
            return "Vui long nhap mo ta combo.";
        }
        if (combo.getStatus() == null || combo.getStatus().isBlank()) {
            combo.setStatus("Active");
        }
        if (!"Active".equalsIgnoreCase(combo.getStatus()) && !"Inactive".equalsIgnoreCase(combo.getStatus())) {
            return "Status cua combo chi duoc la Active hoac Inactive.";
        }
        if (comboSubjects == null || comboSubjects.isEmpty()) {
            return "Vui long them it nhat mot mon hoc cho combo.";
        }

        Set<Integer> uniqueSubjectIds = new HashSet<>();
        for (ComboSubject subject : comboSubjects) {
            if (!uniqueSubjectIds.add(subject.getSubjectId())) {
                return "Khong duoc them trung mon hoc trong combo.";
            }
        }
        return null;
    }

    private User getLoggedInTrainingDepartment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }

        User user = (User) session.getAttribute("user");
        if (!TRAINING_DEPARTMENT_ROLE.equalsIgnoreCase(resolveRoleName(session, user))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Ban khong co quyen truy cap.");
            return null;
        }
        return user;
    }

    private boolean isTrainingDepartment(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            return false;
        }
        return TRAINING_DEPARTMENT_ROLE.equalsIgnoreCase(resolveRoleName(session, (User) session.getAttribute("user")));
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

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private int parsePositiveInt(String value, int defaultValue) {
        try {
            int parsed = Integer.parseInt(value);
            return parsed > 0 ? parsed : defaultValue;
        } catch (Exception e) {
            return defaultValue;
        }
    }

    private Integer parseNullablePositiveInt(String value) {
        try {
            int parsed = Integer.parseInt(value.trim());
            return parsed > 0 ? parsed : null;
        } catch (Exception e) {
            return null;
        }
    }
}
