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

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/forgotpassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = safeTrim(request.getParameter("email")).toLowerCase();
        request.setAttribute("emailValue", email);

        if (email.isEmpty() || !EMAIL_PATTERN.matcher(email).matches()) {
            request.setAttribute("error", "Vui lòng nhập địa chỉ Email hợp lệ.");
            request.getRequestDispatcher("/view/forgotpassword.jsp").forward(request, response);
            return;
        }

        model.User user = userService.getUserByEmail(email);
        if (user != null) {
            java.util.Random rand = new java.util.Random();
            int number = rand.nextInt(900000) + 100000;
            String otp = String.valueOf(number);

            jakarta.servlet.http.HttpSession session = request.getSession();
            session.setAttribute("resetOtp", otp);
            session.setAttribute("resetEmail", email);
            session.setAttribute("resetOtpExpiry", System.currentTimeMillis() + 5 * 60 * 1000);

            String subject = "[TPMS] Mã xác thực đặt lại mật khẩu";
            String content = """
                    <h3>Yêu cầu đặt lại mật khẩu</h3>
                    <p>Xin chào,</p>
                    <p>Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn tại hệ thống TPMS.</p>
                    <p>Mã xác thực OTP đặt lại mật khẩu của bạn là: <b style="font-size: 18px; color: #f37021; letter-spacing: 2px;">%s</b></p>
                    <p>Mã này có hiệu lực trong vòng 5 phút. Vui lòng không chia sẻ mã này với bất kỳ ai.</p>
                    <br/>
                    <p>Nếu bạn không thực hiện yêu cầu này, vui lòng bỏ qua email.</p>
                    <p>Trân trọng,<br/>Đội ngũ phát triển TPMS.</p>
                    """.formatted(otp);

            boolean sent = util.EmailUtility.sendEmail(email, subject, content);
            if (sent) {
                session.setAttribute("resetMessage", "Mã xác thực đã được gửi tới email của bạn. Vui lòng kiểm tra hòm thư.");
                response.sendRedirect(request.getContextPath() + "/reset-password");
                return;
            } else {
                request.setAttribute("error", "Không thể gửi email đặt lại mật khẩu. Vui lòng kiểm tra cấu hình SMTP.");
            }
        } else {
            // Bảo mật thông tin: không thông báo chính xác email có tồn tại hay không
            request.setAttribute("message", "Nếu Email tồn tại trong hệ thống, mã xác thực đã được gửi đến email của bạn.");
        }
        request.getRequestDispatcher("/view/forgotpassword.jsp").forward(request, response);
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
