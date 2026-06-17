package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.TrainingProgram;

public class TrainingProgramDAO extends DBContext {

    public List<TrainingProgram> getTrainingPrograms(String programCode, int page, int pageSize) {
        List<TrainingProgram> list = new ArrayList<>();
        String keyword = normalizeKeyword(programCode);
        int offset = Math.max(page - 1, 0) * pageSize;

        String sql = """
                SELECT ProgramID, CreatedBy, ProgramCode, ProgramName, AcademicYear,
                       MajorName, PNO, Description, Status
                FROM dbo.[Training_Program]
                WHERE (? = '' OR LOWER(ProgramCode) LIKE ?)
                ORDER BY ProgramCode
                OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, keyword);
            ps.setString(2, "%" + keyword + "%");
            ps.setInt(3, offset);
            ps.setInt(4, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapTrainingProgram(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("getTrainingPrograms error: " + e.getMessage());
        }
        return list;
    }

    public int countTrainingPrograms(String programCode) {
        String keyword = normalizeKeyword(programCode);
        String sql = """
                SELECT COUNT(*)
                FROM dbo.[Training_Program]
                WHERE (? = '' OR LOWER(ProgramCode) LIKE ?)
                """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, keyword);
            ps.setString(2, "%" + keyword + "%");

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.out.println("countTrainingPrograms error: " + e.getMessage());
        }
        return 0;
    }

    public TrainingProgram getTrainingProgramById(int programId) {
        String sql = """
                SELECT ProgramID, CreatedBy, ProgramCode, ProgramName, AcademicYear,
                       MajorName, PNO, Description, Status
                FROM dbo.[Training_Program]
                WHERE ProgramID = ?
                """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, programId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapTrainingProgram(rs);
                }
            }
        } catch (Exception e) {
            System.out.println("getTrainingProgramById error: " + e.getMessage());
        }
        return null;
    }

    private TrainingProgram mapTrainingProgram(ResultSet rs) throws Exception {
        TrainingProgram program = new TrainingProgram();
        program.setProgramId(rs.getInt("ProgramID"));
        program.setCreatedBy(rs.getInt("CreatedBy"));
        program.setProgramCode(rs.getString("ProgramCode"));
        program.setProgramName(rs.getString("ProgramName"));
        program.setAcademicYear(rs.getString("AcademicYear"));
        program.setMajorName(rs.getString("MajorName"));
        program.setPno(rs.getString("PNO"));
        program.setDescription(rs.getString("Description"));
        program.setStatus(rs.getString("Status"));
        return program;
    }

    private String normalizeKeyword(String value) {
        return value == null ? "" : value.trim().toLowerCase();
    }
}
