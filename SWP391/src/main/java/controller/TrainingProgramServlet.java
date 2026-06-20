package controller;

import dao.TrainingProgramDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.TrainingProgram;
import model.User;

@WebServlet(name = "TrainingProgramServlet", urlPatterns = {"/training-program"})
public class TrainingProgramServlet extends HttpServlet {

    private final TrainingProgramDAO trainingProgramDAO = new TrainingProgramDAO();

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
            case "edit":
                if (!isTrainingDepartment(user)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Ban khong co quyen truy cap.");
                    return;
                }
                showEditForm(request, response);
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
        } else if ("edit".equals(action)) {
            processUpdate(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/training-program?action=list");
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<TrainingProgram> programs = trainingProgramDAO.getTrainingPrograms();
        request.setAttribute("programs", programs);
        request.getRequestDispatcher("/training-program/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/training-program/create.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        TrainingProgram program = (TrainingProgram) request.getAttribute("program");
        if (program == null) {
            int programId = parseInt(request.getParameter("id"), 0);
            program = trainingProgramDAO.getTrainingProgramById(programId);
            if (program == null) {
                response.sendRedirect(request.getContextPath() + "/training-program?action=list");
                return;
            }
        }
        request.setAttribute("program", program);
        request.getRequestDispatcher("/training-program/edit.jsp").forward(request, response);
    }

    private void processCreate(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        TrainingProgram program = buildProgramFromRequest(request);
        program.setCreatedBy(user.getUserId());

        if (isBlank(program.getProgramCode()) || isBlank(program.getProgramName())) {
            request.setAttribute("error", "Program Code va Program Name la bat buoc.");
            request.setAttribute("program", program);
            showCreateForm(request, response);
            return;
        }

        int id = trainingProgramDAO.createTrainingProgram(program);
        if (id > 0) {
            response.sendRedirect(request.getContextPath() + "/training-program?action=list&success=1");
        } else {
            request.setAttribute("error", "Khong the tao Training Program.");
            request.setAttribute("program", program);
            showCreateForm(request, response);
        }
    }

    private void processUpdate(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        TrainingProgram program = buildProgramFromRequest(request);
        program.setProgramId(parseInt(request.getParameter("id"), 0));
        program.setCreatedBy(user.getUserId());

        if (program.getProgramId() <= 0 || isBlank(program.getProgramCode()) || isBlank(program.getProgramName())) {
            request.setAttribute("error", "Program Code, Program Name va ID la bat buoc.");
            request.setAttribute("program", program);
            showEditForm(request, response);
            return;
        }

        if (trainingProgramDAO.updateTrainingProgram(program)) {
            response.sendRedirect(request.getContextPath() + "/training-program?action=list&updated=1");
        } else {
            request.setAttribute("error", "Khong the cap nhat Training Program.");
            request.setAttribute("program", program);
            showEditForm(request, response);
        }
    }

    private TrainingProgram buildProgramFromRequest(HttpServletRequest request) {
        TrainingProgram program = new TrainingProgram();
        program.setProgramCode(safeTrim(request.getParameter("programCode")));
        program.setProgramName(safeTrim(request.getParameter("programName")));
        program.setAcademicYear(safeTrim(request.getParameter("academicYear")));
        program.setMajorName(safeTrim(request.getParameter("majorName")));
        program.setPno(safeTrim(request.getParameter("pno")));
        program.setDescription(safeTrim(request.getParameter("description")));
        program.setStatus(defaultStatus(safeTrim(request.getParameter("status"))));
        return program;
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
