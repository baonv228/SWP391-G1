package dao;

import dto.PrerequisiteDetailDTO;
import dto.SubjectDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * PrerequisiteDAO — queries against actual TPMS_DB schema.
 *
 * Table: Subject_Prerequisite (with underscore)
 *   Columns: PrerequisiteID, SubjectID, RequiredSubjectID, ConditionType, Description
 *
 * SubjectID         → subject that REQUIRES the prerequisite
 * RequiredSubjectID → subject that must be PASSED first
 */
public class PrerequisiteDAO {

    public PrerequisiteDetailDTO getPrerequisiteDetail(String subjectCode) throws SQLException {
        SubjectDTO current = getSubjectByCode(subjectCode);
        if (current == null) return null;

        PrerequisiteDetailDTO dto = new PrerequisiteDetailDTO();
        dto.setCurrentSubject(current);
        dto.setPrerequisites(getPrerequisitesBySubjectId(current.getSubjectId()));
        dto.setSubsequents(getSubsequentsBySubjectId(current.getSubjectId()));
        return dto;
    }

    public List<SubjectDTO> getPrerequisitesBySubjectCode(String subjectCode) throws SQLException {
        SubjectDTO current = getSubjectByCode(subjectCode);
        if (current == null) return new ArrayList<>();
        return getPrerequisitesBySubjectId(current.getSubjectId());
    }

    public List<SubjectDTO> getSubsequentsBySubjectCode(String subjectCode) throws SQLException {
        SubjectDTO current = getSubjectByCode(subjectCode);
        if (current == null) return new ArrayList<>();
        return getSubsequentsBySubjectId(current.getSubjectId());
    }

    // ----------------------------------------------------------------
    //  Private helpers
    // ----------------------------------------------------------------

    private SubjectDTO getSubjectByCode(String code) throws SQLException {
        String sql = "SELECT SubjectID, SubjectCode, SubjectName, Credits, Status " +
                "FROM Subject WHERE LOWER(SubjectCode) = LOWER(?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapSubject(rs);
            }
        }
        return null;
    }

    /**
     * Get subjects that must be passed before the given subject.
     * SubjectID = given subject → RequiredSubjectID = what it needs.
     */
    private List<SubjectDTO> getPrerequisitesBySubjectId(int subjectId) throws SQLException {
        List<SubjectDTO> list = new ArrayList<>();
        String sql = "SELECT su.SubjectID, su.SubjectCode, su.SubjectName, su.Credits, su.Status " +
                "FROM Subject_Prerequisite sp " +
                "JOIN Subject su ON sp.RequiredSubjectID = su.SubjectID " +
                "WHERE sp.SubjectID = ? " +
                "ORDER BY su.SubjectCode";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapSubject(rs));
            }
        }
        return list;
    }

    /**
     * Get subjects that list the given subject as a prerequisite.
     * RequiredSubjectID = given subject → SubjectID = subsequent subjects.
     */
    private List<SubjectDTO> getSubsequentsBySubjectId(int subjectId) throws SQLException {
        List<SubjectDTO> list = new ArrayList<>();
        String sql = "SELECT su.SubjectID, su.SubjectCode, su.SubjectName, su.Credits, su.Status " +
                "FROM Subject_Prerequisite sp " +
                "JOIN Subject su ON sp.SubjectID = su.SubjectID " +
                "WHERE sp.RequiredSubjectID = ? " +
                "ORDER BY su.SubjectCode";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapSubject(rs));
            }
        }
        return list;
    }

    private SubjectDTO mapSubject(ResultSet rs) throws SQLException {
        SubjectDTO dto = new SubjectDTO();
        dto.setSubjectId(rs.getInt("SubjectID"));
        dto.setSubjectCode(rs.getString("SubjectCode"));
        dto.setSubjectName(rs.getString("SubjectName"));
        dto.setCredits(rs.getInt("Credits"));
        dto.setStatus(rs.getString("Status"));
        return dto;
    }
}
