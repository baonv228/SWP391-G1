package controller.subject;

import dao.PrerequisiteDAO;
import dto.PrerequisiteDetailDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.ValidationUtil;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "PrerequisiteDetailServlet", urlPatterns = {"/prerequisite"})
public class PrerequisiteDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String subjectCode = request.getParameter("subjectCode");
        
        // check value subjectCode -
            System.out.println("Subject Code = " + subjectCode);
            
        // Show page even without search
        String displayCode = (subjectCode != null) ? subjectCode.trim() : "";
        request.setAttribute("subjectCode", displayCode);

        String validationError = ValidationUtil.validateSearchInput(subjectCode);
        if (validationError != null) {
            request.setAttribute("errorMessage", validationError);
            request.getRequestDispatcher("/view/subject/prerequisiteDetail.jsp").forward(request, response);
            return;
        }

        if (!displayCode.isEmpty()) {
            try {
                PrerequisiteDAO dao = new PrerequisiteDAO();
                PrerequisiteDetailDTO detail = dao.getPrerequisiteDetail(displayCode);
                if (detail == null) {
                    request.setAttribute("notFound", true);
                    request.setAttribute("notFoundCode", displayCode);
                } else {
                    request.setAttribute("prerequisiteDetail", detail);
                }
                request.setAttribute("searched", true);
            } catch (SQLException e) {
                getServletContext().log("Database error in PrerequisiteDetailServlet", e);
                request.getRequestDispatcher("/view/error/dbError.jsp").forward(request, response);
                return;
            }
        }

        request.getRequestDispatcher("/view/subject/prerequisiteDetail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
