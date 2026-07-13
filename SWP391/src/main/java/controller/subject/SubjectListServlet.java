package controller.subject;

import dao.SubjectDAO;
import dto.PaginationDTO;
import dto.SubjectDTO;
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

@WebServlet(name = "SubjectListServlet", urlPatterns = {"/subjects"})
public class SubjectListServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword   = request.getParameter("keyword");
        String pageParam = request.getParameter("page");

        String validationError = ValidationUtil.validateSearchInput(keyword);
        if (validationError != null) {
            request.setAttribute("errorMessage", validationError);
            request.getRequestDispatcher("/view/subject/subjectList.jsp").forward(request, response);
            return;
        }

        String displayKeyword = (keyword != null) ? keyword.trim() : "";
        int page = ValidationUtil.parsePageNumber(pageParam);

        try {
            SubjectDAO dao = new SubjectDAO();
            int totalRecords = dao.countSubjects(displayKeyword);
            PaginationDTO pagination = PaginationUtil.buildPagination(totalRecords, page, PAGE_SIZE);
            List<SubjectDTO> subjects = dao.searchSubjects(displayKeyword,
                    pagination.getCurrentPage(), PAGE_SIZE);

            request.setAttribute("subjects", subjects);
            request.setAttribute("pagination", pagination);
            request.setAttribute("keyword", displayKeyword);
            request.setAttribute("totalRecords", totalRecords);

            request.getRequestDispatcher("/view/subject/subjectList.jsp").forward(request, response);

        } catch (SQLException e) {
            getServletContext().log("Database error in SubjectListServlet", e);
            request.getRequestDispatcher("/view/error/dbError.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
