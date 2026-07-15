package controller;

import dao.ViewTrainingReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ViewTrainingReport;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import utils.AuthUtil;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 * View Training Report — read-only for Training Department.
 *
 * GET /view-training-report
 * GET /view-training-report?action=detail&reportId=...
 * GET /view-training-report?export=excel|csv|print
 *
 * Params: keyword, status, fromDate, toDate, sortBy=createdDate|lastModifiedDate
 */
@WebServlet(name = "ViewTrainingReportServlet", urlPatterns = {"/view-training-report"})
public class ViewTrainingReportServlet extends HttpServlet {

    private final ViewTrainingReportDAO reportDAO = new ViewTrainingReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.requireRole(request, response, AuthUtil.ROLE_TRAINING_DEPT)) {
            return;
        }

        String action = safe(request.getParameter("action"));
        if ("detail".equalsIgnoreCase(action)) {
            showDetail(request, response);
            return;
        }
        showList(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = safe(request.getParameter("keyword"));
        String status = safe(request.getParameter("status"));
        String fromDate = safe(request.getParameter("fromDate"));
        String toDate = safe(request.getParameter("toDate"));
        String sortBy = safe(request.getParameter("sortBy"));
        if (!"createdDate".equalsIgnoreCase(sortBy)) {
            sortBy = "lastModifiedDate";
        }
        String export = safe(request.getParameter("export")).toLowerCase();

        List<ViewTrainingReport> reports = reportDAO.findReports(
                emptyToNull(keyword),
                emptyToNull(status),
                emptyToNull(fromDate),
                emptyToNull(toDate),
                sortBy
        );

        if ("csv".equals(export)) {
            exportCsv(response, reports);
            return;
        }
        if ("excel".equals(export) || "xlsx".equals(export)) {
            exportExcel(response, reports);
            return;
        }

        request.setAttribute("reports", reports);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("printMode", "print".equals(export));

        request.getRequestDispatcher("/view/ViewTrainingReportList.jsp")
                .forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String reportIdRaw = safe(request.getParameter("reportId"));
        int reportId;
        try {
            reportId = Integer.parseInt(reportIdRaw);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid reportId.");
            return;
        }

        ViewTrainingReport report = reportDAO.findByReportId(reportId);
        if (report == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Report not found.");
            return;
        }

        request.setAttribute("report", report);
        request.getRequestDispatcher("/view/ViewTrainingReportDetail.jsp")
                .forward(request, response);
    }

    private void exportCsv(HttpServletResponse response, List<ViewTrainingReport> reports)
            throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"view_training_report.csv\"");

        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        try (PrintWriter out = response.getWriter()) {
            out.write('\ufeff');
            out.println("ReportID,CourseID,CourseCode,CourseName,CurriculumName,CourseDescription,"
                    + "CreatedBy,ModifiedBy,CreatedDate,LastModifiedDate,Status,ReportType,"
                    + "NumberOfChanges,ChangeDetails,Reviewer,ReviewDate");
            for (ViewTrainingReport r : reports) {
                out.printf("%d,%d,\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",%d,\"%s\",\"%s\",\"%s\"%n",
                        r.getReportId(),
                        r.getCourseId(),
                        csv(r.getCourseCode()),
                        csv(r.getCourseName()),
                        csv(r.getCurriculumName()),
                        csv(r.getCourseDescription()),
                        csv(r.getCreatedBy()),
                        csv(r.getModifiedBy()),
                        r.getCreatedDate() != null ? df.format(r.getCreatedDate()) : "",
                        r.getLastModifiedDate() != null ? df.format(r.getLastModifiedDate()) : "",
                        csv(r.getStatus()),
                        csv(r.getReportType()),
                        r.getNumberOfChanges(),
                        csv(r.getChangeDetails()),
                        csv(r.getReviewer()),
                        r.getReviewDate() != null ? df.format(r.getReviewDate()) : "");
            }
        }
    }

    private void exportExcel(HttpServletResponse response, List<ViewTrainingReport> reports)
            throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"view_training_report.xlsx\"");

        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        String[] headers = {
                "Report ID", "Course ID", "Course Code", "Course Name", "Curriculum Name",
                "Course Description", "Created By", "Modified By", "Created Date",
                "Last Modified Date", "Status", "Report Type", "Number of Changes",
                "Change Details", "Reviewer", "Review Date"
        };

        try (XSSFWorkbook workbook = new XSSFWorkbook();
             OutputStream out = response.getOutputStream()) {
            Sheet sheet = workbook.createSheet("Training Report");
            Row header = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                header.createCell(i).setCellValue(headers[i]);
            }

            int rowIdx = 1;
            for (ViewTrainingReport r : reports) {
                Row row = sheet.createRow(rowIdx++);
                int c = 0;
                row.createCell(c++).setCellValue(r.getReportId());
                row.createCell(c++).setCellValue(r.getCourseId());
                row.createCell(c++).setCellValue(n(r.getCourseCode()));
                row.createCell(c++).setCellValue(n(r.getCourseName()));
                row.createCell(c++).setCellValue(n(r.getCurriculumName()));
                row.createCell(c++).setCellValue(n(r.getCourseDescription()));
                row.createCell(c++).setCellValue(n(r.getCreatedBy()));
                row.createCell(c++).setCellValue(n(r.getModifiedBy()));
                row.createCell(c++).setCellValue(r.getCreatedDate() != null ? df.format(r.getCreatedDate()) : "");
                row.createCell(c++).setCellValue(r.getLastModifiedDate() != null ? df.format(r.getLastModifiedDate()) : "");
                row.createCell(c++).setCellValue(n(r.getStatus()));
                row.createCell(c++).setCellValue(n(r.getReportType()));
                row.createCell(c++).setCellValue(r.getNumberOfChanges());
                row.createCell(c++).setCellValue(n(r.getChangeDetails()));
                row.createCell(c++).setCellValue(n(r.getReviewer()));
                row.createCell(c).setCellValue(r.getReviewDate() != null ? df.format(r.getReviewDate()) : "");
            }
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }
            workbook.write(out);
        }
    }

    private String csv(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\"", "\"\"");
    }

    private String n(String value) {
        return value == null ? "" : value;
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }

    private String emptyToNull(String value) {
        return (value == null || value.isEmpty()) ? null : value;
    }
}
