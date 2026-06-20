package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.TrainingProgram;

public class TrainingProgramDAO extends DBContext {

    /**
     * Get all training programs with creator name.
     */
    public List<TrainingProgram> getTrainingPrograms() {
        List<TrainingProgram> list = new ArrayList<>();
        String sql = """
                SELECT tp.ProgramID, tp.CreatedBy, tp.ProgramCode, tp.ProgramName,
                       tp.AcademicYear, tp.MajorName, tp.PNO, tp.Description, tp.Status,
                       u.FullName AS CreatedByName
                FROM dbo.[Training_Program] tp
                LEFT JOIN dbo.[User] u ON tp.CreatedBy = u.UserID
                ORDER BY tp.ProgramID DESC
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                TrainingProgram p = new TrainingProgram();
                p.setProgramId(rs.getInt("ProgramID"));
                p.setCreatedBy(rs.getInt("CreatedBy"));
                p.setProgramCode(rs.getString("ProgramCode"));
                p.setProgramName(rs.getString("ProgramName"));
                p.setAcademicYear(rs.getString("AcademicYear"));
                p.setMajorName(rs.getString("MajorName"));
                p.setPno(rs.getString("PNO"));
                p.setDescription(rs.getString("Description"));
                p.setStatus(rs.getString("Status"));
                p.setCreatedByName(rs.getString("CreatedByName"));
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println("getTrainingPrograms error: " + e.getMessage());
        }
        return list;
    }

    /**
     * Get a single training program by id.
     */
    public TrainingProgram getTrainingProgramById(int programId) {
        String sql = """
                SELECT ProgramID, CreatedBy, ProgramCode, ProgramName,
                       AcademicYear, MajorName, PNO, Description, Status
                FROM dbo.[Training_Program]
                WHERE ProgramID = ?
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, programId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    TrainingProgram p = new TrainingProgram();
                    p.setProgramId(rs.getInt("ProgramID"));
                    p.setCreatedBy(rs.getInt("CreatedBy"));
                    p.setProgramCode(rs.getString("ProgramCode"));
                    p.setProgramName(rs.getString("ProgramName"));
                    p.setAcademicYear(rs.getString("AcademicYear"));
                    p.setMajorName(rs.getString("MajorName"));
                    p.setPno(rs.getString("PNO"));
                    p.setDescription(rs.getString("Description"));
                    p.setStatus(rs.getString("Status"));
                    return p;
                }
            }
        } catch (Exception e) {
            System.out.println("getTrainingProgramById error: " + e.getMessage());
        }
        return null;
    }

    /**
     * Create a new training program.
     */
    public int createTrainingProgram(TrainingProgram program) {
        String sql = """
                INSERT INTO dbo.[Training_Program]
                (CreatedBy, ProgramCode, ProgramName, AcademicYear, MajorName, PNO, Description, Status)
                VALUES (?,?,?,?,?,?,?,?)
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, program.getCreatedBy());
            ps.setString(2, program.getProgramCode());
            ps.setString(3, program.getProgramName());
            ps.setString(4, program.getAcademicYear());
            ps.setString(5, program.getMajorName());
            ps.setString(6, program.getPno());
            ps.setString(7, program.getDescription());
            ps.setString(8, program.getStatus());
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        } catch (Exception e) {
            System.out.println("createTrainingProgram error: " + e.getMessage());
        }
        return -1;
    }

    /**
     * Update an existing training program.
     */
    public boolean updateTrainingProgram(TrainingProgram program) {
        String sql = """
                UPDATE dbo.[Training_Program]
                SET ProgramCode = ?, ProgramName = ?, AcademicYear = ?,
                    MajorName = ?, PNO = ?, Description = ?, Status = ?
                WHERE ProgramID = ?
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, program.getProgramCode());
            ps.setString(2, program.getProgramName());
            ps.setString(3, program.getAcademicYear());
            ps.setString(4, program.getMajorName());
            ps.setString(5, program.getPno());
            ps.setString(6, program.getDescription());
            ps.setString(7, program.getStatus());
            ps.setInt(8, program.getProgramId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("updateTrainingProgram error: " + e.getMessage());
        }
        return false;
    }
}
