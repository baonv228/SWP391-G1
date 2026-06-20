package controller;

import dao.CurriculumDAO;
import dao.SubjectDAO;
import dao.TrainingProgramDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.Curriculum;
import model.Subject;
import model.TrainingProgram;
import model.User;

@WebServlet(name = "CurriculumServlet", urlPatterns = {"/curriculum"})
public class CurriculumServlet extends HttpServlet {

    private final CurriculumDAO curriculumDAO = new CurriculumDAO();
    private final TrainingProgramDAO trainingProgramDAO = new TrainingProgramDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = getLoggedInUser(request, response);
        if (user == null) {
            return;
        }

        String action = safeTrim(request.getParameter("action"));
        switch (action) {
            case "create":
                if (!isTrainingDepartment(user)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Ban khong co quyen truy cap.");
                    return;
                }
                showCreateForm(request, response);
                break;
            case "list":
            default:
                showList(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        User user = getLoggedInUser(request, response);
        if (user == null) {
            return;
        }

        if (!isTrainingDepartment(user)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Ban khong co quyen truy cap.");
            return;
        }

        String action = safeTrim(request.getParameter("action"));
        if ("create".equals(action)) {
            processCreate(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/curriculum?action=list");
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Curriculum> curriculums = curriculumDAO.getCurriculums();
        request.setAttribute("curriculums", curriculums);
        request.getRequestDispatcher("/curriculum/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<TrainingProgram> programs = trainingProgramDAO.getTrainingPrograms();
        List<Subject> subjects = subjectDAO.getAllSubjects();
        request.setAttribute("programs", programs);
        request.setAttribute("subjects", subjects);
        request.getRequestDispatcher("/curriculum/create.jsp").forward(request, response);
    }

    private void processCreate(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        Curriculum curriculum = new Curriculum();
        curriculum.setProgramId(parseInt(request.getParameter("programId"), 0));
        curriculum.setCreatedBy(user.getUserId());
        curriculum.setCurriculumName(safeTrim(request.getParameter("curriculumName")));
        curriculum.setDescription(safeTrim(request.getParameter("description")));
        curriculum.setStatus(defaultStatus(safeTrim(request.getParameter("status"))));

        List<Integer> subjectIds = parseSubjectIds(request.getParameterValues("subjectIds"));
        if (curriculum.getProgramId() <= 0 || isBlank(curriculum.getCurriculumName())) {
            request.setAttribute("error", "Program va Curriculum Name la bat buoc.");
            request.setAttribute("curriculum", curriculum);
            showCreateForm(request, response);
            return;
        }

        int id = curriculumDAO.createCurriculum(curriculum, subjectIds);
        if (id > 0) {
            response.sendRedirect(request.getContextPath() + "/curriculum?action=list&success=1");
        } else {
            request.setAttribute("error", "Khong the tao Curriculum.");
            request.setAttribute("curriculum", curriculum);
            showCreateForm(request, response);
        }
    }

    private List<Integer> parseSubjectIds(String[] values) {
        List<Integer> list = new ArrayList<>();
        if (values == null) {
            return list;
        }
        for (String value : values) {
            try {
                list.add(Integer.parseInt(value));
            } catch (Exception ignored) {
            }
        }
        return list;
    }

    private User getLoggedInUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        return (User) session.getAttribute("user");
    }

    private boolean isTrainingDepartment(User user) {
        return user != null
                && user.getRole() != null
                && "Training Department".equalsIgnoreCase(user.getRole().getRoleName());
    }

    private String defaultStatus(String status) {
        return isBlank(status) ? "Active" : status;
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private boolean isBlank(String value) {
        return value == null || value.isBlank();
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(value.trim());
        } catch (Exception e) {
            return defaultValue;
        }
    }
}
