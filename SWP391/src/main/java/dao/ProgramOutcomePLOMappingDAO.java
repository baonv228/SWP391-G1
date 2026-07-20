package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProgramOutcomePLOMappingDAO extends DBContext {

    public Map<Integer, List<Integer>> getMappingByCurriculum(int curriculumId) {
        Map<Integer, List<Integer>> mapping = new HashMap<>();
        String sql = """
                SELECT m.poId, m.ploId
                FROM dbo.ProgramOutcomePLOMapping m
                JOIN dbo.ProgramOutcome po ON m.poId = po.poId
                WHERE po.curriculumId = ?
                """;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int poId = rs.getInt("poId");
                    int ploId = rs.getInt("ploId");
                    mapping.computeIfAbsent(poId, k -> new ArrayList<>()).add(ploId);
                }
            }
        } catch (SQLException e) {
            System.err.println("getMappingByCurriculum error: " + e.getMessage());
        }
        return mapping;
    }
}
