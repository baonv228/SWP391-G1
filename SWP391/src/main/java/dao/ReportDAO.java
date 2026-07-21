package dao;

import model.CourseReportItem;
import model.TrainingReportStats;

import java.sql.Connection;
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

        String sql = """
                SELECT 
                    (SELECT COUNT(*) FROM Training_Program) AS TotalPrograms,
                    (SELECT COUNT(*) FROM Curriculum) AS TotalCurriculums,
                    (SELECT COUNT(*) FROM Subject) AS TotalSubjects,
                    (SELECT COUNT(*) FROM Syllabus) AS TotalSyllabuses
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                stats.setTotalPrograms(rs.getInt("TotalPrograms"));
                stats.setTotalCurriculums(rs.getInt("TotalCurriculums"));
                stats.setTotalSubjects(rs.getInt("TotalSubjects"));
                stats.setTotalSyllabuses(rs.getInt("TotalSyllabuses"));
            }

        } catch (Exception e) {
            System.out.println("getReportStats error: " + e.getMessage());
        }

        return stats;
    }

    // =========================================================
    // COURSE REPORT
    // =========================================================
    public List<CourseReportItem> getCourseReport(String programFilter, String searchKeyword) {
        List<CourseReportItem> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
                SELECT 
                    s.SubjectID,
                    s.SubjectCode,
                    s.SubjectName,
                    s.Credits,
                    ISNULL(sy.Status, 'No Syllabus') AS SyllabusStatus,
                    (
                        SELECT STRING_AGG(c.CurriculumName, ', ')
                        FROM Curriculum_Subject cs
                        JOIN Curriculum c ON cs.CurriculumID = c.CurriculumID
                        WHERE cs.SubjectID = s.SubjectID
                    ) AS AssociatedCurriculums,
                    (
                        SELECT STRING_AGG(tp.ProgramName, ', ')
                        FROM Curriculum_Subject cs
                        JOIN Curriculum c ON cs.CurriculumID = c.CurriculumID
                        JOIN Training_Program tp ON c.ProgramID = tp.ProgramID
                        WHERE cs.SubjectID = s.SubjectID
                    ) AS AssociatedPrograms
                FROM Subject s
                LEFT JOIN Syllabus sy ON s.SubjectID = sy.SubjectID
                WHERE 1 = 1
                """);

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (s.SubjectCode LIKE ? OR s.SubjectName LIKE ?) ");
        }

        if (programFilter != null && !programFilter.trim().isEmpty()) {
            sql.append("""
                    AND EXISTS (
                        SELECT 1
                        FROM Curriculum_Subject cs2
                        JOIN Curriculum c2 ON cs2.CurriculumID = c2.CurriculumID
                        WHERE cs2.SubjectID = s.SubjectID
                          AND c2.ProgramID = ?
                    )
                    """);
        }

        sql.append(" ORDER BY s.SubjectCode ");

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String searchPattern = "%" + searchKeyword.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }

            if (programFilter != null && !programFilter.trim().isEmpty()) {
                ps.setInt(paramIndex, Integer.parseInt(programFilter.trim()));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CourseReportItem item = new CourseReportItem();

                    item.setSubjectId(rs.getInt("SubjectID"));
                    item.setSubjectCode(rs.getString("SubjectCode"));
                    item.setSubjectName(rs.getString("SubjectName"));
                    item.setCredits(rs.getInt("Credits"));
                    item.setSyllabusStatus(rs.getString("SyllabusStatus"));
                    item.setAssociatedCurriculums(rs.getString("AssociatedCurriculums"));
                    item.setAssociatedPrograms(rs.getString("AssociatedPrograms"));

                    list.add(item);
                }
            }

        } catch (Exception e) {
            System.out.println("getCourseReport error: " + e.getMessage());
        }

        return list;
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
    // ADMIN SYSTEM REPORTS — users / activity proxies
    // =========================================================
    public Map<String, Integer> countUsersByRole() throws SQLException {
        return queryGroupBy("""
                SELECT ISNULL(r.RoleName, 'Unknown') AS Label, COUNT(*) AS cnt
                FROM dbo.[User] u
                LEFT JOIN dbo.[Role] r ON u.RoleID = r.RoleID
                GROUP BY r.RoleName
                ORDER BY r.RoleName
                """);
    }

    public Map<String, Integer> countUsersByStatus() throws SQLException {
        return queryGroupBy("""
                SELECT ISNULL(Status, 'Unknown') AS Label, COUNT(*) AS cnt
                FROM dbo.[User]
                GROUP BY Status
                ORDER BY Status
                """);
    }

    /**
     * Account-creation activity proxy (User.CreatedAt).
     * Empty from/to means no bound on that side.
     */
    public Map<String, Integer> countUsersCreatedByDay(String fromDate, String toDate) throws SQLException {
        Map<String, Integer> map = new LinkedHashMap<>();
        StringBuilder sql = new StringBuilder("""
                SELECT CONVERT(varchar(10), CreatedAt, 23) AS DayLabel, COUNT(*) AS cnt
                FROM dbo.[User]
                WHERE 1 = 1
                """);
        if (fromDate != null && !fromDate.isBlank()) {
            sql.append(" AND CAST(CreatedAt AS date) >= ? ");
        }
        if (toDate != null && !toDate.isBlank()) {
            sql.append(" AND CAST(CreatedAt AS date) <= ? ");
        }
        sql.append(" GROUP BY CONVERT(varchar(10), CreatedAt, 23) ORDER BY DayLabel ");

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int idx = 1;
            if (fromDate != null && !fromDate.isBlank()) {
                ps.setString(idx++, fromDate.trim());
            }
            if (toDate != null && !toDate.isBlank()) {
                ps.setString(idx, toDate.trim());
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getString(1), rs.getInt(2));
                }
            }
        }
        return map;
    }

    public int countUsersCreatedInRange(String fromDate, String toDate) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM dbo.[User] WHERE 1 = 1 ");
        if (fromDate != null && !fromDate.isBlank()) {
            sql.append(" AND CAST(CreatedAt AS date) >= ? ");
        }
        if (toDate != null && !toDate.isBlank()) {
            sql.append(" AND CAST(CreatedAt AS date) <= ? ");
        }
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int idx = 1;
            if (fromDate != null && !fromDate.isBlank()) {
                ps.setString(idx++, fromDate.trim());
            }
            if (toDate != null && !toDate.isBlank()) {
                ps.setString(idx, toDate.trim());
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public Map<String, Integer> getAdminSummary() throws SQLException {
        Map<String, Integer> summary = getTotalSummary();
        try (Connection con = getConnection();
             Statement st = con.createStatement()) {
            addCount(st, summary, "Total Programs",
                    "SELECT COUNT(*) FROM Training_Program");
            addCount(st, summary, "Deactivated Users",
                    "SELECT COUNT(*) FROM dbo.[User] WHERE Status <> 'Active'");
        } catch (SQLException e) {
            // Training_Program may be missing on partial DBs — keep base summary
            System.out.println("getAdminSummary extra counts: " + e.getMessage());
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