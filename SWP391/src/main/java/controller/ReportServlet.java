package controller;

import com.lowagie.text.Document;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import dao.ReportDAO;
import dao.TrainingProgramDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;
import model.CourseReportItem;
import model.TrainingProgram;
import model.User;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

@WebServlet(name = "ReportServlet", urlPatterns = {"/report"})
public class ReportServlet extends HttpServlet {
    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    private final ReportDAO reportDAO = new ReportDAO();
    private final TrainingProgramDAO trainingProgramDAO = new TrainingProgramDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = trim(request.getParameter("action"));
        if (!isTrainingDepartment(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if ("detail".equals(action)) {
            showDetail(request, response);
            return;
        }
        ReportFilter filter = new ReportFilter(request);
        List<CourseReportItem> reports = reportDAO.getCourseReports(
                filter.programFilter, filter.keyword, filter.status,
                filter.fromDate, filter.toDate, filter.sort);
        if ("export-excel".equals(action)) {
            exportExcel(response, reports);
            return;
        }
        if ("export-pdf".equals(action)) {
            exportPdf(response, reports);
            return;
        }
        showList(request, response, filter);
    }

    private void showList(HttpServletRequest request, HttpServletResponse response, ReportFilter filter) throws ServletException, IOException {
        request.setAttribute("stats", reportDAO.getReportStats());
        request.setAttribute("reportItems", reportDAO.getCourseReports(
                filter.programFilter, filter.keyword, filter.status,
                filter.fromDate, filter.toDate, filter.sort));
        request.setAttribute("programs", trainingProgramDAO.getTrainingPrograms("", 1, 1000));
        request.setAttribute("filter", filter);
        request.getRequestDispatcher("/view/Report.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int reportId = Integer.parseInt(request.getParameter("id"));
            CourseReportItem report = reportDAO.getCourseReportById(reportId);
            if (report == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            request.setAttribute("report", report);
            request.getRequestDispatcher("/view/ReportDetail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void exportExcel(HttpServletResponse response, List<CourseReportItem> reports) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=tpms-training-reports.xlsx");
        String[] headers = {
            "Report ID", "Course ID", "Course Name", "Curriculum", "Description",
            "Created By", "Modified By", "Created Date", "Last Modified", "Status",
            "Report Type", "Changes", "Change Details", "Reviewer", "Review Date"
        };
        try (XSSFWorkbook workbook = new XSSFWorkbook()) {
            XSSFSheet sheet = workbook.createSheet("Training Reports");
            CellStyle style = workbook.createCellStyle();
            Font font = workbook.createFont();
            font.setBold(true);
            style.setFont(font);
            org.apache.poi.ss.usermodel.Row heading = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                Cell cell = heading.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(style);
            }
            int rowNumber = 1;
            for (CourseReportItem item : reports) {
                org.apache.poi.ss.usermodel.Row row = sheet.createRow(rowNumber++);
                String[] values = {
                    String.valueOf(item.getReportId()), item.getCourseId(), item.getSubjectName(),
                    item.getAssociatedCurriculums(), item.getCourseDescription(), item.getCreatedBy(),
                    item.getModifiedBy(), format(item.getCreatedDate()), format(item.getLastModifiedDate()),
                    item.getSyllabusStatus(), item.getReportType(), String.valueOf(item.getNumberOfChanges()),
                    item.getChangeDetails(), item.getReviewer(), format(item.getReviewDate())
                };
                for (int i = 0; i < values.length; i++) {
                    row.createCell(i).setCellValue(excelSafe(values[i]));
                }
            }
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }
            workbook.write(response.getOutputStream());
        }
    }

    private void exportPdf(HttpServletResponse response, List<CourseReportItem> reports) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=tpms-training-reports.pdf");
        Document document = new Document(com.lowagie.text.PageSize.A4.rotate(), 24, 24, 28, 28);
        try {
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();
            document.add(new Paragraph("TPMS - Training Reports"));
            document.add(new Paragraph("Generated: " + DATE_FORMAT.format(java.time.LocalDateTime.now())));
            document.add(new Paragraph(" "));
            PdfPTable table = new PdfPTable(new float[]{1, 1.5f, 2.3f, 1.5f, 1.3f, 1.3f, 1.4f});
            table.setWidthPercentage(100);
            String[] headings = {"ID", "Course", "Course name", "Type", "Status", "Created", "Reviewer"};
            for (String heading : headings) {
                PdfPCell cell = new PdfPCell(new Phrase(heading));
                cell.setBackgroundColor(new java.awt.Color(255, 230, 195));
                table.addCell(cell);
            }
            for (CourseReportItem item : reports) {
                table.addCell(String.valueOf(item.getReportId()));
                table.addCell(nullSafe(item.getCourseId()));
                table.addCell(nullSafe(item.getSubjectName()));
                table.addCell(nullSafe(item.getReportType()));
                table.addCell(nullSafe(item.getSyllabusStatus()));
                table.addCell(format(item.getCreatedDate()));
                table.addCell(nullSafe(item.getReviewer()));
            }
            document.add(table);
        } catch (Exception e) {
            throw new IOException("Cannot create training report PDF", e);
        } finally {
            if (document.isOpen()) {
                document.close();
            }
        }
    }

    private boolean isTrainingDepartment(HttpServletRequest request) {
        Object role = request.getSession().getAttribute("roleName");
        if (role == null) {
            Object userValue = request.getSession().getAttribute("user");
            if (userValue instanceof User user && user.getRole() != null) {
                role = user.getRole().getRoleName();
                request.getSession().setAttribute("roleName", role);
            }
        }
        return role != null && ("Training Department".equalsIgnoreCase(role.toString().trim())
                || "TrainingDepartment".equalsIgnoreCase(role.toString().trim()));
    }
    private String trim(String value) { return value == null ? "" : value.trim(); }
    private String nullSafe(String value) { return value == null ? "" : value; }
    private String excelSafe(String value) { value = nullSafe(value); return value.startsWith("=") || value.startsWith("+") || value.startsWith("-") || value.startsWith("@") ? "'" + value : value; }
    private String format(Timestamp value) { return value == null ? "" : value.toInstant().atZone(ZoneId.systemDefault()).format(DATE_FORMAT); }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    public static class ReportFilter {
        final String programFilter, keyword, status, fromDate, toDate, sort;

        ReportFilter(HttpServletRequest request) {
            programFilter = request.getParameter("programFilter");
            keyword = request.getParameter("searchKeyword");
            status = request.getParameter("status");
            fromDate = request.getParameter("fromDate");
            toDate = request.getParameter("toDate");
            sort = request.getParameter("sort");
        }

        public String getProgramFilter() { return programFilter; }
        public String getKeyword() { return keyword; }
        public String getStatus() { return status; }
        public String getFromDate() { return fromDate; }
        public String getToDate() { return toDate; }
        public String getSort() { return sort; }
    }
}
