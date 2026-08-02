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

    // ----------------------------------------------------------------
    //  Read
    // ----------------------------------------------------------------

    public List<MaterialDTO> getMaterialsBySyllabusId(int syllabusId) throws SQLException {
        List<MaterialDTO> list = new ArrayList<>();
        String sql = "SELECT MaterialID, SyllabusID, MaterialName, FilePath, " +
                "MaterialType, Visibility, Status, UploadedAt " +
                "FROM Learning_Material " +
                "WHERE SyllabusID = ? AND Status = 'Active' " +
                "ORDER BY UploadedAt DESC, MaterialID DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setQueryTimeout(10);
            ps.setInt(1, syllabusId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
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
        String sql = "SELECT MaterialID, SyllabusID, MaterialName, FilePath, " +
                "MaterialType, Visibility, Status, UploadedAt " +
                "FROM Learning_Material " +
                "WHERE SyllabusID = ? AND Status = 'Active' " +
                "ORDER BY UploadedAt DESC, MaterialID DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, syllabusId);
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    public MaterialDTO getMaterialById(int materialId) throws SQLException {
        String sql = "SELECT MaterialID, SyllabusID, MaterialName, FilePath, " +
                "MaterialType, Visibility, Status, UploadedAt " +
                "FROM Learning_Material " +
                "WHERE MaterialID = ? AND Status = 'Active'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, materialId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public List<MaterialDTO> getAllMaterialsBySyllabusId(int syllabusId) throws SQLException {
        List<MaterialDTO> list = new ArrayList<>();
        String sql = "SELECT MaterialID, SyllabusID, MaterialName, FilePath, " +
                "MaterialType, Visibility, Status, UploadedAt " +
                "FROM Learning_Material " +
                "WHERE SyllabusID = ? " +
                "ORDER BY UploadedAt";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, syllabusId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    /** All materials uploaded by a specific user (teacher's uploads). */
    public List<MaterialDTO> getMaterialsByUploader(int userId) throws SQLException {
        List<MaterialDTO> list = new ArrayList<>();
        String sql = "SELECT m.MaterialID, m.SyllabusID, m.MaterialName, m.FilePath, " +
                "m.MaterialType, m.Visibility, m.Status, m.UploadedAt " +
                "FROM Learning_Material m " +
                "WHERE m.UploadedBy = ? AND m.Status = 'Active' " +
                "ORDER BY m.UploadedAt DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    /**
     * NEW — Teacher "My Uploaded Materials" detail list.
     * Same filter as getMaterialsByUploader, plus SubjectCode / SyllabusTitle for display.
     */
    public List<MaterialDTO> getMaterialsByUploaderDetailed(int userId) throws SQLException {
        List<MaterialDTO> list = new ArrayList<>();
        String sql = """
                SELECT m.MaterialID, m.SyllabusID, m.MaterialName, m.FilePath,
                       m.MaterialType, m.Visibility, m.Status, m.UploadedAt,
                       su.SubjectCode, sy.SyllabusTitle
                FROM dbo.Learning_Material m
                JOIN dbo.Syllabus sy ON m.SyllabusID = sy.SyllabusID
                JOIN dbo.Subject su ON sy.SubjectID = su.SubjectID
                WHERE m.UploadedBy = ? AND m.Status = 'Active'
                ORDER BY m.UploadedAt DESC
                """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MaterialDTO dto = mapRow(rs);
                    dto.setSubjectCode(rs.getString("SubjectCode"));
                    dto.setSyllabusTitle(rs.getString("SyllabusTitle"));
                    list.add(dto);
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
        String sql = "INSERT INTO Learning_Material " +
                "(SyllabusID, UploadedBy, MaterialName, FilePath, MaterialType, " +
                "Visibility, Status, UploadedAt) " +
                "VALUES (?, ?, ?, ?, ?, ?, 'Active', GETDATE())";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, syllabusId);
            ps.setInt(2, uploadedBy);
            ps.setString(3, materialName.trim());
            ps.setString(4, filePath);
            ps.setString(5, materialType);
            ps.setString(6, visibility != null ? visibility : "Public");
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
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

    // ----------------------------------------------------------------
    //  Helper
    // ----------------------------------------------------------------

    private MaterialDTO mapRow(ResultSet rs) throws SQLException {
        MaterialDTO dto = new MaterialDTO();
        dto.setMaterialId(rs.getInt("MaterialID"));
        dto.setSyllabusId(rs.getInt("SyllabusID"));
        dto.setMaterialName(rs.getString("MaterialName"));
        dto.setFilePath(rs.getString("FilePath"));
        dto.setMaterialType(rs.getString("MaterialType"));
        dto.setVisibility(rs.getString("Visibility"));
        dto.setStatus(rs.getString("Status"));
        dto.setUploadedAt(rs.getTimestamp("UploadedAt"));
        return dto;
    }
}
