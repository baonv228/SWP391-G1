package controller;

import dao.TrainingProgramDAO;
import dao.CurriculumDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Curriculum;
import model.PLO;
import model.PO;
import model.TrainingProgram;
import model.User;

@WebServlet(name = "TrainingProgramServlet", urlPatterns = {"/training-program"})
public class TrainingProgramServlet extends HttpServlet {

    private static final String TRAINING_DEPARTMENT_ROLE = "Training Department";
    private static final int PAGE_SIZE = 10;
    private final TrainingProgramDAO trainingProgramDAO = new TrainingProgramDAO();
    private final CurriculumDAO curriculumDAO = new CurriculumDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = getLoggedInTrainingDepartment(request, response);
        if (user == null) {
            return;
        }

        String action = safeTrim(request.getParameter("action"));
        switch (action) {
            case "create":
                showCreateForm(request, response);
                break;
            case "detail":
                showDetail(request, response);
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
        User user = getLoggedInTrainingDepartment(request, response);
        if (user == null) {
            return;
        }

        String action = safeTrim(request.getParameter("action"));
        if ("create".equals(action)) {
            processCreate(request, response, user);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/training-program?action=list");
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String selectedProgramCode = safeTrim(request.getParameter("programCode")).toUpperCase();
        int page = parsePositiveInt(request.getParameter("page"), 1);
        int totalItems = trainingProgramDAO.countTrainingPrograms(selectedProgramCode);
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / PAGE_SIZE));

        if (page > totalPages) {
            page = totalPages;
        }

        List<TrainingProgram> programs = trainingProgramDAO.getTrainingPrograms(selectedProgramCode, page, PAGE_SIZE);
        request.setAttribute("programs", programs);
        request.setAttribute("programOptions", trainingProgramDAO.getTrainingProgramOptions());
        request.setAttribute("selectedProgramCode", selectedProgramCode);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.getRequestDispatcher("/view/ListTrainingProgram.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/CreateTrainingProgram.jsp").forward(request, response);
    }

    private void processCreate(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        TrainingProgram program = new TrainingProgram();
        program.setCreatedBy(user.getUserId());
        program.setProgramName(safeTrim(request.getParameter("programName")));
        program.setProgramCode(safeTrim(request.getParameter("programCode")).toUpperCase());
        program.setMajorName(safeTrim(request.getParameter("majorName")));
        program.setDescription(safeTrim(request.getParameter("description")));
        program.setStatus("Active");

        String validationError = validateCreate(program);
        if (validationError != null) {
            forwardCreateError(validationError, program, request, response);
            return;
        }

        if (trainingProgramDAO.existsProgramCode(program.getProgramCode())) {
            forwardCreateError("Mã ngành đã tồn tại. Vui lòng nhập mã ngành khác.", program, request, response);
            return;
        }

        int programId = trainingProgramDAO.createTrainingProgram(program);
        if (programId <= 0) {
            forwardCreateError("Tạo Training Program thất bại. Vui lòng kiểm tra database.", program, request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/training-program?action=list");
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int programId = parsePositiveInt(request.getParameter("id"), 0);
        TrainingProgram program = trainingProgramDAO.getTrainingProgramById(programId);
        if (program == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Training program not found.");
            return;
        }
        request.setAttribute("program", program);
        List<Curriculum> curriculums = curriculumDAO.getCurriculumsByProgramId(programId);
        List<PO> pos = trainingProgramDAO.getPOsByProgramId(programId);
        request.setAttribute("curriculums", curriculums);
        request.setAttribute("pos", pos);
        request.getRequestDispatcher("/view/TrainingProgramDetail.jsp").forward(request, response);
    }

    private User getLoggedInTrainingDepartment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }

        User user = (User) session.getAttribute("user");
        String roleName = resolveRoleName(session, user);
        if (!TRAINING_DEPARTMENT_ROLE.equalsIgnoreCase(roleName)) {
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

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private String validateCreate(TrainingProgram program) {
        if (program.getProgramName().isEmpty()
                || program.getProgramCode().isEmpty()
                || program.getMajorName().isEmpty()
                || program.getDescription().isEmpty()) {
            return "Vui lòng nhập đầy đủ thông tin chính của Training Program.";
        }
        if (!program.getProgramCode().matches("^[A-Z0-9_-]{2,50}$")) {
            return "Mã ngành chỉ gồm chữ, số, dấu gạch dưới hoặc gạch ngang, độ dài 2-50 ký tự.";
        }
        return null;
    }

    private void forwardCreateError(String error, TrainingProgram program,
                                    HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("error", error);
        request.setAttribute("program", program);
        showCreateForm(request, response);
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
