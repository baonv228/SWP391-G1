package controller;

import dao.ReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Admin System Reports.
 *
 * GET /admin/reports
 * GET /admin/reports?export=csv|excel|print
 * Optional filters: category, fromDate, toDate
 */
@WebServlet(name = "AdminReportServlet", urlPatterns = {"/admin/reports"})
public class AdminReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String category = safe(request.getParameter("category"));
        if (category.isEmpty()) {
            category = "all";
        }
        String fromDate = safe(request.getParameter("fromDate"));
        String toDate = safe(request.getParameter("toDate"));
        String export = safe(request.getParameter("export")).toLowerCase();

        try {
            ReportDAO dao = new ReportDAO();
            ReportBundle bundle = loadBundle(dao, category, fromDate, toDate);

            if ("csv".equals(export)) {
                exportCsv(response, bundle);
                return;
            }
            if ("excel".equals(export) || "xlsx".equals(export)) {
                exportExcel(response, bundle);
                return;
            }

            request.setAttribute("category", category);
            request.setAttribute("fromDate", fromDate);
            request.setAttribute("toDate", toDate);
            request.setAttribute("summary", bundle.summary);
            request.setAttribute("usersByRole", bundle.usersByRole);
            request.setAttribute("usersByStatus", bundle.usersByStatus);
            request.setAttribute("usersCreatedByDay", bundle.usersCreatedByDay);
            request.setAttribute("usersCreatedInRange", bundle.usersCreatedInRange);
            request.setAttribute("syllabiStatus", bundle.syllabiStatus);
            request.setAttribute("subjectStatus", bundle.subjectStatus);
            request.setAttribute("curriculumStatus", bundle.curriculumStatus);
            request.setAttribute("materialTypes", bundle.materialTypes);
            request.setAttribute("requestStatus", bundle.requestStatus);
            request.setAttribute("printMode", "print".equals(export));

            request.getRequestDispatcher("/view/admin_system_reports.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("AdminReportServlet DB error", e);
            request.setAttribute("error", "Không tải được báo cáo hệ thống. Kiểm tra kết nối database.");
            request.getRequestDispatcher("/view/admin_system_reports.jsp").forward(request, response);
        }
    }

    private ReportBundle loadBundle(ReportDAO dao, String category, String fromDate, String toDate)
            throws SQLException {
        ReportBundle b = new ReportBundle();
        b.summary = dao.getAdminSummary();
        b.usersCreatedInRange = dao.countUsersCreatedInRange(fromDate, toDate);

        boolean all = "all".equalsIgnoreCase(category);

        if (all || "users".equalsIgnoreCase(category)) {
            b.usersByRole = dao.countUsersByRole();
            b.usersByStatus = dao.countUsersByStatus();
            b.usersCreatedByDay = dao.countUsersCreatedByDay(fromDate, toDate);
        }
        if (all || "syllabus".equalsIgnoreCase(category)) {
            b.syllabiStatus = dao.countSyllabiByStatus();
            b.requestStatus = dao.countRequestsByStatus();
        }
        if (all || "course".equalsIgnoreCase(category) || "curriculum".equalsIgnoreCase(category)) {
            b.subjectStatus = dao.countSubjectsByStatus();
            b.curriculumStatus = dao.countCurriculaByStatus();
        }
        if (all || "materials".equalsIgnoreCase(category)) {
            b.materialTypes = dao.countMaterialsByType();
        }
        return b;
    }

    private void exportCsv(HttpServletResponse response, ReportBundle bundle) throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"admin_system_report.csv\"");

        try (PrintWriter out = response.getWriter()) {
            out.write('\ufeff'); // BOM for Excel
            out.println("Section,Label,Count");
            writeCsvSection(out, "Summary", bundle.summary);
            writeCsvSection(out, "Users by Role", bundle.usersByRole);
            writeCsvSection(out, "Users by Status", bundle.usersByStatus);
            writeCsvSection(out, "Users Created by Day", bundle.usersCreatedByDay);
            writeCsvSection(out, "Syllabi by Status", bundle.syllabiStatus);
            writeCsvSection(out, "Subjects by Status", bundle.subjectStatus);
            writeCsvSection(out, "Curricula by Status", bundle.curriculumStatus);
            writeCsvSection(out, "Materials by Type", bundle.materialTypes);
            writeCsvSection(out, "Approval Requests", bundle.requestStatus);
            out.printf("\"Summary\",\"Users Created in Range\",%d%n", bundle.usersCreatedInRange);
        }
    }

    private void writeCsvSection(PrintWriter out, String section, Map<String, Integer> data) {
        if (data == null || data.isEmpty()) {
            return;
        }
        for (Map.Entry<String, Integer> e : data.entrySet()) {
            out.printf("\"%s\",\"%s\",%d%n",
                    escapeCsv(section), escapeCsv(e.getKey()), e.getValue());
        }
    }

    private String escapeCsv(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\"", "\"\"");
    }

    private void exportExcel(HttpServletResponse response, ReportBundle bundle) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"admin_system_report.xlsx\"");

        try (XSSFWorkbook workbook = new XSSFWorkbook();
             OutputStream out = response.getOutputStream()) {
            Sheet sheet = workbook.createSheet("System Reports");
            int rowIdx = 0;
            Row header = sheet.createRow(rowIdx++);
            header.createCell(0).setCellValue("Section");
            header.createCell(1).setCellValue("Label");
            header.createCell(2).setCellValue("Count");

            rowIdx = writeExcelSection(sheet, rowIdx, "Summary", bundle.summary);
            rowIdx = writeExcelSection(sheet, rowIdx, "Users by Role", bundle.usersByRole);
            rowIdx = writeExcelSection(sheet, rowIdx, "Users by Status", bundle.usersByStatus);
            rowIdx = writeExcelSection(sheet, rowIdx, "Users Created by Day", bundle.usersCreatedByDay);
            rowIdx = writeExcelSection(sheet, rowIdx, "Syllabi by Status", bundle.syllabiStatus);
            rowIdx = writeExcelSection(sheet, rowIdx, "Subjects by Status", bundle.subjectStatus);
            rowIdx = writeExcelSection(sheet, rowIdx, "Curricula by Status", bundle.curriculumStatus);
            rowIdx = writeExcelSection(sheet, rowIdx, "Materials by Type", bundle.materialTypes);
            rowIdx = writeExcelSection(sheet, rowIdx, "Approval Requests", bundle.requestStatus);

            Row rangeRow = sheet.createRow(rowIdx);
            rangeRow.createCell(0).setCellValue("Summary");
            rangeRow.createCell(1).setCellValue("Users Created in Range");
            rangeRow.createCell(2).setCellValue(bundle.usersCreatedInRange);

            sheet.autoSizeColumn(0);
            sheet.autoSizeColumn(1);
            sheet.autoSizeColumn(2);
            workbook.write(out);
        }
    }

    private int writeExcelSection(Sheet sheet, int rowIdx, String section, Map<String, Integer> data) {
        if (data == null || data.isEmpty()) {
            return rowIdx;
        }
        for (Map.Entry<String, Integer> e : data.entrySet()) {
            Row row = sheet.createRow(rowIdx++);
            row.createCell(0).setCellValue(section);
            row.createCell(1).setCellValue(e.getKey());
            row.createCell(2).setCellValue(e.getValue());
        }
        return rowIdx;
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }

    private static class ReportBundle {
        Map<String, Integer> summary = new LinkedHashMap<>();
        Map<String, Integer> usersByRole = new LinkedHashMap<>();
        Map<String, Integer> usersByStatus = new LinkedHashMap<>();
        Map<String, Integer> usersCreatedByDay = new LinkedHashMap<>();
        Map<String, Integer> syllabiStatus = new LinkedHashMap<>();
        Map<String, Integer> subjectStatus = new LinkedHashMap<>();
        Map<String, Integer> curriculumStatus = new LinkedHashMap<>();
        Map<String, Integer> materialTypes = new LinkedHashMap<>();
        Map<String, Integer> requestStatus = new LinkedHashMap<>();
        int usersCreatedInRange;
    }
}
