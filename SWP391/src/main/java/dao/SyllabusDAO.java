package dao;

import dto.SyllabusDTO;
import model.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SyllabusDAO extends DBContext {

    // =========================================================
    // SEARCH SYLLABI
    // =========================================================
    public List<SyllabusDTO> searchSyllabi(String searchType, String keyword,
                                           int page, int pageSize) throws SQLException {
        List<SyllabusDTO> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        String whereClause = buildWhereClause(searchType, keyword);

        String sql = """
                SELECT sy.SyllabusID, sy.SyllabusTitle, sy.VersionNo, sy.Status,
                       sy.IsCurrentVersion, sy.ApprovedBy, sy.Description,
                       sy.LearningOutcome, sy.AssessmentMethod,
                       sy.CreatedAt, sy.ApprovedAt,
                       su.SubjectCode, su.SubjectName, su.Credits
                FROM dbo.[Syllabus] sy
                JOIN dbo.[Subject] su ON sy.SubjectID = su.SubjectID
                """ + whereClause + """
                ORDER BY sy.SyllabusID
                OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int idx = setSearchParams(ps, searchType, keyword, 1);
            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }

        return list;
    }

    public int countSyllabi(String searchType, String keyword) throws SQLException {
        String whereClause = buildWhereClause(searchType, keyword);

        String sql = """
                SELECT COUNT(*)
                FROM dbo.[Syllabus] sy
                JOIN dbo.[Subject] su ON sy.SubjectID = su.SubjectID
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
    public SyllabusDTO getSyllabusById(int syllabusId) throws SQLException {
        String sql = """
                SELECT sy.SyllabusID, sy.SyllabusTitle, sy.VersionNo, sy.Status,
                       sy.IsCurrentVersion, sy.ApprovedBy, sy.Description,
                       sy.LearningOutcome, sy.AssessmentMethod,
                       sy.CreatedAt, sy.ApprovedAt,
                       su.SubjectCode, su.SubjectName, su.Credits
                FROM dbo.[Syllabus] sy
                JOIN dbo.[Subject] su ON sy.SubjectID = su.SubjectID
                WHERE sy.SyllabusID = ?
                """;

        SyllabusDTO dto = null;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, syllabusId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    dto = mapRow(rs);
                }
            }
        }

        if (dto != null) {
            dto.setLearningOutcomes(parseLearningOutcomes(dto.getLearningOutcome()));

            MaterialDAO materialDAO = new MaterialDAO();
            dto.setMaterials(materialDAO.getMaterialsBySyllabusId(syllabusId));
        }

        return dto;
    }

    // =========================================================
    // CREATE FULL SYLLABUS
    // =========================================================
    public int createFullSyllabus(Syllabus syllabus,
                                  List<SyllabusMaterial> materials,
                                  List<CLO> clos,
                                  List<SyllabusSession> sessions,
                                  List<SyllabusAssessment> assessments) {

        Connection con = null;

        try {
            con = getConnection();
            con.setAutoCommit(false);

            int syllabusId = insertSyllabus(con, syllabus);

            if (syllabusId < 0) {
                con.rollback();
                return -1;
            }

            if (materials != null && !materials.isEmpty()) {
                insertMaterials(con, syllabusId, materials);
            }

            Map<Integer, Integer> cloOrderToId = new HashMap<>();
            if (clos != null && !clos.isEmpty()) {
                cloOrderToId = insertCLOs(con, syllabusId, clos);
            }

            if (sessions != null && !sessions.isEmpty()) {
                insertSessions(con, syllabusId, sessions, cloOrderToId);
            }

            if (assessments != null && !assessments.isEmpty()) {
                insertAssessments(con, syllabusId, assessments, cloOrderToId);
            }

            con.commit();
            return syllabusId;

        } catch (Exception e) {
            System.out.println("createFullSyllabus error: " + e.getMessage());
            e.printStackTrace();

            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }

            return -1;

        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }

    private int insertSyllabus(Connection con, Syllabus s) throws SQLException {
        String sql = """
                INSERT INTO dbo.[Syllabus]
                (SubjectID, CreatedBy, VersionNo, SyllabusTitle, Description,
                 LearningOutcome, AssessmentMethod, Status, IsCurrentVersion,
                 SyllabusName, SyllabusEnglish, DegreeLevel, TimeAllocation,
                 PreRequisiteText, StudentTasks, Tools, ScoringScale,
                 DecisionNo, Note, MinAvgMarkToPass, IsActive)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, s.getSubjectId());
            ps.setInt(2, s.getCreatedBy());
            ps.setString(3, s.getVersionNo());
            ps.setString(4, s.getSyllabusTitle());
            ps.setString(5, s.getDescription());
            ps.setString(6, s.getLearningOutcome());
            ps.setString(7, s.getAssessmentMethod());
            ps.setString(8, s.getStatus());
            ps.setBoolean(9, s.isCurrentVersion());
            ps.setString(10, s.getSyllabusName());
            ps.setString(11, s.getSyllabusEnglish());
            ps.setString(12, s.getDegreeLevel());
            ps.setString(13, s.getTimeAllocation());
            ps.setString(14, s.getPreRequisiteText());
            ps.setString(15, s.getStudentTasks());
            ps.setString(16, s.getTools());

            if (s.getScoringScale() != null) {
                ps.setInt(17, s.getScoringScale());
            } else {
                ps.setNull(17, Types.INTEGER);
            }

            ps.setString(18, s.getDecisionNo());
            ps.setString(19, s.getNote());

            if (s.getMinAvgMarkToPass() != null) {
                ps.setDouble(20, s.getMinAvgMarkToPass());
            } else {
                ps.setNull(20, Types.DECIMAL);
            }

            ps.setBoolean(21, s.getIsActive());

            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }

        return -1;
    }

    private void insertMaterials(Connection con, int syllabusId,
                                 List<SyllabusMaterial> materials) throws SQLException {
        String sql = """
                INSERT INTO dbo.[Syllabus_Material]
                (SyllabusID, MaterialDescription, Author, Publisher, PublishedDate,
                 Edition, ISBN, IsMainMaterial, IsHardCopy, IsOnline, Note, DisplayOrder)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            for (SyllabusMaterial m : materials) {
                ps.setInt(1, syllabusId);
                ps.setString(2, m.getMaterialDescription());
                ps.setString(3, m.getAuthor());
                ps.setString(4, m.getPublisher());
                ps.setString(5, m.getPublishedDate());
                ps.setString(6, m.getEdition());
                ps.setString(7, m.getIsbn());
                ps.setBoolean(8, m.getIsMainMaterial());
                ps.setBoolean(9, m.getIsHardCopy());
                ps.setBoolean(10, m.getIsOnline());
                ps.setString(11, m.getNote());
                ps.setInt(12, m.getDisplayOrder());
                ps.addBatch();
            }

            ps.executeBatch();
        }
    }

    private Map<Integer, Integer> insertCLOs(Connection con, int syllabusId,
                                            List<CLO> clos) throws SQLException {
        String sql = """
                INSERT INTO dbo.[CLO]
                (SyllabusID, CLOName, CLODetails, LODetails, DisplayOrder)
                VALUES (?, ?, ?, ?, ?)
                """;

        Map<Integer, Integer> orderToId = new HashMap<>();

        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            for (CLO c : clos) {
                ps.setInt(1, syllabusId);
                ps.setString(2, c.getCloName());
                ps.setString(3, c.getCloDetails());
                ps.setString(4, c.getLoDetails());
                ps.setInt(5, c.getDisplayOrder());

                ps.executeUpdate();

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        orderToId.put(c.getDisplayOrder(), keys.getInt(1));
                    }
                }
            }
        }

        return orderToId;
    }

    private void insertSessions(Connection con, int syllabusId,
                                List<SyllabusSession> sessions,
                                Map<Integer, Integer> cloOrderToId) throws SQLException {
        String sqlSession = """
                INSERT INTO dbo.[Syllabus_Session]
                (SyllabusID, SessionNumber, Topic, LearningTeachingType, ITU,
                 StudentMaterials, SDownload, StudentTasks, URLs, DisplayOrder)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        String sqlJunction = """
                INSERT INTO dbo.[Session_CLO]
                (SessionID, CLOID)
                VALUES (?, ?)
                """;

        try (PreparedStatement psSession = con.prepareStatement(sqlSession, Statement.RETURN_GENERATED_KEYS);
             PreparedStatement psJunction = con.prepareStatement(sqlJunction)) {

            for (SyllabusSession s : sessions) {
                psSession.setInt(1, syllabusId);
                psSession.setInt(2, s.getSessionNumber());
                psSession.setString(3, s.getTopic());
                psSession.setString(4, s.getLearningTeachingType());
                psSession.setString(5, s.getItu());
                psSession.setString(6, s.getStudentMaterials());
                psSession.setString(7, s.getSDownload());
                psSession.setString(8, s.getStudentTasks());
                psSession.setString(9, s.getUrls());
                psSession.setInt(10, s.getDisplayOrder());

                psSession.executeUpdate();

                int sessionId;

                try (ResultSet keys = psSession.getGeneratedKeys()) {
                    if (keys.next()) {
                        sessionId = keys.getInt(1);
                    } else {
                        continue;
                    }
                }

                if (s.getCloIds() != null) {
                    for (Integer cloOrder : s.getCloIds()) {
                        Integer cloId = cloOrderToId.get(cloOrder);

                        if (cloId != null) {
                            psJunction.setInt(1, sessionId);
                            psJunction.setInt(2, cloId);
                            psJunction.addBatch();
                        }
                    }
                }
            }

            psJunction.executeBatch();
        }
    }

    private void insertAssessments(Connection con, int syllabusId,
                                   List<SyllabusAssessment> assessments,
                                   Map<Integer, Integer> cloOrderToId) throws SQLException {
        String sqlAssess = """
                INSERT INTO dbo.[Syllabus_Assessment]
                (SyllabusID, Category, Type, Part, Weight, CompletionCriteria,
                 Duration, QuestionType, NoQuestion, KnowledgeAndSkill,
                 GradingGuide, Note, DisplayOrder)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        String sqlJunction = """
                INSERT INTO dbo.[Assessment_CLO]
                (AssessmentID, CLOID)
                VALUES (?, ?)
                """;

        try (PreparedStatement psAssess = con.prepareStatement(sqlAssess, Statement.RETURN_GENERATED_KEYS);
             PreparedStatement psJunction = con.prepareStatement(sqlJunction)) {

            for (SyllabusAssessment a : assessments) {
                psAssess.setInt(1, syllabusId);
                psAssess.setString(2, a.getCategory());
                psAssess.setString(3, a.getType());

                if (a.getPart() != null) {
                    psAssess.setInt(4, a.getPart());
                } else {
                    psAssess.setNull(4, Types.INTEGER);
                }

                psAssess.setDouble(5, a.getWeight());
                psAssess.setString(6, a.getCompletionCriteria());
                psAssess.setString(7, a.getDuration());
                psAssess.setString(8, a.getQuestionType());
                psAssess.setString(9, a.getNoQuestion());
                psAssess.setString(10, a.getKnowledgeAndSkill());
                psAssess.setString(11, a.getGradingGuide());
                psAssess.setString(12, a.getNote());
                psAssess.setInt(13, a.getDisplayOrder());

                psAssess.executeUpdate();

                int assessmentId;

                try (ResultSet keys = psAssess.getGeneratedKeys()) {
                    if (keys.next()) {
                        assessmentId = keys.getInt(1);
                    } else {
                        continue;
                    }
                }

                if (a.getCloIds() != null) {
                    for (Integer cloOrder : a.getCloIds()) {
                        Integer cloId = cloOrderToId.get(cloOrder);

                        if (cloId != null) {
                            psJunction.setInt(1, assessmentId);
                            psJunction.setInt(2, cloId);
                            psJunction.addBatch();
                        }
                    }
                }
            }

            psJunction.executeBatch();
        }
    }

    // =========================================================
    // READ SYLLABUS BY CREATOR
    // =========================================================
    public List<Syllabus> getSyllabusesByCreator(int userId) {
        List<Syllabus> list = new ArrayList<>();

        String sql = """
                SELECT s.SyllabusID, s.SubjectID, s.CreatedBy, s.VersionNo,
                       s.SyllabusTitle, s.SyllabusName, s.Status, s.IsCurrentVersion,
                       s.CreatedAt, s.IsActive,
                       sub.SubjectCode, sub.SubjectName
                FROM dbo.[Syllabus] s
                JOIN dbo.[Subject] sub ON s.SubjectID = sub.SubjectID
                WHERE s.CreatedBy = ? AND s.IsActive = 1
                ORDER BY s.CreatedAt DESC
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Syllabus s = new Syllabus();

                    s.setSyllabusId(rs.getInt("SyllabusID"));
                    s.setSubjectId(rs.getInt("SubjectID"));
                    s.setCreatedBy(rs.getInt("CreatedBy"));
                    s.setVersionNo(rs.getString("VersionNo"));
                    s.setSyllabusTitle(rs.getString("SyllabusTitle"));
                    s.setSyllabusName(rs.getString("SyllabusName"));
                    s.setStatus(rs.getString("Status"));
                    s.setCurrentVersion(rs.getBoolean("IsCurrentVersion"));
                    s.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    s.setIsActive(rs.getBoolean("IsActive"));
                    s.setSubjectCode(rs.getString("SubjectCode"));
                    s.setSubjectName(rs.getString("SubjectName"));

                    list.add(s);
                }
            }

        } catch (Exception e) {
            System.out.println("getSyllabusesByCreator error: " + e.getMessage());
        }

        return list;
    }

    // =========================================================
    // HELPERS
    // =========================================================
    private List<String> parseLearningOutcomes(String rawText) {
        List<String> outcomes = new ArrayList<>();

        if (rawText == null || rawText.trim().isEmpty()) {
            return outcomes;
        }

        String[] lines = rawText.split("\\r?\\n");

        for (String line : lines) {
            String trimmed = line.trim().replaceAll("^[-•*]\\s*", "");

            if (!trimmed.isEmpty()) {
                outcomes.add(trimmed);
            }
        }

        if (outcomes.isEmpty()) {
            outcomes.add(rawText.trim());
        }

        return outcomes;
    }

    private String buildWhereClause(String searchType, String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return "";
        }

        switch (searchType == null ? "" : searchType.toLowerCase()) {
            case "name":
                return " WHERE LOWER(sy.SyllabusTitle) LIKE LOWER(?) ";
            case "subject":
                return " WHERE LOWER(su.SubjectCode) LIKE LOWER(?) OR LOWER(su.SubjectName) LIKE LOWER(?) ";
            case "code":
            default:
                return " WHERE LOWER(su.SubjectCode) LIKE LOWER(?) ";
        }
    }

    private int setSearchParams(PreparedStatement ps, String searchType,
                                String keyword, int startIdx) throws SQLException {
        if (keyword == null || keyword.trim().isEmpty()) {
            return startIdx;
        }

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
        dto.setSyllabusEnglishName(rs.getString("SyllabusTitle"));
        dto.setVersionNo(rs.getString("VersionNo"));
        dto.setStatus(rs.getString("Status"));
        dto.setCurrentVersion(rs.getBoolean("IsCurrentVersion"));

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