package service;

/**
 * Cau hinh Google OAuth2 cho chuc nang "Login with Google".
 *
 * CACH LAY CLIENT_ID / CLIENT_SECRET:
 *  1. Vao https://console.cloud.google.com/ -> tao Project.
 *  2. APIs & Services -> OAuth consent screen -> cau hinh (External, them email test).
 *  3. APIs & Services -> Credentials -> Create Credentials -> OAuth client ID
 *     -> Application type: Web application.
 *  4. Them "Authorized redirect URI" trung KHOP voi REDIRECT_URI ben duoi.
 *  5. Copy Client ID va Client Secret dan vao day.
 *
 * LUU Y: khong commit Client Secret that len GitHub cong khai.
 */
public final class GoogleOAuthConfig {

    private GoogleOAuthConfig() {
    }

    // TODO: thay bang Client ID that (dang xxxxx.apps.googleusercontent.com)
    public static final String CLIENT_ID = "YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com";

    // TODO: thay bang Client Secret that
    public static final String CLIENT_SECRET = "YOUR_GOOGLE_CLIENT_SECRET";

    // Phai trung KHOP voi Authorized redirect URI khai bao trong Google Console.
    // Sua context path ("/SWP391_war_exploded") cho dung cau hinh deploy cua ban.
    public static final String REDIRECT_URI =
            "http://localhost:8080/SWP391_war_exploded/login/google/callback";

    // Pham vi truy cap: email + thong tin co ban
    public static final String SCOPES = "openid email profile";
}
