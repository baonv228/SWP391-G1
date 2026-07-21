package controller.teacher;

import dao.MaterialDAO;
import dao.SyllabusDAO;
import dao.SyllabusRequestDAO;
import dto.MaterialDTO;
import dto.SyllabusRequestDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import utils.AuthUtil;
import utils.PaginationUtil;
import dto.PaginationDTO;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Teacher Dashboard — shows summary stats for the logged-in teacher.
 * URL: /teacher/dashboard
 */
@WebServlet(name = "TeacherDashboardServlet", urlPatterns = {"/teacher/dashboard"})
public class TeacherDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.requireTeacher(request, response)) return;

        User teacher = AuthUtil.getLoggedInUser(request);

        try {
            MaterialDAO materialDAO         = new MaterialDAO();
            SyllabusRequestDAO requestDAO   = new SyllabusRequestDAO();

            // My uploaded materials count
            List<MaterialDTO> myMaterials = materialDAO.getMaterialsByUploader(teacher.getUserId());
            long myDownloadsCount = myMaterials.stream()
                    .mapToLong(MaterialDTO::getDownloadCount)
                    .sum();
            // My pending requests count
            int totalRequests = requestDAO.countRequestsByUser(teacher.getUserId());
            List<SyllabusRequestDTO> recentRequests =
                    requestDAO.getRequestsByUser(teacher.getUserId(), 1, 5);

            request.setAttribute("myMaterialsCount", myMaterials.size());
            request.setAttribute("myDownloadsCount", myDownloadsCount);
            request.setAttribute("totalRequests", totalRequests);
            request.setAttribute("recentRequests", recentRequests);
            request.setAttribute("teacher", teacher);

            request.getRequestDispatcher("/view/teacher/dashboard.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            getServletContext().log("DB error in TeacherDashboardServlet", e);
            request.setAttribute("errorMessage", "Database error. Please try again later.");
            request.getRequestDispatcher("/view/error/dbError.jsp").forward(request, response);
        }
    }
}
