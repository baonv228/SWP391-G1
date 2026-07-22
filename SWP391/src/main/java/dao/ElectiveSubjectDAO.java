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
        try (Connection con = getConnection()) {
            String activeFilter = hasDbColumn(con, "dbo.Syllabus", "IsActive")
                    ? "AND syllabus.IsActive = 1 "
                    : "";
            String orderBy = hasDbColumn(con, "dbo.Syllabus", "IsCurrentVersion")
                    ? "syllabus.IsCurrentVersion DESC, syllabus.SyllabusID DESC"
                    : "syllabus.SyllabusID DESC";
            String sql = "SELECT s.SubjectID, s.CreatedBy, s.SubjectCode, s.SubjectName, "
                    + "s.Credits, s.Description, s.Status, sy.SyllabusID "
                    + "FROM dbo.[Curriculum_Elective] ce "
                    + "JOIN dbo.[Subject] s ON ce.SubjectID = s.SubjectID "
                    + "OUTER APPLY ( "
                    + "SELECT TOP 1 syllabus.SyllabusID "
                    + "FROM dbo.[Syllabus] syllabus "
                    + "WHERE syllabus.SubjectID = s.SubjectID "
                    + activeFilter
                    + "AND syllabus.Status IN ('Approved', 'Active') "
                    + "ORDER BY " + orderBy
                    + ") sy "
                    + "WHERE ce.CurriculumElectiveID = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
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
                    int syllabusId = rs.getInt("SyllabusID");
                    s.setSyllabusId(rs.wasNull() ? 0 : syllabusId);
                    list.add(s);
                }
            }
            }
        } catch (SQLException e) {
            System.err.println("getSubjectsByElective error: " + e.getMessage());
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
