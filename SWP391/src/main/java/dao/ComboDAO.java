package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Combo;

public class ComboDAO extends DBContext {

    public List<Combo> getComboByCurriculum(int curriculumId) {
        List<Combo> list = new ArrayList<>();
        String sql = "SELECT comboId, curriculumId, comboCode, comboName, description FROM dbo.Combo WHERE curriculumId = ? ORDER BY comboId ASC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Combo combo = new Combo();
                    combo.setComboId(rs.getInt("comboId"));
                    combo.setCurriculumId(rs.getInt("curriculumId"));
                    combo.setComboCode(rs.getString("comboCode"));
                    combo.setComboName(rs.getString("comboName"));
                    combo.setDescription(rs.getString("description"));
                    list.add(combo);
                }
            }
        } catch (SQLException e) {
            System.err.println("getComboByCurriculum error: " + e.getMessage());
        }
        return list;
    }

    public Combo getComboById(int comboId) {
        String sql = "SELECT comboId, curriculumId, comboCode, comboName, description FROM dbo.Combo WHERE comboId = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, comboId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Combo combo = new Combo();
                    combo.setComboId(rs.getInt("comboId"));
                    combo.setCurriculumId(rs.getInt("curriculumId"));
                    combo.setComboCode(rs.getString("comboCode"));
                    combo.setComboName(rs.getString("comboName"));
                    combo.setDescription(rs.getString("description"));
                    return combo;
                }
            }
        } catch (SQLException e) {
            System.err.println("getComboById error: " + e.getMessage());
        }
        return null;
    }
}
