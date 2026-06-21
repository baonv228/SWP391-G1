package controller.syllabus;

import dao.SyllabusDAO;
import dto.SyllabusDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.ValidationUtil;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "SyllabusDetailServlet", urlPatterns = {"/syllabus/detail"})
public class SyllabusDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String syllabusIdParam = request.getParameter("syllabusId");

        if (!ValidationUtil.isValidId(syllabusIdParam)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid or missing syllabus ID.");
            return;
        }

        int syllabusId = Integer.parseInt(syllabusIdParam.trim());

        try {
            SyllabusDAO dao = new SyllabusDAO();
            SyllabusDTO syllabus = dao.getSyllabusById(syllabusId);

            if (syllabus == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "Syllabus with ID " + syllabusId + " was not found.");
                return;
            }

            request.setAttribute("syllabus", syllabus);
            request.getRequestDispatcher("/views/syllabus/syllabusDetail.jsp").forward(request, response);

        } catch (SQLException e) {
            System.out.println("exepton");
            getServletContext().log("Database error in SyllabusDetailServlet", e);
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
