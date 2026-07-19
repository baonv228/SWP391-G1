package controller.curriculum;

import dao.CurriculumDAO;
import dao.ElectiveDAO;
import dto.CurriculumDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.Elective;

@WebServlet(name = "ElectiveServlet", urlPatterns = {"/curriculum/elective"})
public class ElectiveServlet extends HttpServlet {

    private final ElectiveDAO electiveDAO = new ElectiveDAO();
    private final CurriculumDAO curriculumDAO = new CurriculumDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = safeTrim(request.getParameter("action"));
        if (action.isEmpty() || "list".equalsIgnoreCase(action)) {
            showList(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action.");
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int curriculumId = parseInt(request.getParameter("curriculumId"), 0);
        if (curriculumId <= 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid curriculum ID.");
            return;
        }

        try {
            CurriculumDTO curriculum = curriculumDAO.getCurriculumById(curriculumId);
            if (curriculum == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Curriculum not found.");
                return;
            }

            List<Elective> electiveList = electiveDAO.getElectiveByCurriculum(curriculumId);
            request.setAttribute("curriculum", curriculum);
            request.setAttribute("electiveList", electiveList);
            request.setAttribute("curriculumId", curriculumId);

            request.getRequestDispatcher("/view/curriculum/elective-management.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("Database error in ElectiveServlet.showList", e);
            request.setAttribute("errorMessage", "Database error occurred while fetching Electives.");
            request.getRequestDispatcher("/view/error/dbError.jsp").forward(request, response);
        }
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(value.trim());
        } catch (Exception e) {
            return defaultValue;
        }
    }
}
