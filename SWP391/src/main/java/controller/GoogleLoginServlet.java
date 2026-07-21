package controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeRequestUrl;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.UUID;
import model.User;
import service.GoogleOAuthConfig;
import service.UserService;

/**
 * Login with Google theo luong Authorization Code (OAuth2).
 *  - GET /login/google           : chuyen huong nguoi dung sang trang dang nhap Google.
 *  - GET /login/google/callback  : nhan code, doi lay token, lay email/ten, dang nhap.
 */
@WebServlet(name = "GoogleLoginServlet", urlPatterns = {"/login/google", "/login/google/callback"})
public class GoogleLoginServlet extends HttpServlet {

    private static final String SESSION_STATE = "google_oauth_state";
    private static final String SESSION_REDIRECT_URI = "google_oauth_redirect_uri";
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getServletPath().endsWith("/callback")) {
            handleCallback(request, response);
        } else {
            handleStart(request, response);
        }
    }

    // Buoc 1: tao state chong CSRF va chuyen huong sang Google (chon tai khoan)
    private void handleStart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String state = UUID.randomUUID().toString();
        String redirectUri = GoogleOAuthConfig.buildRedirectUri(request);

        HttpSession session = request.getSession(true);
        session.setAttribute(SESSION_STATE, state);
        session.setAttribute(SESSION_REDIRECT_URI, redirectUri);

        // Dùng set("prompt", ...) thay vì setPrompt() vì một số bản google-api-client không có method đó
        GoogleAuthorizationCodeRequestUrl authRequest = new GoogleAuthorizationCodeRequestUrl(
                GoogleOAuthConfig.CLIENT_ID,
                redirectUri,
                Arrays.asList(GoogleOAuthConfig.SCOPES.split(" ")));
        authRequest.setState(state);
        authRequest.set("prompt", GoogleOAuthConfig.PROMPT);
        response.sendRedirect(authRequest.build());
    }

    // Buoc 2: xu ly callback tu Google
    private void handleCallback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String error = request.getParameter("error");
        if (error != null) {
            redirectLoginError(request, response, "Bạn đã hủy đăng nhập bằng Google.");
            return;
        }

        // Kiem tra state
        HttpSession session = request.getSession(false);
        String expectedState = session == null ? null : (String) session.getAttribute(SESSION_STATE);
        String state = request.getParameter("state");
        if (expectedState == null || !expectedState.equals(state)) {
            redirectLoginError(request, response, "Phiên đăng nhập Google không hợp lệ. Vui lòng thử lại.");
            return;
        }
        session.removeAttribute(SESSION_STATE);

        String redirectUri = (String) session.getAttribute(SESSION_REDIRECT_URI);
        session.removeAttribute(SESSION_REDIRECT_URI);
        if (redirectUri == null || redirectUri.isBlank()) {
            redirectUri = GoogleOAuthConfig.buildRedirectUri(request);
        }

        String code = request.getParameter("code");
        if (code == null || code.isBlank()) {
            redirectLoginError(request, response, "Không nhận được mã xác thực từ Google.");
            return;
        }

        try {
            // Doi code lay token
            GoogleTokenResponse tokenResponse = new GoogleAuthorizationCodeTokenRequest(
                    new NetHttpTransport(),
                    GsonFactory.getDefaultInstance(),
                    GoogleOAuthConfig.CLIENT_ID,
                    GoogleOAuthConfig.CLIENT_SECRET,
                    code,
                    redirectUri)
                    .execute();

            // Lay email + ten tu id_token
            GoogleIdToken idToken = tokenResponse.parseIdToken();
            GoogleIdToken.Payload payload = idToken.getPayload();
            String email = payload.getEmail();
            Boolean emailVerified = payload.getEmailVerified();
            String fullName = (String) payload.get("name");

            if (email == null || (emailVerified != null && !emailVerified)) {
                redirectLoginError(request, response, "Tài khoản Google chưa xác thực email.");
                return;
            }

            User user = userService.loginWithGoogle(email.toLowerCase(), fullName);
            if (user == null) {
                redirectLoginError(request, response, "Tài khoản đã bị vô hiệu hóa. Vui lòng liên hệ Admin để được hỗ trợ.");
                return;
            }

            HttpSession loginSession = request.getSession(true);
            loginSession.setAttribute("user", user);
            loginSession.setAttribute("roleId", user.getRoleId());
            if (user.getRole() != null) {
                loginSession.setAttribute("roleName", user.getRole().getRoleName());
            }

            // Vao he thong theo vai tro (giong dang nhap thuong)
            response.sendRedirect(request.getContextPath() + "/home");
        } catch (Exception e) {
            System.out.println("GoogleLogin callback error: " + e.getMessage());
            redirectLoginError(request, response, "Đăng nhập bằng Google thất bại. Vui lòng thử lại.");
        }
    }

    private void redirectLoginError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/view/login.jsp").forward(request, response);
    }
}
