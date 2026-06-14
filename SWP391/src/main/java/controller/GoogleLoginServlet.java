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

    // Buoc 1: tao state chong CSRF va chuyen huong sang Google
    private void handleStart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String state = UUID.randomUUID().toString();
        request.getSession(true).setAttribute(SESSION_STATE, state);

        String authUrl = new GoogleAuthorizationCodeRequestUrl(
                GoogleOAuthConfig.CLIENT_ID,
                GoogleOAuthConfig.REDIRECT_URI,
                Arrays.asList(GoogleOAuthConfig.SCOPES.split(" ")))
                .setState(state)
                .build();
        response.sendRedirect(authUrl);
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
                    GoogleOAuthConfig.REDIRECT_URI)
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
                redirectLoginError(request, response, "Tài khoản bị khóa hoặc không thể đăng nhập.");
                return;
            }

            request.getSession(true).setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/index.jsp?loginSuccess=1");
        } catch (Exception e) {
            System.out.println("GoogleLogin callback error: " + e.getMessage());
            redirectLoginError(request, response, "Đăng nhập bằng Google thất bại. Vui lòng thử lại.");
        }
    }

    private void redirectLoginError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
}
