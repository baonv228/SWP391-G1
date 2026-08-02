package dao;

import model.TrainingProgram;
import model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * NEW — Teacher ↔ Training_Program (major) assignment.
 * Used by Training Department to assign teachers, and by Upload Material to scope syllabi.
 */
public class TeacherProgramDAO extends DBContext {

    public List<TrainingProgram> getProgramsByTeacherId(int userId) throws SQLException {
        List<TrainingProgram> list = new ArrayList<>();
        String sql = """
                SELECT tp.ProgramID, tp.CreatedBy, tp.ProgramCode, tp.ProgramName,
                       tp.MajorName, tp.Description, tp.Status
                FROM dbo.Teacher_Program tpr
                JOIN dbo.Training_Program tp ON tpr.ProgramID = tp.ProgramID
                WHERE tpr.UserID = ?
                ORDER BY tp.ProgramCode
                """;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapProgram(rs));
                }
            }
        }
        return list;
    }

    public List<Integer> getProgramIdsByTeacherId(int userId) throws SQLException {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT ProgramID FROM dbo.Teacher_Program WHERE UserID = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt("ProgramID"));
                }
            }
        }
        return ids;
    }

    public boolean assign(int userId, int programId, int assignedBy) throws SQLException {
        String sql = """
                IF NOT EXISTS (
                    SELECT 1 FROM dbo.Teacher_Program WHERE UserID = ? AND ProgramID = ?
                )
                INSERT INTO dbo.Teacher_Program (UserID, ProgramID, AssignedBy)
                VALUES (?, ?, ?)
                """;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, programId);
            ps.setInt(3, userId);
            ps.setInt(4, programId);
            ps.setInt(5, assignedBy);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean unassign(int userId, int programId) throws SQLException {
        String sql = "DELETE FROM dbo.Teacher_Program WHERE UserID = ? AND ProgramID = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, programId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Replace all program assignments for a teacher in one transaction. */
    public void replaceAssignments(int userId, List<Integer> programIds, int assignedBy) throws SQLException {
        try (Connection con = getConnection()) {
            con.setAutoCommit(false);
            try {
                try (PreparedStatement del = con.prepareStatement(
                        "DELETE FROM dbo.Teacher_Program WHERE UserID = ?")) {
                    del.setInt(1, userId);
                    del.executeUpdate();
                }
                if (programIds != null && !programIds.isEmpty()) {
                    try (PreparedStatement ins = con.prepareStatement(
                            "INSERT INTO dbo.Teacher_Program (UserID, ProgramID, AssignedBy) VALUES (?, ?, ?)")) {
                        for (Integer programId : programIds) {
                            if (programId == null || programId <= 0) continue;
                            ins.setInt(1, userId);
                            ins.setInt(2, programId);
                            ins.setInt(3, assignedBy);
                            ins.addBatch();
                        }
                        ins.executeBatch();
                    }
                }
                con.commit();
            } catch (SQLException e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    public List<User> listTeachersWithAssignments() throws SQLException {
        List<User> teachers = new ArrayList<>();
        String sql = """
                SELECT u.UserID, u.RoleID, u.Email, u.PasswordHash, u.FullName,
                       u.Status, u.CreatedAt, r.RoleName
                FROM dbo.[User] u
                JOIN dbo.[Role] r ON u.RoleID = r.RoleID
                WHERE u.RoleID = 3
                ORDER BY u.FullName, u.Email
                """;
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User(
                        rs.getInt("UserID"),
                        rs.getInt("RoleID"),
                        rs.getString("Email"),
                        rs.getString("PasswordHash"),
                        rs.getString("FullName"),
                        rs.getString("Status"),
                        rs.getTimestamp("CreatedAt")
                );
                model.Role role = new model.Role();
                role.setRoleId(rs.getInt("RoleID"));
                role.setRoleName(rs.getString("RoleName"));
                u.setRole(role);
                teachers.add(u);
            }
        }
        return teachers;
    }

    private TrainingProgram mapProgram(ResultSet rs) throws SQLException {
        TrainingProgram tp = new TrainingProgram();
        tp.setProgramId(rs.getInt("ProgramID"));
        tp.setCreatedBy(rs.getInt("CreatedBy"));
        tp.setProgramCode(rs.getString("ProgramCode"));
        tp.setProgramName(rs.getString("ProgramName"));
        tp.setMajorName(rs.getString("MajorName"));
        tp.setDescription(rs.getString("Description"));
        tp.setStatus(rs.getString("Status"));
        return tp;
    }
}
