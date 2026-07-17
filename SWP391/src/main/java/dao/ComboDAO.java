package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Combo;

public class ComboDAO extends DBContext {

    public List<Combo> getCombosByCurriculumId(int curriculumId) {
        List<Combo> combos = new ArrayList<>();
        String sql = """
                SELECT c.ComboID, c.CurriculumID, c.ComboName, c.Description, c.Status, c.DisplayOrder,
                       COUNT(cs.SubjectID) AS SubjectCount,
                       COALESCE(SUM(s.Credits), 0) AS TotalCredits,
                       STRING_AGG(CONVERT(NVARCHAR(MAX), s.SubjectCode), ', ') AS SubjectCodes
                FROM dbo.[Combo] c
                LEFT JOIN dbo.[Combo_Subject] cs ON c.ComboID = cs.ComboID
                LEFT JOIN dbo.[Subject] s ON cs.SubjectID = s.SubjectID
                WHERE c.CurriculumID = ?
                GROUP BY c.ComboID, c.CurriculumID, c.ComboName, c.Description, c.Status, c.DisplayOrder
                ORDER BY COALESCE(c.DisplayOrder, c.ComboID), c.ComboID
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    combos.add(mapCombo(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("getCombosByCurriculumId error: " + e.getMessage());
        }
        return combos;
    }

    private Combo mapCombo(ResultSet rs) throws SQLException {
        Combo combo = new Combo();
        combo.setComboId(rs.getInt("ComboID"));
        combo.setCurriculumId(rs.getInt("CurriculumID"));
        combo.setComboName(rs.getString("ComboName"));
        combo.setDescription(rs.getString("Description"));
        combo.setStatus(rs.getString("Status"));

        int displayOrder = rs.getInt("DisplayOrder");
        combo.setDisplayOrder(rs.wasNull() ? null : displayOrder);

        combo.setSubjectCount(rs.getInt("SubjectCount"));
        combo.setTotalCredits(rs.getInt("TotalCredits"));
        combo.setSubjectCodes(rs.getString("SubjectCodes"));
        return combo;
    }
}
