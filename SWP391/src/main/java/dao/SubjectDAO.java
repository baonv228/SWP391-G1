package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Subject;

public class SubjectDAO extends DBContext {

    /**
     * Get all subjects that are waiting for a syllabus to be created.
     */
    public List<Subject> getSubjectsWaitingForSyllabus() {
        List<Subject> list = new ArrayList<>();
        String sql = """
                SELECT SubjectID, CreatedBy, SubjectCode, SubjectName, Credits, Description, Status
                FROM dbo.[Subject]
                WHERE Status = 'WaitingForSyllabus'
                ORDER BY SubjectCode
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

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
        } catch (Exception e) {
            System.out.println("getSubjectsWaitingForSyllabus error: " + e.getMessage());
        }
        return list;
    }

    /**
     * Get a single subject by its ID.
     */
    public Subject getSubjectById(int subjectId) {
        String sql = """
                SELECT SubjectID, CreatedBy, SubjectCode, SubjectName, Credits, Description, Status
                FROM dbo.[Subject]
                WHERE SubjectID = ?
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Subject s = new Subject();
                    s.setSubjectId(rs.getInt("SubjectID"));
                    s.setCreatedBy(rs.getInt("CreatedBy"));
                    s.setSubjectCode(rs.getString("SubjectCode"));
                    s.setSubjectName(rs.getString("SubjectName"));
                    s.setCredits(rs.getInt("Credits"));
                    s.setDescription(rs.getString("Description"));
                    s.setStatus(rs.getString("Status"));
                    return s;
                }
            }
        } catch (Exception e) {
            System.out.println("getSubjectById error: " + e.getMessage());
        }
        return null;
    }

    /**
     * Get all subjects for curriculum selection.
     */
    public List<Subject> getAllSubjects() {
        List<Subject> list = new ArrayList<>();
        String sql = """
                SELECT SubjectID, CreatedBy, SubjectCode, SubjectName, Credits, Description, Status
                FROM dbo.[Subject]
                ORDER BY SubjectCode
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

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
        } catch (Exception e) {
            System.out.println("getAllSubjects error: " + e.getMessage());
        }
        return list;
    }
}
