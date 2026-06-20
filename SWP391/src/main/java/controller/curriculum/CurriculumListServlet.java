package controller.curriculum;

import dao.CurriculumDAO;
import dto.CurriculumDTO;
import dto.PaginationDTO;
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

@WebServlet(name = "CurriculumListServlet", urlPatterns = {"/curriculum"})
public class CurriculumListServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private static final String[] ALLOWED_SEARCH_TYPES = {"code", "name"};

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchType = request.getParameter("searchType");
        String keyword    = request.getParameter("keyword");
        String pageParam  = request.getParameter("page");

        if (searchType == null || searchType.trim().isEmpty()) searchType = "code";
        if (!ValidationUtil.isValidSearchType(searchType, ALLOWED_SEARCH_TYPES)) searchType = "code";

        String validationError = ValidationUtil.validateSearchInput(keyword);
        if (validationError != null) {
            request.setAttribute("errorMessage", validationError);
            request.setAttribute("searchType", searchType);
            request.setAttribute("keyword", "");
            request.getRequestDispatcher("/views/curriculum/curriculumList.jsp").forward(request, response);
            return;
        }

        String displayKeyword = (keyword != null) ? keyword.trim() : "";
        int page = ValidationUtil.parsePageNumber(pageParam);

        try {
            CurriculumDAO dao = new CurriculumDAO();
            int totalRecords = dao.countCurricula(searchType, displayKeyword);
            PaginationDTO pagination = PaginationUtil.buildPagination(totalRecords, page, PAGE_SIZE);
            List<CurriculumDTO> curricula = dao.searchCurricula(searchType, displayKeyword,
                    pagination.getCurrentPage(), PAGE_SIZE);

            request.setAttribute("curricula", curricula);
            request.setAttribute("pagination", pagination);
            request.setAttribute("searchType", searchType);
            request.setAttribute("keyword", displayKeyword);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("searched", !displayKeyword.isEmpty());

            request.getRequestDispatcher("/views/curriculum/curriculumList.jsp").forward(request, response);

        } catch (SQLException e) {
            getServletContext().log("Database error in CurriculumListServlet", e);
            request.getRequestDispatcher("/views/error/dbError.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
