package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import model.Combo;
import model.ComboSubject;
import model.Subject;

public class ComboDAO extends DBContext {

    public List<Combo> getCombosByCurriculumId(int curriculumId) {
        List<Combo> combos = new ArrayList<>();
        String sql = """
                SELECT c.ComboID, c.CurriculumID, c.ComboName, c.Description, c.Status, c.DisplayOrder,
                       COUNT(cs.SubjectID) AS SubjectCount,
                       COALESCE(SUM(s.Credits), 0) AS TotalCredits,
                       CAST(NULL AS NVARCHAR(MAX)) AS SubjectCodes
                FROM dbo.[Combo] c
                LEFT JOIN dbo.[Combo_Subject] cs ON c.ComboID = cs.ComboID
                LEFT JOIN dbo.[Subject] s ON cs.SubjectID = s.SubjectID
                WHERE c.CurriculumID = ?
                GROUP BY c.ComboID, c.CurriculumID, c.ComboName, c.Description, c.Status, c.DisplayOrder
                ORDER BY COALESCE(c.DisplayOrder, c.ComboID), c.ComboID
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    combos.add(mapCombo(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("getCombosByCurriculumId error: " + e.getMessage());
        }
        return combos;
    }

    /** Backward-compatible alias for the legacy curriculum controller. */
    public List<Combo> getComboByCurriculum(int curriculumId) {
        return getCombosByCurriculumId(curriculumId);
    }

    public Combo getComboById(int comboId) {
        String sql = """
                SELECT c.ComboID, c.CurriculumID, c.ComboName, c.Description, c.Status, c.DisplayOrder,
                       COUNT(cs.SubjectID) AS SubjectCount,
                       COALESCE(SUM(s.Credits), 0) AS TotalCredits,
                       CAST(NULL AS NVARCHAR(MAX)) AS SubjectCodes
                FROM dbo.[Combo] c
                LEFT JOIN dbo.[Combo_Subject] cs ON c.ComboID = cs.ComboID
                LEFT JOIN dbo.[Subject] s ON cs.SubjectID = s.SubjectID
                WHERE c.ComboID = ?
                GROUP BY c.ComboID, c.CurriculumID, c.ComboName, c.Description, c.Status, c.DisplayOrder
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, comboId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCombo(rs);
                }
            }
        } catch (Exception e) {
            System.out.println("getComboById error: " + e.getMessage());
        }
        return null;
    }

    public List<Subject> getSubjectsByComboId(int comboId) {
        List<Subject> subjects = new ArrayList<>();
        String sql = """
                SELECT s.SubjectID, s.CreatedBy, s.SubjectCode, s.SubjectName,
                       s.Credits, s.Description, s.Status
                FROM dbo.[Combo_Subject] cs
                JOIN dbo.[Subject] s ON cs.SubjectID = s.SubjectID
                WHERE cs.ComboID = ?
                ORDER BY COALESCE(cs.DisplayOrder, cs.ComboSubjectID), s.SubjectCode
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, comboId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    subjects.add(mapSubject(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("getSubjectsByComboId error: " + e.getMessage());
        }
        return subjects;
    }

    public int createCombo(Combo combo, List<ComboSubject> subjects) {
        Connection con = null;
        try {
            con = getConnection();
            con.setAutoCommit(false);

            int comboId = insertCombo(con, combo);
            if (comboId <= 0) {
                con.rollback();
                return -1;
            }

            insertComboSubjects(con, comboId, subjects);
            con.commit();
            return comboId;
        } catch (Exception e) {
            System.out.println("createCombo error: " + e.getMessage());
            if (con != null) {
                try {
                    con.rollback();
                } catch (Exception ex) {
                    System.out.println("createCombo rollback error: " + ex.getMessage());
                }
            }
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (Exception e) {
                    System.out.println("createCombo close error: " + e.getMessage());
                }
            }
        }
        return -1;
    }

    private int insertCombo(Connection con, Combo combo) throws SQLException {
        String sql = """
                INSERT INTO dbo.[Combo] (CurriculumID, ComboName, Description, Status, DisplayOrder)
                VALUES (?, ?, ?, ?, ?)
                """;

        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, combo.getCurriculumId());
            ps.setString(2, combo.getComboName());
            ps.setString(3, combo.getDescription());
            ps.setString(4, combo.getStatus());
            if (combo.getDisplayOrder() == null) {
                ps.setNull(5, Types.INTEGER);
            } else {
                ps.setInt(5, combo.getDisplayOrder());
            }
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        return -1;
    }

    private void insertComboSubjects(Connection con, int comboId, List<ComboSubject> subjects) throws SQLException {
        if (subjects == null || subjects.isEmpty()) {
            return;
        }

        String sql = """
                INSERT INTO dbo.[Combo_Subject] (ComboID, SubjectID, SemesterNo, DisplayOrder)
                VALUES (?, ?, ?, ?)
                """;

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            int displayOrder = 1;
            for (ComboSubject subject : subjects) {
                if (subject == null || subject.getSubjectId() <= 0) {
                    continue;
                }
                ps.setInt(1, comboId);
                ps.setInt(2, subject.getSubjectId());
                if (subject.getSemesterNo() == null || subject.getSemesterNo() <= 0) {
                    ps.setNull(3, Types.INTEGER);
                } else {
                    ps.setInt(3, subject.getSemesterNo());
                }
                ps.setInt(4, displayOrder++);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    private Combo mapCombo(ResultSet rs) throws SQLException {
        Combo combo = new Combo();
        combo.setComboId(rs.getInt("ComboID"));
        combo.setCurriculumId(rs.getInt("CurriculumID"));
        combo.setComboName(rs.getString("ComboName"));
        combo.setDescription(rs.getString("Description"));
        combo.setStatus(rs.getString("Status"));

        int displayOrder = rs.getInt("DisplayOrder");
        combo.setDisplayOrder(rs.wasNull() ? null : displayOrder);

        combo.setSubjectCount(rs.getInt("SubjectCount"));
        combo.setTotalCredits(rs.getInt("TotalCredits"));
        combo.setSubjectCodes(rs.getString("SubjectCodes"));
        return combo;
    }

    private Subject mapSubject(ResultSet rs) throws SQLException {
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
}
