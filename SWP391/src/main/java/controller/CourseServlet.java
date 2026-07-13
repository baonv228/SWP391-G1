package controller;

import dao.CourseDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import model.Subject;
import model.User;

@WebServlet(name = "CourseServlet", urlPatterns = {"/course"})
public class CourseServlet extends HttpServlet {

    private static final String TRAINING_DEPARTMENT_ROLE = "Training Department";
    private static final int PAGE_SIZE = 10;
    private final CourseDao courseDao = new CourseDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = safeTrim(request.getParameter("action"));
        if ("create".equals(action)) {
            User user = getLoggedInTrainingDepartment(request, response);
            if (user == null) {
                return;
            }
            showCreateForm(request, response, user);
            return;
        }
        if ("detail".equals(action)) {
            showDetail(request, response);
            return;
        }

        showList(request, response);
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
            processCreate(request, response, user);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/course?action=list");
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String subjectCode = safeTrim(request.getParameter("subjectCode"));
        String selectedStatus = safeTrim(request.getParameter("status"));
        int page = parsePositiveInt(request.getParameter("page"), 1);
        int totalItems = courseDao.countCourses(subjectCode, selectedStatus);
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / PAGE_SIZE));

        if (page > totalPages) {
            page = totalPages;
        }

        List<Subject> courses = courseDao.getCourses(subjectCode, selectedStatus, page, PAGE_SIZE);
        Map<Integer, List<String>> prerequisiteMap = courseDao.getPrerequisiteCodesBySubjectIds(courses);
        request.setAttribute("courses", courses);
        request.setAttribute("prerequisiteMap", prerequisiteMap);
        request.setAttribute("statusOptions", courseDao.getCourseStatuses());
        request.setAttribute("subjectCode", subjectCode);
        request.setAttribute("selectedStatus", selectedStatus);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("canCreateCourse", isTrainingDepartment(request));
        request.getRequestDispatcher("/view/CourseList.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        request.setAttribute("creatorName", resolveDisplayName(user));
        request.setAttribute("courseOptions", courseDao.getCourseOptions());
        request.getRequestDispatcher("/view/CreateCourse.jsp").forward(request, response);
    }

    private void processCreate(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        Subject course = new Subject();
        course.setCreatedBy(user.getUserId());
        course.setSubjectCode(safeTrim(request.getParameter("subjectCode")).toUpperCase());
        course.setSubjectName(safeTrim(request.getParameter("subjectName")));
        course.setCredits(parsePositiveInt(request.getParameter("credits"), 0));
        course.setDescription(safeTrim(request.getParameter("description")));
        course.setStatus("WaitingForSyllabus");
        List<Integer> prerequisiteSubjectIds = parsePrerequisiteSubjectIds(request);

        String validationError = validateCreate(course);
        if (validationError != null) {
            forwardCreateError(validationError, course, prerequisiteSubjectIds, user, request, response);
            return;
        }

        if (courseDao.existsSubjectCode(course.getSubjectCode())) {
            forwardCreateError("Subject Code da ton tai. Vui long nhap ma mon khac.", course, prerequisiteSubjectIds, user, request, response);
            return;
        }

        if (!courseDao.createCourse(course, prerequisiteSubjectIds)) {
            forwardCreateError("Tao course that bai. Vui long kiem tra database.", course, prerequisiteSubjectIds, user, request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/course?action=list");
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int subjectId = parsePositiveInt(request.getParameter("id"), 0);
        Subject course = courseDao.getCourseById(subjectId);
        if (course == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Course not found.");
            return;
        }

        request.setAttribute("course", course);
        showList(request, response);
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

    private boolean isTrainingDepartment(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            return false;
        }
        User user = (User) session.getAttribute("user");
        return TRAINING_DEPARTMENT_ROLE.equalsIgnoreCase(resolveRoleName(session, user));
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

    private String resolveDisplayName(User user) {
        if (user == null) {
            return "";
        }
        if (user.getFullName() != null && !user.getFullName().isBlank()) {
            return user.getFullName();
        }
        return user.getEmail() != null ? user.getEmail() : "";
    }

    private String validateCreate(Subject course) {
        if (course.getSubjectCode().isEmpty()
                || course.getSubjectName().isEmpty()
                || course.getCredits() <= 0
                || course.getDescription().isEmpty()) {
            return "Vui long nhap day du thong tin course.";
        }
        if (!course.getSubjectCode().matches("^[A-Z0-9_-]{2,50}$")) {
            return "Subject Code chi gom chu, so, dau gach duoi hoac gach ngang, do dai 2-50 ky tu.";
        }
        return null;
    }

    private List<Integer> parsePrerequisiteSubjectIds(HttpServletRequest request) {
        String[] values = request.getParameterValues("prerequisiteSubjectId");
        Set<Integer> uniqueIds = new LinkedHashSet<>();
        if (values == null) {
            return new ArrayList<>();
        }

        for (String value : values) {
            int id = parsePositiveInt(value, 0);
            if (id > 0) {
                uniqueIds.add(id);
            }
        }
        return new ArrayList<>(uniqueIds);
    }

    private void forwardCreateError(String error, Subject course, List<Integer> prerequisiteSubjectIds, User user,
                                    HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("error", error);
        request.setAttribute("course", course);
        request.setAttribute("selectedPrerequisiteIds", prerequisiteSubjectIds);
        showCreateForm(request, response, user);
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
