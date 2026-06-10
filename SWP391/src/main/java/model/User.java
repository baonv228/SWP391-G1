/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author ADMIN
 */
public class User {

    private int userId;
    private int roleId;
    private String fullName;
    private String email;
    private String phone;
    private String passwordHash;
    private String status;
    private Timestamp createdAt;
    private Role role;
    
    public User() {
    }

    public User(int userId, int roleId, String email, String passwordHash, String fullName, String status, Timestamp createdAt) {
        this.userId = userId;
        this.roleId = roleId;
        this.email = email;
        this.passwordHash = passwordHash;
        this.fullName = fullName;
        this.status = status;
        this.createdAt = createdAt;
    }

    public User(int userId, int roleId, String fullName, String email, String phone, String passwordHash, String status, java.sql.Date createdAt) {
        this(userId, roleId, email, passwordHash, fullName, status, createdAt == null ? null : new Timestamp(createdAt.getTime()));
        this.phone = phone;
    }

    public User(int userId, int roleId, String fullName, String email, String phone, String passwordHash, String status, java.sql.Date createdAt, Role role) {
        this(userId, roleId, fullName, email, phone, passwordHash, status, createdAt);
        this.role = role;
    }

    public User(int userId, int roleId, String email, String passwordHash, String fullName, String status, Timestamp createdAt, Role role) {
        this.userId = userId;
        this.roleId = roleId;
        this.email = email;
        this.passwordHash = passwordHash;
        this.fullName = fullName;
        this.status = status;
        this.createdAt = createdAt;
        this.role = role;
    }

    public Role getRole() {
        return role;
    }

    public Role getRoleName() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
        if (role != null) {
            this.roleId = role.getRoleId();
        }
    }

    public void setRoleName(Role role) {
        setRole(role);
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public void setCreatedAt(java.sql.Date createdAt) {
        this.createdAt = createdAt == null ? null : new Timestamp(createdAt.getTime());
    }

    @Override
    public String toString() {
        return "User{" + "userId=" + userId + ", roleId=" + roleId + ", email=" + email + ", fullName=" + fullName + ", status=" + status + ", createdAt=" + createdAt + ", role=" + role + '}';
    }
}
