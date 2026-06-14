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
        String token = safeTrim(request.getParameter("token"));
        if (token.isEmpty() || !userService.isResetTokenValid(token)) {
            request.setAttribute("invalidToken", true);
            request.setAttribute("error", "Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
        } else {
            request.setAttribute("token", token);
        }
        request.getRequestDispatcher("/resetpassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = safeTrim(request.getParameter("token"));
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        if (newPassword == null) newPassword = "";
        if (confirmPassword == null) confirmPassword = "";

        request.setAttribute("token", token);

        if (token.isEmpty()) {
            request.setAttribute("invalidToken", true);
            request.setAttribute("error", "Liên kết đặt lại mật khẩu không hợp lệ.");
            request.getRequestDispatcher("/resetpassword.jsp").forward(request, response);
            return;
        }
        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu mới phải từ 6 ký tự trở lên.");
            request.getRequestDispatcher("/resetpassword.jsp").forward(request, response);
            return;
        }
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("/resetpassword.jsp").forward(request, response);
            return;
        }

        ServiceResult result = userService.resetPassword(token, newPassword);
        if (result.isSuccess()) {
            response.sendRedirect(request.getContextPath() + "/login?reset=1");
            return;
        }
        request.setAttribute("invalidToken", true);
        request.setAttribute("error", result.getMessage());
        request.getRequestDispatcher("/resetpassword.jsp").forward(request, response);
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
