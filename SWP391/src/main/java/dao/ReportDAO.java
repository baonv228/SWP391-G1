package dao;

import model.CourseReportItem;
import model.TrainingReportStats;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ReportDAO extends DBContext {

    // =========================================================
    // TRAINING REPORT STATS
    // =========================================================
    public TrainingReportStats getReportStats() {
        TrainingReportStats stats = new TrainingReportStats();
        String sql = "SELECT (SELECT COUNT(*) FROM Training_Program) TotalPrograms, "
                + "(SELECT COUNT(*) FROM Curriculum) TotalCurriculums, "
                + "(SELECT COUNT(*) FROM Subject) TotalSubjects, "
                + "(SELECT COUNT(*) FROM Syllabus) TotalSyllabuses";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                stats.setTotalPrograms(rs.getInt("TotalPrograms"));
                stats.setTotalCurriculums(rs.getInt("TotalCurriculums"));
                stats.setTotalSubjects(rs.getInt("TotalSubjects"));
                stats.setTotalSyllabuses(rs.getInt("TotalSyllabuses"));
            }
        } catch (Exception e) { System.out.println("getReportStats error: " + e.getMessage()); }
        return stats;
    }

    public List<CourseReportItem> getCourseReports(String programFilter, String keyword, String status,
            String fromDate, String toDate, String sort) {
        List<CourseReportItem> reports = new ArrayList<>();
        StringBuilder sql = new StringBuilder(baseSelect()).append(" WHERE 1=1 ");
        List<Object> parameters = new ArrayList<>();
        if (hasText(keyword)) {
            sql.append(" AND (sub.SubjectCode LIKE ? OR sub.SubjectName LIKE ?) ");
            parameters.add("%" + keyword.trim() + "%"); parameters.add("%" + keyword.trim() + "%");
        }
        if (hasText(status)) { sql.append(" AND sy.Status = ? "); parameters.add(status.trim()); }
        if (hasText(programFilter)) {
            sql.append(" AND EXISTS (SELECT 1 FROM Curriculum_Subject fcs JOIN Curriculum fc ON fcs.CurriculumID = fc.CurriculumID WHERE fcs.SubjectID = sub.SubjectID AND fc.ProgramID = ?) ");
            parameters.add(Integer.parseInt(programFilter.trim()));
        }
        if (hasText(fromDate)) { sql.append(" AND CAST(sy.CreatedAt AS DATE) >= ? "); parameters.add(Date.valueOf(fromDate)); }
        if (hasText(toDate)) { sql.append(" AND CAST(sy.CreatedAt AS DATE) <= ? "); parameters.add(Date.valueOf(toDate)); }
        sql.append(orderBy(sort));
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            bind(ps, parameters);
            try (ResultSet rs = ps.executeQuery()) { while (rs.next()) reports.add(map(rs)); }
        } catch (Exception e) { System.out.println("getCourseReports error: " + e.getMessage()); }
        return reports;
    }

    public CourseReportItem getCourseReportById(int reportId) {
        String sql = baseSelect() + " WHERE sy.SyllabusID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reportId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? map(rs) : null; }
        } catch (Exception e) { System.out.println("getCourseReportById error: " + e.getMessage()); return null; }
    }

    private String baseSelect() {
        return """
            SELECT sy.SyllabusID AS ReportID, sub.SubjectID, sub.SubjectCode, sub.SubjectName,
                   COALESCE(NULLIF(sub.Description, ''), sy.Description, '') AS CourseDescription,
                   sub.Credits, COALESCE(sy.Status, 'Draft') AS SyllabusStatus, sy.VersionNo,
                   CASE WHEN sy.VersionNo IS NULL OR sy.VersionNo IN ('1', '1.0', 'v1', 'V1') THEN 'Created' ELSE 'Updated' END AS ReportType,
                   CASE WHEN sy.VersionNo IS NULL OR sy.VersionNo IN ('1', '1.0', 'v1', 'V1') THEN 0 ELSE 1 END AS NumberOfChanges,
                   CASE WHEN sy.VersionNo IS NULL OR sy.VersionNo IN ('1', '1.0', 'v1', 'V1') THEN 'Initial syllabus version created.' ELSE CONCAT('Syllabus version ', sy.VersionNo, ' created as an update.') END AS ChangeDetails,
                   creator.FullName AS CreatedBy, creator.FullName AS ModifiedBy, sy.CreatedAt AS CreatedDate, sy.CreatedAt AS LastModifiedDate,
                   reviewer.FullName AS Reviewer, sy.ApprovedAt AS ReviewDate,
                   (SELECT STRING_AGG(c.CurriculumName, ', ') FROM Curriculum_Subject cs JOIN Curriculum c ON cs.CurriculumID = c.CurriculumID WHERE cs.SubjectID = sub.SubjectID) AS AssociatedCurriculums,
                   (SELECT STRING_AGG(tp.ProgramName, ', ') FROM Curriculum_Subject cs JOIN Curriculum c ON cs.CurriculumID = c.CurriculumID JOIN Training_Program tp ON c.ProgramID = tp.ProgramID WHERE cs.SubjectID = sub.SubjectID) AS AssociatedPrograms
            FROM Syllabus sy
            JOIN Subject sub ON sy.SubjectID = sub.SubjectID
            LEFT JOIN dbo.[User] creator ON sy.CreatedBy = creator.UserID
            LEFT JOIN dbo.[User] reviewer ON sy.ApprovedBy = reviewer.UserID
            """;
    }

    private String orderBy(String sort) {
        if ("created_asc".equals(sort)) return " ORDER BY sy.CreatedAt ASC";
        if ("modified_desc".equals(sort)) return " ORDER BY sy.CreatedAt DESC";
        if ("modified_asc".equals(sort)) return " ORDER BY sy.CreatedAt ASC";
        return " ORDER BY sy.CreatedAt DESC";
    }
    private boolean hasText(String value) { return value != null && !value.trim().isEmpty(); }
    private void bind(PreparedStatement ps, List<Object> params) throws Exception {
        for (int i = 0; i < params.size(); i++) {
            Object value = params.get(i); if (value instanceof Integer) ps.setInt(i + 1, (Integer) value);
            else if (value instanceof Date) ps.setDate(i + 1, (Date) value); else ps.setString(i + 1, String.valueOf(value));
        }
    }
    private CourseReportItem map(ResultSet rs) throws Exception {
        CourseReportItem r = new CourseReportItem();
        r.setReportId(rs.getInt("ReportID")); r.setSubjectId(rs.getInt("SubjectID")); r.setSubjectCode(rs.getString("SubjectCode")); r.setSubjectName(rs.getString("SubjectName"));
        r.setCourseDescription(rs.getString("CourseDescription")); r.setCredits(rs.getInt("Credits")); r.setSyllabusStatus(rs.getString("SyllabusStatus")); r.setVersionNo(rs.getString("VersionNo"));
        r.setReportType(rs.getString("ReportType")); r.setNumberOfChanges(rs.getInt("NumberOfChanges")); r.setChangeDetails(rs.getString("ChangeDetails"));
        r.setCreatedBy(rs.getString("CreatedBy")); r.setModifiedBy(rs.getString("ModifiedBy")); r.setCreatedDate(rs.getTimestamp("CreatedDate")); r.setLastModifiedDate(rs.getTimestamp("LastModifiedDate"));
        r.setReviewer(rs.getString("Reviewer")); r.setReviewDate(rs.getTimestamp("ReviewDate")); r.setAssociatedCurriculums(rs.getString("AssociatedCurriculums")); r.setAssociatedPrograms(rs.getString("AssociatedPrograms"));
        return r;
    }

    // =========================================================
    // SYSTEM REPORT - GROUP BY STATUS / TYPE
    // =========================================================
    public Map<String, Integer> countSyllabiByStatus() throws SQLException {
        return queryGroupBy("""
                SELECT Status, COUNT(*) AS cnt
                FROM Syllabus
                GROUP BY Status
                ORDER BY Status
                """);
    }

    public Map<String, Integer> countSubjectsByStatus() throws SQLException {
        return queryGroupBy("""
                SELECT Status, COUNT(*) AS cnt
                FROM Subject
                GROUP BY Status
                ORDER BY Status
                """);
    }

    public Map<String, Integer> countMaterialsByType() throws SQLException {
        return queryGroupBy("""
                SELECT ISNULL(MaterialType, 'Unknown') AS Status, COUNT(*) AS cnt
                FROM Learning_Material
                WHERE Status = 'Active'
                GROUP BY MaterialType
                ORDER BY MaterialType
                """);
    }

    public Map<String, Integer> countRequestsByStatus() throws SQLException {
        return queryGroupBy("""
                SELECT Status, COUNT(*) AS cnt
                FROM Syllabus_Approval_Request
                GROUP BY Status
                ORDER BY Status
                """);
    }

    public Map<String, Integer> countCurriculaByStatus() throws SQLException {
        return queryGroupBy("""
                SELECT Status, COUNT(*) AS cnt
                FROM Curriculum
                GROUP BY Status
                ORDER BY Status
                """);
    }

    public Map<String, Integer> getTotalSummary() throws SQLException {
        Map<String, Integer> summary = new LinkedHashMap<>();

        try (Connection con = getConnection();
             Statement st = con.createStatement()) {

            addCount(st, summary, "Total Syllabi",
                    "SELECT COUNT(*) FROM Syllabus");

            addCount(st, summary, "Total Subjects",
                    "SELECT COUNT(*) FROM Subject");

            addCount(st, summary, "Total Materials",
                    "SELECT COUNT(*) FROM Learning_Material WHERE Status = 'Active'");

            addCount(st, summary, "Total Curricula",
                    "SELECT COUNT(*) FROM Curriculum");

            addCount(st, summary, "Total Requests",
                    "SELECT COUNT(*) FROM Syllabus_Approval_Request");

            addCount(st, summary, "Pending Requests",
                    "SELECT COUNT(*) FROM Syllabus_Approval_Request WHERE Status = 'Pending'");

            addCount(st, summary, "Total Users",
                    "SELECT COUNT(*) FROM [User] WHERE Status = 'Active'");
        }

        return summary;
    }

    // =========================================================
    // HELPERS
    // =========================================================
    private Map<String, Integer> queryGroupBy(String sql) throws SQLException {
        Map<String, Integer> map = new LinkedHashMap<>();

        try (Connection con = getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                map.put(rs.getString(1), rs.getInt(2));
            }
        }

        return map;
    }

    private void addCount(Statement st, Map<String, Integer> map,
                          String label, String sql) throws SQLException {
        try (ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                map.put(label, rs.getInt(1));
            }
        }
    }
}