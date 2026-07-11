package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.PLO;

public class PLODAO extends DBContext {

    /**
     * Get all PLOs through curriculums belonging to a Training_Program.
     */
    public List<PLO> getPLOsByProgramId(int programId) {
        List<PLO> list = new ArrayList<>();
        String sql = """
                SELECT p.plo_id, p.CurriculumID, p.plo_code, p.plo_description
                FROM dbo.[PLO] p
                JOIN dbo.[Curriculum] c ON p.CurriculumID = c.CurriculumID
                WHERE c.ProgramID = ?
                ORDER BY p.plo_code
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, programId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PLO p = new PLO();
                    p.setPloId(rs.getInt("plo_id"));
                    p.setCurriculumId(rs.getInt("CurriculumID"));
                    p.setPloCode(rs.getString("plo_code"));
                    p.setPloDescription(rs.getString("plo_description"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            System.out.println("getPLOsByProgramId error: " + e.getMessage());
        }
        return list;
    }

    /**
     * Find Training_Program IDs that contain a given Subject.
     * Path: Training_Program → Curriculum → Curriculum_Subject → Subject
     */
    public List<Integer> getProgramIdsForSubject(int subjectId) {
        List<Integer> ids = new ArrayList<>();
        String sql = """
                SELECT DISTINCT tp.ProgramID
                FROM dbo.[Training_Program] tp
                JOIN dbo.[Curriculum] c ON tp.ProgramID = c.ProgramID
                JOIN dbo.[Curriculum_Subject] cs ON c.CurriculumID = cs.CurriculumID
                WHERE cs.SubjectID = ?
                ORDER BY tp.ProgramID
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt("ProgramID"));
                }
            }
        } catch (Exception e) {
            System.out.println("getProgramIdsForSubject error: " + e.getMessage());
        }
        return ids;
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
