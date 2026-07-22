package util;

/** Google OAuth2 settings for local development. */
public final class Iconstant {

    private Iconstant() {
    }

    public static final String GOOGLE_CLIENT_ID =
            "779483089264-9vgukro2j7liahhg5t6o8lhib1efnnka.apps.googleusercontent.com";
    public static final String GOOGLE_CLIENT_SECRET = "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";
    public static final String GOOGLE_REDIRECT_URI = "http://localhost:8080/SWP391/login/google/callback";
    public static final String GOOGLE_GRANT_TYPE = "authorization_code";
    public static final String GOOGLE_LINK_GET_TOKEN = "https://oauth2.googleapis.com/token";
    public static final String GOOGLE_LINK_GET_USER_INFO =
            "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";
    public static final String GOOGLE_LINK_AUTHORIZE = "https://accounts.google.com/o/oauth2/auth";
}
