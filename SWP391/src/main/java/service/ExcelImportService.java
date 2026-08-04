package service;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.InputStream;
import java.util.*;

/**
 * Parses uploaded .xlsx files for Syllabus import.
 * Expected sheets:
 *   Sheet 0 "General Info"  — key-value pairs (Field / Value)
 *   Sheet 1 "CLOs"          — table: CLO#, CLODetails, LODetails
 *   Sheet 2 "Sessions"      — table: Session#, Topic, Type, CLOs, ITU, Materials, SDownload, Tasks, URLs
 *   Sheet 3 "Materials"     — table: #, Description, Author, Publisher, PublishedDate, Edition, ISBN, Main, Hard, Online, Note
 *   Sheet 4 "Assessments"   — table: #, Category, Type, Weight, CLOs, CompletionCriteria, Duration, QuestionType, KnowledgeSkill, GradingGuide, Note
 */
public class ExcelImportService {

    public static class ImportResult {
        public Map<String, String> generalInfo = new LinkedHashMap<>();
        public List<Map<String, String>> clos = new ArrayList<>();
        public List<Map<String, String>> sessions = new ArrayList<>();
        public List<Map<String, String>> materials = new ArrayList<>();
        public List<Map<String, String>> assessments = new ArrayList<>();
        public List<String> errors = new ArrayList<>();

        public boolean hasErrors() { return !errors.isEmpty(); }
    }

    public ImportResult parseExcel(InputStream inputStream) {
        ImportResult result = new ImportResult();

        try (Workbook workbook = new XSSFWorkbook(inputStream)) {

            // Sheet: General Info
            Sheet generalSheet = workbook.getSheet("General Info");
            if (generalSheet != null) {
                parseGeneralInfo(generalSheet, result);
            } else {
                result.errors.add("Không tìm thấy Sheet 'General Info'.");
            }

            // Sheet: CLOs
            Sheet cloSheet = workbook.getSheet("CLOs");
            if (cloSheet != null) {
                parseCLOs(cloSheet, result);
            } else {
                result.errors.add("Không tìm thấy Sheet 'CLOs'.");
            }

            // Sheet: Sessions
            Sheet sessionSheet = workbook.getSheet("Sessions");
            if (sessionSheet != null) {
                parseSessions(sessionSheet, result);
            } else {
                result.errors.add("Không tìm thấy Sheet 'Sessions'.");
            }

            // Sheet: Materials
            Sheet matSheet = workbook.getSheet("Materials");
            if (matSheet != null) {
                parseMaterials(matSheet, result);
            } else {
                result.errors.add("Không tìm thấy Sheet 'Materials'.");
            }

            // Sheet: Assessments
            Sheet asmSheet = workbook.getSheet("Assessments");
            if (asmSheet != null) {
                parseAssessments(asmSheet, result);
            } else {
                result.errors.add("Không tìm thấy Sheet 'Assessments'.");
            }

            // Cross-validate: CLOs referenced in Sessions must exist
            validateCLOReferences(result);

        } catch (Exception e) {
            result.errors.add("Lỗi đọc file Excel: " + e.getMessage());
        }

        return result;
    }

    // =========================================================================
    // Sheet 0: General Info (key-value)
    // =========================================================================
    private void parseGeneralInfo(Sheet sheet, ImportResult result) {
        for (int i = 1; i <= sheet.getLastRowNum(); i++) { // skip header row
            Row row = sheet.getRow(i);
            if (row == null) continue;
            String field = getCellString(row, 0).trim();
            String value = getCellString(row, 1).trim();
            if (!field.isEmpty()) {
                result.generalInfo.put(field, value);
            }
        }
    }

