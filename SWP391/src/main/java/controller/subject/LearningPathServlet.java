package controller.subject;

import dao.SubjectDAO;
import dto.LearningPathDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.ValidationUtil;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "LearningPathServlet", urlPatterns = {"/learning-path"})
public class LearningPathServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String subjectCode = request.getParameter("subjectCode");
        
        // check value subjectCode -
            System.out.println("Subject Code = " + subjectCode);

        // Always show the search page — results only if code provided
        String validationError = ValidationUtil.validateSearchInput(subjectCode);
        if (validationError != null) {
            request.setAttribute("errorMessage", validationError);
            request.getRequestDispatcher("/views/subject/learningPath.jsp").forward(request, response);
            return;
        }

        String displayCode = (subjectCode != null) ? subjectCode.trim() : "";
        request.setAttribute("subjectCode", displayCode);

        if (!displayCode.isEmpty()) {
            try {
                SubjectDAO dao = new SubjectDAO();
                List<LearningPathDTO> learningPaths = dao.getLearningPath(displayCode);
                request.setAttribute("learningPaths", learningPaths);
                request.setAttribute("totalResults", learningPaths.size());
                request.setAttribute("searched", true);
            } catch (SQLException e) {
                getServletContext().log("Database error in LearningPathServlet", e);
                request.getRequestDispatcher("/views/error/dbError.jsp").forward(request, response);
                return;
            }
        }

        request.getRequestDispatcher("/views/subject/learningPath.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
