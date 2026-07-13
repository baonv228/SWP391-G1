package controller.teacher;

import dao.SubjectDAO;
import dao.SyllabusDAO;
import dto.PaginationDTO;
import dto.SyllabusDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.AuthUtil;
import utils.PaginationUtil;
import utils.ValidationUtil;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * CourseListServlet — Comprehensive course list for Teacher.
 * Shows all subjects with their current syllabus info.
 *
 * GET /teacher/courses?keyword=...&searchType=code|name&page=N
 */
@WebServlet(name = "TeacherCourseListServlet", urlPatterns = {"/teacher/courses"})
public class CourseListServlet extends HttpServlet {

    private static final int PAGE_SIZE = 15;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.requireTeacher(request, response)) return;

        String searchType = request.getParameter("searchType");
        String keyword    = request.getParameter("keyword");
        String pageParam  = request.getParameter("page");

        // Validate & sanitize
        if (keyword != null) {
            if (ValidationUtil.containsDangerousPattern(keyword)) {
                request.setAttribute("errorMessage", "Invalid search input detected.");
                keyword = "";
            } else if (keyword.length() > 200) {
                request.setAttribute("errorMessage", "Search input is too long (max 200 chars).");
                keyword = keyword.substring(0, 200);
            } else {
                keyword = ValidationUtil.sanitize(keyword);
            }
        }

        if (searchType == null) searchType = "code";
        int page = ValidationUtil.parsePageNumber(pageParam);

        try {
            SyllabusDAO syllabusDAO = new SyllabusDAO();
            int total = syllabusDAO.countSyllabi(searchType, keyword);
            PaginationDTO pagination = PaginationUtil.buildPagination(page, PAGE_SIZE, total);
            List<SyllabusDTO> courses = syllabusDAO.searchSyllabi(searchType, keyword, page, PAGE_SIZE);

            request.setAttribute("courses", courses);
            request.setAttribute("pagination", pagination);
            request.setAttribute("totalRecords", total);
            request.setAttribute("searchType", searchType);
            request.setAttribute("keyword", keyword != null ? keyword : "");
            request.setAttribute("searched", keyword != null && !keyword.trim().isEmpty());

            request.getRequestDispatcher("/views/teacher/courseList.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            getServletContext().log("DB error in TeacherCourseListServlet", e);
            request.getRequestDispatcher("/views/error/dbError.jsp").forward(request, response);
        }
    }
}
