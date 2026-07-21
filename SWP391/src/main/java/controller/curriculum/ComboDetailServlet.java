package controller.curriculum;

import dao.ComboDAO;
import dao.ComboSubjectDAO;
import dao.CurriculumDAO;
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
import model.Combo;
import model.ComboSubject;

@WebServlet(name = "ComboDetailServlet", urlPatterns = {"/curriculum/combo/detail"})
public class ComboDetailServlet extends HttpServlet {

    private final ComboDAO comboDAO = new ComboDAO();
    private final ComboSubjectDAO comboSubjectDAO = new ComboSubjectDAO();
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
        int comboId = parseInt(request.getParameter("comboId"), 0);
        if (comboId <= 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Combo ID.");
            return;
        }

        Combo combo = comboDAO.getComboById(comboId);
        if (combo == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Combo not found.");
            return;
        }

        try {
            CurriculumDTO curriculum = curriculumDAO.getCurriculumById(combo.getCurriculumId());
            List<ComboSubject> subjectList = comboSubjectDAO.getSubjectsByCombo(comboId);

            request.setAttribute("curriculum", curriculum);
            request.setAttribute("combo", combo);
            request.setAttribute("subjectList", subjectList);

            request.getRequestDispatcher("/view/curriculum/combo-detail.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("Database error in ComboDetailServlet.showDetail", e);
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
