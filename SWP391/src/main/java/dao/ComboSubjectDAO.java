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
                       s.SubjectCode, s.SubjectName
                FROM dbo.[ComboSubject] cs
                JOIN dbo.[Subject] s ON cs.SubjectID = s.SubjectID
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
                    list.add(cs);
                }
            }
        } catch (SQLException e) {
            System.err.println("getSubjectsByCombo error: " + e.getMessage());
        }
        return list;
    }
}
