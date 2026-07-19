package controller.curriculum;

import dao.CurriculumDAO;
import dao.ElectiveDAO;
import dao.ElectiveSubjectDAO;
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
import model.Subject;

@WebServlet(name = "ElectiveDetailServlet", urlPatterns = {"/curriculum/elective/detail"})
public class ElectiveDetailServlet extends HttpServlet {

    private final ElectiveDAO electiveDAO = new ElectiveDAO();
    private final ElectiveSubjectDAO electiveSubjectDAO = new ElectiveSubjectDAO();
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
        if ("detail".equalsIgnoreCase(action)) {
            showDetail(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action.");
        }
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int electiveId = parseInt(request.getParameter("electiveId"), 0);
        if (electiveId <= 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Elective ID.");
            return;
        }

        Elective elective = electiveDAO.getElectiveById(electiveId);
        if (elective == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Elective not found.");
            return;
        }

        try {
            CurriculumDTO curriculum = curriculumDAO.getCurriculumById(elective.getCurriculumId());
            List<Subject> subjectList = electiveSubjectDAO.getSubjectsByElective(electiveId);

            request.setAttribute("curriculum", curriculum);
            request.setAttribute("elective", elective);
            request.setAttribute("subjectList", subjectList);

            request.getRequestDispatcher("/view/curriculum/elective-detail.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("Database error in ElectiveDetailServlet.showDetail", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred.");
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
