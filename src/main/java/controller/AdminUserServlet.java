package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Role;
import model.User;
import service.UserService;

@WebServlet(name = "AdminUserServlet", urlPatterns = {"/admin/users"})
public class AdminUserServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<User> users = userService.getAllUsers();
        List<Role> roles = userService.getAllRoles();

        request.setAttribute("users", users);
        request.setAttribute("roles", roles);

        String successParam = request.getParameter("success");
        if (successParam != null) {
            switch (successParam) {
                case "add" -> request.setAttribute("successMsg", "Thêm người dùng mới thành công!");
                case "edit" -> request.setAttribute("successMsg", "Cập nhật thông tin thành công!");
                case "reset" -> request.setAttribute("successMsg", "Đặt lại mật khẩu thành công!");
            }
        }

        String errorParam = request.getParameter("error");
        if (errorParam != null) {
            switch (errorParam) {
                case "exist" -> request.setAttribute("errorMsg", "Email đã tồn tại trong hệ thống!");
                case "self_deactivate" -> request.setAttribute("errorMsg", "Không thể tự vô hiệu hóa tài khoản của chính mình!");
                default -> request.setAttribute("errorMsg", "Đã xảy ra lỗi. Vui lòng thử lại!");
            }
        }

        request.getRequestDispatcher("/view/admin_users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) action = "";

        try {
            switch (action) {
                case "add" -> {
                    String fullName = request.getParameter("fullName");
                    String email = request.getParameter("email");
                    String password = request.getParameter("password");
                    int roleId = Integer.parseInt(request.getParameter("roleId"));
                    String status = request.getParameter("status");

                    boolean ok = userService.addUser(fullName, email, password, roleId, status);
                    if (ok) {
                        response.sendRedirect(request.getContextPath() + "/admin/users?success=add");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/users?error=exist");
                    }
                    return;
                }
                case "edit" -> {
                    int userId = Integer.parseInt(request.getParameter("userId"));
                    String fullName = request.getParameter("fullName");
                    int roleId = Integer.parseInt(request.getParameter("roleId"));
                    String status = request.getParameter("status");

                    System.out.println("[DEBUG AdminEdit] Received params: userId=" + userId + ", fullName=" + fullName + ", roleId=" + roleId + ", status=" + status);

                    User loggedInUser = (User) request.getSession().getAttribute("user");
                    if (loggedInUser != null && loggedInUser.getUserId() == userId) {
                        if ("Deactive".equalsIgnoreCase(status)) {
                            System.out.println("[DEBUG AdminEdit] Prevent self-deactivation for loggedInUser=" + loggedInUser.getUserId());
                            response.sendRedirect(request.getContextPath() + "/admin/users?error=self_deactivate");
                            return;
                        }
                    }

                    boolean ok = userService.updateUser(userId, roleId, fullName, status);
                    System.out.println("[DEBUG AdminEdit] db update result: " + ok);
                    if (ok) {
                        // Gui email thong bao khi admin vo hieu hoa tai khoan
                        System.out.println("[DEBUG AdminEdit] Checking if status equals Deactive: status=" + status);
                        if ("Deactive".equalsIgnoreCase(status)) {
                            User targetUser = userService.getById(userId);
                            System.out.println("[DEBUG AdminEdit] targetUser: " + (targetUser == null ? "NULL" : "Email=" + targetUser.getEmail() + ", Name=" + targetUser.getFullName()));
                            if (targetUser != null && targetUser.getEmail() != null) {
                                String subject = "[TPMS] Tài khoản của bạn đã bị vô hiệu hóa";
                                String content = "<div style='font-family:Arial,sans-serif;max-width:600px;margin:auto;'>"
                                        + "<h2 style='color:#e74c3c;'>Thông báo vô hiệu hóa tài khoản</h2>"
                                        + "<p>Xin chào <b>" + targetUser.getFullName() + "</b>,</p>"
                                        + "<p>Tài khoản của bạn trên hệ thống <b>TPMS</b> đã bị <span style='color:#e74c3c;font-weight:bold;'>vô hiệu hóa</span> bởi quản trị viên.</p>"
                                        + "<p>Nếu bạn cho rằng đây là một nhầm lẫn, vui lòng liên hệ với quản trị viên để được hỗ trợ.</p>"
                                        + "<hr style='border:none;border-top:1px solid #eee;'>"
                                        + "<p style='color:#999;font-size:12px;'>Email này được gửi tự động từ hệ thống TPMS. Vui lòng không trả lời email này.</p>"
                                        + "</div>";
                                System.out.println("[DEBUG AdminEdit] Attempting to send email to: " + targetUser.getEmail());
                                boolean emailSent = util.EmailUtility.sendEmail(targetUser.getEmail(), subject, content);
                                System.out.println("[DEBUG AdminEdit] sendEmail return value: " + emailSent);
                            }
                        }
                        response.sendRedirect(request.getContextPath() + "/admin/users?success=edit");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/users?error=fail");
                    }
                    return;
                }
                case "reset-password" -> {
                    int userId = Integer.parseInt(request.getParameter("userId"));
                    String newPassword = request.getParameter("newPassword");

                    boolean ok = userService.resetPasswordAdmin(userId, newPassword);
                    if (ok) {
                        response.sendRedirect(request.getContextPath() + "/admin/users?success=reset");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/users?error=fail");
                    }
                    return;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/users?error=fail");
    }
}
