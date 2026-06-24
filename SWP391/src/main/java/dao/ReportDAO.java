package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.CourseReportItem;
import model.TrainingReportStats;

public class ReportDAO extends DBContext {

    public TrainingReportStats getReportStats() {
        TrainingReportStats stats = new TrainingReportStats();
        String sql = """
                SELECT 
                    (SELECT COUNT(*) FROM Training_Program) AS TotalPrograms,
                    (SELECT COUNT(*) FROM Curriculum) AS TotalCurriculums,
                    (SELECT COUNT(*) FROM Subject) AS TotalSubjects,
                    (SELECT COUNT(*) FROM Syllabus) AS TotalSyllabuses
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                stats.setTotalPrograms(rs.getInt("TotalPrograms"));
                stats.setTotalCurriculums(rs.getInt("TotalCurriculums"));
                stats.setTotalSubjects(rs.getInt("TotalSubjects"));
                stats.setTotalSyllabuses(rs.getInt("TotalSyllabuses"));
            }
        } catch (Exception e) {
            System.out.println("getReportStats error: " + e.getMessage());
        }
        return stats;
    }

    public List<CourseReportItem> getCourseReport(String programFilter, String searchKeyword) {
        List<CourseReportItem> list = new ArrayList<>();
        // Using STRING_AGG in SQL Server to concatenate Curriculums and Programs.
        String sql = """
                SELECT 
                    s.SubjectID,
                    s.SubjectCode,
                    s.SubjectName,
                    s.Credits,
                    ISNULL(sy.Status, 'No Syllabus') AS SyllabusStatus,
                    (
                        SELECT STRING_AGG(c.CurriculumName, ', ')
                        FROM Curriculum_Subject cs
                        JOIN Curriculum c ON cs.CurriculumID = c.CurriculumID
                        WHERE cs.SubjectID = s.SubjectID
                    ) AS AssociatedCurriculums,
                    (
                        SELECT STRING_AGG(tp.ProgramName, ', ')
                        FROM Curriculum_Subject cs
                        JOIN Curriculum c ON cs.CurriculumID = c.CurriculumID
                        JOIN Training_Program tp ON c.ProgramID = tp.ProgramID
                        WHERE cs.SubjectID = s.SubjectID
                    ) AS AssociatedPrograms
                FROM Subject s
                LEFT JOIN Syllabus sy ON s.SubjectID = sy.SubjectID
                WHERE 1=1
                """;

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql += " AND (s.SubjectCode LIKE ? OR s.SubjectName LIKE ?) ";
        }
        
        if (programFilter != null && !programFilter.trim().isEmpty()) {
            sql += """
                   AND EXISTS (
                       SELECT 1 
                       FROM Curriculum_Subject cs2 
                       JOIN Curriculum c2 ON cs2.CurriculumID = c2.CurriculumID 
                       WHERE cs2.SubjectID = s.SubjectID AND c2.ProgramID = ?
                   )
                   """;
        }
        
        sql += " ORDER BY s.SubjectCode";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int paramIndex = 1;
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String searchPattern = "%" + searchKeyword.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            if (programFilter != null && !programFilter.trim().isEmpty()) {
                ps.setInt(paramIndex++, Integer.parseInt(programFilter.trim()));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CourseReportItem item = new CourseReportItem();
                    item.setSubjectId(rs.getInt("SubjectID"));
                    item.setSubjectCode(rs.getString("SubjectCode"));
                    item.setSubjectName(rs.getString("SubjectName"));
                    item.setCredits(rs.getInt("Credits"));
                    item.setSyllabusStatus(rs.getString("SyllabusStatus"));
                    item.setAssociatedCurriculums(rs.getString("AssociatedCurriculums"));
                    item.setAssociatedPrograms(rs.getString("AssociatedPrograms"));
                    list.add(item);
                }
            }
        } catch (Exception e) {
            System.out.println("getCourseReport error: " + e.getMessage());
        }
        return list;
    }
}
