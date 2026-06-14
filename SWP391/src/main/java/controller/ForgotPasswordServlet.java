package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.regex.Pattern;
import service.UserService;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    private static final Pattern GMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9._%+-]+@gmail\\.com$");
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = safeTrim(request.getParameter("email")).toLowerCase();
        request.setAttribute("emailValue", email);

        if (email.isEmpty() || !GMAIL_PATTERN.matcher(email).matches()) {
            request.setAttribute("error", "Vui lòng nhập địa chỉ Gmail hợp lệ.");
            request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
            return;
        }

        String token = userService.createResetToken(email);
        // Khong tiet lo email co ton tai hay khong: luon hien thong bao chung.
        request.setAttribute("message",
                "Nếu Gmail tồn tại trong hệ thống, liên kết đặt lại mật khẩu sẽ được tạo.");
        if (token != null) {
            // Che do dev: hien link dat lai truc tiep (chua tich hop Email Service)
            String resetLink = request.getScheme() + "://" + request.getServerName()
                    + ":" + request.getServerPort() + request.getContextPath()
                    + "/reset-password?token=" + token;
            request.setAttribute("resetLink", resetLink);
        }
        request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
