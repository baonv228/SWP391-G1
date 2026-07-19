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

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
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
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Yêu cầu không hợp lệ.");
            return;
        }

        String fullName = safeTrim(request.getParameter("fullName"));
        String email = safeTrim(request.getParameter("email")).toLowerCase();
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

        if (fullName.isEmpty() || email.isEmpty() || password.isEmpty() || confirmPassword.isEmpty()) {
            setErrorAndForward("Vui lòng nhập đầy đủ Họ tên, Email và mật khẩu.", request, response);
            return;
        }

        if (!EMAIL_PATTERN.matcher(email).matches()) {
            setErrorAndForward("Email đăng ký không hợp lệ.", request, response);
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

        ServiceResult result = userService.register(fullName, email, password);
        if (!result.isSuccess()) {
            setErrorAndForward(result.getMessage(), request, response);
            return;
        }

        // Gửi email chào mừng khi đăng ký thành công
        String loginLink = request.getScheme() + "://" + request.getServerName()
                + ":" + request.getServerPort() + request.getContextPath()
                + "/login";
        
        String subject = "[TPMS] Đăng ký tài khoản thành công";
        String content = """
                <h3>Chào mừng bạn đến với TPMS!</h3>
                <p>Xin chào <strong>%s</strong>,</p>
                <p>Bạn đã đăng ký tài khoản thành công tại hệ thống Quản lý Chương trình Đào tạo (TPMS).</p>
                <p><strong>Thông tin tài khoản đăng nhập của bạn:</strong></p>
                <ul>
                    <li>Email: %s</li>
                    <li>Vai trò: Student</li>
                </ul>
                <p>Bây giờ bạn có thể đăng nhập vào hệ thống để bắt đầu trải nghiệm.</p>
                <p><a href="%s" style="padding: 10px 20px; background: #f37021; color: white; text-decoration: none; border-radius: 5px; display: inline-block; font-weight: bold;">Đăng nhập ngay</a></p>
                <br/>
                <p>Trân trọng,<br/>Đội ngũ phát triển TPMS.</p>
                """.formatted(fullName, email, loginLink);

        util.EmailUtility.sendEmail(email, subject, content);

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
