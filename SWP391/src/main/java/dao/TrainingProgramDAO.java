package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.PO;
import model.TrainingProgram;

public class TrainingProgramDAO extends DBContext {

    public List<TrainingProgram> getTrainingPrograms(String programCode, int page, int pageSize) {
        List<TrainingProgram> list = new ArrayList<>();
        String normalizedCode = normalizeProgramCode(programCode);
        int offset = Math.max(page - 1, 0) * pageSize;

        String sql = """
                SELECT ProgramID, CreatedBy, ProgramCode, ProgramName,
                       MajorName, Description, Status
                FROM dbo.[Training_Program]
                WHERE (? = '' OR ProgramCode = ?)
                ORDER BY ProgramID
                OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, normalizedCode);
            ps.setString(2, normalizedCode);
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
        String normalizedCode = normalizeProgramCode(programCode);
        String sql = """
                SELECT COUNT(*)
                FROM dbo.[Training_Program]
                WHERE (? = '' OR ProgramCode = ?)
                """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, normalizedCode);
            ps.setString(2, normalizedCode);

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

    public List<TrainingProgram> getTrainingProgramOptions() {
        List<TrainingProgram> list = new ArrayList<>();
        String sql = """
                SELECT ProgramID, CreatedBy, ProgramCode, ProgramName,
                       MajorName, Description, Status
                FROM dbo.[Training_Program]
                ORDER BY ProgramID
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapTrainingProgram(rs));
            }
        } catch (Exception e) {
            System.out.println("getTrainingProgramOptions error: " + e.getMessage());
        }
        return list;
    }

    public TrainingProgram getTrainingProgramById(int programId) {
        String sql = """
                SELECT ProgramID, CreatedBy, ProgramCode, ProgramName,
                       MajorName, Description, Status
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

    public boolean existsProgramCode(String programCode) {
        String sql = "SELECT COUNT(*) FROM dbo.[Training_Program] WHERE ProgramCode = ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, normalizeProgramCode(programCode));

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            System.out.println("existsProgramCode error: " + e.getMessage());
            return false;
        }
    }

    public List<PO> getPOsByProgramId(int programId) {
        List<PO> list = new ArrayList<>();
        String sql = """
                SELECT po.PoID AS po_id, po.CurriculumID,
                       po.PoCode AS po_code, po.PoDescription AS po_description
                FROM dbo.[PO] po
                JOIN dbo.[Curriculum] c ON po.CurriculumID = c.CurriculumID
                WHERE c.ProgramID = ?
                ORDER BY po.PoCode
                """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, programId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PO po = new PO();
                    po.setPoId(rs.getInt("po_id"));
                    po.setCurriculumId(rs.getInt("CurriculumID"));
                    po.setPoCode(rs.getString("po_code"));
                    po.setPoDescription(rs.getString("po_description"));
                    list.add(po);
                }
            }
        } catch (Exception e) {
            System.out.println("getPOsByProgramId error: " + e.getMessage());
        }
        return list;
    }

    public int createTrainingProgram(TrainingProgram program) {
        Connection con = null;
        try {
            con = getConnection();
            con.setAutoCommit(false);

            int programId = insertTrainingProgram(con, program);

            con.commit();
            return programId;
        } catch (Exception e) {
            System.out.println("createTrainingProgram error: " + e.getMessage());
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return -1;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private int insertTrainingProgram(Connection con, TrainingProgram program) throws SQLException {
        String sql = """
                INSERT INTO dbo.[Training_Program]
                (CreatedBy, ProgramCode, ProgramName, MajorName, Description, Status)
                VALUES (?, ?, ?, ?, ?, ?)
                """;

        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, program.getCreatedBy());
            ps.setString(2, normalizeProgramCode(program.getProgramCode()));
            ps.setString(3, program.getProgramName());
            ps.setString(4, program.getMajorName());
            ps.setString(5, program.getDescription());
            ps.setString(6, program.getStatus());
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        throw new SQLException("Cannot get generated ProgramID.");
    }

    private TrainingProgram mapTrainingProgram(ResultSet rs) throws SQLException {
        TrainingProgram program = new TrainingProgram();
        program.setProgramId(rs.getInt("ProgramID"));
        program.setCreatedBy(rs.getInt("CreatedBy"));
        program.setProgramCode(rs.getString("ProgramCode"));
        program.setProgramName(rs.getString("ProgramName"));
        program.setMajorName(rs.getString("MajorName"));
        program.setDescription(rs.getString("Description"));
        program.setStatus(rs.getString("Status"));
        return program;
    }

    private String normalizeProgramCode(String programCode) {
        return programCode == null ? "" : programCode.trim().toUpperCase();
    }
}
