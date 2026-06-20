package dao;

import dto.LearningPathDTO;
import dto.SubjectDTO;

import java.sql.*;
import java.util.*;

/**
 * SubjectDAO — queries against actual TPMS_DB schema.
 *
 * Table mapping:
 *   Subject             : SubjectID, SubjectCode, SubjectName, Credits, Description, Status
 *   Subject_Prerequisite: PrerequisiteID, SubjectID, RequiredSubjectID, ConditionType, Description
 *   Syllabus            : SyllabusID, SubjectID, SyllabusTitle, VersionNo, Status, IsCurrentVersion
 *
 * Note: Subject has no Semester column; semester comes from Curriculum_Subject.SemesterNo.
 *       For search/list we use Credits from Subject directly.
 */
public class SubjectDAO {

    // ----------------------------------------------------------------
    //  Search subjects
    // ----------------------------------------------------------------

    public List<SubjectDTO> searchSubjects(String keyword, int page, int pageSize) throws SQLException {
        List<SubjectDTO> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        String whereClause = hasKeyword
                ? "WHERE LOWER(SubjectCode) LIKE LOWER(?) OR LOWER(SubjectName) LIKE LOWER(?) "
                : "";

        String sql = "SELECT SubjectID, SubjectCode, SubjectName, Credits, Status " +
                "FROM Subject " + whereClause +
                "ORDER BY SubjectCode " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            if (hasKeyword) {
                String like = "%" + keyword.trim() + "%";
                ps.setString(idx++, like);
                ps.setString(idx++, like);
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapSubjectRow(rs));
            }
        }
        return list;
    }

    public int countSubjects(String keyword) throws SQLException {
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        String whereClause = hasKeyword
                ? "WHERE LOWER(SubjectCode) LIKE LOWER(?) OR LOWER(SubjectName) LIKE LOWER(?) "
                : "";
        String sql = "SELECT COUNT(*) FROM Subject " + whereClause;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (hasKeyword) {
                String like = "%" + keyword.trim() + "%";
                ps.setString(1, like);
                ps.setString(2, like);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public SubjectDTO getSubjectByCode(String code) throws SQLException {
        String sql = "SELECT SubjectID, SubjectCode, SubjectName, Credits, Status " +
                "FROM Subject WHERE LOWER(SubjectCode) = LOWER(?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapSubjectRow(rs);
            }
        }
        return null;
    }

    // ----------------------------------------------------------------
    //  Learning Path: find all syllabi matching subjectCode pattern,
    //  with full recursive prerequisite chain for each.
    // ----------------------------------------------------------------

    public List<LearningPathDTO> getLearningPath(String subjectCode) throws SQLException {
        List<LearningPathDTO> result = new ArrayList<>();

        // Find all syllabi whose subject matches the given code
        String sql = "SELECT sy.SyllabusID, sy.SyllabusTitle, sy.VersionNo, sy.Status, " +
                "su.SubjectCode, su.SubjectName " +
                "FROM Syllabus sy " +
                "JOIN Subject su ON sy.SubjectID = su.SubjectID " +
                "WHERE LOWER(su.SubjectCode) LIKE LOWER(?) " +
                "ORDER BY sy.SyllabusID";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + subjectCode.trim() + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LearningPathDTO dto = new LearningPathDTO();
                    dto.setSyllabusId(rs.getInt("SyllabusID"));
                    dto.setSyllabusName(rs.getString("SyllabusTitle"));
                    dto.setDecisionNo(rs.getString("VersionNo")); // VersionNo shown in DecisionNo column
                    dto.setSubjectCode(rs.getString("SubjectCode"));
                    dto.setSubjectName(rs.getString("SubjectName"));
                    dto.setPrerequisiteMap(buildPrerequisiteMap(rs.getString("SubjectCode")));
                    result.add(dto);
                }
            }
        }
        return result;
    }

    /**
     * Builds a recursive prerequisite map:
     *   subjectCode → list of prerequisite descriptions
     *   e.g. { "LAB211" → ["Pass PRO192", "Pass PRF192"],
     *           "PRO192" → ["Pass PRF192"],
     *           "PRF192" → ["None"] }
     */
    private Map<String, List<String>> buildPrerequisiteMap(String subjectCode) throws SQLException {
        Map<String, List<String>> map = new LinkedHashMap<>();
        buildPrerequisiteMapRecursive(subjectCode.toUpperCase(), map, new HashSet<>());
        return map;
    }

    private void buildPrerequisiteMapRecursive(String subjectCode,
                                               Map<String, List<String>> map,
                                               Set<String> visited) throws SQLException {
        if (visited.contains(subjectCode)) return;
        visited.add(subjectCode);

        // Subject_Prerequisite table: SubjectID → subject that NEEDS, RequiredSubjectID → subject to PASS first
        String sql = "SELECT su.SubjectCode, sp.ConditionType " +
                "FROM Subject_Prerequisite sp " +
                "JOIN Subject su  ON sp.RequiredSubjectID = su.SubjectID " +
                "JOIN Subject s2  ON sp.SubjectID = s2.SubjectID " +
                "WHERE UPPER(s2.SubjectCode) = ?";

        List<String> prereqs = new ArrayList<>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, subjectCode);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String prereqCode = rs.getString("SubjectCode").toUpperCase();
                    String condition  = rs.getString("ConditionType");
                    prereqs.add((condition != null && !condition.isEmpty() ? condition + " " : "Pass ") + prereqCode);
                    buildPrerequisiteMapRecursive(prereqCode, map, visited);
                }
            }
        }

        if (prereqs.isEmpty()) prereqs.add("None");
        map.put(subjectCode, prereqs);
    }

    // ----------------------------------------------------------------
    //  Helpers
    // ----------------------------------------------------------------

    private SubjectDTO mapSubjectRow(ResultSet rs) throws SQLException {
        SubjectDTO dto = new SubjectDTO();
        dto.setSubjectId(rs.getInt("SubjectID"));
        dto.setSubjectCode(rs.getString("SubjectCode"));
        dto.setSubjectName(rs.getString("SubjectName"));
        dto.setCredits(rs.getInt("Credits"));
        dto.setStatus(rs.getString("Status"));
        return dto;
    }
}
