package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import model.PasswordResetToken;

/**
 * Truy van bang PasswordResetToken (MySQL) cho chuc nang Password Reset.
 */
public class PasswordResetTokenDao extends DBContext {

    // Tao token moi
    public boolean create(int userId, String token, Timestamp expiresAt) {
        String sql = "INSERT INTO PasswordResetToken(UserID, Token, ExpiresAt, Used) VALUES (?, ?, ?, 0)";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.setTimestamp(3, expiresAt);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("PasswordResetTokenDao.create error: " + e.getMessage());
            return false;
        }
    }

    // Lay token con hieu luc (chua dung, chua het han)
    public PasswordResetToken findValidToken(String token) {
        String sql = """
                SELECT TokenID, UserID, Token, ExpiresAt, Used
                FROM PasswordResetToken
                WHERE Token = ? AND Used = 0 AND ExpiresAt > NOW()
                """;
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new PasswordResetToken(
                            rs.getInt("TokenID"),
                            rs.getInt("UserID"),
                            rs.getString("Token"),
                            rs.getTimestamp("ExpiresAt"),
                            rs.getBoolean("Used")
                    );
                }
            }
        } catch (Exception e) {
            System.out.println("PasswordResetTokenDao.findValidToken error: " + e.getMessage());
        }
        return null;
    }

    // Danh dau token da su dung
    public boolean markUsed(int tokenId) {
        String sql = "UPDATE PasswordResetToken SET Used = 1 WHERE TokenID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, tokenId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("PasswordResetTokenDao.markUsed error: " + e.getMessage());
            return false;
        }
    }
}
