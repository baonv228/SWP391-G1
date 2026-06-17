package controller;

import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.regex.Pattern;
import model.User;

@WebServlet(name = "LoginServlet", urlPatterns = { "/login" })
public class LoginServlet extends HttpServlet {

    private static final Pattern GMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9._%+-]+@gmail\\.com$");
    private final UserDao userDao = new UserDao();

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
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Yeu cau khong hop le.");
            return;
        }

        String email = safeTrim(request.getParameter("email")).toLowerCase();
        String password = request.getParameter("password");
        if (password == null) {
            password = "";
        }

        request.setAttribute("emailValue", email);

        if (email.isEmpty() || password.isEmpty()) {
            setErrorAndForward("Vui lòng nhập đầy đủ Gmail và mật khẩu.", request, response);
            return;
        }

        if (!GMAIL_PATTERN.matcher(email).matches()) {
            setErrorAndForward("Email đăng nhập phải là địa chỉ Gmail hợp lệ.", request, response);
            return;
        }

        if (password.length() < 6) {
            setErrorAndForward("Mật khẩu phải từ 6 ký tự trở lên.", request, response);
            return;
        }

        User user = userDao.loginByEmailPassword(email, password);
        if (user == null) {
            setErrorAndForward("Gmail hoặc mật khẩu không đúng.", request, response);
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
