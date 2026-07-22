package controller.teacher;

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
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * TeachingActivityServlet — read-only view of teaching/learning activities.
 *
 * GET /teacher/teaching-activities                 → syllabus picker
 * GET /teacher/teaching-activities?syllabusId=N     → sessions of the syllabus
 *                                                      with the private-cloud
 *                                                      materials linked to each.
 */
@WebServlet(name = "TeacherTeachingActivityServlet", urlPatterns = {"/teacher/teaching-activities"})
public class TeachingActivityServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.requireTeacher(request, response)) return;

        try {
            SyllabusDAO syllabusDAO = new SyllabusDAO();

            // Syllabi dropdown (all active syllabi), same as UploadMaterialServlet.
            List<SyllabusDTO> syllabi = syllabusDAO.searchSyllabi("", "", 1, 1000);
            request.setAttribute("syllabi", syllabi);

            String syllabusIdParam = request.getParameter("syllabusId");
            if (ValidationUtil.isValidId(syllabusIdParam)) {
                int syllabusId = Integer.parseInt(syllabusIdParam.trim());
                request.setAttribute("selectedSyllabusId", syllabusId);

                List<SyllabusSession> sessions = syllabusDAO.getSessions(syllabusId);
                SessionMaterialDAO sessionMaterialDAO = new SessionMaterialDAO();
                Map<Integer, List<MaterialDTO>> linksBySession =
                        sessionMaterialDAO.getMaterialsBySyllabus(syllabusId);

                request.setAttribute("sessions", sessions);
                request.setAttribute("linksBySession", linksBySession);
            }

            request.getRequestDispatcher("/view/teacher/teachingActivities.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            getServletContext().log("DB error in TeachingActivityServlet", e);
            request.getRequestDispatcher("/view/error/dbError.jsp").forward(request, response);
        }
    }
}
