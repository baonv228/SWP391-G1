package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.UUID;
import model.GoogleAccount;
import model.User;
import service.GoogleUtils;
import service.UserService;
import util.Iconstant;

@WebServlet(name = "GoogleLoginServlet", urlPatterns = {"/login/google", "/login/google/callback"})
public class GoogleLoginServlet extends HttpServlet {

    private static final String SESSION_STATE = "google_oauth_state";
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getServletPath().endsWith("/callback")) {
            handleCallback(request, response);
            return;
        }
        startGoogleLogin(request, response);
    }

    private void startGoogleLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String state = UUID.randomUUID().toString();
        request.getSession(true).setAttribute(SESSION_STATE, state);

        String authorizeUrl = Iconstant.GOOGLE_LINK_AUTHORIZE
                + "?scope=" + encode("email profile openid")
                + "&redirect_uri=" + encode(Iconstant.GOOGLE_REDIRECT_URI)
                + "&response_type=code"
                + "&client_id=" + encode(Iconstant.GOOGLE_CLIENT_ID)
                + "&approval_prompt=force"
                + "&state=" + encode(state);
        response.sendRedirect(authorizeUrl);
    }

    private void handleCallback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getParameter("error") != null) {
            forwardLoginError("Ban da huy dang nhap bang Google.", request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        String state = request.getParameter("state");
        String expectedState = session == null ? null : (String) session.getAttribute(SESSION_STATE);
        if (expectedState == null || !expectedState.equals(state)) {
            forwardLoginError("Phien dang nhap Google khong hop le. Vui long thu lai.", request, response);
            return;
        }
        session.removeAttribute(SESSION_STATE);

        String code = request.getParameter("code");
        if (code == null || code.isBlank()) {
            forwardLoginError("Khong nhan duoc ma xac thuc tu Google.", request, response);
            return;
        }

        try {
            GoogleAccount googleAccount = GoogleUtils.getUserInfo(GoogleUtils.getToken(code));
            if (googleAccount == null || googleAccount.getEmail() == null || !googleAccount.isVerified_email()) {
                forwardLoginError("Tai khoan Google chua xac thuc email.", request, response);
                return;
            }

            User user = userService.loginWithGoogle(googleAccount.getEmail().toLowerCase(), googleAccount.getName());
            if (user == null) {
                forwardLoginError("Email Google chua dang ky hoac tai khoan da bi vo hieu hoa.", request, response);
                return;
            }

            HttpSession loggedInSession = request.getSession(true);
            loggedInSession.setAttribute("user", user);
            loggedInSession.setAttribute("roleId", user.getRoleId());
            if (user.getRole() != null) {
                loggedInSession.setAttribute("roleName", user.getRole().getRoleName());
            }
            response.sendRedirect(request.getContextPath() + "/home");
        } catch (IOException e) {
            getServletContext().log("Google login failed", e);
            forwardLoginError("Dang nhap bang Google that bai. Vui long thu lai.", request, response);
        }
    }

    private void forwardLoginError(String message, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/view/login.jsp").forward(request, response);
    }

    private String encode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}
