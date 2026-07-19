package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.Subject;

public class CourseDao extends DBContext {

    private static final String DEFAULT_COURSE_STATUS = "WaitingForSyllabus";

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

    public List<Subject> getCourseOptions() {
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
                list.add(mapSubject(rs));
            }
        } catch (Exception e) {
            System.out.println("getCourseOptions error: " + e.getMessage());
        }
        return list;
    }

    public Map<Integer, List<String>> getPrerequisiteCodesBySubjectIds(List<Subject> subjects) {
        Map<Integer, List<String>> prerequisiteMap = new LinkedHashMap<>();
        if (subjects == null || subjects.isEmpty()) {
            return prerequisiteMap;
        }

        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < subjects.size(); i++) {
            if (i > 0) {
                placeholders.append(",");
            }
            placeholders.append("?");
            prerequisiteMap.put(subjects.get(i).getSubjectId(), new ArrayList<>());
        }

        String sql = """
                SELECT sp.SubjectID, s.SubjectCode
                FROM dbo.[Subject_Prerequisite] sp
                JOIN dbo.[Subject] s ON sp.RequiredSubjectID = s.SubjectID
                WHERE sp.SubjectID IN (%s)
                ORDER BY sp.SubjectID, s.SubjectCode
                """.formatted(placeholders);

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 0; i < subjects.size(); i++) {
                ps.setInt(i + 1, subjects.get(i).getSubjectId());
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int subjectId = rs.getInt("SubjectID");
                    prerequisiteMap.computeIfAbsent(subjectId, key -> new ArrayList<>())
                            .add(rs.getString("SubjectCode"));
                }
            }
        } catch (Exception e) {
            System.out.println("getPrerequisiteCodesBySubjectIds error: " + e.getMessage());
        }
        return prerequisiteMap;
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

    public boolean createCourse(Subject subject, List<Integer> prerequisiteSubjectIds) {
        String sql = """
                INSERT INTO dbo.[Subject] (CreatedBy, SubjectCode, SubjectName, Credits, Description, Status)
                VALUES (?, ?, ?, ?, ?, ?)
                """;

        try (Connection con = getConnection()) {
            con.setAutoCommit(false);

            try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, subject.getCreatedBy());
                ps.setString(2, subject.getSubjectCode());
                ps.setString(3, subject.getSubjectName());
                ps.setInt(4, subject.getCredits());
                ps.setString(5, subject.getDescription());
                ps.setString(6, DEFAULT_COURSE_STATUS);
                if (ps.executeUpdate() == 0) {
                    con.rollback();
                    return false;
                }

                int subjectId;
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (!keys.next()) {
                        con.rollback();
                        return false;
                    }
                    subjectId = keys.getInt(1);
                }

                insertPrerequisites(con, subjectId, prerequisiteSubjectIds);
                con.commit();
                return true;
            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (Exception e) {
            System.out.println("createCourse error: " + e.getMessage());
        }
        return false;
    }

    private void insertPrerequisites(Connection con, int subjectId, List<Integer> prerequisiteSubjectIds) throws SQLException {
        if (prerequisiteSubjectIds == null || prerequisiteSubjectIds.isEmpty()) {
            return;
        }

        String sql = """
                INSERT INTO dbo.[Subject_Prerequisite] (SubjectID, RequiredSubjectID, ConditionType, Description)
                VALUES (?, ?, ?, ?)
                """;

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            for (Integer requiredSubjectId : prerequisiteSubjectIds) {
                if (requiredSubjectId == null || requiredSubjectId <= 0) {
                    continue;
                }
                ps.setInt(1, subjectId);
                ps.setInt(2, requiredSubjectId);
                ps.setString(3, "Pass");
                ps.setString(4, "Pass prerequisite subject");
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    public boolean createCourse(Subject subject) {
        return createCourse(subject, List.of());
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
