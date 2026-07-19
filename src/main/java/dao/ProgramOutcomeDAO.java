package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ProgramOutcome;

public class ProgramOutcomeDAO extends DBContext {

    public List<ProgramOutcome> getPOByCurriculum(int curriculumId) {
        List<ProgramOutcome> list = new ArrayList<>();
        String sql = "SELECT poId, curriculumId, poName, poDescription FROM dbo.ProgramOutcome WHERE curriculumId = ? ORDER BY poId ASC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProgramOutcome po = new ProgramOutcome();
                    po.setPoId(rs.getInt("poId"));
                    po.setCurriculumId(rs.getInt("curriculumId"));
                    po.setPoName(rs.getString("poName"));
                    po.setPoDescription(rs.getString("poDescription"));
                    list.add(po);
                }
            }
        } catch (SQLException e) {
            System.err.println("getPOByCurriculum error: " + e.getMessage());
        }
        return list;
    }

    public ProgramOutcome getPOById(int poId) {
        String sql = "SELECT poId, curriculumId, poName, poDescription FROM dbo.ProgramOutcome WHERE poId = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, poId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ProgramOutcome po = new ProgramOutcome();
                    po.setPoId(rs.getInt("poId"));
                    po.setCurriculumId(rs.getInt("curriculumId"));
                    po.setPoName(rs.getString("poName"));
                    po.setPoDescription(rs.getString("poDescription"));
                    return po;
                }
            }
        } catch (SQLException e) {
            System.err.println("getPOById error: " + e.getMessage());
        }
        return null;
    }

    public boolean insertPO(ProgramOutcome po) {
        String sql = "INSERT INTO dbo.ProgramOutcome (curriculumId, poName, poDescription) VALUES (?, ?, ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, po.getCurriculumId());
            ps.setString(2, po.getPoName());
            ps.setString(3, po.getPoDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("insertPO error: " + e.getMessage());
            return false;
        }
    }

    public boolean updatePO(ProgramOutcome po) {
        String sql = "UPDATE dbo.ProgramOutcome SET poName = ?, poDescription = ? WHERE poId = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, po.getPoName());
            ps.setString(2, po.getPoDescription());
            ps.setInt(3, po.getPoId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("updatePO error: " + e.getMessage());
            return false;
        }
    }

    public boolean deletePO(int poId) {
        String sql = "DELETE FROM dbo.ProgramOutcome WHERE poId = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, poId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("deletePO error: " + e.getMessage());
            return false;
        }
    }
}
