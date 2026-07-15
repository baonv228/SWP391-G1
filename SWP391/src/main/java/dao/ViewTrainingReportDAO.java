package dao;

import model.ViewTrainingReport;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for View Training Report (read-only).
 * New file only — does not modify existing DAOs.
 */
public class ViewTrainingReportDAO extends DBContext {

    private static final String BASE_SELECT = """
            SELECT
                r.RequestID                                              AS ReportID,
                s.SubjectID                                              AS CourseID,
                s.SubjectCode                                            AS CourseCode,
                s.SubjectName                                            AS CourseName,
                (
                    SELECT STRING_AGG(c.CurriculumName, ', ')
                    FROM dbo.Curriculum_Subject cs
                    INNER JOIN dbo.Curriculum c ON c.CurriculumID = cs.CurriculumID
                    WHERE cs.SubjectID = s.SubjectID
                )                                                        AS CurriculumName,
                s.Description                                            AS CourseDescription,
                creator.FullName                                         AS CreatedBy,
                ISNULL(modifier.FullName, requester.FullName)            AS ModifiedBy,
                sy.CreatedAt                                             AS CreatedDate,
                ISNULL(r.ReviewedAt, r.RequestedAt)                      AS LastModifiedDate,
                r.Status                                                 AS Status,
                r.RequestType                                            AS ReportType,
                (
                    SELECT COUNT(*)
                    FROM dbo.Syllabus_Feedback f
                    WHERE f.SyllabusID = sy.SyllabusID
                )                                                        AS NumberOfChanges,
                r.ReviewNote                                             AS ChangeDetails,
                reviewer.FullName                                        AS Reviewer,
                r.ReviewedAt                                             AS ReviewDate,
                sy.SyllabusID                                            AS SyllabusID,
                sy.SyllabusTitle                                         AS SyllabusTitle,
                sy.VersionNo                                             AS VersionNo
            FROM dbo.Syllabus_Approval_Request r
            INNER JOIN dbo.Syllabus sy
                ON sy.SyllabusID = r.SyllabusID
            INNER JOIN dbo.Subject s
                ON s.SubjectID = sy.SubjectID
            LEFT JOIN dbo.[User] creator
                ON creator.UserID = s.CreatedBy
            LEFT JOIN dbo.[User] requester
                ON requester.UserID = r.RequestedBy
            LEFT JOIN dbo.[User] reviewer
                ON reviewer.UserID = r.ReviewedBy
            LEFT JOIN dbo.[User] modifier
                ON modifier.UserID = ISNULL(r.ReviewedBy, r.RequestedBy)
            """;

    /**
     * List reports with optional search / status / date filters and sort.
     *
     * @param keyword  Course ID/code or Course Name (nullable)
     * @param status   Exact status filter (nullable)
     * @param fromDate yyyy-MM-dd (nullable)
     * @param toDate   yyyy-MM-dd (nullable)
     * @param sortBy   "createdDate" or "lastModifiedDate" (default lastModifiedDate)
     */
    public List<ViewTrainingReport> findReports(String keyword, String status,
                                                String fromDate, String toDate,
                                                String sortBy) {
        List<ViewTrainingReport> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT);
        sql.append(" WHERE 1 = 1 ");

        String keywordPattern = null;
        if (keyword != null && !keyword.trim().isEmpty()) {
            keywordPattern = "%" + keyword.trim() + "%";
            sql.append(" AND (s.SubjectCode LIKE ? OR s.SubjectName LIKE ?) ");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND r.Status = ? ");
        }
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append(" AND CAST(ISNULL(r.ReviewedAt, r.RequestedAt) AS date) >= CAST(? AS date) ");
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append(" AND CAST(ISNULL(r.ReviewedAt, r.RequestedAt) AS date) <= CAST(? AS date) ");
        }

        if ("createdDate".equalsIgnoreCase(sortBy)) {
            sql.append(" ORDER BY sy.CreatedAt DESC ");
        } else {
            sql.append(" ORDER BY ISNULL(r.ReviewedAt, r.RequestedAt) DESC ");
        }

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int idx = 1;
            if (keywordPattern != null) {
                ps.setString(idx++, keywordPattern);
                ps.setString(idx++, keywordPattern);
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(idx++, status.trim());
            }
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                ps.setString(idx++, fromDate.trim());
            }
            if (toDate != null && !toDate.trim().isEmpty()) {
                ps.setString(idx++, toDate.trim());
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs, false));
                }
            }
        } catch (SQLException e) {
            System.out.println("ViewTrainingReportDAO.findReports error: " + e.getMessage());
        }
        return list;
    }

    /** Backward-compatible overload: sort by last modified. */
    public List<ViewTrainingReport> findReports(String keyword, String status,
                                                String fromDate, String toDate) {
        return findReports(keyword, status, fromDate, toDate, "lastModifiedDate");
    }

    /**
     * Load one report by ReportID (RequestID). Returns null if not found.
     */
    public ViewTrainingReport findByReportId(int reportId) {
        String sql = BASE_SELECT + " WHERE r.RequestID = ? ";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reportId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs, true);
                }
            }
        } catch (SQLException e) {
            System.out.println("ViewTrainingReportDAO.findByReportId error: " + e.getMessage());
        }
        return null;
    }

    private ViewTrainingReport mapRow(ResultSet rs, boolean includeDetailExtras) throws SQLException {
        ViewTrainingReport item = new ViewTrainingReport();
        item.setReportId(rs.getInt("ReportID"));
        item.setCourseId(rs.getInt("CourseID"));
        item.setCourseCode(rs.getString("CourseCode"));
        item.setCourseName(rs.getString("CourseName"));
        item.setCurriculumName(rs.getString("CurriculumName"));
        item.setCourseDescription(rs.getString("CourseDescription"));
        item.setCreatedBy(rs.getString("CreatedBy"));
        item.setModifiedBy(rs.getString("ModifiedBy"));
        item.setCreatedDate(rs.getTimestamp("CreatedDate"));
        item.setLastModifiedDate(rs.getTimestamp("LastModifiedDate"));
        item.setStatus(rs.getString("Status"));
        item.setReportType(rs.getString("ReportType"));
        item.setNumberOfChanges(rs.getInt("NumberOfChanges"));
        item.setChangeDetails(rs.getString("ChangeDetails"));
        item.setReviewer(rs.getString("Reviewer"));
        item.setReviewDate(rs.getTimestamp("ReviewDate"));

        // Always available in BASE_SELECT
        int syllabusId = rs.getInt("SyllabusID");
        if (!rs.wasNull()) {
            item.setSyllabusId(syllabusId);
        }
        item.setSyllabusTitle(rs.getString("SyllabusTitle"));
        item.setVersionNo(rs.getString("VersionNo"));
        return item;
    }
}
