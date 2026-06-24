package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.regex.Pattern;
import model.User;
import service.UserService;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = safeTrim(request.getParameter("action"));
        if (!action.isEmpty() && !"login".equalsIgnoreCase(action)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Yêu cầu không hợp lệ.");
            return;
        }

        String email = safeTrim(request.getParameter("email")).toLowerCase();
        String password = request.getParameter("password");
        if (password == null) {
            password = "";
        }

        request.setAttribute("emailValue", email);

        if (email.isEmpty() || password.isEmpty()) {
            setErrorAndForward("Vui lòng nhập đầy đủ Email và mật khẩu.", request, response);
            return;
        }

        if (!EMAIL_PATTERN.matcher(email).matches()) {
            setErrorAndForward("Email đăng nhập không hợp lệ.", request, response);
            return;
        }

        System.out.println("[DEBUG Login] Email input: " + email);
        User user = userService.authenticate(email, password);
        System.out.println("[DEBUG Login] Authenticate result: " + (user == null ? "NULL" : "User found (" + user.getFullName() + ", Status=" + user.getStatus() + ")"));
        if (user == null) {
            // Kiem tra xem tai khoan co bi vo hieu hoa hay khong
            boolean isDeactivated = userService.isAccountDeactivated(email);
            System.out.println("[DEBUG Login] isAccountDeactivated result: " + isDeactivated);
            if (isDeactivated) {
                setErrorAndForward("Tài khoản đã bị vô hiệu hóa. Vui lòng liên hệ Admin để được hỗ trợ.", request, response);
            } else {
                setErrorAndForward("Email hoặc mật khẩu không đúng.", request, response);
            }
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);
        session.setAttribute("roleId", user.getRoleId());
        if (user.getRole() != null) {
            session.setAttribute("roleName", user.getRole().getRoleName());
        }
        response.sendRedirect(request.getContextPath() + "/home");
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private void setErrorAndForward(String message, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/view/login.jsp").forward(request, response);
    }
}