    // =========================================================================
    // Sheet 1: CLOs
    // =========================================================================
    private void parseCLOs(Sheet sheet, ImportResult result) {
        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (row == null || isRowEmpty(row)) continue;

            Map<String, String> clo = new LinkedHashMap<>();
            clo.put("cloName", getCellString(row, 0).trim());       // CLO#
            clo.put("cloDetails", getCellString(row, 1).trim());    // CLO Details
            clo.put("loDetails", getCellString(row, 2).trim());     // LO Details

            if (clo.get("cloName").isEmpty()) {
                result.errors.add("Sheet CLOs, dòng " + (i + 1) + ": CLO# không được trống.");
                continue;
            }
            result.clos.add(clo);
        }
    }

    // =========================================================================
    // Sheet 2: Sessions
    // =========================================================================
    private void parseSessions(Sheet sheet, ImportResult result) {
        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (row == null || isRowEmpty(row)) continue;

            Map<String, String> ses = new LinkedHashMap<>();
            ses.put("session", getCellString(row, 0).trim());
            ses.put("topic", getCellString(row, 1).trim());
            ses.put("type", getCellString(row, 2).trim());
            ses.put("clos", getCellString(row, 3).trim());          // e.g. "CLO1,CLO3"
            ses.put("itu", getCellString(row, 4).trim());
            ses.put("materials", getCellString(row, 5).trim());
            ses.put("download", getCellString(row, 6).trim());
            ses.put("tasks", getCellString(row, 7).trim());
            ses.put("urls", getCellString(row, 8).trim());

            if (ses.get("topic").isEmpty()) {
                result.errors.add("Sheet Sessions, dòng " + (i + 1) + ": Topic không được trống.");
            }
            result.sessions.add(ses);
        }
    }

    // =========================================================================
    // Sheet 3: Materials
    // =========================================================================
    private void parseMaterials(Sheet sheet, ImportResult result) {
        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (row == null || isRowEmpty(row)) continue;

            Map<String, String> mat = new LinkedHashMap<>();
            mat.put("description", getCellString(row, 1).trim());
            mat.put("author", getCellString(row, 2).trim());
            mat.put("publisher", getCellString(row, 3).trim());
            mat.put("publishedDate", getCellString(row, 4).trim());
            mat.put("edition", getCellString(row, 5).trim());
            mat.put("isbn", getCellString(row, 6).trim());
            mat.put("isMain", getCellString(row, 7).trim().toLowerCase());
            mat.put("isHard", getCellString(row, 8).trim().toLowerCase());
            mat.put("isOnline", getCellString(row, 9).trim().toLowerCase());
            mat.put("note", getCellString(row, 10).trim());

            if (mat.get("description").isEmpty()) {
                result.errors.add("Sheet Materials, dòng " + (i + 1) + ": Mô tả không được trống.");
            }
            result.materials.add(mat);
        }
    }

    // =========================================================================
    // Sheet 4: Assessments
    // =========================================================================
    private void parseAssessments(Sheet sheet, ImportResult result) {
        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (row == null || isRowEmpty(row)) continue;

            Map<String, String> asm = new LinkedHashMap<>();
            asm.put("category", getCellString(row, 1).trim());
            asm.put("type", getCellString(row, 2).trim());
            asm.put("weight", getCellString(row, 3).trim());
            asm.put("clos", getCellString(row, 4).trim());
            asm.put("criteria", getCellString(row, 5).trim());
            asm.put("duration", getCellString(row, 6).trim());
            asm.put("questionType", getCellString(row, 7).trim());
            asm.put("knowledgeSkill", getCellString(row, 8).trim());
            asm.put("gradingGuide", getCellString(row, 9).trim());
            asm.put("note", getCellString(row, 10).trim());

            if (asm.get("category").isEmpty()) {
                result.errors.add("Sheet Assessments, dòng " + (i + 1) + ": Category không được trống.");
            }
            result.assessments.add(asm);
        }
    }

    // =========================================================================
    // Cross-validation
    // =========================================================================
    private void validateCLOReferences(ImportResult result) {
        Set<String> definedCLOs = new HashSet<>();
        for (Map<String, String> clo : result.clos) {
            definedCLOs.add(clo.get("cloName").toUpperCase());
        }

        // Check Sessions
        for (int i = 0; i < result.sessions.size(); i++) {
            String cloStr = result.sessions.get(i).get("clos");
            if (cloStr != null && !cloStr.isEmpty()) {
                for (String ref : cloStr.split("[,;\\s]+")) {
                    ref = ref.trim().toUpperCase();
                    if (!ref.isEmpty() && !definedCLOs.contains(ref)) {
                        result.errors.add("Sheet Sessions, dòng " + (i + 2) + ": " + ref + " không tồn tại trong danh sách CLOs.");
                    }
                }
            }
        }

        // Check Assessments
        for (int i = 0; i < result.assessments.size(); i++) {
            String cloStr = result.assessments.get(i).get("clos");
            if (cloStr != null && !cloStr.isEmpty()) {
                for (String ref : cloStr.split("[,;\\s]+")) {
                    ref = ref.trim().toUpperCase();
                    if (!ref.isEmpty() && !definedCLOs.contains(ref)) {
                        result.errors.add("Sheet Assessments, dòng " + (i + 2) + ": " + ref + " không tồn tại trong danh sách CLOs.");
                    }
                }
            }
        }
    }

    // =========================================================================
    // Utility
    // =========================================================================
    private String getCellString(Row row, int colIndex) {
        Cell cell = row.getCell(colIndex, Row.MissingCellPolicy.RETURN_BLANK_AS_NULL);
        if (cell == null) return "";

        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue();
            case NUMERIC:
                // Avoid scientific notation for whole numbers
                double val = cell.getNumericCellValue();
                if (val == Math.floor(val) && !Double.isInfinite(val)) {
                    return String.valueOf((long) val);
                }
                return String.valueOf(val);
            case BOOLEAN:
                return cell.getBooleanCellValue() ? "true" : "false";
            case FORMULA:
                try {
                    return cell.getStringCellValue();
                } catch (Exception e) {
                    try {
                        double v = cell.getNumericCellValue();
                        if (v == Math.floor(v)) return String.valueOf((long) v);
                        return String.valueOf(v);
                    } catch (Exception e2) {
                        return "";
                    }
                }
            default:
                return "";
        }
    }

    private boolean isRowEmpty(Row row) {
        for (int i = row.getFirstCellNum(); i < row.getLastCellNum(); i++) {
            Cell cell = row.getCell(i, Row.MissingCellPolicy.RETURN_BLANK_AS_NULL);
            if (cell != null && cell.getCellType() != CellType.BLANK) {
                String val = getCellString(row, i).trim();
                if (!val.isEmpty()) return false;
            }
        }
        return true;
    }
}
