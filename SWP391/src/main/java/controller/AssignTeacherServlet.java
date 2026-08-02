package controller;

import dao.TeacherProgramDAO;
import dao.TrainingProgramDAO;
import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.TrainingProgram;
import model.User;
import utils.AuthUtil;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * NEW — Training Department assigns teachers to majors (Training_Program).
 * URL: /assign-teacher
 */
@WebServlet(name = "AssignTeacherServlet", urlPatterns = {"/assign-teacher"})
public class AssignTeacherServlet extends HttpServlet {

    private static final String TRAINING_DEPARTMENT_ROLE = "Training Department";

    private final TeacherProgramDAO teacherProgramDAO = new TeacherProgramDAO();
    private final TrainingProgramDAO trainingProgramDAO = new TrainingProgramDAO();
    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User actor = requireTrainingDepartment(request, response);
        if (actor == null) return;

        try {
            loadPage(request);
            request.getRequestDispatcher("/view/AssignTeacher.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("AssignTeacherServlet GET error", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        User actor = requireTrainingDepartment(request, response);
        if (actor == null) return;

        String teacherIdParam = request.getParameter("teacherId");
        if (teacherIdParam == null || teacherIdParam.isBlank()) {
            request.setAttribute("error", "Vui lòng chọn giáo viên.");
            doGet(request, response);
            return;
        }

        int teacherId;
        try {
            teacherId = Integer.parseInt(teacherIdParam.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Teacher ID không hợp lệ.");
            doGet(request, response);
            return;
        }

        try {
            User teacher = userDao.findById(teacherId);
            if (teacher == null || teacher.getRoleId() != AuthUtil.ROLE_TEACHER) {
                request.setAttribute("error", "Chỉ được gán ngành cho tài khoản Teacher.");
                doGet(request, response);
                return;
            }

            String[] programParams = request.getParameterValues("programIds");
            List<Integer> programIds = new ArrayList<>();
            if (programParams != null) {
                for (String p : programParams) {
                    try {
                        int id = Integer.parseInt(p.trim());
                        if (id > 0) programIds.add(id);
                    } catch (NumberFormatException ignored) {
                    }
                }
            }

            teacherProgramDAO.replaceAssignments(teacherId, programIds, actor.getUserId());
            response.sendRedirect(request.getContextPath()
                    + "/assign-teacher?teacherId=" + teacherId
                    + "&success=" + java.net.URLEncoder.encode("Đã cập nhật ngành cho giáo viên.", "UTF-8"));
        } catch (SQLException e) {
            getServletContext().log("AssignTeacherServlet POST error", e);
            request.setAttribute("error", "Lỗi database khi gán ngành.");
            doGet(request, response);
        }
    }

    private void loadPage(HttpServletRequest request) throws SQLException {
        List<User> teachers = teacherProgramDAO.listTeachersWithAssignments();
        List<TrainingProgram> programs = trainingProgramDAO.getTrainingProgramOptions();

        Map<Integer, List<TrainingProgram>> assignments = new HashMap<>();
        Map<Integer, List<Integer>> assignedIds = new HashMap<>();
        for (User t : teachers) {
            List<TrainingProgram> assigned = teacherProgramDAO.getProgramsByTeacherId(t.getUserId());
            assignments.put(t.getUserId(), assigned);
            List<Integer> ids = new ArrayList<>();
            for (TrainingProgram p : assigned) {
                ids.add(p.getProgramId());
            }
            assignedIds.put(t.getUserId(), ids);
        }

        int selectedTeacherId = 0;
        String teacherIdParam = request.getParameter("teacherId");
        if (teacherIdParam != null && !teacherIdParam.isBlank()) {
            try {
                selectedTeacherId = Integer.parseInt(teacherIdParam.trim());
            } catch (NumberFormatException ignored) {
            }
        }
        if (selectedTeacherId == 0 && !teachers.isEmpty()) {
            selectedTeacherId = teachers.get(0).getUserId();
        }

        request.setAttribute("teachers", teachers);
        request.setAttribute("programs", programs);
        request.setAttribute("assignments", assignments);
        request.setAttribute("assignedIds", assignedIds);
        request.setAttribute("selectedTeacherId", selectedTeacherId);
        request.setAttribute("success", request.getParameter("success"));
    }

    private User requireTrainingDepartment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        User user = (User) session.getAttribute("user");
        String roleName = null;
        Object rn = session.getAttribute("roleName");
        if (rn instanceof String s && !s.isBlank()) {
            roleName = s.trim();
        } else if (user.getRole() != null) {
            roleName = user.getRole().getRoleName();
        }
        if (roleName == null || !TRAINING_DEPARTMENT_ROLE.equalsIgnoreCase(roleName)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chi Training Department moi duoc gan teacher theo nganh.");
            return null;
        }
        return user;
    }
}
