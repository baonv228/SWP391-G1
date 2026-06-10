package controller;

import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.regex.Pattern;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private static final Pattern GMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9._%+-]+@gmail\\.com$");
    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = safeTrim(request.getParameter("action"));
        if (!"register".equalsIgnoreCase(action)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Yeu cau khong hop le.");
            return;
        }

        String email = safeTrim(request.getParameter("email")).toLowerCase();
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        if (password == null) {
            password = "";
        }
        if (confirmPassword == null) {
            confirmPassword = "";
        }

        request.setAttribute("emailValue", email);

        if (email.isEmpty() || password.isEmpty() || confirmPassword.isEmpty()) {
            setErrorAndForward("Vui lòng nhập đầy đủ Gmail và mật khẩu.", request, response);
            return;
        }

        if (!GMAIL_PATTERN.matcher(email).matches()) {
            setErrorAndForward("Email đăng ký phải là địa chỉ Gmail hợp lệ.", request, response);
            return;
        }

        if (password.length() < 6) {
            setErrorAndForward("Mật khẩu phải từ 6 ký tự trở lên.", request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            setErrorAndForward("Xác nhận mật khẩu không khớp.", request, response);
            return;
        }

        if (userDao.existsEmail(email)) {
            setErrorAndForward("Gmail đã tồn tại. Vui lòng dùng Gmail khác.", request, response);
            return;
        }

        boolean ok = userDao.registerStudent(email, password);
        if (!ok) {
            setErrorAndForward("Đăng ký thất bại. Kiểm tra database đã có role Student chưa.", request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/login?success=1");
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private void setErrorAndForward(String message, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
}
