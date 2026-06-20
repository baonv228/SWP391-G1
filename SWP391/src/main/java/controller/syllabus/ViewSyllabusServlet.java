package controller.syllabus;

import dao.SyllabusDAO;
import dto.PaginationDTO;
import dto.SyllabusDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.PaginationUtil;
import utils.ValidationUtil;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ViewSyllabusServlet", urlPatterns = {"/syllabus"})
public class ViewSyllabusServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private static final String[] ALLOWED_SEARCH_TYPES = {"code", "name", "subject"};

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchType = request.getParameter("searchType");
        String keyword    = request.getParameter("keyword");
        String pageParam  = request.getParameter("page");

        // Default search type
        if (searchType == null || searchType.trim().isEmpty()) searchType = "code";
        if (!ValidationUtil.isValidSearchType(searchType, ALLOWED_SEARCH_TYPES)) searchType = "code";

        // Validate keyword
        String validationError = ValidationUtil.validateSearchInput(keyword);
        if (validationError != null) {
            request.setAttribute("errorMessage", validationError);
            request.setAttribute("searchType", searchType);
            request.setAttribute("keyword", "");
            request.getRequestDispatcher("/views/syllabus/syllabusManagement.jsp").forward(request, response);
            return;
        }

        // Sanitize keyword for display (don't sanitize for DB – PreparedStatement handles that)
        String displayKeyword = (keyword != null) ? keyword.trim() : "";

        int page = ValidationUtil.parsePageNumber(pageParam);

        try {
            SyllabusDAO dao = new SyllabusDAO();
            int totalRecords = dao.countSyllabi(searchType, displayKeyword);
            PaginationDTO pagination = PaginationUtil.buildPagination(totalRecords, page, PAGE_SIZE);
            List<SyllabusDTO> syllabi = dao.searchSyllabi(searchType, displayKeyword,
                    pagination.getCurrentPage(), PAGE_SIZE);

            request.setAttribute("syllabi", syllabi);
            request.setAttribute("pagination", pagination);
            request.setAttribute("searchType", searchType);
            request.setAttribute("keyword", displayKeyword);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("searched", !displayKeyword.isEmpty());

            request.getRequestDispatcher("/views/syllabus/syllabusManagement.jsp").forward(request, response);

        } catch (SQLException e) {
            getServletContext().log("Database error in ViewSyllabusServlet", e);
            request.setAttribute("errorMessage", "Database connection error. Please try again later.");
            request.getRequestDispatcher("/views/error/dbError.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
