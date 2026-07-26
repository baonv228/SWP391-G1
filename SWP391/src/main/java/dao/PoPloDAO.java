package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.PoPlo;

public class PoPloDAO extends DBContext {

    public Map<Integer, List<Integer>> getMappingByCurriculum(int curriculumId) throws SQLException {
        Map<Integer, List<Integer>> mapping = new HashMap<>();
        String sql = """
                SELECT m.PoID, m.PloID
                FROM dbo.[PO_PLO] m
                JOIN dbo.[PO] po ON po.PoID = m.PoID
                JOIN dbo.[PLO] plo ON plo.PloID = m.PloID
                WHERE po.CurriculumID = ? AND plo.CurriculumID = ?
                ORDER BY po.PoCode, plo.PloCode
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, curriculumId);
            ps.setInt(2, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int poId = rs.getInt("PoID");
                    int ploId = rs.getInt("PloID");
                    mapping.computeIfAbsent(poId, ignored -> new ArrayList<>()).add(ploId);
                }
            }
        }
        return mapping;
    }

    public boolean hasMappingByCurriculum(int curriculumId) throws SQLException {
        String sql = """
                SELECT TOP 1 1
                FROM dbo.[PO_PLO] m
                JOIN dbo.[PO] po ON po.PoID = m.PoID
                JOIN dbo.[PLO] plo ON plo.PloID = m.PloID
                WHERE po.CurriculumID = ? AND plo.CurriculumID = ?
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, curriculumId);
            ps.setInt(2, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean replaceMappingByCurriculum(int curriculumId, List<PoPlo> mappings) throws SQLException {
        String deleteSql = """
                DELETE m
                FROM dbo.[PO_PLO] m
                JOIN dbo.[PO] po ON po.PoID = m.PoID
                WHERE po.CurriculumID = ?
                """;
        String insertSql = """
                INSERT INTO dbo.[PO_PLO] (PoID, PloID)
                SELECT po.PoID, plo.PloID
                FROM dbo.[PO] po
                JOIN dbo.[PLO] plo ON plo.PloID = ?
                WHERE po.PoID = ?
                  AND po.CurriculumID = ?
                  AND plo.CurriculumID = ?
                """;

        Connection con = null;
        try {
            con = getConnection();
            con.setAutoCommit(false);

            try (PreparedStatement delete = con.prepareStatement(deleteSql)) {
                delete.setInt(1, curriculumId);
                delete.executeUpdate();
            }

            if (mappings != null && !mappings.isEmpty()) {
                try (PreparedStatement insert = con.prepareStatement(insertSql)) {
                    for (PoPlo mapping : mappings) {
                        insert.setInt(1, mapping.getPloId());
                        insert.setInt(2, mapping.getPoId());
                        insert.setInt(3, curriculumId);
                        insert.setInt(4, curriculumId);
                        insert.addBatch();
                    }
                    insert.executeBatch();
                }
            }

            con.commit();
            return true;
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ignored) {
                }
            }
            throw e;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException ignored) {
                }
            }
        }
    }
}
