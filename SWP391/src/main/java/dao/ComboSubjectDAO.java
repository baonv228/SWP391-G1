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
        String sql = """
                SELECT cs.ComboID, cs.SubjectID, cs.SemesterNo,
                       s.SubjectCode, s.SubjectName,
                       sy.SyllabusID
                FROM dbo.[Combo_Subject] cs
                JOIN dbo.[Subject] s ON cs.SubjectID = s.SubjectID
                OUTER APPLY (
                    SELECT TOP 1 syllabus.SyllabusID
                    FROM dbo.[Syllabus] syllabus
                    WHERE syllabus.SubjectID = s.SubjectID
                      AND syllabus.IsActive = 1
                      AND syllabus.Status IN ('Approved', 'Active')
                    ORDER BY syllabus.IsCurrentVersion DESC, syllabus.SyllabusID DESC
                ) sy
                WHERE cs.ComboID = ?
                ORDER BY COALESCE(cs.DisplayOrder, cs.ComboSubjectID), s.SubjectCode
                """;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
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
        } catch (SQLException e) {
            System.err.println("getSubjectsByCombo error: " + e.getMessage());
        }
        return list;
    }
}
