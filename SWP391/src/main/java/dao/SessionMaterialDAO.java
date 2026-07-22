package dao;

import dto.MaterialDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO for the Session_Material junction table.
 *
 * Links a teacher's private-cloud material to a specific teaching session,
 * anchored by (SyllabusID, SessionNumber) rather than SessionID.
 *
 * Rationale: SyllabusDAO.saveAllChildren wipes and recreates every
 * Syllabus_Session row whenever a Designer saves the syllabus, so SessionID
 * is not stable. SessionNumber is stable thanks to the
 * UQ_Session_Number(SyllabusID, SessionNumber) constraint, so links survive.
 */
public class SessionMaterialDAO {

    /**
     * Returns a map of SessionNumber -> list of linked, active materials for
     * the given syllabus. Ordered by SessionNumber, then material name.
     */
    public Map<Integer, List<MaterialDTO>> getMaterialsBySyllabus(int syllabusId) throws SQLException {
        Map<Integer, List<MaterialDTO>> bySession = new LinkedHashMap<>();
        try (Connection conn = DBContext.getConnection()) {
            boolean hasDownloadCount = hasColumn(conn, "dbo.Learning_Material", "DownloadCount");
            boolean hasFileSize = hasColumn(conn, "dbo.Learning_Material", "FileSize");

            String downloadCountExpr = hasDownloadCount
                    ? "ISNULL(lm.DownloadCount, 0) AS DownloadCount"
                    : "0 AS DownloadCount";
            String fileSizeExpr = hasFileSize
                    ? "ISNULL(lm.FileSize, 0) AS FileSize"
                    : "0 AS FileSize";

            String sql = "SELECT sm.SessionNumber, "
                    + "lm.MaterialID, lm.SyllabusID, lm.UploadedBy, lm.MaterialName, "
                    + "lm.FilePath, lm.MaterialType, lm.Visibility, lm.Status, lm.UploadedAt, "
                    + downloadCountExpr + ", " + fileSizeExpr + " "
                    + "FROM Session_Material sm "
                    + "JOIN Learning_Material lm ON lm.MaterialID = sm.MaterialID "
                    + "WHERE sm.SyllabusID = ? AND lm.Status = 'Active' "
                    + "ORDER BY sm.SessionNumber, lm.MaterialName";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setQueryTimeout(10);
                ps.setInt(1, syllabusId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int sessionNumber = rs.getInt("SessionNumber");
                        bySession.computeIfAbsent(sessionNumber, k -> new ArrayList<>())
                                .add(mapRow(rs));
                    }
                }
            }
        }
        return bySession;
    }

    /** Material IDs already linked to one session. */
    public List<Integer> getMaterialIds(int syllabusId, int sessionNumber) throws SQLException {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT MaterialID FROM Session_Material "
                + "WHERE SyllabusID = ? AND SessionNumber = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, syllabusId);
            ps.setInt(2, sessionNumber);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) ids.add(rs.getInt(1));
            }
        }
        return ids;
    }

    /**
     * Links a material to a session. Idempotent: skips if already linked.
     * @return true when a new link row was created.
     */
    public boolean link(int syllabusId, int sessionNumber, int materialId) throws SQLException {
        String sql = "INSERT INTO Session_Material (SyllabusID, SessionNumber, MaterialID) "
                + "SELECT ?, ?, ? "
                + "WHERE NOT EXISTS ("
                + "  SELECT 1 FROM Session_Material "
                + "  WHERE SyllabusID = ? AND SessionNumber = ? AND MaterialID = ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, syllabusId);
            ps.setInt(2, sessionNumber);
            ps.setInt(3, materialId);
            ps.setInt(4, syllabusId);
            ps.setInt(5, sessionNumber);
            ps.setInt(6, materialId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Removes a material link from a session. */
    public boolean unlink(int syllabusId, int sessionNumber, int materialId) throws SQLException {
        String sql = "DELETE FROM Session_Material "
                + "WHERE SyllabusID = ? AND SessionNumber = ? AND MaterialID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, syllabusId);
            ps.setInt(2, sessionNumber);
            ps.setInt(3, materialId);
            return ps.executeUpdate() > 0;
        }
    }

    // ----------------------------------------------------------------
    //  Helpers
    // ----------------------------------------------------------------

    private MaterialDTO mapRow(ResultSet rs) throws SQLException {
        MaterialDTO dto = new MaterialDTO();
        dto.setMaterialId(rs.getInt("MaterialID"));
        dto.setSyllabusId(rs.getInt("SyllabusID"));
        dto.setUploadedBy(rs.getInt("UploadedBy"));
        dto.setMaterialName(rs.getString("MaterialName"));
        dto.setFilePath(rs.getString("FilePath"));
        dto.setMaterialType(rs.getString("MaterialType"));
        dto.setVisibility(rs.getString("Visibility"));
        dto.setStatus(rs.getString("Status"));
        dto.setUploadedAt(rs.getTimestamp("UploadedAt"));
        dto.setDownloadCount(rs.getInt("DownloadCount"));
        dto.setFileSizeBytes(rs.getLong("FileSize"));
        return dto;
    }

    private boolean hasColumn(Connection conn, String tableName, String columnName) throws SQLException {
        String sql = "SELECT COL_LENGTH(?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tableName);
            ps.setString(2, columnName);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getObject(1) != null;
            }
        }
    }
}
