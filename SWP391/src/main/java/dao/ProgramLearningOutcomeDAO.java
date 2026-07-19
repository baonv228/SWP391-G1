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
        String sql = "SELECT ploId, curriculumId, ploName, ploDescription FROM dbo.ProgramLearningOutcome WHERE curriculumId = ? ORDER BY ploId ASC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProgramLearningOutcome plo = new ProgramLearningOutcome();
                    plo.setPloId(rs.getInt("ploId"));
                    plo.setCurriculumId(rs.getInt("curriculumId"));
                    plo.setPloName(rs.getString("ploName"));
                    plo.setPloDescription(rs.getString("ploDescription"));
                    list.add(plo);
                }
            }
        } catch (SQLException e) {
            System.err.println("getPLOByCurriculum error: " + e.getMessage());
        }
        return list;
    }
}
