package controller.curriculum;

import dao.CurriculumDAO;
import dto.CurriculumDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.ValidationUtil;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "CurriculumDetailServlet", urlPatterns = {"/curriculum/detail"})
public class CurriculumDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("curriculumId");

        if (!ValidationUtil.isValidId(idParam)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid or missing curriculum ID.");
            System.out.println("idParam"+idParam);
            return;
        }

        int curriculumId = Integer.parseInt(idParam.trim());

        try {
            CurriculumDAO dao = new CurriculumDAO();
            CurriculumDTO curriculum = dao.getCurriculumById(curriculumId);

            if (curriculum == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "Curriculum with ID " + curriculumId + " was not found.");
                return;
            }

            request.setAttribute("curriculum", curriculum);
            request.getRequestDispatcher("/views/curriculum/curriculumDetail.jsp").forward(request, response);

        } catch (SQLException e) {
            getServletContext().log("Database error in CurriculumDetailServlet", e);
            request.getRequestDispatcher("/views/error/dbError.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
