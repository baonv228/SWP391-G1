package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Role;

/**
 * Truy van bang Role (MySQL).
 */
public class RoleDao {

    public List<Role> getAllRole() throws SQLException {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT RoleID, RoleName, Description FROM `Role` ORDER BY RoleID";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Role(
                        rs.getInt("RoleID"),
                        rs.getString("RoleName"),
                        rs.getString("Description")
                ));
            }
        }
        return list;
    }

    public Role getRoleById(int roleId) {
        String sql = "SELECT RoleID, RoleName, Description FROM `Role` WHERE RoleID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Role(
                            rs.getInt("RoleID"),
                            rs.getString("RoleName"),
                            rs.getString("Description")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
