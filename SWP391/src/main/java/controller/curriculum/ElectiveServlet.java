package controller.curriculum;

import dao.CurriculumDAO;
import dao.ElectiveDAO;
import dto.CurriculumDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.CurriculumElective;
import model.Elective;
import model.Subject;
import model.User;

@WebServlet(name = "ElectiveServlet", urlPatterns = {"/curriculum/elective"})
public class ElectiveServlet extends HttpServlet {

    private static final String TRAINING_DEPARTMENT_ROLE = "Training Department";
    private final ElectiveDAO electiveDAO = new ElectiveDAO();
    private final CurriculumDAO curriculumDAO = new CurriculumDAO();
    private final dao.SubjectDAO subjectDAO = new dao.SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = safeTrim(request.getParameter("action"));
        if (action.isEmpty() || "list".equalsIgnoreCase(action)) {
            showList(request, response);
        } else if ("create".equalsIgnoreCase(action)) {
            if (!isTrainingDepartment(session)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Ban khong co quyen truy cap.");
                return;
            }
            showCreateForm(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!isTrainingDepartment(session)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Ban khong co quyen truy cap.");
            return;
        }

        String action = safeTrim(request.getParameter("action"));
        if ("create".equalsIgnoreCase(action)) {
            processCreate(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/curriculum/elective?action=list");
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int curriculumId = parseInt(request.getParameter("curriculumId"), 0);
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

            List<Elective> electiveList = electiveDAO.getElectiveByCurriculum(curriculumId);
            request.setAttribute("curriculum", curriculum);
            request.setAttribute("electiveList", electiveList);
            request.setAttribute("curriculumId", curriculumId);
            request.setAttribute("canCreateElective", isTrainingDepartment(request.getSession(false)));

            request.getRequestDispatcher("/view/curriculum/elective-management.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("Database error in ElectiveServlet.showList", e);
            request.setAttribute("errorMessage", "Database error occurred while fetching Electives.");
            request.getRequestDispatcher("/view/error/dbError.jsp").forward(request, response);
        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int curriculumId = parseInt(request.getParameter("curriculumId"), 0);
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

            List<Subject> subjects = subjectDAO.getAllSubjects();
            request.setAttribute("curriculum", curriculum);
            request.setAttribute("subjects", subjects);
            request.getRequestDispatcher("/view/createElective.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("Database error in ElectiveServlet.showCreateForm", e);
            request.setAttribute("errorMessage", "Database error occurred while loading Add Elective form.");
            request.getRequestDispatcher("/view/error/dbError.jsp").forward(request, response);
        }
    }

    private void processCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CurriculumElective elective = new CurriculumElective();
        elective.setCurriculumId(parseInt(request.getParameter("curriculumId"), 0));
        elective.setSubjectId(parseInt(request.getParameter("subjectId"), 0));
        elective.setElectiveGroupName(safeTrim(request.getParameter("electiveGroupName")));
        elective.setStatus("Active");

        String validationError = validateCreate(elective);
        if (validationError != null) {
            request.setAttribute("error", validationError);
            request.setAttribute("elective", elective);
            showCreateForm(request, response);
            return;
        }

        if (electiveDAO.existsElectiveSubject(elective.getCurriculumId(), elective.getSubjectId())) {
            request.setAttribute("error", "This subject already exists in the elective list.");
            request.setAttribute("elective", elective);
            showCreateForm(request, response);
            return;
        }

        if (!electiveDAO.createElective(elective)) {
            request.setAttribute("error", "Cannot add elective course. Please check database.");
            request.setAttribute("elective", elective);
            showCreateForm(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/curriculum/elective?action=list&curriculumId=" + elective.getCurriculumId());
    }

    private String validateCreate(CurriculumElective elective) {
        if (elective.getCurriculumId() <= 0) {
            return "Invalid curriculum.";
        }
        if (elective.getSubjectId() <= 0) {
            return "Please select a subject.";
        }
        return null;
    }

    private boolean isTrainingDepartment(HttpSession session) {
        if (session == null || session.getAttribute("user") == null) {
            return false;
        }
        User user = (User) session.getAttribute("user");
        Object roleNameAttr = session.getAttribute("roleName");
        String roleName = roleNameAttr instanceof String value && !value.isBlank()
                ? value.trim()
                : user.getRole() != null ? user.getRole().getRoleName() : "";
        return TRAINING_DEPARTMENT_ROLE.equalsIgnoreCase(roleName);
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(value.trim());
        } catch (Exception e) {
            return defaultValue;
        }
    }
}
