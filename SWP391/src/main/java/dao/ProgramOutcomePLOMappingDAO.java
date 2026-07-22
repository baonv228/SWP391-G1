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
                JOIN dbo.[PO] po ON m.PoID = po.PoID
                JOIN dbo.[PLO] plo ON m.PloID = plo.PloID
                WHERE po.CurriculumID = ? AND plo.CurriculumID = ?
                """;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, curriculumId);
            ps.setInt(2, curriculumId);
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

    public boolean replaceMappingByCurriculum(int curriculumId, Map<Integer, List<Integer>> mapping)
            throws SQLException {
        String deleteSql = """
                DELETE m FROM dbo.ProgramOutcomePLOMapping m
                JOIN dbo.[PO] po ON po.PoID = m.PoID
                WHERE po.CurriculumID = ?
                """;
        String insertSql = """
                INSERT INTO dbo.ProgramOutcomePLOMapping(PoID, PloID)
                SELECT po.PoID, plo.PloID
                FROM dbo.[PO] po CROSS JOIN dbo.[PLO] plo
                WHERE po.PoID = ? AND plo.PloID = ?
                  AND po.CurriculumID = ? AND plo.CurriculumID = ?
                """;
        try (Connection con = getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement delete = con.prepareStatement(deleteSql);
                 PreparedStatement insert = con.prepareStatement(insertSql)) {
                delete.setInt(1, curriculumId);
                delete.executeUpdate();
                for (Map.Entry<Integer, List<Integer>> entry : mapping.entrySet()) {
                    for (Integer ploId : entry.getValue()) {
                        insert.setInt(1, entry.getKey());
                        insert.setInt(2, ploId);
                        insert.setInt(3, curriculumId);
                        insert.setInt(4, curriculumId);
                        insert.addBatch();
                    }
                }
                insert.executeBatch();
                con.commit();
                return true;
            } catch (SQLException e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }
}
