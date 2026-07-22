package controller.curriculum;

import dao.CurriculumDAO;
import dto.CurriculumDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
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
            request.getRequestDispatcher("/view/curriculum/curriculumDetail.jsp").forward(request, response);

        } catch (SQLException e) {
            getServletContext().log("Database error in CurriculumDetailServlet", e);
            request.getRequestDispatcher("/view/error/dbError.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (!"updateStatus".equals(action)) {
            doGet(request, response);
            return;
        }

        String idParam = request.getParameter("curriculumId");
        if (!ValidationUtil.isValidId(idParam)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid or missing curriculum ID.");
            return;
        }

        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        String roleName = user != null && user.getRole() != null ? user.getRole().getRoleName() : null;
        if (roleName == null || (!"Training Department".equalsIgnoreCase(roleName.trim())
                && !"Admin".equalsIgnoreCase(roleName.trim()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not have permission to update curriculum status.");
            return;
        }

        int curriculumId = Integer.parseInt(idParam.trim());
        String targetStatus = request.getParameter("targetStatus");
        if (!"Active".equals(targetStatus) && !"Not Active".equals(targetStatus)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid curriculum status.");
            return;
        }

        try {
            CurriculumDAO dao = new CurriculumDAO();
            boolean updated = dao.updateCurriculumStatus(curriculumId, targetStatus);
            String result = updated ? "statusUpdated" : "statusUpdateFailed";
            response.sendRedirect(request.getContextPath() + "/curriculum/detail?curriculumId=" + curriculumId + "&result=" + result);
        } catch (SQLException e) {
            getServletContext().log("Database error when updating curriculum status", e);
            request.getRequestDispatcher("/view/error/dbError.jsp").forward(request, response);
        }
    }
}
