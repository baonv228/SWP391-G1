package controller;

import dao.CurriculumDAO;
import dao.ProgramOutcomeDAO;
import dao.ProgramLearningOutcomeDAO;
import dao.ProgramOutcomePLOMappingDAO;
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
import java.util.Map;
import java.util.ArrayList;
import java.util.HashMap;
import model.ProgramOutcome;
import model.ProgramLearningOutcome;
import model.User;

@WebServlet(name = "ProgramOutcomeServlet", urlPatterns = {"/curriculum/po", "/ProgramOutcomeServlet", "/po-management"})
public class ProgramOutcomeServlet extends HttpServlet {

    private final ProgramOutcomeDAO poDAO = new ProgramOutcomeDAO();
    private final CurriculumDAO curriculumDAO = new CurriculumDAO();
    private final ProgramLearningOutcomeDAO ploDAO = new ProgramLearningOutcomeDAO();
    private final ProgramOutcomePLOMappingDAO mappingDAO = new ProgramOutcomePLOMappingDAO();

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
        } else if ("edit".equalsIgnoreCase(action)) {
            // Check authorization for modification
            if (!canManagePO(request)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not have permission to perform this action.");
                return;
            }
            showEditForm(request, response);
        } else if ("delete".equalsIgnoreCase(action)) {
            if (!canManagePO(request)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not have permission to perform this action.");
                return;
            }
            processDelete(request, response);
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

        if (!canManagePO(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not have permission to perform this action.");
            return;
        }

        String action = safeTrim(request.getParameter("action"));
        if ("create".equalsIgnoreCase(action)) {
            processCreate(request, response);
        } else if ("update".equalsIgnoreCase(action)) {
            processUpdate(request, response);
        } else if ("saveMapping".equalsIgnoreCase(action)) {
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

            request.setAttribute("curriculum", curriculum);
            request.setAttribute("poList", poList);
            request.setAttribute("ploList", ploList);
            request.setAttribute("poPloMapping", poPloMapping);
            request.setAttribute("curriculumId", curriculumId);
            request.setAttribute("canManagePO", canManagePO(request));

            request.getRequestDispatcher("/view/curriculum/po-management.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("Database error in ProgramOutcomeServlet.showList", e);
            request.setAttribute("errorMessage", "Database error occurred while fetching Program Outcomes.");
            request.getRequestDispatcher("/view/error/dbError.jsp").forward(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int poId = parseInt(request.getParameter("poId"), 0);
        int curriculumId = parseInt(request.getParameter("curriculumId"), 0);
        ProgramOutcome po = poDAO.getPOById(poId);
        if (po == null) {
            redirectToList(request, response, curriculumId);
            return;
        }

        try {
            CurriculumDTO curriculum = curriculumDAO.getCurriculumById(curriculumId);
            List<ProgramOutcome> poList = poDAO.getPOByCurriculum(curriculumId);
            List<ProgramLearningOutcome> ploList = ploDAO.getPLOByCurriculum(curriculumId);
            Map<Integer, List<Integer>> poPloMapping = mappingDAO.getMappingByCurriculum(curriculumId);
            
            request.setAttribute("curriculum", curriculum);
            request.setAttribute("poList", poList);
            request.setAttribute("ploList", ploList);
            request.setAttribute("poPloMapping", poPloMapping);
            request.setAttribute("curriculumId", curriculumId);
            request.setAttribute("editingPO", po); // Pass editing PO to JSP
            request.setAttribute("canManagePO", canManagePO(request));

            request.getRequestDispatcher("/view/curriculum/po-management.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("Database error in ProgramOutcomeServlet.showEditForm", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred.");
        }
    }

    private void processCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int curriculumId = parseInt(request.getParameter("curriculumId"), 0);
        String poName = safeTrim(request.getParameter("poName"));
        String poDescription = safeTrim(request.getParameter("poDescription"));

        if (curriculumId <= 0 || poName.isEmpty()) {
            request.getSession().setAttribute("errorMessage", "PO Name cannot be empty.");
            redirectToList(request, response, curriculumId);
            return;
        }

        ProgramOutcome po = new ProgramOutcome();
        po.setCurriculumId(curriculumId);
        po.setPoName(poName);
        po.setPoDescription(poDescription);

        boolean success = poDAO.insertPO(po);
        if (!success) {
            request.getSession().setAttribute("errorMessage", "Failed to add Program Outcome.");
        } else {
            request.getSession().setAttribute("successMessage", "Program Outcome added successfully.");
        }

        redirectToList(request, response, curriculumId);
    }

    private void processUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int poId = parseInt(request.getParameter("poId"), 0);
        int curriculumId = parseInt(request.getParameter("curriculumId"), 0);
        String poName = safeTrim(request.getParameter("poName"));
        String poDescription = safeTrim(request.getParameter("poDescription"));

        if (poId <= 0 || curriculumId <= 0 || poName.isEmpty()) {
            request.getSession().setAttribute("errorMessage", "PO Name cannot be empty.");
            redirectToList(request, response, curriculumId);
            return;
        }

        ProgramOutcome po = new ProgramOutcome();
        po.setPoId(poId);
        po.setCurriculumId(curriculumId);
        po.setPoName(poName);
        po.setPoDescription(poDescription);

        boolean success = poDAO.updatePO(po);
        if (!success) {
            request.getSession().setAttribute("errorMessage", "Failed to update Program Outcome.");
        } else {
            request.getSession().setAttribute("successMessage", "Program Outcome updated successfully.");
        }

        redirectToList(request, response, curriculumId);
    }

    private void processDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int poId = parseInt(request.getParameter("poId"), 0);
        int curriculumId = parseInt(request.getParameter("curriculumId"), 0);

        if (poId <= 0 || curriculumId <= 0) {
            redirectToList(request, response, curriculumId);
            return;
        }

        boolean success = poDAO.deletePO(poId);
        if (!success) {
            request.getSession().setAttribute("errorMessage", "Failed to delete Program Outcome.");
        } else {
            request.getSession().setAttribute("successMessage", "Program Outcome deleted successfully.");
        }

        redirectToList(request, response, curriculumId);
    }

    private void processSaveMapping(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int curriculumId = parseInt(request.getParameter("curriculumId"), 0);
        if (curriculumId <= 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid curriculum ID.");
            return;
        }
        Map<Integer, List<Integer>> mapping = new HashMap<>();
        String[] values = request.getParameterValues("mapping");
        if (values != null) {
            for (String value : values) {
                String[] ids = value.split(":", 2);
                if (ids.length != 2) continue;
                int poId = parseInt(ids[0], 0);
                int ploId = parseInt(ids[1], 0);
                if (poId > 0 && ploId > 0) {
                    mapping.computeIfAbsent(poId, key -> new ArrayList<>()).add(ploId);
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

    private boolean canManagePO(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() == null) return false;

        String roleName = user.getRole().getRoleName();
        return "Admin".equalsIgnoreCase(roleName) || 
               "TrainingDepartment".equalsIgnoreCase(roleName) ||
               "Training Department".equalsIgnoreCase(roleName) ||
               "SyllabusDesigner".equalsIgnoreCase(roleName) ||
               "Syllabus Designer".equalsIgnoreCase(roleName);
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
