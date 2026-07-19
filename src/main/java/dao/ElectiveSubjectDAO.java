package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Subject;

public class ElectiveSubjectDAO extends DBContext {

    public List<Subject> getSubjectsByElective(int electiveId) {
        List<Subject> list = new ArrayList<>();
        String sql = """
                SELECT s.SubjectID, s.CreatedBy, s.SubjectCode, s.SubjectName, s.Credits, s.Description, s.Status
                FROM dbo.ElectiveSubject es
                JOIN dbo.Subject s ON es.subjectId = s.SubjectID
                WHERE es.electiveId = ?
                """;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, electiveId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Subject s = new Subject();
                    s.setSubjectId(rs.getInt("SubjectID"));
                    s.setCreatedBy(rs.getInt("CreatedBy"));
                    s.setSubjectCode(rs.getString("SubjectCode"));
                    s.setSubjectName(rs.getString("SubjectName"));
                    s.setCredits(rs.getInt("Credits"));
                    s.setDescription(rs.getString("Description"));
                    s.setStatus(rs.getString("Status"));
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            System.err.println("getSubjectsByElective error: " + e.getMessage());
        }
        return list;
    }
}
