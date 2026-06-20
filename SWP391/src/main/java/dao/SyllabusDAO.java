package dao;

import dto.SyllabusDTO;
import dto.SyllabusDTO.SessionDTO;
import dto.MaterialDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * SyllabusDAO — queries against actual TPMS_DB schema.
 *
 * Key table/column mapping:
 *   Syllabus  : SyllabusID, SubjectID, VersionNo, SyllabusTitle, Description,
 *               LearningOutcome, AssessmentMethod, Status, IsCurrentVersion,
 *               CreatedAt, ApprovedAt, ApprovedBy
 *   Subject   : SubjectID, SubjectCode, SubjectName, Credits, Status
 *
 * IsActive  → Syllabus.IsCurrentVersion
 * IsApproved → Syllabus.ApprovedBy IS NOT NULL
 * DecisionNo → not in DB; show VersionNo instead
 */
public class SyllabusDAO {

    // ----------------------------------------------------------------
    //  Search
    // ----------------------------------------------------------------

    public List<SyllabusDTO> searchSyllabi(String searchType, String keyword,
                                            int page, int pageSize) throws SQLException {
        List<SyllabusDTO> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        String whereClause = buildWhereClause(searchType, keyword);
        String sql = "SELECT sy.SyllabusID, sy.SyllabusTitle, sy.VersionNo, sy.Status, " +
                "sy.IsCurrentVersion, sy.ApprovedBy, sy.Description, " +
                "sy.LearningOutcome, sy.AssessmentMethod, " +
                "sy.CreatedAt, sy.ApprovedAt, " +
                "su.SubjectCode, su.SubjectName, su.Credits " +
                "FROM Syllabus sy " +
                "JOIN Subject su ON sy.SubjectID = su.SubjectID " +
                whereClause +
                " ORDER BY sy.SyllabusID " +
                " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = setSearchParams(ps, searchType, keyword, 1);
            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    public int countSyllabi(String searchType, String keyword) throws SQLException {
        String whereClause = buildWhereClause(searchType, keyword);
        String sql = "SELECT COUNT(*) FROM Syllabus sy " +
                "JOIN Subject su ON sy.SubjectID = su.SubjectID " + whereClause;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setSearchParams(ps, searchType, keyword, 1);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    // ----------------------------------------------------------------
    //  Detail
    // ----------------------------------------------------------------

    public SyllabusDTO getSyllabusById(int syllabusId) throws SQLException {
        String sql = "SELECT sy.SyllabusID, sy.SyllabusTitle, sy.VersionNo, sy.Status, " +
                "sy.IsCurrentVersion, sy.ApprovedBy, sy.Description, " +
                "sy.LearningOutcome, sy.AssessmentMethod, " +
                "sy.CreatedAt, sy.ApprovedAt, " +
                "su.SubjectCode, su.SubjectName, su.Credits " +
                "FROM Syllabus sy " +
                "JOIN Subject su ON sy.SubjectID = su.SubjectID " +
                "WHERE sy.SyllabusID = ?";

        SyllabusDTO dto = null;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, syllabusId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) dto = mapRow(rs);
            }
        }
        if (dto != null) {
            dto.setLearningOutcomes(parseLearningOutcomes(dto.getLearningOutcome()));
            // Load materials from Learning_Material via MaterialDAO
            MaterialDAO materialDAO = new MaterialDAO();
            dto.setMaterials(materialDAO.getMaterialsBySyllabusId(syllabusId));
        }
        return dto;
    }

    // ----------------------------------------------------------------
    //  Helpers
    // ----------------------------------------------------------------

    private List<String> parseLearningOutcomes(String rawText) {
        List<String> outcomes = new ArrayList<>();
        if (rawText == null || rawText.trim().isEmpty()) return outcomes;
        String[] lines = rawText.split("\\r?\\n");
        for (String line : lines) {
            String trimmed = line.trim().replaceAll("^[-•*]\\s*", "");
            if (!trimmed.isEmpty()) outcomes.add(trimmed);
        }
        if (outcomes.isEmpty()) outcomes.add(rawText.trim());
        return outcomes;
    }

    private String buildWhereClause(String searchType, String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) return "";
        switch (searchType == null ? "" : searchType.toLowerCase()) {
            case "name":    return "WHERE LOWER(sy.SyllabusTitle) LIKE LOWER(?) ";
            case "subject": return "WHERE LOWER(su.SubjectCode) LIKE LOWER(?) OR LOWER(su.SubjectName) LIKE LOWER(?) ";
            case "code":
            default:        return "WHERE LOWER(su.SubjectCode) LIKE LOWER(?) ";
        }
    }

    private int setSearchParams(PreparedStatement ps, String searchType,
                                String keyword, int startIdx) throws SQLException {
        if (keyword == null || keyword.trim().isEmpty()) return startIdx;
        String like = "%" + keyword.trim() + "%";
        if ("subject".equalsIgnoreCase(searchType)) {
            ps.setString(startIdx++, like);
            ps.setString(startIdx++, like);
        } else {
            ps.setString(startIdx++, like);
        }
        return startIdx;
    }

    private SyllabusDTO mapRow(ResultSet rs) throws SQLException {
        SyllabusDTO dto = new SyllabusDTO();
        dto.setSyllabusId(rs.getInt("SyllabusID"));
        dto.setSyllabusTitle(rs.getString("SyllabusTitle"));
        dto.setSyllabusEnglishName(rs.getString("SyllabusTitle")); // same field
        dto.setVersionNo(rs.getString("VersionNo"));
        dto.setStatus(rs.getString("Status"));
        dto.setCurrentVersion(rs.getBoolean("IsCurrentVersion"));
        // ApprovedBy IS NOT NULL → isApproved
        int approvedBy = rs.getInt("ApprovedBy");
        dto.setApproved(!rs.wasNull() && approvedBy > 0);
        dto.setDescription(rs.getString("Description"));
        dto.setLearningOutcome(rs.getString("LearningOutcome"));
        dto.setAssessmentMethod(rs.getString("AssessmentMethod"));
        dto.setCreatedAt(rs.getTimestamp("CreatedAt"));
        dto.setApprovedAt(rs.getTimestamp("ApprovedAt"));
        dto.setSubjectCode(rs.getString("SubjectCode"));
        dto.setSubjectName(rs.getString("SubjectName"));
        dto.setCredits(rs.getInt("Credits"));
        return dto;
    }
}
