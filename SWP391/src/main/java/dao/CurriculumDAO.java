package dao;

import dto.CurriculumDTO;
import dto.SubjectDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import model.Curriculum;

public class CurriculumDAO extends DBContext {

    /**
     * Get all curriculums with program and creator information.
     */
    public List<Curriculum> getCurriculums() {
        List<Curriculum> list = new ArrayList<>();
        String sql = """
                SELECT c.CurriculumID, c.ProgramID, c.CreatedBy, c.CurriculumName,
                       c.Description, c.Status,
                       tp.ProgramCode, tp.ProgramName,
                       u.FullName AS CreatedByName,
                       COUNT(cs.CurriculumSubjectID) AS SubjectCount,
                       COALESCE(SUM(s.Credits), 0) AS TotalCredits
                FROM dbo.[Curriculum] c
                LEFT JOIN dbo.[Training_Program] tp ON c.ProgramID = tp.ProgramID
                LEFT JOIN dbo.[User] u ON c.CreatedBy = u.UserID
                LEFT JOIN dbo.[Curriculum_Subject] cs ON c.CurriculumID = cs.CurriculumID
                LEFT JOIN dbo.[Subject] s ON cs.SubjectID = s.SubjectID
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
                c.setTotalCredits(rs.getInt("TotalCredits"));
                list.add(c);
            }
        } catch (Exception e) {
            System.out.println("getCurriculums error: " + e.getMessage());
        }
        return list;
    }

    public List<Curriculum> getCurriculumsByProgramId(int programId) {
        List<Curriculum> list = new ArrayList<>();
        String sql = """
                SELECT c.CurriculumID, c.ProgramID, c.CreatedBy, c.CurriculumName,
                       c.Description, c.Status,
                       tp.ProgramCode, tp.ProgramName,
                       u.FullName AS CreatedByName,
                       COUNT(cs.CurriculumSubjectID) AS SubjectCount,
                       COALESCE(SUM(s.Credits), 0) AS TotalCredits
                FROM dbo.[Curriculum] c
                LEFT JOIN dbo.[Training_Program] tp ON c.ProgramID = tp.ProgramID
                LEFT JOIN dbo.[User] u ON c.CreatedBy = u.UserID
                LEFT JOIN dbo.[Curriculum_Subject] cs ON c.CurriculumID = cs.CurriculumID
                LEFT JOIN dbo.[Subject] s ON cs.SubjectID = s.SubjectID
                WHERE c.ProgramID = ?
                GROUP BY c.CurriculumID, c.ProgramID, c.CreatedBy, c.CurriculumName,
                         c.Description, c.Status, tp.ProgramCode, tp.ProgramName, u.FullName
                ORDER BY c.CurriculumID DESC
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, programId);

            try (ResultSet rs = ps.executeQuery()) {
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
                    c.setTotalCredits(rs.getInt("TotalCredits"));
                    list.add(c);
                }
            }
        } catch (Exception e) {
            System.out.println("getCurriculumsByProgramId error: " + e.getMessage());
        }
        return list;
    }

    /**
     * Create curriculum and optional subject mappings in one transaction.
     */
    public int createCurriculum(Curriculum curriculum, List<Integer> subjectIds) {
        Connection con = null;
        try {
            con = getConnection();
            con.setAutoCommit(false);

            int curriculumId = insertCurriculum(con, curriculum);
            if (curriculumId < 0) {
                con.rollback();
                return -1;
            }

            if (subjectIds != null && !subjectIds.isEmpty()) {
                insertCurriculumSubjects(con, curriculumId, subjectIds);
            }

            con.commit();
            return curriculumId;
        } catch (Exception e) {
            System.out.println("createCurriculum error: " + e.getMessage());
            if (con != null) {
                try {
                    con.rollback();
                } catch (Exception ex) {
                    System.out.println("createCurriculum rollback error: " + ex.getMessage());
                }
            }
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (Exception e) {
                    System.out.println("createCurriculum close error: " + e.getMessage());
                }
            }
        }
        return -1;
    }

    private int insertCurriculum(Connection con, Curriculum curriculum) throws Exception {
        String sql = """
                INSERT INTO dbo.[Curriculum]
                (ProgramID, CreatedBy, CurriculumName, Description, Status)
                VALUES (?,?,?,?,?)
                """;

        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, curriculum.getProgramId());
            ps.setInt(2, curriculum.getCreatedBy());
            ps.setString(3, curriculum.getCurriculumName());
            ps.setString(4, curriculum.getDescription());
            ps.setString(5, curriculum.getStatus());
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        return -1;
    }

    private void insertCurriculumSubjects(Connection con, int curriculumId, List<Integer> subjectIds) throws Exception {
        String sql = """
                INSERT INTO dbo.[Curriculum_Subject]
                (CurriculumID, SubjectID, SemesterNo, SubjectGroup, IsRequired, DisplayOrder)
                VALUES (?,?,?,?,?,?)
                """;

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            int displayOrder = 1;
            for (Integer subjectId : subjectIds) {
                if (subjectId == null || subjectId <= 0) {
                    continue;
                }
                ps.setInt(1, curriculumId);
                ps.setInt(2, subjectId);
                ps.setNull(3, java.sql.Types.INTEGER);
                ps.setNull(4, java.sql.Types.NVARCHAR);
                ps.setBoolean(5, true);
                ps.setInt(6, displayOrder++);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }
    
    
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

