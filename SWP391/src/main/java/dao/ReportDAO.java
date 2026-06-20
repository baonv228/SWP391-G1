package dao;

import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * ReportDAO — aggregation queries for the System Report feature.
 * Returns Map<label, count> for easy rendering in JSP.
 */
public class ReportDAO {

    /** Count syllabi grouped by Status. */
    public Map<String, Integer> countSyllabiByStatus() throws SQLException {
        return queryGroupBy(
                "SELECT Status, COUNT(*) AS cnt FROM Syllabus GROUP BY Status ORDER BY Status");
    }

    /** Count subjects grouped by Status. */
    public Map<String, Integer> countSubjectsByStatus() throws SQLException {
        return queryGroupBy(
                "SELECT Status, COUNT(*) AS cnt FROM Subject GROUP BY Status ORDER BY Status");
    }

    /** Count Learning_Material grouped by MaterialType. */
    public Map<String, Integer> countMaterialsByType() throws SQLException {
        return queryGroupBy(
                "SELECT ISNULL(MaterialType,'Unknown') AS Status, COUNT(*) AS cnt " +
                "FROM Learning_Material WHERE Status='Active' " +
                "GROUP BY MaterialType ORDER BY MaterialType");
    }

    /** Count Syllabus_Approval_Request grouped by Status. */
    public Map<String, Integer> countRequestsByStatus() throws SQLException {
        return queryGroupBy(
                "SELECT Status, COUNT(*) AS cnt FROM Syllabus_Approval_Request " +
                "GROUP BY Status ORDER BY Status");
    }

    /** Count Curriculum grouped by Status. */
    public Map<String, Integer> countCurriculaByStatus() throws SQLException {
        return queryGroupBy(
                "SELECT Status, COUNT(*) AS cnt FROM Curriculum GROUP BY Status ORDER BY Status");
    }

    /** Total counts across the whole system. */
    public Map<String, Integer> getTotalSummary() throws SQLException {
        Map<String, Integer> summary = new LinkedHashMap<>();
        try (Connection conn = DBContext.getConnection();
             Statement st = conn.createStatement()) {

            addCount(st, summary, "Total Syllabi",   "SELECT COUNT(*) FROM Syllabus");
            addCount(st, summary, "Total Subjects",  "SELECT COUNT(*) FROM Subject");
            addCount(st, summary, "Total Materials", "SELECT COUNT(*) FROM Learning_Material WHERE Status='Active'");
            addCount(st, summary, "Total Curricula", "SELECT COUNT(*) FROM Curriculum");
            addCount(st, summary, "Total Requests",  "SELECT COUNT(*) FROM Syllabus_Approval_Request");
            addCount(st, summary, "Pending Requests","SELECT COUNT(*) FROM Syllabus_Approval_Request WHERE Status='Pending'");
            addCount(st, summary, "Total Users",     "SELECT COUNT(*) FROM [User] WHERE Status='Active'");
        }
        return summary;
    }

    // ----------------------------------------------------------------
    //  Helpers
    // ----------------------------------------------------------------

    private Map<String, Integer> queryGroupBy(String sql) throws SQLException {
        Map<String, Integer> map = new LinkedHashMap<>();
        try (Connection conn = DBContext.getConnection();
             Statement st = conn.createStatement();
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
            if (rs.next()) map.put(label, rs.getInt(1));
        }
    }
}
