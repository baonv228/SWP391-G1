package controller.teacher;

import dao.SyllabusDAO;
import dao.SyllabusRequestDAO;
import dto.SyllabusDTO;
import dto.SyllabusRequestDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import utils.AuthUtil;
import utils.PaginationUtil;
import utils.ValidationUtil;
import dto.PaginationDTO;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * SubmitRequestServlet — Teacher submits a design/modification request.
 *
 * GET  /teacher/submit-request          → Show submission form + request history
 * POST /teacher/submit-request          → Save new request (Pending)
 * 
 */
@WebServlet(name = "SubmitRequestServlet", urlPatterns = {"/teacher/submit-request"})
public class SubmitRequestServlet extends HttpServlet {

    private static final int PAGE_SIZE = PaginationUtil.TEACHER_PAGE_SIZE;

    // ----------------------------------------------------------------
    //  GET — Show form + history
    // ----------------------------------------------------------------

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.requireTeacher(request, response)) return;

        User teacher = AuthUtil.getLoggedInUser(request);

        try {
            SyllabusDAO syllabusDAO         = new SyllabusDAO();
            SyllabusRequestDAO requestDAO   = new SyllabusRequestDAO();

            // Syllabi dropdown (all active syllabi)
            List<SyllabusDTO> syllabi = syllabusDAO.searchSyllabi("", "", 1, 1000);
            request.setAttribute("syllabi", syllabi);

            // My submission history with pagination
            int page = ValidationUtil.parsePageNumber(request.getParameter("page"));
            int total = requestDAO.countRequestsByUser(teacher.getUserId());
            PaginationDTO pagination = PaginationUtil.buildPagination(total, page, PAGE_SIZE);
            List<SyllabusRequestDTO> myRequests =
                    requestDAO.getRequestsByUser(teacher.getUserId(), page, PAGE_SIZE);

            request.setAttribute("myRequests", myRequests);
            request.setAttribute("pagination", pagination);
            request.setAttribute("totalRequests", total);

            request.getRequestDispatcher("/view/teacher/submitRequest.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            getServletContext().log("DB error in SubmitRequestServlet GET", e);
            request.getRequestDispatcher("/view/error/dbError.jsp").forward(request, response);
        }
    }

    // ----------------------------------------------------------------
    //  POST — Save new request
    // ----------------------------------------------------------------

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.requireTeacher(request, response)) return;

        User teacher = AuthUtil.getLoggedInUser(request);
        request.setCharacterEncoding("UTF-8");

        String syllabusIdParam = request.getParameter("syllabusId");
        String requestType     = request.getParameter("requestType");
        String reviewNote      = request.getParameter("reviewNote");

        // ── Validate ──────────────────────────────────────────────────
        if (!ValidationUtil.isValidId(syllabusIdParam)) {
            request.setAttribute("error", "Please select a valid syllabus.");
            doGet(request, response);
            return;
        }

        if (requestType == null || requestType.trim().isEmpty()) {
            request.setAttribute("error", "Please select a request type.");
            doGet(request, response);
            return;
        }

        // Allowed request types (whitelist)
        if (!requestType.matches("New|Modify|Deactivate")) {
            request.setAttribute("error", "Invalid request type.");
            doGet(request, response);
            return;
        }

        if (reviewNote != null) {
            reviewNote = ValidationUtil.sanitize(reviewNote);
            if (reviewNote.length() > 2000) {
                request.setAttribute("error", "Notes must not exceed 2000 characters.");
                doGet(request, response);
                return;
            }
        }

        int syllabusId = Integer.parseInt(syllabusIdParam.trim());

        try {
            SyllabusRequestDAO requestDAO = new SyllabusRequestDAO();
            int newId = requestDAO.insertRequest(
                    syllabusId, teacher.getUserId(), requestType, reviewNote);

            if (newId > 0) {
                response.sendRedirect(request.getContextPath()
                        + "/teacher/submit-request?success=Request+submitted+successfully");
            } else {
                request.setAttribute("error", "Failed to submit request. Please try again.");
                doGet(request, response);
            }
        } catch (SQLException e) {
            getServletContext().log("DB error in SubmitRequestServlet POST", e);
            request.setAttribute("error", "Database error. Please try again later.");
            doGet(request, response);
        }
    }
}
