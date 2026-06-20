package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.regex.Pattern;
import service.ServiceResult;
import service.UserService;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private static final Pattern GMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9._%+-]+@gmail\\.com$");
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = safeTrim(request.getParameter("action"));
        if (!"register".equalsIgnoreCase(action)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Yeu cau khong hop le.");
            return;
        }

        String fullName = safeTrim(request.getParameter("fullName"));
        String email = safeTrim(request.getParameter("email")).toLowerCase();
        String phone = safeTrim(request.getParameter("phone"));
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        if (password == null) {
            password = "";
        }
        if (confirmPassword == null) {
            confirmPassword = "";
        }

        request.setAttribute("fullNameValue", fullName);
        request.setAttribute("emailValue", email);
        request.setAttribute("phoneValue", phone);

        if (fullName.isEmpty() || email.isEmpty() || password.isEmpty() || confirmPassword.isEmpty()) {
            setErrorAndForward("Vui lòng nhập đầy đủ Họ tên, Gmail và mật khẩu.", request, response);
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

        ServiceResult result = userService.register(fullName, email, phone.isEmpty() ? null : phone, password);
        if (!result.isSuccess()) {
            setErrorAndForward(result.getMessage(), request, response);
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
        request.getRequestDispatcher("/view/register.jsp").forward(request, response);
    }
}
