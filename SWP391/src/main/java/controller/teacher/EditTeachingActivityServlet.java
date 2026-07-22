package controller.teacher;

import dao.MaterialDAO;
import dao.SessionMaterialDAO;
import dao.SyllabusDAO;
import dto.MaterialDTO;
import dto.SyllabusDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.SyllabusSession;
import model.User;
import utils.AuthUtil;
import utils.ValidationUtil;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * EditTeachingActivityServlet — Teacher attaches/detaches private-cloud
 * materials to the teaching sessions of a syllabus.
 *
 * GET  /teacher/teaching-activities/edit?syllabusId=N  → Show edit form
 * POST /teacher/teaching-activities/edit               → action=link | unlink
 *
 * Teacher does NOT edit session content (Topic/Type belong to the Designer);
 * only the material links are managed here. Links are anchored by
 * (SyllabusID, SessionNumber, MaterialID) so they survive Designer re-saves.
 */
@WebServlet(name = "TeacherEditTeachingActivityServlet",
        urlPatterns = {"/teacher/teaching-activities/edit"})
public class EditTeachingActivityServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.requireTeacher(request, response)) return;

        User teacher = AuthUtil.getLoggedInUser(request);

        try {
            SyllabusDAO syllabusDAO = new SyllabusDAO();
            List<SyllabusDTO> syllabi = syllabusDAO.searchSyllabi("", "", 1, 1000);
            request.setAttribute("syllabi", syllabi);

            String syllabusIdParam = request.getParameter("syllabusId");
            if (!ValidationUtil.isValidId(syllabusIdParam)) {
                // No syllabus chosen yet — send back to the view page to pick one.
                response.sendRedirect(request.getContextPath() + "/teacher/teaching-activities");
                return;
            }

            int syllabusId = Integer.parseInt(syllabusIdParam.trim());
            request.setAttribute("selectedSyllabusId", syllabusId);

            List<SyllabusSession> sessions = syllabusDAO.getSessions(syllabusId);
            request.setAttribute("sessions", sessions);

            SessionMaterialDAO smDAO = new SessionMaterialDAO();
            Map<Integer, List<MaterialDTO>> linksBySession = smDAO.getMaterialsBySyllabus(syllabusId);
            request.setAttribute("linksBySession", linksBySession);

            // Teacher's own private-cloud materials for this syllabus (the pick list).
            MaterialDAO materialDAO = new MaterialDAO();
            List<MaterialDTO> myMaterials = materialDAO.getMaterialsByUploader(
                    teacher.getUserId(), syllabusId, 1, Integer.MAX_VALUE);
            request.setAttribute("myMaterials", myMaterials);

            request.getRequestDispatcher("/view/teacher/teachingActivitiesEdit.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            getServletContext().log("DB error in EditTeachingActivityServlet GET", e);
            request.getRequestDispatcher("/view/error/dbError.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.requireTeacher(request, response)) return;

        User teacher = AuthUtil.getLoggedInUser(request);
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String syllabusIdParam = request.getParameter("syllabusId");
        String sessionNumberParam = request.getParameter("sessionNumber");
        String materialIdParam = request.getParameter("materialId");

        if (!ValidationUtil.isValidId(syllabusIdParam)
                || !ValidationUtil.isValidId(sessionNumberParam)
                || !ValidationUtil.isValidId(materialIdParam)) {
            redirectToEdit(request, response, syllabusIdParam, "error", "Invalid request");
            return;
        }

        int syllabusId = Integer.parseInt(syllabusIdParam.trim());
        int sessionNumber = Integer.parseInt(sessionNumberParam.trim());
        int materialId = Integer.parseInt(materialIdParam.trim());

        try {
            SessionMaterialDAO smDAO = new SessionMaterialDAO();

            if ("unlink".equalsIgnoreCase(action)) {
                boolean removed = smDAO.unlink(syllabusId, sessionNumber, materialId);
                redirectToEdit(request, response, syllabusIdParam,
                        removed ? "success" : "error",
                        removed ? "Material removed from session" : "Link not found");
                return;
            }

            if ("link".equalsIgnoreCase(action)) {
                // Security: material must belong to this teacher.
                MaterialDAO materialDAO = new MaterialDAO();
                MaterialDTO material = materialDAO.getMaterialById(materialId);
                if (material == null || material.getUploadedBy() != teacher.getUserId()) {
                    redirectToEdit(request, response, syllabusIdParam,
                            "error", "Material not found or access denied");
                    return;
                }
                boolean linked = smDAO.link(syllabusId, sessionNumber, materialId);
                redirectToEdit(request, response, syllabusIdParam,
                        linked ? "success" : "error",
                        linked ? "Material attached to session" : "Material already attached");
                return;
            }

            redirectToEdit(request, response, syllabusIdParam, "error", "Unknown action");

        } catch (SQLException e) {
            getServletContext().log("DB error in EditTeachingActivityServlet POST", e);
            redirectToEdit(request, response, syllabusIdParam, "error", "Database error");
        }
    }

    private void redirectToEdit(HttpServletRequest request, HttpServletResponse response,
                                String syllabusIdParam, String messageType, String message)
            throws IOException {
        StringBuilder url = new StringBuilder(request.getContextPath())
                .append("/teacher/teaching-activities/edit");
        String separator = "?";
        if (ValidationUtil.isValidId(syllabusIdParam)) {
            url.append(separator).append("syllabusId=").append(syllabusIdParam.trim());
            separator = "&";
        }
        url.append(separator)
                .append(messageType)
                .append("=")
                .append(URLEncoder.encode(message, StandardCharsets.UTF_8));
        response.sendRedirect(url.toString());
    }
}
