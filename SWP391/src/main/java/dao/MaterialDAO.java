package dao;

import dto.MaterialDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for the Learning_Material table.
 * Handles read operations (already existing) plus INSERT for teacher uploads.
 */
public class MaterialDAO {

    private static final String[] MATERIAL_COLUMN_NAMES = {
            "MaterialID", "SyllabusID", "UploadedBy", "MaterialName", "FilePath",
            "MaterialType", "Visibility", "Status", "UploadedAt"
    };

    // ----------------------------------------------------------------
    //  Read
    // ----------------------------------------------------------------

    public List<MaterialDTO> getMaterialsBySyllabusId(int syllabusId) throws SQLException {
        List<MaterialDTO> list = new ArrayList<>();
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT " + materialColumns(conn) +
                    "FROM Learning_Material " +
                    "WHERE SyllabusID = ? AND Status = 'Active' " +
                    "ORDER BY UploadedAt DESC, MaterialID DESC";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setQueryTimeout(10);
            ps.setInt(1, syllabusId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
            }
        }
        return list;
    }

    public int countMaterialsBySyllabusId(int syllabusId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Learning_Material " +
                "WHERE SyllabusID = ? AND Status = 'Active'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, syllabusId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<MaterialDTO> getMaterialsBySyllabusId(int syllabusId, int page, int pageSize) throws SQLException {
        int offset = (page - 1) * pageSize;
        List<MaterialDTO> list = new ArrayList<>();
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT " + materialColumns(conn) +
                    "FROM Learning_Material " +
                    "WHERE SyllabusID = ? AND Status = 'Active' " +
                    "ORDER BY UploadedAt DESC, MaterialID DESC " +
                    "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, syllabusId);
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
            }
        }
        return list;
    }

    public MaterialDTO getMaterialById(int materialId) throws SQLException {
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT " + materialColumns(conn) +
                    "FROM Learning_Material " +
                    "WHERE MaterialID = ? AND Status = 'Active'";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, materialId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
            }
        }
        return null;
    }

    public List<MaterialDTO> getAllMaterialsBySyllabusId(int syllabusId) throws SQLException {
        List<MaterialDTO> list = new ArrayList<>();
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT " + materialColumns(conn) +
                    "FROM Learning_Material " +
                    "WHERE SyllabusID = ? " +
                    "ORDER BY UploadedAt";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, syllabusId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
            }
        }
        return list;
    }

    /** All materials uploaded by a specific user (teacher's uploads). */
    public List<MaterialDTO> getMaterialsByUploader(int userId) throws SQLException {
        return getMaterialsByUploader(userId, null, 1, Integer.MAX_VALUE);
    }

    public int countMaterialsByUploader(int userId, Integer syllabusId) throws SQLException {
        return countMaterialsByUploader(userId, syllabusId, null, null);
    }

    public int countMaterialsByUploader(int userId, Integer syllabusId,
                                        String keyword, String searchType) throws SQLException {
        String searchClause = buildSearchClause(keyword);
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Learning_Material m ")
                .append("WHERE m.UploadedBy = ? AND m.Status = 'Active'");
        if (syllabusId != null) {
            sql.append(" AND m.SyllabusID = ?");
        }
        sql.append(searchClause);

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, userId);
            if (syllabusId != null) {
                ps.setInt(paramIndex++, syllabusId);
            }
            bindSearchParams(ps, paramIndex, keyword, searchType);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<MaterialDTO> getMaterialsByUploader(
            int userId, Integer syllabusId, int page, int pageSize) throws SQLException {
        return getMaterialsByUploader(userId, syllabusId, page, pageSize, null, null);
    }

    public List<MaterialDTO> getMaterialsByUploader(
            int userId, Integer syllabusId, int page, int pageSize,
            String keyword, String searchType) throws SQLException {
        List<MaterialDTO> list = new ArrayList<>();
        int offset = Math.max(0, page - 1) * pageSize;
        String searchClause = buildSearchClause(keyword);
        try (Connection conn = DBContext.getConnection()) {
            StringBuilder sql = new StringBuilder("SELECT ")
                    .append(materialColumns(conn, "m"))
                    .append("FROM Learning_Material m ")
                    .append("WHERE m.UploadedBy = ? AND m.Status = 'Active' ");
            if (syllabusId != null) {
                sql.append("AND m.SyllabusID = ? ");
            }
            sql.append(searchClause).append(' ');
            sql.append("ORDER BY m.UploadedAt DESC, m.MaterialID DESC ")
                    .append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

            try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                int paramIndex = 1;
                ps.setInt(paramIndex++, userId);
                if (syllabusId != null) {
                    ps.setInt(paramIndex++, syllabusId);
                }
                paramIndex = bindSearchParams(ps, paramIndex, keyword, searchType);
                ps.setInt(paramIndex++, offset);
                ps.setInt(paramIndex, pageSize);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    /**
     * Builds an optional search clause on MaterialName / MaterialType.
     * Returns "" when keyword is blank so callers append nothing.
     */
    private String buildSearchClause(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return "";
        }
        return " AND (LOWER(m.MaterialName) LIKE LOWER(?) OR LOWER(m.MaterialType) LIKE LOWER(?))";
    }

    /**
     * Binds the two LIKE params for the search clause when keyword is present.
     * @param searchType name | type | all (default all → match both columns)
     * @return next free parameter index
     */
    private int bindSearchParams(PreparedStatement ps, int startIdx,
                                 String keyword, String searchType) throws SQLException {
        if (keyword == null || keyword.trim().isEmpty()) {
            return startIdx;
        }
        String like = "%" + keyword.trim() + "%";
        String type = (searchType == null) ? "all" : searchType.trim().toLowerCase();
        // For a name-only or type-only search, neutralize the other LIKE with a no-match token.
        String noMatch = " _no_match_ ";
        String nameParam = type.equals("type") ? noMatch : like;
        String typeParam = type.equals("name") ? noMatch : like;
        ps.setString(startIdx++, nameParam);
        ps.setString(startIdx++, typeParam);
        return startIdx;
    }

    public List<MaterialDTO> getPrivateMaterialsByUploader(int userId) throws SQLException {
        List<MaterialDTO> list = new ArrayList<>();
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT " + materialColumns(conn, "m") +
                    "FROM Learning_Material m " +
                    "WHERE m.UploadedBy = ? AND m.Status = 'Active' AND m.Visibility = 'Private' " +
                    "ORDER BY m.UploadedAt DESC, m.MaterialID DESC";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
            }
        }
        return list;
    }

    // ----------------------------------------------------------------
    //  Write: INSERT
    // ----------------------------------------------------------------

    /**
     * Inserts a new material record. Returns generated MaterialID or -1.
     *
     * @param syllabusId  ID of the associated syllabus
     * @param uploadedBy  UserID of the teacher uploading
     * @param materialName  Display name
     * @param filePath    Relative path on disk (e.g. /materials/3/lab01.zip)
     * @param materialType  ZIP | PDF | PPTX | etc.
     * @param visibility  Public | Private
     */
    public int insertMaterial(int syllabusId, int uploadedBy,
                              String materialName, String filePath,
                              String materialType, String visibility) throws SQLException {
        return insertMaterial(syllabusId, uploadedBy, materialName, filePath,
                materialType, visibility, 0L);
    }

    public int insertMaterial(int syllabusId, int uploadedBy,
                              String materialName, String filePath,
                              String materialType, String visibility,
                              long fileSize) throws SQLException {
        try (Connection conn = DBContext.getConnection()) {
            boolean hasFileSize = hasColumn(conn, "dbo.Learning_Material", "FileSize");

            StringBuilder columns = new StringBuilder(
                    "SyllabusID, UploadedBy, MaterialName, FilePath, MaterialType, Visibility, Status, UploadedAt");
            StringBuilder values = new StringBuilder("?, ?, ?, ?, ?, ?, 'Active', GETDATE()");
            if (hasFileSize) {
                columns.append(", FileSize");
                values.append(", ?");
            }

            String sql = "INSERT INTO Learning_Material (" + columns + ") VALUES (" + values + ")";
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                int idx = 1;
                ps.setInt(idx++, syllabusId);
                ps.setInt(idx++, uploadedBy);
                ps.setString(idx++, materialName.trim());
                ps.setString(idx++, filePath);
                ps.setString(idx++, materialType);
                ps.setString(idx++, visibility != null ? visibility : "Public");
                if (hasFileSize) {
                    ps.setLong(idx++, Math.max(0L, fileSize));
                }
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    /** Soft-delete: set Status = 'Inactive' for a material. */
    public boolean deleteMaterial(int materialId, int uploadedBy) throws SQLException {
        String sql = "UPDATE Learning_Material SET Status = 'Inactive' " +
                "WHERE MaterialID = ? AND UploadedBy = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, materialId);
            ps.setInt(2, uploadedBy);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean incrementDownloadCount(int materialId) throws SQLException {
        try (Connection conn = DBContext.getConnection()) {
            if (!hasColumn(conn, "dbo.Learning_Material", "DownloadCount")) {
                return false;
            }
        String sql = "UPDATE Learning_Material " +
                "SET DownloadCount = ISNULL(DownloadCount, 0) + 1 " +
                "WHERE MaterialID = ? AND Status = 'Active'";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, materialId);
            return ps.executeUpdate() > 0;
            }
        }
    }

    public boolean updateMaterialName(int materialId, int uploadedBy, String materialName) throws SQLException {
        String sql = "UPDATE Learning_Material " +
                "SET MaterialName = ? " +
                "WHERE MaterialID = ? AND UploadedBy = ? AND Status = 'Active'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, materialName.trim());
            ps.setInt(2, materialId);
            ps.setInt(3, uploadedBy);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Replaces the stored file for a material: updates FilePath, MaterialType,
     * and FileSize (when the column exists). The material name is kept unchanged.
     * Only the owner can replace, and only Active records.
     */
    public boolean updateMaterialFile(int materialId, int uploadedBy,
                                      String filePath, String materialType,
                                      long fileSize) throws SQLException {
        try (Connection conn = DBContext.getConnection()) {
            boolean hasFileSize = hasColumn(conn, "dbo.Learning_Material", "FileSize");

            StringBuilder sql = new StringBuilder("UPDATE Learning_Material ")
                    .append("SET FilePath = ?, MaterialType = ?");
            if (hasFileSize) {
                sql.append(", FileSize = ?");
            }
            sql.append(" WHERE MaterialID = ? AND UploadedBy = ? AND Status = 'Active'");

            try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                int idx = 1;
                ps.setString(idx++, filePath);
                ps.setString(idx++, materialType);
                if (hasFileSize) {
                    ps.setLong(idx++, Math.max(0L, fileSize));
                }
                ps.setInt(idx++, materialId);
                ps.setInt(idx, uploadedBy);
                return ps.executeUpdate() > 0;
            }
        }
    }

    // ----------------------------------------------------------------
    //  Helper
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

    private String materialColumns(Connection conn) throws SQLException {
        return materialColumns(conn, null);
    }

    private String materialColumns(Connection conn, String alias) throws SQLException {
        String prefix = alias == null || alias.trim().isEmpty() ? "" : alias.trim() + ".";
        StringBuilder columns = new StringBuilder();
        for (String columnName : MATERIAL_COLUMN_NAMES) {
            if (columns.length() > 0) {
                columns.append(", ");
            }
            columns.append(prefix).append(columnName);
        }
        String downloadCountExpression = hasColumn(conn, "dbo.Learning_Material", "DownloadCount")
                ? "ISNULL(" + prefix + "DownloadCount, 0) AS DownloadCount "
                : "0 AS DownloadCount ";
        columns.append(", ").append(downloadCountExpression);
        String fileSizeExpression = hasColumn(conn, "dbo.Learning_Material", "FileSize")
                ? "ISNULL(" + prefix + "FileSize, 0) AS FileSize "
                : "0 AS FileSize ";
        return columns.append(", ").append(fileSizeExpression).toString();
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
