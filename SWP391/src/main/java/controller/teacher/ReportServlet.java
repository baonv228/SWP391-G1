package controller.teacher;

import dao.ReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.AuthUtil;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Map;

/**
 * ReportServlet — System Reports for Teacher.
 *
 * GET  /teacher/report          → View HTML report
 * GET  /teacher/report?export=csv → Download as CSV
 */
@WebServlet(name = "TeacherReportServlet", urlPatterns = {"/teacher/report"})
public class ReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.requireTeacher(request, response)) return;

        try {
            ReportDAO dao = new ReportDAO();
            Map<String, Integer> summary        = dao.getTotalSummary();
            Map<String, Integer> syllabiStatus  = dao.countSyllabiByStatus();
            Map<String, Integer> subjectStatus  = dao.countSubjectsByStatus();
            Map<String, Integer> materialTypes  = dao.countMaterialsByType();
            Map<String, Integer> requestStatus  = dao.countRequestsByStatus();

            // CSV export
            if ("csv".equalsIgnoreCase(request.getParameter("export"))) {
                exportCsv(response, summary, syllabiStatus, subjectStatus,
                        materialTypes, requestStatus);
                return;
            }

            request.setAttribute("summary",       summary);
            request.setAttribute("syllabiStatus", syllabiStatus);
            request.setAttribute("subjectStatus", subjectStatus);
            request.setAttribute("materialTypes", materialTypes);
            request.setAttribute("requestStatus", requestStatus);

            request.getRequestDispatcher("/view/teacher/systemReport.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            getServletContext().log("DB error in ReportServlet", e);
            request.getRequestDispatcher("/view/error/dbError.jsp").forward(request, response);
        }
    }

    private void exportCsv(HttpServletResponse response,
                            Map<String, Integer> summary,
                            Map<String, Integer> syllabiStatus,
                            Map<String, Integer> subjectStatus,
                            Map<String, Integer> materialTypes,
                            Map<String, Integer> requestStatus) throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"system_report.csv\"");

        try (PrintWriter out = response.getWriter()) {
            out.println("Section,Label,Count");
            writeSection(out, "Summary",           summary);
            writeSection(out, "Syllabi by Status", syllabiStatus);
            writeSection(out, "Subjects by Status",subjectStatus);
            writeSection(out, "Materials by Type", materialTypes);
            writeSection(out, "Requests by Status",requestStatus);
        }
    }

    private void writeSection(PrintWriter out, String section, Map<String, Integer> data) {
        for (Map.Entry<String, Integer> e : data.entrySet()) {
            out.printf("\"%s\",\"%s\",%d%n", section, e.getKey(), e.getValue());
        }
    }
}
