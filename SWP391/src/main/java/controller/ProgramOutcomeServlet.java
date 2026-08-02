package controller;

import dao.CurriculumDAO;
import dao.ProgramOutcomeDAO;
import dao.ProgramLearningOutcomeDAO;
import dao.PoPloDAO;
import dto.CurriculumDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import model.ProgramOutcome;
import model.ProgramLearningOutcome;
import model.PoPlo;
import model.User;

@WebServlet(name = "ProgramOutcomeServlet", urlPatterns = {"/curriculum/po", "/ProgramOutcomeServlet", "/po-management"})
public class ProgramOutcomeServlet extends HttpServlet {

    private final ProgramOutcomeDAO poDAO = new ProgramOutcomeDAO();
    private final CurriculumDAO curriculumDAO = new CurriculumDAO();
    private final ProgramLearningOutcomeDAO ploDAO = new ProgramLearningOutcomeDAO();
    private final PoPloDAO mappingDAO = new PoPloDAO();

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
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action requested.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!canManageMapping(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not have permission to perform this action.");
            return;
        }

        String action = safeTrim(request.getParameter("action"));
        if ("saveMapping".equalsIgnoreCase(action)) {
            processSaveMapping(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid post action.");
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

            List<ProgramOutcome> poList = poDAO.getPOByCurriculum(curriculumId);
            List<ProgramLearningOutcome> ploList = ploDAO.getPLOByCurriculum(curriculumId);
            Map<Integer, List<Integer>> poPloMapping = mappingDAO.getMappingByCurriculum(curriculumId);
            boolean mappingExists = mappingDAO.hasMappingByCurriculum(curriculumId);
            boolean canManageMapping = canManageMapping(request);
            boolean editMapping = canManageMapping && "true".equalsIgnoreCase(request.getParameter("editMapping"));

            request.setAttribute("curriculum", curriculum);
            request.setAttribute("poList", poList);
            request.setAttribute("ploList", ploList);
            request.setAttribute("poPloMapping", poPloMapping);
            request.setAttribute("mappingExists", mappingExists);
            request.setAttribute("editMapping", editMapping);
            request.setAttribute("curriculumId", curriculumId);
            request.setAttribute("canManageMapping", canManageMapping);

            request.getRequestDispatcher("/view/curriculum/po-management.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("Database error in ProgramOutcomeServlet.showList", e);
            request.setAttribute("errorMessage", "Database error occurred while fetching Program Outcomes.");
            request.getRequestDispatcher("/view/error/dbError.jsp").forward(request, response);
        }
    }

    private void processSaveMapping(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int curriculumId = parseInt(request.getParameter("curriculumId"), 0);
        if (curriculumId <= 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid curriculum ID.");
            return;
        }
        List<PoPlo> mapping = new ArrayList<>();
        String[] values = request.getParameterValues("mapping");
        if (values != null) {
            for (String value : values) {
                String[] ids = value.split(":", 2);
                if (ids.length != 2) continue;
                int poId = parseInt(ids[0], 0);
                int ploId = parseInt(ids[1], 0);
                if (poId > 0 && ploId > 0) {
                    mapping.add(new PoPlo(poId, ploId));
                }
            }
        }
        try {
            mappingDAO.replaceMappingByCurriculum(curriculumId, mapping);
            request.getSession().setAttribute("successMessage", "PO to PLO mapping saved successfully.");
        } catch (SQLException e) {
            getServletContext().log("Unable to save PO-PLO mapping", e);
            request.getSession().setAttribute("errorMessage", "Unable to save PO to PLO mapping.");
        }
        redirectToList(request, response, curriculumId);
    }

    private void redirectToList(HttpServletRequest request, HttpServletResponse response, int curriculumId)
            throws IOException {
        response.sendRedirect(request.getContextPath()
                + "/curriculum/po?action=list&curriculumId=" + curriculumId);
    }

    private boolean canManageMapping(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() == null) return false;

        String roleName = user.getRole().getRoleName();
        return "TrainingDepartment".equalsIgnoreCase(roleName) ||
               "Training Department".equalsIgnoreCase(roleName);
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
