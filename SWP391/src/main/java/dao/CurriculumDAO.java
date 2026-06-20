package dao;

import dto.CurriculumDTO;
import dto.SubjectDTO;

import java.sql.*;
import java.util.*;

/**
 * CurriculumDAO — queries against actual TPMS_DB schema.
 *
 * Table mapping:
 *   Curriculum        : CurriculumID, ProgramID, CreatedBy, CurriculumName, Description, Status
 *   Training_Program  : ProgramID, ProgramCode, ProgramName, MajorName, AcademicYear, Status
 *   Curriculum_Subject: CurriculumSubjectID, CurriculumID, SubjectID, SemesterNo, IsRequired
 *   Subject           : SubjectID, SubjectCode, SubjectName, Credits, Status
 *
 * Note: Curriculum has no CurriculumCode or TotalCredits.
 *       We join Training_Program to get ProgramCode for display.
 *       TotalCredits is computed from Subject.Credits sum in Curriculum_Subject.
 */
public class CurriculumDAO {

    // ----------------------------------------------------------------
    //  Search
    // ----------------------------------------------------------------

    public List<CurriculumDTO> searchCurricula(String searchType, String keyword,
                                                int page, int pageSize) throws SQLException {
        List<CurriculumDTO> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        String whereClause = buildWhereClause(searchType, keyword);
        String sql = "SELECT c.CurriculumID, c.CurriculumName, c.Description, c.Status, " +
                "tp.ProgramCode, tp.ProgramName, tp.MajorName, tp.AcademicYear " +
                "FROM Curriculum c " +
                "JOIN Training_Program tp ON c.ProgramID = tp.ProgramID " +
                whereClause +
                " ORDER BY c.CurriculumID " +
                " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = setSearchParams(ps, searchType, keyword, 1);
            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRowBasic(rs));
            }
        }
        return list;
    }

    public int countCurricula(String searchType, String keyword) throws SQLException {
        String whereClause = buildWhereClause(searchType, keyword);
        String sql = "SELECT COUNT(*) FROM Curriculum c " +
                "JOIN Training_Program tp ON c.ProgramID = tp.ProgramID " +
                whereClause;
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

    public CurriculumDTO getCurriculumById(int curriculumId) throws SQLException {
        String sql = "SELECT c.CurriculumID, c.CurriculumName, c.Description, c.Status, " +
                "tp.ProgramCode, tp.ProgramName, tp.MajorName, tp.AcademicYear " +
                "FROM Curriculum c " +
                "JOIN Training_Program tp ON c.ProgramID = tp.ProgramID " +
                "WHERE c.CurriculumID = ?";

        CurriculumDTO dto = null;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) dto = mapRowBasic(rs);
            }
        }
        if (dto != null) {
            Map<Integer, List<SubjectDTO>> semMap = loadSemesterSubjects(curriculumId);
            dto.setSemesterSubjects(semMap);
            // Compute total credits
            int total = semMap.values().stream()
                    .flatMap(List::stream)
                    .mapToInt(SubjectDTO::getCredits)
                    .sum();
            dto.setTotalCredits(total);
        }
        return dto;
    }

    // ----------------------------------------------------------------
    //  Semester breakdown
    // ----------------------------------------------------------------

    private Map<Integer, List<SubjectDTO>> loadSemesterSubjects(int curriculumId) throws SQLException {
        Map<Integer, List<SubjectDTO>> map = new TreeMap<>();
        String sql = "SELECT cs.SemesterNo, su.SubjectID, su.SubjectCode, su.SubjectName, " +
                "su.Credits, su.Status, cs.IsRequired, cs.SubjectGroup " +
                "FROM Curriculum_Subject cs " +
                "JOIN Subject su ON cs.SubjectID = su.SubjectID " +
                "WHERE cs.CurriculumID = ? " +
                "ORDER BY cs.SemesterNo, cs.DisplayOrder, su.SubjectCode";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int semester = rs.getInt("SemesterNo");
                    SubjectDTO sub = new SubjectDTO();
                    sub.setSubjectId(rs.getInt("SubjectID"));
                    sub.setSubjectCode(rs.getString("SubjectCode"));
                    sub.setSubjectName(rs.getString("SubjectName"));
                    sub.setCredits(rs.getInt("Credits"));
                    sub.setSemester(semester);
                    sub.setStatus(rs.getString("Status"));
                    sub.setRequired(rs.getBoolean("IsRequired"));
                    map.computeIfAbsent(semester, k -> new ArrayList<>()).add(sub);
                }
            }
        }
        return map;
    }

    // ----------------------------------------------------------------
    //  Helpers
    // ----------------------------------------------------------------

    private String buildWhereClause(String searchType, String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) return "";
        if ("name".equalsIgnoreCase(searchType)) {
            return "WHERE LOWER(c.CurriculumName) LIKE LOWER(?) ";
        }
        // default: code → search on Training_Program.ProgramCode
        return "WHERE LOWER(tp.ProgramCode) LIKE LOWER(?) ";
    }

    private int setSearchParams(PreparedStatement ps, String searchType,
                                String keyword, int startIdx) throws SQLException {
        if (keyword == null || keyword.trim().isEmpty()) return startIdx;
        ps.setString(startIdx++, "%" + keyword.trim() + "%");
        return startIdx;
    }

    private CurriculumDTO mapRowBasic(ResultSet rs) throws SQLException {
        CurriculumDTO dto = new CurriculumDTO();
        dto.setCurriculumId(rs.getInt("CurriculumID"));
        dto.setCurriculumName(rs.getString("CurriculumName"));
        dto.setDescription(rs.getString("Description"));
        dto.setStatus(rs.getString("Status"));
        dto.setProgramCode(rs.getString("ProgramCode"));
        dto.setProgramName(rs.getString("ProgramName"));
        dto.setMajorName(rs.getString("MajorName"));
        dto.setAcademicYear(rs.getString("AcademicYear"));
        return dto;
    }
}
