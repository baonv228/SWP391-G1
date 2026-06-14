package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;
import service.ServiceResult;
import service.UserService;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/change-password"})
public class ChangePasswordServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (getLoggedInUser(request) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/changepassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User current = getLoggedInUser(request);
        if (current == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        if (oldPassword == null) oldPassword = "";
        if (newPassword == null) newPassword = "";
        if (confirmPassword == null) confirmPassword = "";

        if (oldPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            forwardError("Vui lòng nhập đầy đủ thông tin.", request, response);
            return;
        }
        if (newPassword.length() < 6) {
            forwardError("Mật khẩu mới phải từ 6 ký tự trở lên.", request, response);
            return;
        }
        if (!newPassword.equals(confirmPassword)) {
            forwardError("Xác nhận mật khẩu mới không khớp.", request, response);
            return;
        }

        ServiceResult result = userService.changePassword(current.getUserId(), oldPassword, newPassword);
        if (result.isSuccess()) {
            request.setAttribute("message", result.getMessage());
        } else {
            request.setAttribute("error", result.getMessage());
        }
        request.getRequestDispatcher("/changepassword.jsp").forward(request, response);
    }

    private User getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object user = session.getAttribute("user");
        return user instanceof User ? (User) user : null;
    }

    private void forwardError(String message, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/changepassword.jsp").forward(request, response);
    }
}
