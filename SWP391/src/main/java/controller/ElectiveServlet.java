package controller;

import dao.CurriculumDAO;
import dao.ElectiveDAO;
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
import model.CurriculumElective;
import model.Subject;
import model.User;

@WebServlet(name = "ElectiveServlet", urlPatterns = {"/elective"})
public class ElectiveServlet extends HttpServlet {

    private static final String TRAINING_DEPARTMENT_ROLE = "Training Department";
    private final ElectiveDAO electiveDAO = new ElectiveDAO();
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

            request.setAttribute("curriculum", curriculum);
            request.setAttribute("electives", electiveDAO.getElectivesByCurriculumId(curriculumId));
            request.setAttribute("canCreateElective", isTrainingDepartment(request));
            request.getRequestDispatcher("/view/electiveList.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("Database error in ElectiveServlet", e);
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
            request.getRequestDispatcher("/view/createElective.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("Database error in ElectiveServlet", e);
            request.getRequestDispatcher("/view/error/dbError.jsp").forward(request, response);
        }
    }

    private void processCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CurriculumElective elective = new CurriculumElective();
        elective.setCurriculumId(parsePositiveInt(request.getParameter("curriculumId"), 0));
        elective.setSubjectId(parsePositiveInt(request.getParameter("subjectId"), 0));
        elective.setElectiveGroupName(safeTrim(request.getParameter("electiveGroupName")));
        elective.setDisplayOrder(null);
        elective.setStatus("Active");

        String validationError = validateCreate(elective);
        if (validationError != null) {
            request.setAttribute("error", validationError);
            request.setAttribute("elective", elective);
            showCreateForm(request, response);
            return;
        }

        if (electiveDAO.existsElectiveSubject(elective.getCurriculumId(), elective.getSubjectId())) {
            request.setAttribute("error", "Mon hoc nay da ton tai trong elective list cua curriculum.");
            request.setAttribute("elective", elective);
            showCreateForm(request, response);
            return;
        }

        if (!electiveDAO.createElective(elective)) {
            request.setAttribute("error", "Khong the them elective course. Vui long kiem tra database.");
            request.setAttribute("elective", elective);
            showCreateForm(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/elective?action=list&curriculumId=" + elective.getCurriculumId());
    }

    private String validateCreate(CurriculumElective elective) {
        if (elective.getCurriculumId() <= 0) {
            return "Curriculum khong hop le.";
        }
        if (elective.getSubjectId() <= 0) {
            return "Vui long chon mon hoc.";
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
}
