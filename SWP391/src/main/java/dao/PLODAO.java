package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import model.PLO;

public class PLODAO extends DBContext {

    /**
     * Get all PLOs through curriculums belonging to a Training_Program.
     * Get all PLOs belonging to a Curriculum.
     */
    public List<PLO> getPLOsByCurriculumId(int curriculumId) {
        List<PLO> list = new ArrayList<>();
        String sql = """
                SELECT PloID, CurriculumID, PloCode, PloDescription
                FROM dbo.[PLO]
                WHERE CurriculumID = ?
                ORDER BY PloCode
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PLO p = new PLO();
                    p.setPloId(rs.getInt("PloID"));
                    p.setCurriculumId(rs.getInt("CurriculumID"));
                    p.setPloCode(rs.getString("PloCode"));
                    p.setPloDescription(rs.getString("PloDescription"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            System.out.println("getPLOsByCurriculumId error: " + e.getMessage());
        }
        return list;
    }

    /**
     * Find Curriculum IDs that contain a given Subject.
     * Path: Curriculum -> Curriculum_Subject -> Subject
     */
    public List<Integer> getCurriculumIdsForSubject(int subjectId) {
        List<Integer> ids = new ArrayList<>();
        String sql = """
                SELECT DISTINCT c.CurriculumID
                FROM dbo.[Curriculum] c
                JOIN dbo.[Curriculum_Subject] cs ON c.CurriculumID = cs.CurriculumID
                WHERE cs.SubjectID = ?
                ORDER BY c.CurriculumID
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt("CurriculumID"));
                }
            }
        } catch (Exception e) {
            System.out.println("getCurriculumIdsForSubject error: " + e.getMessage());
        }
        return ids;
    }

    /**
     * Get list of Curricula (with their PLOs) that contain a given Subject.
     */
    public List<Map<String, Object>> getCurriculaWithPLOsForSubject(int subjectId) {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = """
                SELECT DISTINCT c.CurriculumID, c.CurriculumName
                FROM dbo.[Curriculum] c
                JOIN dbo.[Curriculum_Subject] cs ON c.CurriculumID = cs.CurriculumID
                WHERE cs.SubjectID = ?
                ORDER BY c.CurriculumID
                """;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    int currId = rs.getInt("CurriculumID");
                    map.put("curriculumId", currId);
                    map.put("curriculumName", rs.getString("CurriculumName"));
                    // Only get PLOs assigned to this subject, NOT all PLOs in curriculum
                    map.put("plos", getPLOsForSubjectInCurriculum(subjectId, currId));
                    result.add(map);
                }
            }
        } catch (Exception e) {
            System.out.println("getCurriculaWithPLOsForSubject error: " + e.getMessage());
        }
        return result;
    }

    /**
     * Get only the PLOs that a specific Subject is responsible for within a Curriculum.
     * Uses the Curriculum_Subject_PLO junction table.
     */
    public List<PLO> getPLOsForSubjectInCurriculum(int subjectId, int curriculumId) {
        List<PLO> list = new ArrayList<>();
        String sql = """
                SELECT p.PloID, p.CurriculumID, p.PloCode, p.PloDescription, csp.ContributionLevel
                FROM dbo.[PLO] p
                JOIN dbo.[Curriculum_Subject_PLO] csp ON p.PloID = csp.PloID AND p.CurriculumID = csp.CurriculumID
                JOIN dbo.[Curriculum_Subject] cs ON csp.CurriculumSubjectID = cs.CurriculumSubjectID
                WHERE cs.SubjectID = ? AND cs.CurriculumID = ?
                ORDER BY p.PloCode
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            ps.setInt(2, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PLO p = new PLO();
                    p.setPloId(rs.getInt("PloID"));
                    p.setCurriculumId(rs.getInt("CurriculumID"));
                    p.setPloCode(rs.getString("PloCode"));
                    p.setPloDescription(rs.getString("PloDescription"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            System.out.println("getPLOsForSubjectInCurriculum error: " + e.getMessage());
        }
        return list;
    }

    /**
     * Get Training_Programs that contain a given Subject (for dropdown).
     * Returns list of [ProgramID, ProgramCode, ProgramName].
     */
    public List<model.TrainingProgram> getTrainingProgramsForSubject(int subjectId) {
        List<model.TrainingProgram> list = new ArrayList<>();
        String sql = """
                SELECT DISTINCT tp.ProgramID, tp.ProgramCode, tp.ProgramName
                FROM dbo.[Training_Program] tp
                JOIN dbo.[Curriculum] c ON tp.ProgramID = c.ProgramID
                JOIN dbo.[Curriculum_Subject] cs ON c.CurriculumID = cs.CurriculumID
                WHERE cs.SubjectID = ? AND tp.Status = 'Active'
                ORDER BY tp.ProgramCode
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.TrainingProgram tp = new model.TrainingProgram();
                    tp.setProgramId(rs.getInt("ProgramID"));
                    tp.setProgramCode(rs.getString("ProgramCode"));
                    tp.setProgramName(rs.getString("ProgramName"));
                    list.add(tp);
                }
            }
        } catch (Exception e) {
            System.out.println("getTrainingProgramsForSubject error: " + e.getMessage());
        }
        return list;
    }
}
