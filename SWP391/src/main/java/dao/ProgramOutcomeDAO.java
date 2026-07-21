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
        String sql = """
                SELECT PoID, CurriculumID, PoCode, PoDescription
                FROM dbo.[PO]
                WHERE CurriculumID = ?
                ORDER BY PoCode
                """;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProgramOutcome po = new ProgramOutcome();
                    po.setPoId(rs.getInt("PoID"));
                    po.setCurriculumId(rs.getInt("CurriculumID"));
                    po.setPoName(rs.getString("PoCode"));
                    po.setPoDescription(rs.getString("PoDescription"));
                    list.add(po);
                }
            }
        } catch (SQLException e) {
            System.err.println("getPOByCurriculum error: " + e.getMessage());
        }
        return list;
    }

    public ProgramOutcome getPOById(int poId) {
        String sql = """
                SELECT PoID, CurriculumID, PoCode, PoDescription
                FROM dbo.[PO]
                WHERE PoID = ?
                """;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, poId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ProgramOutcome po = new ProgramOutcome();
                    po.setPoId(rs.getInt("PoID"));
                    po.setCurriculumId(rs.getInt("CurriculumID"));
                    po.setPoName(rs.getString("PoCode"));
                    po.setPoDescription(rs.getString("PoDescription"));
                    return po;
                }
            }
        } catch (SQLException e) {
            System.err.println("getPOById error: " + e.getMessage());
        }
        return null;
    }

    public boolean insertPO(ProgramOutcome po) {
        String sql = "INSERT INTO dbo.[PO] (CurriculumID, PoCode, PoDescription) VALUES (?, ?, ?)";
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
        String sql = "UPDATE dbo.[PO] SET PoCode = ?, PoDescription = ? WHERE PoID = ?";
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
        String sql = "DELETE FROM dbo.[PO] WHERE PoID = ?";
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
