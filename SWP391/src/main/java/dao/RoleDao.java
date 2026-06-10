package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Role;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author ADMIN
 */
public class RoleDao {

    public List<Role> getAllRole() throws SQLException {
        List<Role> list = new ArrayList<>();
        String sql = """
        SELECT *
        FROM role 
    """;

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            Role role = new Role();
            role.setRoleId(rs.getInt("user_id"));
            role.setRoleName(rs.getString("full_name"));

            list.add(role);
        }
        return list;
    }

    public Role getRoleById(int roleId) {
        String sql = "SELECT role_name FROM role WHERE role_id = ?";
        try {Connection conn = DBContext.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Role role = new Role();
                
                role.setRoleName(rs.getString("role_name"));
                return role;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
