package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.*;
import dto.MaterialDTO;
import dto.SyllabusDTO;

public class SyllabusDAO extends DBContext {

    // =========================================================================
    // CREATE DRAFT — Section 1 only (partial save)
    // =========================================================================
    public int createDraftSyllabus(Syllabus s) {
        String sql = """
                INSERT INTO dbo.[Syllabus]
                (SubjectID, CreatedBy, VersionNo, SyllabusTitle, Description,
                 Status, IsCurrentVersion, SyllabusName, SyllabusEnglish,
                 DegreeLevel, TimeAllocation, PreRequisiteText, StudentTasks,
                 Tools, ScoringScale, DecisionNo, Note, MinAvgMarkToPass, IsActive)
                VALUES (?,?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,?)
                """;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, s.getSubjectId());
            ps.setInt(2, s.getCreatedBy());
            ps.setString(3, s.getVersionNo());
            ps.setString(4, s.getSyllabusTitle());
            ps.setString(5, s.getDescription());
            ps.setString(6, "Draft");
            ps.setBoolean(7, false);
            ps.setString(8, s.getSyllabusName());
            ps.setString(9, s.getSyllabusEnglish());
            ps.setString(10, s.getDegreeLevel());
            ps.setString(11, s.getTimeAllocation());
            ps.setString(12, s.getPreRequisiteText());
            ps.setString(13, s.getStudentTasks());
            ps.setString(14, s.getTools());
            if (s.getScoringScale() != null) ps.setInt(15, s.getScoringScale());
            else ps.setNull(15, Types.INTEGER);
            ps.setString(16, s.getDecisionNo());
            ps.setString(17, s.getNote());
            if (s.getMinAvgMarkToPass() != null) ps.setDouble(18, s.getMinAvgMarkToPass());
            else ps.setNull(18, Types.DECIMAL);
            ps.setBoolean(19, true);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("createDraftSyllabus error: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    // =========================================================================
    // CHECK — draft exists for subject
    // =========================================================================
    public boolean hasDraftForSubject(int subjectId, int excludeSyllabusId) {
        String sql = "SELECT COUNT(*) FROM dbo.[Syllabus] WHERE SubjectID=? AND Status='Draft' AND IsActive=1 AND SyllabusID<>?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            ps.setInt(2, excludeSyllabusId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (Exception e) { System.out.println("hasDraftForSubject error: " + e.getMessage()); }
        return false;
    }

    // =========================================================================
    // VERSION — next version number
    // =========================================================================
    public String getNextVersionNo(int subjectId) {
        String sql = "SELECT MAX(CAST(LEFT(VersionNo, CHARINDEX('.', VersionNo)-1) AS INT)) FROM dbo.[Syllabus] WHERE SubjectID=? AND IsActive=1";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int maxMajor = rs.getInt(1);
                    if (!rs.wasNull()) return (maxMajor + 1) + ".0";
                }
            }
        } catch (Exception e) { System.out.println("getNextVersionNo error: " + e.getMessage()); }
        return "1.0";
    }

    // =========================================================================
    // READ — single syllabus by ID
    // =========================================================================
    public Syllabus getSyllabusById(int syllabusId) {
        String sql = """
                SELECT s.*, sub.SubjectCode, sub.SubjectName, u.FullName AS CreatedByName
                FROM dbo.[Syllabus] s
                JOIN dbo.[Subject] sub ON s.SubjectID = sub.SubjectID
                JOIN dbo.[User] u ON s.CreatedBy = u.UserID
                WHERE s.SyllabusID = ?
                """;
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setQueryTimeout(10);
            ps.setInt(1, syllabusId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapSyllabusRow(rs);
            }
        } catch (Exception e) { System.out.println("getSyllabusById error: " + e.getMessage()); }
        return null;
    }

    private Syllabus mapSyllabusRow(ResultSet rs) throws SQLException {
        Syllabus s = new Syllabus();
        s.setSyllabusId(rs.getInt("SyllabusID"));
        s.setSubjectId(rs.getInt("SubjectID"));
        s.setCreatedBy(rs.getInt("CreatedBy"));
        int approvedBy = rs.getInt("ApprovedBy");
        s.setApprovedBy(rs.wasNull() ? null : approvedBy);
        s.setVersionNo(rs.getString("VersionNo"));
        s.setSyllabusTitle(rs.getString("SyllabusTitle"));
        s.setDescription(rs.getString("Description"));
        s.setLearningOutcome(rs.getString("LearningOutcome"));
        s.setAssessmentMethod(rs.getString("AssessmentMethod"));
        s.setStatus(rs.getString("Status"));
        s.setCurrentVersion(rs.getBoolean("IsCurrentVersion"));
        s.setCreatedAt(rs.getTimestamp("CreatedAt"));
        s.setApprovedAt(rs.getTimestamp("ApprovedAt"));
        s.setSyllabusName(rs.getString("SyllabusName"));
        s.setSyllabusEnglish(rs.getString("SyllabusEnglish"));
        s.setDegreeLevel(rs.getString("DegreeLevel"));
        s.setTimeAllocation(rs.getString("TimeAllocation"));
        s.setPreRequisiteText(rs.getString("PreRequisiteText"));
        s.setStudentTasks(rs.getString("StudentTasks"));
        s.setTools(rs.getString("Tools"));
        int scale = rs.getInt("ScoringScale");
        s.setScoringScale(rs.wasNull() ? null : scale);
        s.setDecisionNo(rs.getString("DecisionNo"));
        s.setNote(rs.getString("Note"));
        double mark = rs.getDouble("MinAvgMarkToPass");
        s.setMinAvgMarkToPass(rs.wasNull() ? null : mark);
        s.setIsActive(rs.getBoolean("IsActive"));
        s.setSubjectCode(rs.getString("SubjectCode"));
        s.setSubjectName(rs.getString("SubjectName"));
        s.setCreatedByName(rs.getString("CreatedByName"));
        return s;
    }

    // =========================================================================
    // READ — list by creator
    // =========================================================================
    public List<Syllabus> getSyllabusesByCreator(int userId) {
        List<Syllabus> list = new ArrayList<>();
        String sql = """
                SELECT s.*, sub.SubjectCode, sub.SubjectName, u.FullName AS CreatedByName
                FROM dbo.[Syllabus] s
                JOIN dbo.[Subject] sub ON s.SubjectID = sub.SubjectID
                JOIN dbo.[User] u ON s.CreatedBy = u.UserID
                WHERE s.CreatedBy = ? AND s.IsActive = 1
                ORDER BY s.CreatedAt DESC
                """;
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapSyllabusRow(rs));
            }
        } catch (Exception e) { System.out.println("getSyllabusesByCreator error: " + e.getMessage()); }
        return list;
    }

    public List<Syllabus> getPendingApprovalSyllabuses() {
        List<Syllabus> list = new ArrayList<>();
        String sql = """
                SELECT s.*, sub.SubjectCode, sub.SubjectName, u.FullName AS CreatedByName
                FROM dbo.[Syllabus] s
                JOIN dbo.[Subject] sub ON s.SubjectID = sub.SubjectID
                JOIN dbo.[User] u ON s.CreatedBy = u.UserID
                WHERE s.IsActive = 1 AND s.Status = 'Pending Approval'
                ORDER BY s.CreatedAt DESC, s.SyllabusID DESC
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapSyllabusRow(rs));
            }
        } catch (Exception e) {
            System.out.println("getPendingApprovalSyllabuses error: " + e.getMessage());
        }
        return list;
    }

    // =========================================================================
    // UPDATE — details only
    // =========================================================================
    public boolean updateSyllabusDetails(Syllabus s) {
        String sql = """
                UPDATE dbo.[Syllabus] SET
                    SyllabusTitle=?, Description=?, SyllabusName=?, SyllabusEnglish=?,
                    DegreeLevel=?, TimeAllocation=?, PreRequisiteText=?, StudentTasks=?,
                    Tools=?, ScoringScale=?, DecisionNo=?, Note=?, MinAvgMarkToPass=?
                WHERE SyllabusID=?
                """;
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, s.getSyllabusTitle());
            ps.setString(2, s.getDescription());
            ps.setString(3, s.getSyllabusName());
            ps.setString(4, s.getSyllabusEnglish());
            ps.setString(5, s.getDegreeLevel());
            ps.setString(6, s.getTimeAllocation());
            ps.setString(7, s.getPreRequisiteText());
            ps.setString(8, s.getStudentTasks());
            ps.setString(9, s.getTools());
            if (s.getScoringScale() != null) ps.setInt(10, s.getScoringScale());
            else ps.setNull(10, Types.INTEGER);
            ps.setString(11, s.getDecisionNo());
            ps.setString(12, s.getNote());
            if (s.getMinAvgMarkToPass() != null) ps.setDouble(13, s.getMinAvgMarkToPass());
            else ps.setNull(13, Types.DECIMAL);
            ps.setInt(14, s.getSyllabusId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { System.out.println("updateSyllabusDetails error: " + e.getMessage()); }
        return false;
    }

    // =========================================================================
    // UPDATE STATUS
    // =========================================================================
    public boolean updateStatus(int syllabusId, String status) {
        String sql = "UPDATE dbo.[Syllabus] SET Status=? WHERE SyllabusID=?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, syllabusId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { System.out.println("updateStatus error: " + e.getMessage()); }
        return false;
    }

    public boolean approveSyllabus(int syllabusId, int reviewerId) {
        String sql = """
                UPDATE dbo.[Syllabus]
                SET Status = 'Approved', ApprovedBy = ?, ApprovedAt = GETDATE(), IsCurrentVersion = 1
                WHERE SyllabusID = ?
                """;
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reviewerId);
            ps.setInt(2, syllabusId);
            boolean updated = ps.executeUpdate() > 0;
            updateLatestApprovalRequest(syllabusId, reviewerId, "Approved", null);
            return updated;
        } catch (Exception e) {
            System.out.println("approveSyllabus error: " + e.getMessage());
        }
        return false;
    }

    public boolean rejectSyllabus(int syllabusId, int reviewerId, String reason) {
        String sql = """
                UPDATE dbo.[Syllabus]
                SET Status = 'Rejected', ApprovedBy = NULL, ApprovedAt = NULL, Note = ?
                WHERE SyllabusID = ?
                """;
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, reason);
            ps.setInt(2, syllabusId);
            boolean updated = ps.executeUpdate() > 0;
            updateLatestApprovalRequest(syllabusId, reviewerId, "Rejected", reason);
            return updated;
        } catch (Exception e) {
            System.out.println("rejectSyllabus error: " + e.getMessage());
        }
        return false;
    }

    private void updateLatestApprovalRequest(int syllabusId, int reviewerId, String status, String reviewNote) {
        String sql = """
                UPDATE dbo.[Syllabus_Approval_Request]
                SET Status = ?, ReviewedBy = ?, ReviewedAt = GETDATE(), ReviewNote = ?
                WHERE RequestID = (
                    SELECT TOP 1 RequestID
                    FROM dbo.[Syllabus_Approval_Request]
                    WHERE SyllabusID = ? AND Status IN ('Pending', 'Pending Approval')
                    ORDER BY RequestedAt DESC, RequestID DESC
                )
                """;
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, reviewerId);
            ps.setString(3, reviewNote);
            ps.setInt(4, syllabusId);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("updateLatestApprovalRequest warning: " + e.getMessage());
        }
    }

    public boolean deleteSyllabus(int syllabusId) {
        Connection con = null;
        try {
            con = getConnection();
            con.setAutoCommit(false);
            deleteChildren(con, syllabusId);
            String sqlMat = "DELETE FROM dbo.[Learning_Material] WHERE SyllabusID=?";
            try (PreparedStatement ps = con.prepareStatement(sqlMat)) {
                ps.setInt(1, syllabusId);
                ps.executeUpdate();
            }
            String sql = "DELETE FROM dbo.[Syllabus] WHERE SyllabusID=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, syllabusId);
                ps.executeUpdate();
            }
            con.commit();
            return true;
        } catch (Exception e) {
            if (con != null) { try { con.rollback(); } catch (Exception ex) {} }
            System.out.println("deleteSyllabus error: " + e.getMessage());
            return false;
        } finally {
            if (con != null) { try { con.setAutoCommit(true); con.close(); } catch (Exception ex) {} }
        }
    }

    // =========================================================================
    // SAVE CHILDREN — transactional (delete old + insert new)
    // =========================================================================
    public boolean saveAllChildren(int syllabusId,
                                   List<SyllabusMaterial> materials,
                                   List<CLO> clos,
                                   List<SyllabusSession> sessions,
                                   List<SyllabusAssessment> assessments) {
        Connection con = null;
        try {
            con = getConnection();
            con.setAutoCommit(false);

            // Delete existing children in reverse FK order
            deleteChildren(con, syllabusId);

            // Insert materials
            if (materials != null && !materials.isEmpty()) insertMaterials(con, syllabusId, materials);

            // Insert CLOs → get orderToId map
            Map<Integer, Integer> cloOrderToId = new HashMap<>();
            if (clos != null && !clos.isEmpty()) cloOrderToId = insertCLOs(con, syllabusId, clos);

            // Insert sessions + junction
            if (sessions != null && !sessions.isEmpty()) insertSessions(con, syllabusId, sessions, cloOrderToId);

            // Insert assessments + junction
            if (assessments != null && !assessments.isEmpty()) insertAssessments(con, syllabusId, assessments, cloOrderToId);

            // Insert CLO-PLO mappings
            if (clos != null) insertCloPloMappings(con, clos, cloOrderToId);

            con.commit();
            return true;
        } catch (Exception e) {
            System.out.println("saveAllChildren error: " + e.getMessage());
            e.printStackTrace();
            if (con != null) try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            return false;
        } finally {
            if (con != null) try { con.setAutoCommit(true); con.close(); } catch (SQLException ex) { ex.printStackTrace(); }
        }
    }

    private void deleteChildren(Connection con, int syllabusId) throws SQLException {
        // Delete junctions first (FK order)
        String[] deleteJunctions = {
            "DELETE FROM dbo.[CLO_PLO] WHERE CLOID IN (SELECT CLOID FROM dbo.[CLO] WHERE SyllabusID=?)",
            "DELETE FROM dbo.[Assessment_CLO] WHERE AssessmentID IN (SELECT AssessmentID FROM dbo.[Syllabus_Assessment] WHERE SyllabusID=?)",
            "DELETE FROM dbo.[Session_CLO] WHERE SessionID IN (SELECT SessionID FROM dbo.[Syllabus_Session] WHERE SyllabusID=?)",
            "DELETE FROM dbo.[Syllabus_Assessment] WHERE SyllabusID=?",
            "DELETE FROM dbo.[Syllabus_Session] WHERE SyllabusID=?",
            "DELETE FROM dbo.[CLO] WHERE SyllabusID=?",
            "DELETE FROM dbo.[Syllabus_Material] WHERE SyllabusID=?"
        };
        for (String sql : deleteJunctions) {
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, syllabusId);
                ps.executeUpdate();
            }
        }
    }

    private void insertMaterials(Connection con, int syllabusId, List<SyllabusMaterial> materials) throws SQLException {
        String sql = "INSERT INTO dbo.[Syllabus_Material](SyllabusID,MaterialDescription,Author,Publisher,PublishedDate,Edition,ISBN,IsMainMaterial,IsHardCopy,IsOnline,Note,DisplayOrder) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            for (SyllabusMaterial m : materials) {
                ps.setInt(1, syllabusId); ps.setString(2, m.getMaterialDescription());
                ps.setString(3, m.getAuthor()); ps.setString(4, m.getPublisher());
                ps.setString(5, m.getPublishedDate()); ps.setString(6, m.getEdition());
                ps.setString(7, m.getIsbn()); ps.setBoolean(8, m.getIsMainMaterial());
                ps.setBoolean(9, m.getIsHardCopy()); ps.setBoolean(10, m.getIsOnline());
                ps.setString(11, m.getNote()); ps.setInt(12, m.getDisplayOrder());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    private Map<Integer, Integer> insertCLOs(Connection con, int syllabusId, List<CLO> clos) throws SQLException {
        String sql = "INSERT INTO dbo.[CLO](SyllabusID,CLOName,CLODetails,LODetails,DisplayOrder) VALUES(?,?,?,?,?)";
        Map<Integer, Integer> orderToId = new HashMap<>();
        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            for (CLO c : clos) {
                ps.setInt(1, syllabusId); ps.setString(2, c.getCloName());
                ps.setString(3, c.getCloDetails()); ps.setString(4, c.getLoDetails());
                ps.setInt(5, c.getDisplayOrder());
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) orderToId.put(c.getDisplayOrder(), keys.getInt(1));
                }
            }
        }
        return orderToId;
    }

    private void insertSessions(Connection con, int syllabusId, List<SyllabusSession> sessions, Map<Integer, Integer> cloOrderToId) throws SQLException {
        String sqlS = "INSERT INTO dbo.[Syllabus_Session](SyllabusID,SessionNumber,Topic,LearningTeachingType,ITU,StudentMaterials,SDownload,StudentTasks,URLs,DisplayOrder) VALUES(?,?,?,?,?,?,?,?,?,?)";
        String sqlJ = "INSERT INTO dbo.[Session_CLO](SessionID,CLOID) VALUES(?,?)";
        try (PreparedStatement psS = con.prepareStatement(sqlS, Statement.RETURN_GENERATED_KEYS);
             PreparedStatement psJ = con.prepareStatement(sqlJ)) {
            for (SyllabusSession s : sessions) {
                psS.setInt(1, syllabusId); psS.setInt(2, s.getSessionNumber());
                psS.setString(3, s.getTopic()); psS.setString(4, s.getLearningTeachingType());
                psS.setString(5, s.getItu()); psS.setString(6, s.getStudentMaterials());
                psS.setString(7, s.getSDownload()); psS.setString(8, s.getStudentTasks());
                psS.setString(9, s.getUrls()); psS.setInt(10, s.getDisplayOrder());
                psS.executeUpdate();
                int sessionId = -1;
                try (ResultSet keys = psS.getGeneratedKeys()) { if (keys.next()) sessionId = keys.getInt(1); }
                if (sessionId > 0 && s.getCloIds() != null) {
                    for (Integer cloOrder : s.getCloIds()) {
                        Integer cloId = cloOrderToId.get(cloOrder);
                        if (cloId != null) { psJ.setInt(1, sessionId); psJ.setInt(2, cloId); psJ.addBatch(); }
                    }
                }
            }
            psJ.executeBatch();
        }
    }

    private void insertAssessments(Connection con, int syllabusId, List<SyllabusAssessment> assessments, Map<Integer, Integer> cloOrderToId) throws SQLException {
        String sqlA = "INSERT INTO dbo.[Syllabus_Assessment](SyllabusID,Category,Type,Part,Weight,CompletionCriteria,Duration,QuestionType,NoQuestion,KnowledgeAndSkill,GradingGuide,Note,DisplayOrder) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)";
        String sqlJ = "INSERT INTO dbo.[Assessment_CLO](AssessmentID,CLOID) VALUES(?,?)";
        try (PreparedStatement psA = con.prepareStatement(sqlA, Statement.RETURN_GENERATED_KEYS);
             PreparedStatement psJ = con.prepareStatement(sqlJ)) {
            for (SyllabusAssessment a : assessments) {
                psA.setInt(1, syllabusId); psA.setString(2, a.getCategory()); psA.setString(3, a.getType());
                if (a.getPart() != null) psA.setInt(4, a.getPart()); else psA.setNull(4, Types.INTEGER);
                psA.setDouble(5, a.getWeight()); psA.setString(6, a.getCompletionCriteria());
                psA.setString(7, a.getDuration()); psA.setString(8, a.getQuestionType());
                psA.setString(9, a.getNoQuestion()); psA.setString(10, a.getKnowledgeAndSkill());
                psA.setString(11, a.getGradingGuide()); psA.setString(12, a.getNote());
                psA.setInt(13, a.getDisplayOrder());
                psA.executeUpdate();
                int asmId = -1;
                try (ResultSet keys = psA.getGeneratedKeys()) { if (keys.next()) asmId = keys.getInt(1); }
                if (asmId > 0 && a.getCloIds() != null) {
                    for (Integer cloOrder : a.getCloIds()) {
                        Integer cloId = cloOrderToId.get(cloOrder);
                        if (cloId != null) { psJ.setInt(1, asmId); psJ.setInt(2, cloId); psJ.addBatch(); }
                    }
                }
            }
            psJ.executeBatch();
        }
    }

    private void insertCloPloMappings(Connection con, List<CLO> clos, Map<Integer, Integer> cloOrderToId) throws SQLException {
        String sql = "INSERT INTO dbo.[CLO_PLO](CLOID, PloID) VALUES(?,?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            for (CLO c : clos) {
                Integer cloId = cloOrderToId.get(c.getDisplayOrder());
                if (cloId != null && c.getPloIds() != null) {
                    for (Integer ploId : c.getPloIds()) {
                        ps.setInt(1, cloId); ps.setInt(2, ploId); ps.addBatch();
                    }
                }
            }
            ps.executeBatch();
        }
    }

    // =========================================================================
    // READ CHILDREN — for edit page
    // =========================================================================
    public List<SyllabusMaterial> getMaterials(int syllabusId) {
        List<SyllabusMaterial> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.[Syllabus_Material] WHERE SyllabusID=? ORDER BY DisplayOrder";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setQueryTimeout(10);
            ps.setInt(1, syllabusId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SyllabusMaterial m = new SyllabusMaterial();
                    m.setMaterialId(rs.getInt("MaterialID")); m.setSyllabusId(syllabusId);
                    m.setMaterialDescription(rs.getString("MaterialDescription"));
                    m.setAuthor(rs.getString("Author")); m.setPublisher(rs.getString("Publisher"));
                    m.setPublishedDate(rs.getString("PublishedDate")); m.setEdition(rs.getString("Edition"));
                    m.setIsbn(rs.getString("ISBN")); m.setIsMainMaterial(rs.getBoolean("IsMainMaterial"));
                    m.setIsHardCopy(rs.getBoolean("IsHardCopy")); m.setIsOnline(rs.getBoolean("IsOnline"));
                    m.setNote(rs.getString("Note")); m.setDisplayOrder(rs.getInt("DisplayOrder"));
                    list.add(m);
                }
            }
        } catch (Exception e) { System.out.println("getMaterials error: " + e.getMessage()); }
        return list;
    }

    public List<CLO> getCLOs(int syllabusId) {
        List<CLO> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.[CLO] WHERE SyllabusID=? ORDER BY DisplayOrder";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setQueryTimeout(10);
            ps.setInt(1, syllabusId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CLO c = new CLO();
                    c.setCloId(rs.getInt("CLOID")); c.setSyllabusId(syllabusId);
                    c.setCloName(rs.getString("CLOName")); c.setCloDetails(rs.getString("CLODetails"));
                    c.setLoDetails(rs.getString("LODetails")); c.setDisplayOrder(rs.getInt("DisplayOrder"));
                    list.add(c);
                }
            }
            // Fetch PLO mappings after RS is closed to avoid MARS issue
            String sqlMap = "SELECT PloID FROM dbo.[CLO_PLO] WHERE CLOID=?";
            try (PreparedStatement psM = con.prepareStatement(sqlMap)) {
                for (CLO c : list) {
                    psM.setInt(1, c.getCloId());
                    try (ResultSet rsM = psM.executeQuery()) {
                        List<Integer> ploIds = new ArrayList<>();
                        while (rsM.next()) ploIds.add(rsM.getInt(1));
                        c.setPloIds(ploIds);
                    }
                }
            }
        } catch (Exception e) { System.out.println("getCLOs error: " + e.getMessage()); }
        return list;
    }

    public List<SyllabusSession> getSessions(int syllabusId) {
        List<SyllabusSession> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.[Syllabus_Session] WHERE SyllabusID=? ORDER BY SessionNumber";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setQueryTimeout(10);
            ps.setInt(1, syllabusId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SyllabusSession s = new SyllabusSession();
                    s.setSessionId(rs.getInt("SessionID")); s.setSyllabusId(syllabusId);
                    s.setSessionNumber(rs.getInt("SessionNumber")); s.setTopic(rs.getString("Topic"));
                    s.setLearningTeachingType(rs.getString("LearningTeachingType"));
                    s.setItu(rs.getString("ITU")); s.setStudentMaterials(rs.getString("StudentMaterials"));
                    s.setSDownload(rs.getString("SDownload")); s.setStudentTasks(rs.getString("StudentTasks"));
                    s.setUrls(rs.getString("URLs")); s.setDisplayOrder(rs.getInt("DisplayOrder"));
                    list.add(s);
                }
            }
            // Fetch CLO mappings after RS is closed
            String sqlMap = "SELECT CLOID FROM dbo.[Session_CLO] WHERE SessionID=?";
            try (PreparedStatement psM = con.prepareStatement(sqlMap)) {
                for (SyllabusSession s : list) {
                    psM.setInt(1, s.getSessionId());
                    try (ResultSet rsM = psM.executeQuery()) {
                        List<Integer> cloIds = new ArrayList<>();
                        while (rsM.next()) cloIds.add(rsM.getInt(1));
                        s.setCloIds(cloIds);
                    }
                }
            }
        } catch (Exception e) { System.out.println("getSessions error: " + e.getMessage()); }
        return list;
    }

    public List<SyllabusAssessment> getAssessments(int syllabusId) {
        List<SyllabusAssessment> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.[Syllabus_Assessment] WHERE SyllabusID=? ORDER BY DisplayOrder";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setQueryTimeout(10);
            ps.setInt(1, syllabusId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SyllabusAssessment a = new SyllabusAssessment();
                    a.setAssessmentId(rs.getInt("AssessmentID")); a.setSyllabusId(syllabusId);
                    a.setCategory(rs.getString("Category")); a.setType(rs.getString("Type"));
                    int part = rs.getInt("Part"); a.setPart(rs.wasNull() ? null : part);
                    a.setWeight(rs.getDouble("Weight")); a.setCompletionCriteria(rs.getString("CompletionCriteria"));
                    a.setDuration(rs.getString("Duration")); a.setQuestionType(rs.getString("QuestionType"));
                    a.setNoQuestion(rs.getString("NoQuestion")); a.setKnowledgeAndSkill(rs.getString("KnowledgeAndSkill"));
                    a.setGradingGuide(rs.getString("GradingGuide")); a.setNote(rs.getString("Note"));
                    a.setDisplayOrder(rs.getInt("DisplayOrder"));
                    list.add(a);
                }
            }
            // Fetch CLO mappings after RS is closed
            String sqlMap = "SELECT CLOID FROM dbo.[Assessment_CLO] WHERE AssessmentID=?";
            try (PreparedStatement psM = con.prepareStatement(sqlMap)) {
                for (SyllabusAssessment a : list) {
                    psM.setInt(1, a.getAssessmentId());
                    try (ResultSet rsM = psM.executeQuery()) {
                        List<Integer> cloIds = new ArrayList<>();
                        while (rsM.next()) cloIds.add(rsM.getInt(1));
                        a.setCloIds(cloIds);
                    }
                }
            }
        } catch (Exception e) { System.out.println("getAssessments error: " + e.getMessage()); }
        return list;
    }

    // =========================================================================
    // FILE UPLOAD — Learning_Material record
    // =========================================================================
    public void saveMaterialFile(int syllabusId, int uploadedBy, String filePath) {
        String sql = "INSERT INTO dbo.[Learning_Material](SyllabusID,UploadedBy,MaterialName,FilePath,MaterialType,Visibility,Status) VALUES(?,?,?,?,?,?,?)";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, syllabusId); ps.setInt(2, uploadedBy);
            ps.setString(3, "Student Material Package"); ps.setString(4, filePath);
            ps.setString(5, "ZIP"); ps.setString(6, "Public"); ps.setString(7, "Active");
            ps.executeUpdate();
        } catch (Exception e) { System.out.println("saveMaterialFile error: " + e.getMessage()); }
    }

    public String getLatestMaterialFilePath(int syllabusId) {
        String sql = "SELECT TOP 1 FilePath FROM dbo.[Learning_Material] WHERE SyllabusID=? AND Status='Active' ORDER BY UploadedAt DESC";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, syllabusId);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getString("FilePath"); }
        } catch (Exception e) { System.out.println("getLatestMaterialFilePath error: " + e.getMessage()); }
        return null;
    }

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
                ORDER BY sy.CreatedAt DESC, sy.SyllabusID DESC
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


    public SyllabusDTO getSyllabusDtoById(int syllabusId) throws SQLException {
        String sql = """
                SELECT sy.SyllabusID, sy.SyllabusTitle, sy.VersionNo, sy.Status,
                       sy.IsCurrentVersion, sy.ApprovedBy, sy.Description,
                       sy.LearningOutcome, sy.AssessmentMethod,
                       sy.CreatedAt, sy.ApprovedAt,
                       sy.SyllabusName, sy.SyllabusEnglish, sy.DegreeLevel,
                       sy.TimeAllocation, sy.PreRequisiteText, sy.StudentTasks,
                       sy.Tools, sy.ScoringScale, sy.DecisionNo, sy.Note,
                       sy.MinAvgMarkToPass, sy.IsActive,
                       su.SubjectCode, su.SubjectName, su.Credits
                FROM dbo.[Syllabus] sy
                JOIN dbo.[Subject] su ON sy.SubjectID = su.SubjectID
                WHERE sy.SyllabusID = ?
                """;

        SyllabusDTO dto = null;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setQueryTimeout(10);
            ps.setInt(1, syllabusId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    dto = mapRow(rs);
                }
            }
        }

        if (dto != null) {
            dto.setLearningOutcomes(parseLearningOutcomes(dto.getLearningOutcome()));

            // Load child lists
            dto.setTextbooks(getMaterials(syllabusId));
            dto.setClos(getCLOs(syllabusId));
            dto.setAssessments(getAssessments(syllabusId));

            // Load Syllabus_Session and map to SessionDTO list
            List<SyllabusSession> dbSessions = getSessions(syllabusId);
            List<SyllabusDTO.SessionDTO> mappedSessions = new ArrayList<>();
            for (SyllabusSession s : dbSessions) {
                SyllabusDTO.SessionDTO sDto = new SyllabusDTO.SessionDTO();
                sDto.setSessionNo(s.getSessionNumber());
                sDto.setTopic(s.getTopic());
                sDto.setLearningTeachingType(s.getLearningTeachingType());
                sDto.setLo(s.getItu()); 
                sDto.setItu(s.getItu());
                sDto.setStudentMaterials(s.getStudentMaterials());
                sDto.setStudentDownload(s.getSDownload());
                sDto.setStudentTasks(s.getStudentTasks());
                sDto.setUrls(s.getUrls());
                mappedSessions.add(sDto);
            }
            dto.setSessions(mappedSessions);
            dto.setMaterials(buildSessionDownloadMaterials(syllabusId, dbSessions));
        }

        return dto;
    }

    /**
     * Builds the downloadable-material list shown on Syllabus Details from the
     * S-Download column of the syllabus sessions. Repeated paths are displayed
     * only once, while preserving their first-session order.
     */
    private List<MaterialDTO> buildSessionDownloadMaterials(
            int syllabusId, List<SyllabusSession> sessions) {
        Map<String, MaterialDTO> uniqueMaterials = new LinkedHashMap<>();

        for (SyllabusSession session : sessions) {
            String filePath = session.getSDownload();
            if (filePath == null || filePath.trim().isEmpty()) {
                continue;
            }

            filePath = filePath.trim();
            String key = filePath.toLowerCase();
            if (uniqueMaterials.containsKey(key)) {
                continue;
            }

            MaterialDTO material = new MaterialDTO();
            material.setSyllabusId(syllabusId);
            material.setFilePath(filePath);
            material.setMaterialName(extractFileName(filePath));
            material.setMaterialType(extractFileType(filePath));
            material.setVisibility("Public");
            material.setStatus("Active");
            uniqueMaterials.put(key, material);
        }

        return new ArrayList<>(uniqueMaterials.values());
    }

    private String extractFileName(String filePath) {
        String normalized = filePath.replace('\\', '/');
        int slash = normalized.lastIndexOf('/');
        return slash >= 0 ? normalized.substring(slash + 1) : normalized;
    }

    private String extractFileType(String filePath) {
        String fileName = extractFileName(filePath);
        int dot = fileName.lastIndexOf('.');
        return dot >= 0 && dot < fileName.length() - 1
                ? fileName.substring(dot + 1).toUpperCase()
                : "FILE";
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

    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        ResultSetMetaData metaData = rs.getMetaData();
        int columns = metaData.getColumnCount();
        for (int i = 1; i <= columns; i++) {
            if (columnName.equalsIgnoreCase(metaData.getColumnLabel(i)) 
                    || columnName.equalsIgnoreCase(metaData.getColumnName(i))) {
                return true;
            }
        }
        return false;
    }

    private SyllabusDTO mapRow(ResultSet rs) throws SQLException {
        SyllabusDTO dto = new SyllabusDTO();

        dto.setSyllabusId(rs.getInt("SyllabusID"));
        dto.setSyllabusTitle(rs.getString("SyllabusTitle"));
        
        if (hasColumn(rs, "SyllabusEnglish") && rs.getString("SyllabusEnglish") != null) {
            dto.setSyllabusEnglishName(rs.getString("SyllabusEnglish"));
        } else {
            dto.setSyllabusEnglishName(rs.getString("SyllabusTitle"));
        }
        
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

        if (hasColumn(rs, "SyllabusName")) {
            dto.setSyllabusName(rs.getString("SyllabusName"));
        }
        if (hasColumn(rs, "SyllabusEnglish")) {
            dto.setSyllabusEnglish(rs.getString("SyllabusEnglish"));
        }
        if (hasColumn(rs, "DegreeLevel")) {
            dto.setDegreeLevel(rs.getString("DegreeLevel"));
        }
        if (hasColumn(rs, "TimeAllocation")) {
            dto.setTimeAllocation(rs.getString("TimeAllocation"));
        }
        if (hasColumn(rs, "PreRequisiteText")) {
            dto.setPreRequisiteText(rs.getString("PreRequisiteText"));
        }
        if (hasColumn(rs, "StudentTasks")) {
            dto.setStudentTasks(rs.getString("StudentTasks"));
        }
        if (hasColumn(rs, "Tools")) {
            dto.setTools(rs.getString("Tools"));
        }
        if (hasColumn(rs, "DecisionNo")) {
            dto.setDecisionNo(rs.getString("DecisionNo"));
        }
        if (hasColumn(rs, "Note")) {
            dto.setNote(rs.getString("Note"));
        }
        if (hasColumn(rs, "IsActive")) {
            dto.setIsActive(rs.getBoolean("IsActive"));
        }

        if (hasColumn(rs, "ScoringScale")) {
            int scoringScale = rs.getInt("ScoringScale");
            if (!rs.wasNull()) {
                dto.setScoringScale(scoringScale);
            }
        }
        
        if (hasColumn(rs, "MinAvgMarkToPass")) {
            double minAvgMarkToPass = rs.getDouble("MinAvgMarkToPass");
            if (!rs.wasNull()) {
                dto.setMinAvgMarkToPass(minAvgMarkToPass);
            }
        }

        return dto;
    }

}
