package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ComboSubject;

public class ComboSubjectDAO extends DBContext {

    public List<ComboSubject> getSubjectsByCombo(int comboId) {
        List<ComboSubject> list = new ArrayList<>();
        try (Connection con = getConnection()) {
            String activeFilter = hasDbColumn(con, "dbo.Syllabus", "IsActive")
                    ? "AND syllabus.IsActive = 1 "
                    : "";
            String orderBy = hasDbColumn(con, "dbo.Syllabus", "IsCurrentVersion")
                    ? "syllabus.IsCurrentVersion DESC, syllabus.SyllabusID DESC"
                    : "syllabus.SyllabusID DESC";
            String sql = "SELECT cs.ComboID, cs.SubjectID, cs.SemesterNo, "
                    + "s.SubjectCode, s.SubjectName, sy.SyllabusID "
                    + "FROM dbo.[Combo_Subject] cs "
                    + "JOIN dbo.[Subject] s ON cs.SubjectID = s.SubjectID "
                    + "OUTER APPLY ( "
                    + "SELECT TOP 1 syllabus.SyllabusID "
                    + "FROM dbo.[Syllabus] syllabus "
                    + "WHERE syllabus.SubjectID = s.SubjectID "
                    + activeFilter
                    + "AND syllabus.Status IN ('Approved', 'Active') "
                    + "ORDER BY " + orderBy
                    + ") sy "
                    + "WHERE cs.ComboID = ? "
                    + "ORDER BY COALESCE(cs.DisplayOrder, cs.ComboSubjectID), s.SubjectCode";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, comboId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ComboSubject cs = new ComboSubject();
                    cs.setComboId(rs.getInt("ComboID"));
                    cs.setSubjectId(rs.getInt("SubjectID"));
                    int semesterNo = rs.getInt("SemesterNo");
                    cs.setSemesterNo(rs.wasNull() ? null : semesterNo);
                    cs.setSubjectCode(rs.getString("SubjectCode"));
                    cs.setSubjectName(rs.getString("SubjectName"));
                    int syllabusId = rs.getInt("SyllabusID");
                    cs.setSyllabusId(rs.wasNull() ? 0 : syllabusId);
                    list.add(cs);
                }
            }
            }
        } catch (SQLException e) {
            System.err.println("getSubjectsByCombo error: " + e.getMessage());
        }
        return list;
    }

    private boolean hasDbColumn(Connection con, String tableName, String columnName) throws SQLException {
        String sql = "SELECT COL_LENGTH(?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, tableName);
            ps.setString(2, columnName);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getObject(1) != null;
            }
        }
    }
}
