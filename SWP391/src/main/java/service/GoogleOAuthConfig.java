package service;

import jakarta.servlet.http.HttpServletRequest;

/**
 * Cau hinh Google OAuth2 cho chuc nang "Login with Google".
 *
 * CACH LAY CLIENT_ID / CLIENT_SECRET:
 *  1. Vao https://console.cloud.google.com/ -> tao Project.
 *  2. APIs & Services -> OAuth consent screen -> cau hinh (External, them email test).
 *  3. APIs & Services -> Credentials -> Create Credentials -> OAuth client ID
 *     -> Application type: Web application.
 *  4. Them "Authorized redirect URI" trung KHOP voi callback URL cua ung dung, vi du:
 *     http://localhost:8080/SWP391/login/google/callback
 *  5. Copy Client ID va Client Secret dan vao day.
 *
 * LUU Y: khong commit Client Secret that len GitHub cong khai.
 */
public final class GoogleOAuthConfig {

    private GoogleOAuthConfig() {
    }

    public static final String CLIENT_ID = "873214167278-uigpmld27etbed5p80hu4it4qdt9pbh9.apps.googleusercontent.com";

    // TODO: thay bang Client Secret that (Google Cloud Console -> Credentials -> OAuth client)
    public static final String CLIENT_SECRET = "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";

    // Pham vi truy cap: email + thong tin co ban
    public static final String SCOPES = "openid email profile";

    // Buoc chon tai khoan Google / "Su dung tai khoan khac"
    public static final String PROMPT = "select_account";

    public static String buildRedirectUri(HttpServletRequest request) {
        return request.getScheme()
                + "://"
                + request.getServerName()
                + ":"
                + request.getServerPort()
                + request.getContextPath()
                + "/login/google/callback";
    }
}
