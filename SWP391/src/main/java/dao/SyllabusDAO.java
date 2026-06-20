package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.*;

public class SyllabusDAO extends DBContext {

    // =========================================================================
    // CREATE — Full syllabus with all children (transactional)
    // =========================================================================

    /**
     * Create a complete syllabus with materials, CLOs, sessions, and assessments.
     * All inserts run inside a single transaction.
     *
     * @return the generated SyllabusID, or -1 on failure
     */
    public int createFullSyllabus(Syllabus syllabus,
                                  List<SyllabusMaterial> materials,
                                  List<CLO> clos,
                                  List<SyllabusSession> sessions,
                                  List<SyllabusAssessment> assessments) {

        Connection con = null;
        int syllabusId = -1;

        try {
            con = getConnection();
            con.setAutoCommit(false);

            // 1) Insert Syllabus
            syllabusId = insertSyllabus(con, syllabus);
            if (syllabusId < 0) {
                con.rollback();
                return -1;
            }

            // 2) Insert Materials
            if (materials != null && !materials.isEmpty()) {
                insertMaterials(con, syllabusId, materials);
            }

            // 3) Insert CLOs — collect generated IDs for junction mapping
            // Map: displayOrder -> generated CLOID
            Map<Integer, Integer> cloOrderToId = new HashMap<>();
            if (clos != null && !clos.isEmpty()) {
                cloOrderToId = insertCLOs(con, syllabusId, clos);
            }

            // 4) Insert Sessions + Session_CLO junction
            if (sessions != null && !sessions.isEmpty()) {
                insertSessions(con, syllabusId, sessions, cloOrderToId);
            }

            // 5) Insert Assessments + Assessment_CLO junction
            if (assessments != null && !assessments.isEmpty()) {
                insertAssessments(con, syllabusId, assessments, cloOrderToId);
            }

            con.commit();
            return syllabusId;

        } catch (Exception e) {
            System.out.println("createFullSyllabus error: " + e.getMessage());
            e.printStackTrace();
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return -1;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException ex) { ex.printStackTrace(); }
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
                VALUES (?,?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?)
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

    private void insertMaterials(Connection con, int syllabusId, List<SyllabusMaterial> materials) throws SQLException {
        String sql = """
                INSERT INTO dbo.[Syllabus_Material]
                (SyllabusID, MaterialDescription, Author, Publisher, PublishedDate,
                 Edition, ISBN, IsMainMaterial, IsHardCopy, IsOnline, Note, DisplayOrder)
                VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?)
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

    /**
     * Insert CLOs and return a map of displayOrder -> generated CLOID.
     */
    private Map<Integer, Integer> insertCLOs(Connection con, int syllabusId, List<CLO> clos) throws SQLException {
        String sql = """
                INSERT INTO dbo.[CLO]
                (SyllabusID, CLOName, CLODetails, LODetails, DisplayOrder)
                VALUES (?,?,?,?,?)
                """;
        Map<Integer, Integer> orderToId = new HashMap<>();

        // Insert one by one to get each generated key
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
                VALUES (?,?,?,?,?, ?,?,?,?,?)
                """;
        String sqlJunction = "INSERT INTO dbo.[Session_CLO] (SessionID, CLOID) VALUES (?,?)";

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

                // Insert junction: Session_CLO
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
                VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?)
                """;
        String sqlJunction = "INSERT INTO dbo.[Assessment_CLO] (AssessmentID, CLOID) VALUES (?,?)";

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

                // Insert junction: Assessment_CLO
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

    // =========================================================================
    // READ — List syllabuses for a designer
    // =========================================================================

    /**
     * Get all syllabuses created by a specific user, with subject info.
     */
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
}
