package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Elective;

public class ElectiveDAO extends DBContext {

    public List<Elective> getElectiveByCurriculum(int curriculumId) {
        List<Elective> list = new ArrayList<>();
        String sql = "SELECT electiveId, curriculumId, electiveCode, electiveName, note FROM dbo.Elective WHERE curriculumId = ? ORDER BY electiveId ASC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Elective el = new Elective();
                    el.setElectiveId(rs.getInt("electiveId"));
                    el.setCurriculumId(rs.getInt("curriculumId"));
                    el.setElectiveCode(rs.getString("electiveCode"));
                    el.setElectiveName(rs.getString("electiveName"));
                    el.setNote(rs.getString("note"));
                    list.add(el);
                }
            }
        } catch (SQLException e) {
            System.err.println("getElectiveByCurriculum error: " + e.getMessage());
        }
        return list;
    }

    public Elective getElectiveById(int electiveId) {
        String sql = "SELECT electiveId, curriculumId, electiveCode, electiveName, note FROM dbo.Elective WHERE electiveId = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, electiveId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Elective el = new Elective();
                    el.setElectiveId(rs.getInt("electiveId"));
                    el.setCurriculumId(rs.getInt("curriculumId"));
                    el.setElectiveCode(rs.getString("electiveCode"));
                    el.setElectiveName(rs.getString("electiveName"));
                    el.setNote(rs.getString("note"));
                    return el;
                }
            }
        } catch (SQLException e) {
            System.err.println("getElectiveById error: " + e.getMessage());
        }
        return null;
    }
}
