package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Role;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

public class UserDao extends DBContext {

    private static final String BASE_SELECT = """
            SELECT u.UserID, u.RoleID, u.Email, u.Phone, u.PasswordHash, u.FullName,
                   u.Status, u.CreatedAt, r.RoleName, r.Description
            FROM `User` u
            JOIN `Role` r ON u.RoleID = r.RoleID
            """;

    // Doc 1 user tu ResultSet hien tai
    private User mapUser(ResultSet rs) throws SQLException {
        Role role = new Role(
                rs.getInt("RoleID"),
                rs.getString("RoleName"),
                rs.getString("Description")
        );
        User user = new User();
        user.setUserId(rs.getInt("UserID"));
        user.setRole(role);
        user.setEmail(rs.getString("Email"));
        user.setPhone(rs.getString("Phone"));
        user.setPasswordHash(rs.getString("PasswordHash"));
        user.setFullName(rs.getString("FullName"));
        user.setStatus(rs.getString("Status"));
        user.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return user;
    }

    // Dang nhap: tra ve User neu email/mat khau dung va tai khoan dang Active
    public User loginByEmailPassword(String email, String rawPassword) {
        String sql = BASE_SELECT + " WHERE u.Email = ?";
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
                return mapUser(rs);
            }
        } catch (Exception e) {
            System.out.println("loginByEmailPassword error: " + e.getMessage());
            return null;
        }
    }

    // Tim user theo email (khong kiem tra mat khau)
    public User findByEmail(String email) {
        String sql = BASE_SELECT + " WHERE u.Email = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapUser(rs) : null;
            }
        } catch (Exception e) {
            System.out.println("findByEmail error: " + e.getMessage());
            return null;
        }
    }

    // Tim user theo id
    public User findById(int userId) {
        String sql = BASE_SELECT + " WHERE u.UserID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapUser(rs) : null;
            }
        } catch (Exception e) {
            System.out.println("findById error: " + e.getMessage());
            return null;
        }
    }

    // Dang ky tai khoan Student (giu cho luong dang ky mac dinh)
    public boolean registerStudent(String email, String rawPassword) {
        String fullName = email.substring(0, email.indexOf("@"));
        return register(fullName, email, null, rawPassword, "Student");
    }

    // Dang ky tai khoan tong quat theo ten role
    public boolean register(String fullName, String email, String phone, String rawPassword, String roleName) {
        Integer roleId = getRoleIdByName(roleName);
        if (roleId == null) {
            System.out.println("register error: khong tim thay role " + roleName);
            return false;
        }
        String passwordHash = hashPassword(rawPassword);
        String sql = """
                INSERT INTO `User`(RoleID, Email, Phone, PasswordHash, FullName, Status, CreatedAt)
                VALUES (?, ?, ?, ?, ?, 'Active', NOW())
                """;
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, passwordHash);
            ps.setString(5, fullName);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("register error: " + e.getMessage());
            return false;
        }
    }

    // Cap nhat thong tin ho so (User Profile)
    public boolean updateProfile(int userId, String fullName, String phone) {
        String sql = "UPDATE `User` SET FullName = ?, Phone = ? WHERE UserID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("updateProfile error: " + e.getMessage());
            return false;
        }
    }

    // Cap nhat mat khau (dung cho Change Password va Password Reset)
    public boolean updatePassword(int userId, String newRawPassword) {
        String sql = "UPDATE `User` SET PasswordHash = ? WHERE UserID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, hashPassword(newRawPassword));
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("updatePassword error: " + e.getMessage());
            return false;
        }
    }

    public String hashPassword(String rawPassword) {
        return BCrypt.hashpw(rawPassword, BCrypt.gensalt(10));
    }

    public boolean existsEmail(String email) {
        String sql = "SELECT COUNT(*) FROM `User` WHERE Email = ?";
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

    public Integer getRoleIdByName(String roleName) {
        String sql = "SELECT RoleID FROM `Role` WHERE RoleName = ?";
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
        String sql = BASE_SELECT + " ORDER BY u.UserID";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        }
        return list;
    }
}
