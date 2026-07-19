package model;

import java.sql.Timestamp;

/**
 * Token dung mot lan cho chuc nang Password Reset.
 */
public class PasswordResetToken {

    private int tokenId;
    private int userId;
    private String token;
    private Timestamp expiresAt;
    private boolean used;

    public PasswordResetToken() {
    }

    public PasswordResetToken(int tokenId, int userId, String token, Timestamp expiresAt, boolean used) {
        this.tokenId = tokenId;
        this.userId = userId;
        this.token = token;
        this.expiresAt = expiresAt;
        this.used = used;
    }

    public int getTokenId() {
        return tokenId;
    }

    public void setTokenId(int tokenId) {
        this.tokenId = tokenId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Timestamp getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Timestamp expiresAt) {
        this.expiresAt = expiresAt;
    }

    public boolean isUsed() {
        return used;
    }

    public void setUsed(boolean used) {
        this.used = used;
    }
}
