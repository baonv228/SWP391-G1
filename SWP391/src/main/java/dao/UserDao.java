package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Role;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

public class UserDao extends DBContext {

    public User loginByEmailPassword(String email, String rawPassword) {
        String sql = """
                SELECT u.UserID, u.RoleID, u.Email, u.PasswordHash, u.FullName,
                       u.Status, u.CreatedAt, r.RoleName, r.Description
                FROM dbo.[User] u
                JOIN dbo.[Role] r ON u.RoleID = r.RoleID
                WHERE u.Email = ?
                """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }

                String status = rs.getString("Status");
                String passwordHash = rs.getString("PasswordHash");

                if (status == null || !status.equalsIgnoreCase("Active")) {
                    return null;
                }
                if (passwordHash == null || passwordHash.isBlank()) {
                    return null;
                }
                if (!BCrypt.checkpw(rawPassword, passwordHash)) {
                    return null;
                }

                Role role = new Role(
                        rs.getInt("RoleID"),
                        rs.getString("RoleName"),
                        rs.getString("Description")
                );

                User user = new User();
                user.setUserId(rs.getInt("UserID"));
                user.setRole(role);
                user.setEmail(rs.getString("Email"));
                user.setPasswordHash(passwordHash);
                user.setFullName(rs.getString("FullName"));
                user.setStatus(status);
                user.setCreatedAt(rs.getTimestamp("CreatedAt"));
                return user;
            }
        } catch (Exception e) {
            System.out.println("loginByEmailPassword error: " + e.getMessage());
            return null;
        }
    }

    public boolean registerStudent(String email, String rawPassword) {
        Integer studentRoleId = getRoleIdByName("Student");
        if (studentRoleId == null) {
            System.out.println("registerStudent error: khong tim thay role Student.");
            return false;
        }

        String fullName = email.substring(0, email.indexOf("@"));
        String passwordHash = hashPassword(rawPassword);
        String sql = """
                INSERT INTO dbo.[User](RoleID, Email, PasswordHash, FullName, Status, CreatedAt)
                VALUES (?, ?, ?, ?, 'Active', GETDATE())
                """;

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentRoleId);
            ps.setString(2, email);
            ps.setString(3, passwordHash);
            ps.setString(4, fullName);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("registerStudent error: " + e.getMessage());
            return false;
        }
    }

    public boolean registerCustomer(String fullName, String email, String phone, String rawPassword) {
        return registerStudent(email, rawPassword);
    }

    public String hashPassword(String rawPassword) {
        return BCrypt.hashpw(rawPassword, BCrypt.gensalt(10));
    }

    public boolean existsEmail(String email) {
        String sql = "SELECT COUNT(*) FROM dbo.[User] WHERE Email = ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            System.out.println("existsEmail error: " + e.getMessage());
            return false;
        }
    }

    public boolean existsPhone(String phone) {
        return false;
    }

    public Integer getRoleIdByName(String roleName) {
        String sql = "SELECT RoleID FROM dbo.[Role] WHERE RoleName = ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, roleName);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("RoleID");
                }
            }
        } catch (Exception e) {
            System.out.println("getRoleIdByName error: " + e.getMessage());
        }
        return null;
    }

    public List<User> getAllUsers() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = """
                SELECT u.UserID, u.RoleID, u.Email, u.PasswordHash, u.FullName,
                       u.Status, u.CreatedAt, r.RoleName, r.Description
                FROM dbo.[User] u
                JOIN dbo.[Role] r ON u.RoleID = r.RoleID
                ORDER BY u.UserID
                """;

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Timestamp createdAt = rs.getTimestamp("CreatedAt");
                Role role = new Role(rs.getInt("RoleID"), rs.getString("RoleName"), rs.getString("Description"));

                User user = new User();
                user.setUserId(rs.getInt("UserID"));
                user.setRole(role);
                user.setEmail(rs.getString("Email"));
                user.setPasswordHash(rs.getString("PasswordHash"));
                user.setFullName(rs.getString("FullName"));
                user.setStatus(rs.getString("Status"));
                user.setCreatedAt(createdAt);
                list.add(user);
            }
        }
        return list;
    }
}
