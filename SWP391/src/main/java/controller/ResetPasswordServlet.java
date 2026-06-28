package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import service.ServiceResult;
import service.UserService;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/reset-password"})
public class ResetPasswordServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = request.getSession();
        String resetOtp = (String) session.getAttribute("resetOtp");
        String resetEmail = (String) session.getAttribute("resetEmail");
        Long resetOtpExpiry = (Long) session.getAttribute("resetOtpExpiry");
        String resetMessage = (String) session.getAttribute("resetMessage");

        if (resetMessage != null) {
            request.setAttribute("message", resetMessage);
            session.removeAttribute("resetMessage");
        }

        if (resetOtp == null || resetEmail == null || resetOtpExpiry == null || System.currentTimeMillis() > resetOtpExpiry) {
            request.setAttribute("invalidToken", true);
            request.setAttribute("error", "Phiên đặt lại mật khẩu không hợp lệ hoặc đã hết hạn (hiệu lực trong 5 phút). Vui lòng yêu cầu mã mới.");
        } else {
            request.setAttribute("email", resetEmail);
        }
        request.getRequestDispatcher("/view/resetpassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String otp = safeTrim(request.getParameter("otp"));
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        if (newPassword == null) newPassword = "";
        if (confirmPassword == null) confirmPassword = "";

        jakarta.servlet.http.HttpSession session = request.getSession();
        String resetOtp = (String) session.getAttribute("resetOtp");
        String resetEmail = (String) session.getAttribute("resetEmail");
        Long resetOtpExpiry = (Long) session.getAttribute("resetOtpExpiry");

        if (resetOtp == null || resetEmail == null || resetOtpExpiry == null || System.currentTimeMillis() > resetOtpExpiry) {
            request.setAttribute("invalidToken", true);
            request.setAttribute("error", "Phiên đặt lại mật khẩu đã hết hạn hoặc không hợp lệ. Vui lòng yêu cầu mã mới.");
            request.getRequestDispatcher("/view/resetpassword.jsp").forward(request, response);
            return;
        }

        request.setAttribute("email", resetEmail);

        if (otp.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mã OTP.");
            request.getRequestDispatcher("/view/resetpassword.jsp").forward(request, response);
            return;
        }
        if (!otp.equals(resetOtp)) {
            request.setAttribute("error", "Mã OTP không chính xác.");
            request.getRequestDispatcher("/view/resetpassword.jsp").forward(request, response);
            return;
        }
        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu mới phải từ 6 ký tự trở lên.");
            request.getRequestDispatcher("/view/resetpassword.jsp").forward(request, response);
            return;
        }
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("/view/resetpassword.jsp").forward(request, response);
            return;
        }

        boolean success = userService.resetPasswordByEmail(resetEmail, newPassword);
        if (success) {
            session.removeAttribute("resetOtp");
            session.removeAttribute("resetEmail");
            session.removeAttribute("resetOtpExpiry");
            response.sendRedirect(request.getContextPath() + "/login?reset=1");
            return;
        }
        request.setAttribute("error", "Đặt lại mật khẩu thất bại. Vui lòng thử lại.");
        request.getRequestDispatcher("/view/resetpassword.jsp").forward(request, response);
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
