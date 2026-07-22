package dao;

import dto.CurriculumDTO;
import dto.SubjectDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import model.Curriculum;
import model.CurriculumSubject;
import model.CurriculumSubjectPLO;
import model.PLO;
import model.PO;

public class CurriculumDAO extends DBContext {

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
                list.add(mapCurriculum(rs));
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
                    list.add(mapCurriculum(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("getCurriculumsByProgramId error: " + e.getMessage());
        }
        return list;
    }

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

    public int createCurriculumWithSubjects(Curriculum curriculum, List<CurriculumSubject> subjects) {
        return createCurriculumWithSubjects(curriculum, subjects, null, null);
    }

    public int createCurriculumWithSubjects(Curriculum curriculum, List<CurriculumSubject> subjects,
                                            List<PLO> plos, List<PO> pos) {
        return createCurriculumWithSubjects(curriculum, subjects, plos, pos, null);
    }

    public int createCurriculumWithSubjects(Curriculum curriculum, List<CurriculumSubject> subjects,
                                            List<PLO> plos, List<PO> pos,
                                            List<CurriculumSubjectPLO> subjectPLOs) {
        Connection con = null;
        try {
            con = getConnection();
            con.setAutoCommit(false);

            int curriculumId = insertCurriculum(con, curriculum);
            if (curriculumId < 0) {
                con.rollback();
                return -1;
            }

            if (subjects != null && !subjects.isEmpty()) {
                insertCurriculumSubjectDetails(con, curriculumId, subjects);
            }
            if (plos != null && !plos.isEmpty()) {
                insertPLOs(con, curriculumId, plos);
            }
            if (pos != null && !pos.isEmpty()) {
                insertPOs(con, curriculumId, pos);
            }
            if (subjectPLOs != null && !subjectPLOs.isEmpty()) {
                insertCurriculumSubjectPLOs(con, curriculumId, subjects, plos, subjectPLOs);
            }

            con.commit();
            return curriculumId;
        } catch (Exception e) {
            System.out.println("createCurriculumWithSubjects error: " + e.getMessage());
            if (con != null) {
                try {
                    con.rollback();
                } catch (Exception ex) {
                    System.out.println("createCurriculumWithSubjects rollback error: " + ex.getMessage());
                }
            }
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (Exception e) {
                    System.out.println("createCurriculumWithSubjects close error: " + e.getMessage());
                }
            }
        }
        return -1;
    }

    public List<CurriculumDTO> searchCurricula(String searchType, String keyword,
                                               int page, int pageSize) throws SQLException {
        List<CurriculumDTO> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String whereClause = buildWhereClause(searchType, keyword);

        String sql = """
                SELECT c.CurriculumID, c.CurriculumName, c.Description, c.Status,
                       tp.ProgramCode, tp.ProgramName, tp.MajorName
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

    public CurriculumDTO getCurriculumById(int curriculumId) throws SQLException {
        String sql = """
                SELECT c.CurriculumID, c.CurriculumName, c.Description, c.Status,
                       tp.ProgramCode, tp.ProgramName, tp.MajorName
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

    public boolean updateCurriculumStatus(int curriculumId, String status) throws SQLException {
        String sql = """
                UPDATE dbo.[Curriculum]
                SET Status = ?
                WHERE CurriculumID = ?
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, curriculumId);
            return ps.executeUpdate() > 0;
        }
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
                ps.setNull(3, Types.INTEGER);
                ps.setNull(4, Types.NVARCHAR);
                ps.setBoolean(5, true);
                ps.setInt(6, displayOrder++);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    private void insertCurriculumSubjectDetails(Connection con, int curriculumId, List<CurriculumSubject> subjects) throws Exception {
        String sql = """
                INSERT INTO dbo.[Curriculum_Subject]
                (CurriculumID, SubjectID, SemesterNo, SubjectGroup, IsRequired, DisplayOrder)
                VALUES (?,?,?,?,?,?)
                """;

        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            int displayOrder = 1;
            for (CurriculumSubject subject : subjects) {
                if (subject == null || subject.getSubjectId() <= 0 || subject.getSemesterNo() == null) {
                    continue;
                }
                ps.setInt(1, curriculumId);
                ps.setInt(2, subject.getSubjectId());
                ps.setInt(3, subject.getSemesterNo());
                ps.setNull(4, Types.NVARCHAR);
                ps.setBoolean(5, true);
                ps.setInt(6, displayOrder++);
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        subject.setCurriculumSubjectId(keys.getInt(1));
                    }
                }
                subject.setCurriculumId(curriculumId);
            }
        }
    }

    private void insertPLOs(Connection con, int curriculumId, List<PLO> plos) throws Exception {
        String sql = """
                INSERT INTO dbo.[PLO] (CurriculumID, PloCode, PloDescription)
                VALUES (?, ?, ?)
                """;

        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            for (PLO plo : plos) {
                ps.setInt(1, curriculumId);
                ps.setString(2, plo.getPloCode());
                ps.setString(3, plo.getPloDescription());
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        plo.setPloId(keys.getInt(1));
                    }
                }
                plo.setCurriculumId(curriculumId);
            }
        }
    }

    private void insertPOs(Connection con, int curriculumId, List<PO> pos) throws Exception {
        String sql = """
                INSERT INTO dbo.[PO] (CurriculumID, PoCode, PoDescription)
                VALUES (?, ?, ?)
                """;

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            for (PO po : pos) {
                ps.setInt(1, curriculumId);
                ps.setString(2, po.getPoCode());
                ps.setString(3, po.getPoDescription());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    private void insertCurriculumSubjectPLOs(Connection con, int curriculumId,
                                            List<CurriculumSubject> subjects,
                                            List<PLO> plos,
                                            List<CurriculumSubjectPLO> subjectPLOs) throws Exception {
        String sql = """
                INSERT INTO dbo.[Curriculum_Subject_PLO]
                (CurriculumID, CurriculumSubjectID, PloID, ContributionLevel, Description)
                VALUES (?, ?, ?, ?, ?)
                """;

        Map<String, Integer> subjectIdsByKey = new HashMap<>();
        if (subjects != null) {
            for (CurriculumSubject subject : subjects) {
                if (subject.getClientKey() != null && !subject.getClientKey().isBlank()) {
                    subjectIdsByKey.put(subject.getClientKey(), subject.getCurriculumSubjectId());
                }
            }
        }

        Map<String, Integer> ploIdsByKey = new HashMap<>();
        if (plos != null) {
            for (PLO plo : plos) {
                if (plo.getClientKey() != null && !plo.getClientKey().isBlank()) {
                    ploIdsByKey.put(plo.getClientKey(), plo.getPloId());
                }
            }
        }

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            for (CurriculumSubjectPLO mapping : subjectPLOs) {
                Integer curriculumSubjectId = subjectIdsByKey.get(mapping.getCurriculumSubjectClientKey());
                Integer ploId = ploIdsByKey.get(mapping.getPloClientKey());
                if (curriculumSubjectId == null || curriculumSubjectId <= 0 || ploId == null || ploId <= 0) {
                    continue;
                }
                ps.setInt(1, curriculumId);
                ps.setInt(2, curriculumSubjectId);
                ps.setInt(3, ploId);
                if (mapping.getContributionLevel() == null || mapping.getContributionLevel().isBlank()) {
                    ps.setNull(4, Types.VARCHAR);
                } else {
                    ps.setString(4, mapping.getContributionLevel());
                }
                if (mapping.getDescription() == null || mapping.getDescription().isBlank()) {
                    ps.setNull(5, Types.NVARCHAR);
                } else {
                    ps.setString(5, mapping.getDescription());
                }
                ps.addBatch();
            }
            ps.executeBatch();
        }
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
                    subject.setSubjectName(rs.getString("SubjectName"));
                    subject.setCredits(rs.getInt("Credits"));
                    subject.setSemester(semester);
                    subject.setStatus(rs.getString("Status"));
                    subject.setRequired(rs.getBoolean("IsRequired"));
                    map.computeIfAbsent(semester, ignored -> new ArrayList<>()).add(subject);
                }
            }
        }
        return map;
    }

    private Curriculum mapCurriculum(ResultSet rs) throws SQLException {
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
        return c;
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
        return dto;
    }

    private String buildWhereClause(String searchType, String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return " WHERE c.Status = 'Active' ";
        }
        if ("name".equalsIgnoreCase(searchType)) {
            return " WHERE c.Status = 'Active' AND c.CurriculumName LIKE ? ";
        }
        return " WHERE c.Status = 'Active' AND tp.ProgramCode LIKE ? ";
    }

    private int setSearchParams(PreparedStatement ps, String searchType, String keyword, int startIndex)
            throws SQLException {
        if (keyword == null || keyword.trim().isEmpty()) {
            return startIndex;
        }
        ps.setString(startIndex++, "%" + keyword.trim() + "%");
        return startIndex;
    }
}
