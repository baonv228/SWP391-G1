package service;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.*;

import java.io.OutputStream;

/**
 * Generates a Syllabus Excel template (.xlsx) with 5 sheets
 * containing headers and sample data for guidance.
 */
public class ExcelTemplateGenerator {

    public static void generate(OutputStream out) throws Exception {
        try (XSSFWorkbook wb = new XSSFWorkbook()) {

            // ── Styles ──
            CellStyle headerStyle = createHeaderStyle(wb);
            CellStyle fieldStyle = createFieldNameStyle(wb);

            // ================================================================
            // Sheet 0: General Info
            // ================================================================
            XSSFSheet s0 = wb.createSheet("General Info");
            s0.setColumnWidth(0, 7000);
            s0.setColumnWidth(1, 15000);

            createHeaderRow(s0, headerStyle, "Field", "Value");

            String[][] generalRows = {
                {"Syllabus Name (Tiếng Việt)", "Phát triển ứng dụng Web với Java"},
                {"Syllabus English", "Web Application Development with Java"},
                {"Description", "Mô tả tổng quan về đề cương..."},
                {"Student Tasks", "Nhiệm vụ của sinh viên..."},
                {"Time Allocation", "Study hour (150h) = 45h contact + 104h self-study"},
                {"Tools", "IntelliJ IDEA, SQL Server, Apache Tomcat"},
                {"Scoring Scale", "10"},
                {"Min Avg Mark To Pass", "5"},
                {"Degree Level", "Bachelor"},
                {"Decision No", "377/QĐ-ĐHFPT dated 04/09/2026"},
                {"Note", ""}
            };
            for (int i = 0; i < generalRows.length; i++) {
                Row row = s0.createRow(i + 1);
                Cell c0 = row.createCell(0);
                c0.setCellValue(generalRows[i][0]);
                c0.setCellStyle(fieldStyle);
                row.createCell(1).setCellValue(generalRows[i][1]);
            }

            // ================================================================
            // Sheet 1: CLOs
            // ================================================================
            XSSFSheet s1 = wb.createSheet("CLOs");
            s1.setColumnWidth(0, 3000);
            s1.setColumnWidth(1, 5000);
            s1.setColumnWidth(2, 15000);

            createHeaderRow(s1, headerStyle, "CLO#", "CLO Details", "LO Details");

            String[][] cloRows = {
                {"CLO1", "CLO1", "Apply knowledge of computing and mathematics to develop software"},
                {"CLO2", "CLO2", "Identify and analyze software requirements from stakeholders"},
                {"CLO3", "CLO3", "Design and implement web-based applications using Java technologies"},
                {"CLO4", "CLO4", "Test and debug programs systematically"},
                {"CLO5", "CLO5", "Work effectively in teams using software project management tools"}
            };
            for (int i = 0; i < cloRows.length; i++) {
                Row row = s1.createRow(i + 1);
                row.createCell(0).setCellValue(cloRows[i][0]);
                row.createCell(1).setCellValue(cloRows[i][1]);
                row.createCell(2).setCellValue(cloRows[i][2]);
            }

            // ================================================================
            // Sheet 2: Sessions
            // ================================================================
            XSSFSheet s2 = wb.createSheet("Sessions");
            String[] sesHeaders = {"Session", "Topic", "Learning-Teaching Type", "CLOs",
                    "ITU", "Student Materials", "S-Download", "Student Tasks", "URLs"};
            createHeaderRow(s2, headerStyle, sesHeaders);
            s2.setColumnWidth(1, 8000);
            s2.setColumnWidth(2, 5000);
            s2.setColumnWidth(3, 4000);

            String[][] sesRows = {
                {"1", "Course Introduction & Overview", "Lecture", "CLO1", "", "Slide 1", "Yes", "Read syllabus", ""},
                {"2", "Software Development Life Cycle", "Lecture, Discussion", "CLO1,CLO2", "", "Slide 2", "", "Read chapter 1", ""},
                {"3", "Requirement Analysis", "Lecture, Workshop", "CLO2", "AI literacy", "Slide 3", "Yes", "Practice exercises", ""},
            };
            for (int i = 0; i < sesRows.length; i++) {
                Row row = s2.createRow(i + 1);
                for (int j = 0; j < sesRows[i].length; j++) {
                    row.createCell(j).setCellValue(sesRows[i][j]);
                }
            }

            // ================================================================
            // Sheet 3: Materials
            // ================================================================
            XSSFSheet s3 = wb.createSheet("Materials");
            String[] matHeaders = {"#", "Mô tả", "Tác giả", "NXB", "Năm XB",
                    "Edition", "ISBN", "Main (x)", "Hard (x)", "Online (x)", "Note/URL"};
            createHeaderRow(s3, headerStyle, matHeaders);
            s3.setColumnWidth(1, 10000);

            String[][] matRows = {
                {"1", "Software Engineering: A Practitioner's Approach", "Roger S. Pressman", "McGraw-Hill", "2020", "9th", "978-1259872976", "x", "x", "", ""},
                {"2", "Head First Java", "Kathy Sierra", "O'Reilly", "2022", "3rd", "978-1491910771", "", "", "x", "https://example.com"},
            };
            for (int i = 0; i < matRows.length; i++) {
                Row row = s3.createRow(i + 1);
                for (int j = 0; j < matRows[i].length; j++) {
                    row.createCell(j).setCellValue(matRows[i][j]);
                }
            }

            // ================================================================
            // Sheet 4: Assessments
            // ================================================================
            XSSFSheet s4 = wb.createSheet("Assessments");
            String[] asmHeaders = {"#", "Category", "Type", "Weight %", "CLOs",
                    "Completion Criteria", "Duration", "Question Type",
                    "Knowledge & Skill", "Grading Guide", "Note"};
            createHeaderRow(s4, headerStyle, asmHeaders);
            s4.setColumnWidth(1, 5000);

            String[][] asmRows = {
                {"1", "Assignment", "Group project", "20", "CLO1,CLO2,CLO3", "> 0", "", "Practical", "Apply & Analyze", "Rubric", ""},
                {"2", "Progress Test", "Multiple choice", "20", "CLO1,CLO2", "> 0", "60 min", "MCQ", "Remember & Understand", "Answer key", ""},
                {"3", "Final Exam", "Written exam", "40", "CLO1,CLO2,CLO3,CLO4", "> 0", "90 min", "MCQ + Essay", "All levels", "Answer key + Rubric", ""},
                {"4", "Participation & Attitude", "Attendance", "10", "CLO5", "> 80% attendance", "", "", "", "", ""},
                {"5", "Practice Exercises", "Lab work", "10", "CLO3,CLO4", "> 0", "", "Practical", "Apply", "Checklist", ""},
            };
            for (int i = 0; i < asmRows.length; i++) {
                Row row = s4.createRow(i + 1);
                for (int j = 0; j < asmRows[i].length; j++) {
                    row.createCell(j).setCellValue(asmRows[i][j]);
                }
            }

            wb.write(out);
        }
    }

    private static void createHeaderRow(Sheet sheet, CellStyle style, String... headers) {
        Row row = sheet.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            Cell cell = row.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(style);
        }
    }

    private static CellStyle createHeaderStyle(XSSFWorkbook wb) {
        CellStyle style = wb.createCellStyle();
        Font font = wb.createFont();
        font.setBold(true);
        font.setColor(IndexedColors.WHITE.getIndex());
        font.setFontHeightInPoints((short) 12);
        style.setFont(font);
        style.setFillForegroundColor(new XSSFColor(new byte[]{(byte) 0xF2, 0x6D, 0x21}, null)); // #F26D21
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setBorderBottom(BorderStyle.THIN);
        return style;
    }

    private static CellStyle createFieldNameStyle(XSSFWorkbook wb) {
        CellStyle style = wb.createCellStyle();
        Font font = wb.createFont();
        font.setBold(true);
        style.setFont(font);
        style.setFillForegroundColor(new XSSFColor(new byte[]{(byte) 0xFF, (byte) 0xF0, (byte) 0xE6}, null)); // #FFF0E6
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        return style;
    }
}
