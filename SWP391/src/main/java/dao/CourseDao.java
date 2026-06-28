package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Subject;

public class CourseDao extends DBContext {

    private static final String DEFAULT_COURSE_STATUS = "pending design";

    public List<Subject> getCourses(String subjectCode, int page, int pageSize) {
        List<Subject> list = new ArrayList<>();
        String keyword = normalizeKeyword(subjectCode);
        String sql = """
                SELECT SubjectID, CreatedBy, SubjectCode, SubjectName, Credits, Description, Status
                FROM dbo.[Subject]
                WHERE (? = '' OR LOWER(SubjectCode) LIKE ?)
                ORDER BY SubjectCode
                OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, keyword);
            ps.setString(2, "%" + keyword + "%");
            ps.setInt(3, Math.max(0, (page - 1) * pageSize));
            ps.setInt(4, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSubject(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("getCourses error: " + e.getMessage());
        }
        return list;
    }

    public int countCourses(String subjectCode) {
        String keyword = normalizeKeyword(subjectCode);
        String sql = """
                SELECT COUNT(*)
                FROM dbo.[Subject]
                WHERE (? = '' OR LOWER(SubjectCode) LIKE ?)
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, keyword);
            ps.setString(2, "%" + keyword + "%");

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.out.println("countCourses error: " + e.getMessage());
        }
        return 0;
    }

    public Subject getCourseById(int subjectId) {
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
                    return mapSubject(rs);
                }
            }
        } catch (Exception e) {
            System.out.println("getCourseById error: " + e.getMessage());
        }
        return null;
    }

    public boolean existsSubjectCode(String subjectCode) {
        String sql = """
                SELECT COUNT(*)
                FROM dbo.[Subject]
                WHERE LOWER(SubjectCode) = LOWER(?)
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, subjectCode);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            System.out.println("existsSubjectCode error: " + e.getMessage());
        }
        return false;
    }

    public boolean createCourse(Subject subject) {
        String sql = """
                INSERT INTO dbo.[Subject] (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
                VALUES (?, ?, ?, ?, ?, ?)
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, subject.getCreatedBy());
            ps.setString(2, subject.getSubjectCode());
            ps.setString(3, subject.getSubjectName());
            ps.setInt(4, subject.getCredits());
            ps.setString(5, subject.getDescription());
            ps.setString(6, DEFAULT_COURSE_STATUS);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("createCourse error: " + e.getMessage());
        }
        return false;
    }

    private String normalizeKeyword(String value) {
        return value == null ? "" : value.trim().toLowerCase();
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
