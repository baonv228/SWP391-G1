package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ProgramLearningOutcome;

public class ProgramLearningOutcomeDAO extends DBContext {

    public List<ProgramLearningOutcome> getPLOByCurriculum(int curriculumId) {
        List<ProgramLearningOutcome> list = new ArrayList<>();
        String sql = """
                SELECT PloID, CurriculumID, PloCode, PloDescription
                FROM dbo.[PLO]
                WHERE CurriculumID = ?
                ORDER BY PloCode
                """;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProgramLearningOutcome plo = new ProgramLearningOutcome();
                    plo.setPloId(rs.getInt("PloID"));
                    plo.setCurriculumId(rs.getInt("CurriculumID"));
                    plo.setPloName(rs.getString("PloCode"));
                    plo.setPloDescription(rs.getString("PloDescription"));
                    list.add(plo);
                }
            }
        } catch (SQLException e) {
            System.err.println("getPLOByCurriculum error: " + e.getMessage());
        }
        return list;
    }
}
