package dao;

import dto.LearningPathDTO;
import dto.SubjectDTO;
import model.Subject;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class SubjectDAO extends DBContext {

    // =========================================================
    // SUBJECT MODEL METHODS
    // =========================================================
    public List<Subject> getSubjectsWaitingForSyllabus() {
        List<Subject> list = new ArrayList<>();

        String sql = """
                SELECT SubjectID, CreatedBy, SubjectCode, SubjectName, Credits, Description, Status
                FROM dbo.[Subject]
                WHERE Status = 'WaitingForSyllabus'
                ORDER BY SubjectCode
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapSubjectModel(rs));
            }

        } catch (Exception e) {
            System.out.println("getSubjectsWaitingForSyllabus error: " + e.getMessage());
        }

        return list;
    }

    public Subject getSubjectById(int subjectId) {
        String sql = """
                SELECT SubjectID, CreatedBy, SubjectCode, SubjectName, Credits, Description, Status
                FROM dbo.[Subject]
                WHERE SubjectID = ?
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, subjectId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapSubjectModel(rs);
                }
            }

        } catch (Exception e) {
            System.out.println("getSubjectById error: " + e.getMessage());
        }

        return null;
    }

    public List<Subject> getAllSubjects() {
        List<Subject> list = new ArrayList<>();

        String sql = """
                SELECT SubjectID, CreatedBy, SubjectCode, SubjectName, Credits, Description, Status
                FROM dbo.[Subject]
                ORDER BY SubjectCode
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapSubjectModel(rs));
            }

        } catch (Exception e) {
            System.out.println("getAllSubjects error: " + e.getMessage());
        }

        return list;
    }

    // =========================================================
    // SUBJECT DTO METHODS
    // =========================================================
    public List<SubjectDTO> searchSubjects(String keyword, int page, int pageSize) throws SQLException {
        List<SubjectDTO> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

        String whereClause = hasKeyword
                ? " WHERE LOWER(SubjectCode) LIKE LOWER(?) OR LOWER(SubjectName) LIKE LOWER(?) "
                : "";

        String sql = """
                SELECT SubjectID, SubjectCode, SubjectName, Credits, Status
                FROM dbo.[Subject]
                """ + whereClause + """
                ORDER BY SubjectCode
                OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int idx = 1;

            if (hasKeyword) {
                String like = "%" + keyword.trim() + "%";
                ps.setString(idx++, like);
                ps.setString(idx++, like);
            }

            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSubjectDTO(rs));
                }
            }
        }

        return list;
    }

    public int countSubjects(String keyword) throws SQLException {
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

        String whereClause = hasKeyword
                ? " WHERE LOWER(SubjectCode) LIKE LOWER(?) OR LOWER(SubjectName) LIKE LOWER(?) "
                : "";

        String sql = """
                SELECT COUNT(*)
                FROM dbo.[Subject]
                """ + whereClause;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (hasKeyword) {
                String like = "%" + keyword.trim() + "%";
                ps.setString(1, like);
                ps.setString(2, like);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }

    public SubjectDTO getSubjectByCode(String code) throws SQLException {
        String sql = """
                SELECT SubjectID, SubjectCode, SubjectName, Credits, Status
                FROM dbo.[Subject]
                WHERE LOWER(SubjectCode) = LOWER(?)
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, code.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapSubjectDTO(rs);
                }
            }
        }

        return null;
    }

    // =========================================================
    // LEARNING PATH
    // =========================================================
    public List<LearningPathDTO> getLearningPath(String subjectCode) throws SQLException {
        List<LearningPathDTO> result = new ArrayList<>();

        String sql = """
                SELECT sy.SyllabusID, sy.SyllabusTitle, sy.VersionNo, sy.Status,
                       s.SubjectCode, s.SubjectName
                FROM dbo.[Syllabus] sy
                JOIN dbo.[Subject] s ON sy.SubjectID = s.SubjectID
                WHERE LOWER(s.SubjectCode) LIKE LOWER(?)
                ORDER BY sy.SyllabusID
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + subjectCode.trim() + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LearningPathDTO dto = new LearningPathDTO();

                    dto.setSyllabusId(rs.getInt("SyllabusID"));
                    dto.setSyllabusName(rs.getString("SyllabusTitle"));
                    dto.setDecisionNo(rs.getString("VersionNo"));
                    dto.setSubjectCode(rs.getString("SubjectCode"));
                    dto.setSubjectName(rs.getString("SubjectName"));
                    dto.setPrerequisiteMap(buildPrerequisiteMap(rs.getString("SubjectCode")));

                    result.add(dto);
                }
            }
        }

        return result;
    }

    private Map<String, List<String>> buildPrerequisiteMap(String subjectCode) throws SQLException {
        Map<String, List<String>> map = new LinkedHashMap<>();
        buildPrerequisiteMapRecursive(subjectCode.toUpperCase(), map, new HashSet<>());
        return map;
    }

    private void buildPrerequisiteMapRecursive(String subjectCode,
                                               Map<String, List<String>> map,
                                               Set<String> visited) throws SQLException {
        if (visited.contains(subjectCode)) {
            return;
        }

        visited.add(subjectCode);

        String sql = """
                SELECT required.SubjectCode, sp.ConditionType
                FROM dbo.[Subject_Prerequisite] sp
                JOIN dbo.[Subject] required ON sp.RequiredSubjectID = required.SubjectID
                JOIN dbo.[Subject] currentSubject ON sp.SubjectID = currentSubject.SubjectID
                WHERE UPPER(currentSubject.SubjectCode) = ?
                """;

        List<String> prerequisites = new ArrayList<>();

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, subjectCode);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String prerequisiteCode = rs.getString("SubjectCode").toUpperCase();
                    String condition = rs.getString("ConditionType");

                    prerequisites.add(
                            (condition != null && !condition.isEmpty()
                                    ? condition + " "
                                    : "Pass ") + prerequisiteCode
                    );

                    buildPrerequisiteMapRecursive(prerequisiteCode, map, visited);
                }
            }
        }

        if (prerequisites.isEmpty()) {
            prerequisites.add("None");
        }

        map.put(subjectCode, prerequisites);
    }

    // =========================================================
    // HELPERS
    // =========================================================
    private Subject mapSubjectModel(ResultSet rs) throws SQLException {
        Subject subject = new Subject();

        subject.setSubjectId(rs.getInt("SubjectID"));
        subject.setCreatedBy(rs.getInt("CreatedBy"));
        subject.setSubjectCode(rs.getString("SubjectCode"));
        subject.setSubjectName(rs.getString("SubjectName"));
        subject.setCredits(rs.getInt("Credits"));
        subject.setDescription(rs.getString("Description"));
        subject.setStatus(rs.getString("Status"));

        return subject;
    }

    private SubjectDTO mapSubjectDTO(ResultSet rs) throws SQLException {
        SubjectDTO dto = new SubjectDTO();

        dto.setSubjectId(rs.getInt("SubjectID"));
        dto.setSubjectCode(rs.getString("SubjectCode"));
        dto.setSubjectName(rs.getString("SubjectName"));
        dto.setCredits(rs.getInt("Credits"));
        dto.setStatus(rs.getString("Status"));

        return dto;
    }

    /**
     * Get prerequisite text for a subject (e.g., "PRJ301, SWE201c")
     */
    public String getPreRequisiteText(int subjectId) {
        StringBuilder sb = new StringBuilder();
        String sql = """
                SELECT rs.SubjectCode
                FROM dbo.[Subject_Prerequisite] sp
                JOIN dbo.[Subject] rs ON sp.RequiredSubjectID = rs.SubjectID
                WHERE sp.SubjectID = ?
                ORDER BY rs.SubjectCode
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                boolean first = true;
                while (rs.next()) {
                    if (!first) {
                        sb.append(", ");
                    }
                    sb.append(rs.getString("SubjectCode"));
                    first = false;
                }
            }
        } catch (Exception e) {
            System.out.println("getPreRequisiteText error: " + e.getMessage());
        }
        return sb.toString();
    }
}
