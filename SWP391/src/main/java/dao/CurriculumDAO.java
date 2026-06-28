package dao;

import dto.CurriculumDTO;
import dto.SubjectDTO;
import model.Curriculum;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class CurriculumDAO extends DBContext {

    // =========================================================
    // GET ALL CURRICULUMS
    // =========================================================
    public List<Curriculum> getCurriculums() {
        List<Curriculum> list = new ArrayList<>();

        String sql = """
                SELECT c.CurriculumID, c.ProgramID, c.CreatedBy, c.CurriculumName,
                       c.Description, c.Status,
                       tp.ProgramCode, tp.ProgramName,
                       u.FullName AS CreatedByName,
                       COUNT(cs.CurriculumSubjectID) AS SubjectCount
                FROM dbo.[Curriculum] c
                LEFT JOIN dbo.[Training_Program] tp ON c.ProgramID = tp.ProgramID
                LEFT JOIN dbo.[User] u ON c.CreatedBy = u.UserID
                LEFT JOIN dbo.[Curriculum_Subject] cs ON c.CurriculumID = cs.CurriculumID
                GROUP BY c.CurriculumID, c.ProgramID, c.CreatedBy, c.CurriculumName,
                         c.Description, c.Status, tp.ProgramCode, tp.ProgramName, u.FullName
                ORDER BY c.CurriculumID DESC
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Curriculum c = new Curriculum();
                c.setCurriculumId(rs.getInt("CurriculumID"));
                c.setProgramId(rs.getInt("ProgramID"));
                c.setCreatedBy(rs.getInt("CreatedBy"));
                c.setCurriculumName(rs.getString("CurriculumName"));
                c.setDescription(rs.getString("Description"));
                c.setStatus(rs.getString("Status"));
                c.setProgramCode(rs.getString("ProgramCode"));
                c.setProgramName(rs.getString("ProgramName"));
                c.setCreatedByName(rs.getString("CreatedByName"));
                c.setSubjectCount(rs.getInt("SubjectCount"));

                list.add(c);
            }

        } catch (Exception e) {
            System.out.println("getCurriculums error: " + e.getMessage());
        }

        return list;
    }

    // =========================================================
    // SEARCH CURRICULA
    // =========================================================
    public List<CurriculumDTO> searchCurricula(String searchType, String keyword,
                                               int page, int pageSize) throws SQLException {
        List<CurriculumDTO> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        String whereClause = buildWhereClause(searchType, keyword);

        String sql = """
                SELECT c.CurriculumID, c.CurriculumName, c.Description, c.Status,
                       tp.ProgramCode, tp.ProgramName, tp.MajorName, tp.AcademicYear
                FROM dbo.[Curriculum] c
                JOIN dbo.[Training_Program] tp ON c.ProgramID = tp.ProgramID
                """ + whereClause + """
                ORDER BY c.CurriculumID
                OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int idx = setSearchParams(ps, searchType, keyword, 1);
            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowBasic(rs));
                }
            }
        }

        return list;
    }

    public int countCurricula(String searchType, String keyword) throws SQLException {
        String whereClause = buildWhereClause(searchType, keyword);

        String sql = """
                SELECT COUNT(*)
                FROM dbo.[Curriculum] c
                JOIN dbo.[Training_Program] tp ON c.ProgramID = tp.ProgramID
                """ + whereClause;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            setSearchParams(ps, searchType, keyword, 1);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }

    // =========================================================
    // DETAIL
    // =========================================================
    public CurriculumDTO getCurriculumById(int curriculumId) throws SQLException {
        String sql = """
                SELECT c.CurriculumID, c.CurriculumName, c.Description, c.Status,
                       tp.ProgramCode, tp.ProgramName, tp.MajorName, tp.AcademicYear
                FROM dbo.[Curriculum] c
                JOIN dbo.[Training_Program] tp ON c.ProgramID = tp.ProgramID
                WHERE c.CurriculumID = ?
                """;

        CurriculumDTO dto = null;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, curriculumId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    dto = mapRowBasic(rs);
                }
            }
        }

        if (dto != null) {
            Map<Integer, List<SubjectDTO>> semesterSubjects = loadSemesterSubjects(curriculumId);
            dto.setSemesterSubjects(semesterSubjects);

            int totalCredits = semesterSubjects.values()
                    .stream()
                    .flatMap(List::stream)
                    .mapToInt(SubjectDTO::getCredits)
                    .sum();

            dto.setTotalCredits(totalCredits);
        }

        return dto;
    }

    private Map<Integer, List<SubjectDTO>> loadSemesterSubjects(int curriculumId) throws SQLException {
        Map<Integer, List<SubjectDTO>> map = new TreeMap<>();

        String sql = """
                SELECT cs.SemesterNo,
                       s.SubjectID, s.SubjectCode, s.SubjectName, s.Credits, s.Status,
                       cs.IsRequired
                FROM dbo.[Curriculum_Subject] cs
                JOIN dbo.[Subject] s ON cs.SubjectID = s.SubjectID
                WHERE cs.CurriculumID = ?
                ORDER BY cs.SemesterNo, s.SubjectCode
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, curriculumId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int semester = rs.getInt("SemesterNo");

                    SubjectDTO subject = new SubjectDTO();
                    subject.setSubjectId(rs.getInt("SubjectID"));
                    subject.setSubjectCode(rs.getString("SubjectCode"));
                    subject.setSubjectName(rs.get