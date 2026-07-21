package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import model.CurriculumElective;
import model.Elective;

public class ElectiveDAO extends DBContext {

    public List<CurriculumElective> getElectivesByCurriculumId(int curriculumId) {
        List<CurriculumElective> electives = new ArrayList<>();
        String sql = """
                SELECT ce.CurriculumElectiveID, ce.CurriculumID, ce.SubjectID,
                       ce.ElectiveGroupName, ce.DisplayOrder, ce.Status,
                       s.SubjectCode, s.SubjectName, s.Credits
                FROM dbo.[Curriculum_Elective] ce
                JOIN dbo.[Subject] s ON ce.SubjectID = s.SubjectID
                WHERE ce.CurriculumID = ?
                ORDER BY COALESCE(ce.DisplayOrder, ce.CurriculumElectiveID), ce.CurriculumElectiveID
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, curriculumId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    electives.add(mapElective(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("getElectivesByCurriculumId error: " + e.getMessage());
        }
        return electives;
    }

    /** Backward-compatible projection for legacy curriculum pages. */
    public List<Elective> getElectiveByCurriculum(int curriculumId) {
        List<Elective> result = new ArrayList<>();
        for (CurriculumElective item : getElectivesByCurriculumId(curriculumId)) {
            result.add(toLegacyElective(item));
        }
        return result;
    }

    public Elective getElectiveById(int electiveId) {
        String sql = """
                SELECT ce.CurriculumElectiveID, ce.CurriculumID, ce.SubjectID,
                       ce.ElectiveGroupName, ce.DisplayOrder, ce.Status,
                       s.SubjectCode, s.SubjectName, s.Credits
                FROM dbo.[Curriculum_Elective] ce
                JOIN dbo.[Subject] s ON ce.SubjectID = s.SubjectID
                WHERE ce.CurriculumElectiveID = ?
                """;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, electiveId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return toLegacyElective(mapElective(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("getElectiveById error: " + e.getMessage());
        }
        return null;
    }

    private Elective toLegacyElective(CurriculumElective item) {
        Elective elective = new Elective();
        elective.setElectiveId(item.getCurriculumElectiveId());
        elective.setCurriculumId(item.getCurriculumId());
        elective.setElectiveCode(item.getSubjectCode());
        elective.setElectiveName(item.getElectiveGroupName() == null
                ? item.getSubjectName() : item.getElectiveGroupName());
        elective.setNote(item.getStatus());
        return elective;
    }

    public boolean existsElectiveSubject(int curriculumId, int subjectId) {
        String sql = """
                SELECT COUNT(*)
                FROM dbo.[Curriculum_Elective]
                WHERE CurriculumID = ? AND SubjectID = ?
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, curriculumId);
            ps.setInt(2, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            System.out.println("existsElectiveSubject error: " + e.getMessage());
        }
        return false;
    }

    public boolean createElective(CurriculumElective elective) {
        String sql = """
                INSERT INTO dbo.[Curriculum_Elective]
                (CurriculumID, SubjectID, ElectiveGroupName, DisplayOrder, Status)
                VALUES (
                    ?, ?, ?,
                    (SELECT COALESCE(MAX(DisplayOrder), 0) + 1 FROM dbo.[Curriculum_Elective] WHERE CurriculumID = ?),
                    ?
                )
                """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, elective.getCurriculumId());
            ps.setInt(2, elective.getSubjectId());
            setNullableString(ps, 3, elective.getElectiveGroupName());
            ps.setInt(4, elective.getCurriculumId());
            ps.setString(5, elective.getStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("createElective error: " + e.getMessage());
        }
        return false;
    }

    private void setNullableString(PreparedStatement ps, int index, String value) throws SQLException {
        if (value == null || value.isBlank()) {
            ps.setNull(index, Types.NVARCHAR);
        } else {
            ps.setString(index, value.trim());
        }
    }

    private CurriculumElective mapElective(ResultSet rs) throws SQLException {
        CurriculumElective elective = new CurriculumElective();
        elective.setCurriculumElectiveId(rs.getInt("CurriculumElectiveID"));
        elective.setCurriculumId(rs.getInt("CurriculumID"));
        elective.setSubjectId(rs.getInt("SubjectID"));
        elective.setElectiveGroupName(rs.getString("ElectiveGroupName"));

        int displayOrder = rs.getInt("DisplayOrder");
        elective.setDisplayOrder(rs.wasNull() ? null : displayOrder);

        elective.setStatus(rs.getString("Status"));
        elective.setSubjectCode(rs.getString("SubjectCode"));
        elective.setSubjectName(rs.getString("SubjectName"));
        elective.setCredits(rs.getInt("Credits"));
        return elective;
    }
}
