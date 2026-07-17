package controller;

import dao.ComboDAO;
import dao.CurriculumDAO;
import dto.CurriculumDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.Combo;

@WebServlet(name = "ComboServlet", urlPatterns = {"/combo"})
public class ComboServlet extends HttpServlet {

    private final ComboDAO comboDAO = new ComboDAO();
    private final CurriculumDAO curriculumDAO = new CurriculumDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = safeTrim(request.getParameter("action"));
        if (action.isEmpty() || "list".equals(action)) {
            showList(request, response);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/curriculum");
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int curriculumId = parsePositiveInt(request.getParameter("curriculumId"), 0);
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

            List<Combo> combos = comboDAO.getCombosByCurriculumId(curriculumId);
            request.setAttribute("curriculum", curriculum);
            request.setAttribute("combos", combos);
            request.getRequestDispatcher("/view/combo/comboList.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("Database error in ComboServlet", e);
            request.getRequestDispatcher("/view/error/dbError.jsp").forward(request, response);
        }
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private int parsePositiveInt(String value, int defaultValue) {
        try {
            int parsed = Integer.parseInt(value);
            return parsed > 0 ? parsed : defaultValue;
        } catch (Exception e) {
            return defaultValue;
        }
    }
}
