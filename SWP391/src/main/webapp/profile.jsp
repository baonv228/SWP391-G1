<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
    String fullName = user.getFullName() == null ? "" : user.getFullName();
    String phone = user.getPhone() == null ? "" : user.getPhone();
    String roleName = user.getRole() == null ? "" : user.getRole().getRoleName();
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Hồ sơ cá nhân</title>
        <style>
            :root {
                --green: #28a745;
                --green-dark: #218838;
                --text: #1f2a37;
                --muted: #6b7280;
                --border: #e5e7eb;
                --danger: #dc3545;
            }
            * { box-sizing: border-box; }
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 24px;
                background: #f3f7f1;
            }
            .card {
                width: 100%;
                max-width: 480px;
                background: #fff;
                border: 1px solid var(--border);
                border-radius: 14px;
                box-shadow: 0 14px 40px rgba(0, 0, 0, 0.12);
                padding: 24px;
            }
            h2 {
                margin: 0 0 4px;
                text-align: center;
                color: var(--green);
                font-size: 22px;
                font-weight: 800;
            }
            .subtitle { text-align: center; color: var(--muted); font-size: 13px; margin-bottom: 14px; }
            .message, .error {
                margin: 10px 0;
                padding: 10px 12px;
                border-radius: 10px;
                font-size: 13px;
                text-align: center;
            }
            .message { border: 1px solid #b7f0c2; background: #ecfff1; color: #0b6b2f; }
            .error { border: 1px solid rgba(220, 53, 69, 0.35); background: rgba(220, 53, 69, 0.08); color: var(--danger); }
            .row { margin-bottom: 12px; }
            label { display: block; font-size: 13px; font-weight: 600; color: #374151; margin-bottom: 6px; }
            input {
                width: 100%;
                padding: 10px 12px;
                border-radius: 10px;
                border: 1px solid var(--border);
                font-size: 14px;
                outline: none;
                background: #fff;
                color: var(--text);
            }
            input:disabled { background: #f3f4f6; color: var(--muted); }
            input:focus { border-color: rgba(40,167,69,0.9); box-shadow: 0 0 0 0.2rem rgba(40,167,69,0.18); }
            .btn-primary {
                width: 100%;
                border: none;
                cursor: pointer;
                border-radius: 10px;
                padding: 10px 12px;
                background: var(--green);
                color: #fff;
                font-size: 15px;
                font-weight: 700;
                margin-top: 6px;
            }
            .btn-primary:hover { background: var(--green-dark); }
            .links { text-align: center; margin-top: 14px; font-size: 13px; color: var(--muted); }
            .links a { color: #0d6efd; text-decoration: none; font-weight: 700; margin: 0 6px; }
        </style>
        <script>
            function validateProfile() {
                const fullName = document.getElementById("fullName").value.trim();
                if (!fullName) {
                    alert("Họ tên không được để trống.");
                    return false;
                }
                return true;
            }
        </script>
    </head>
    <body>
        <div class="card">
            <h2>Hồ sơ cá nhân</h2>
            <div class="subtitle">Xem và cập nhật thông tin tài khoản của bạn.</div>

            <% if (message != null) { %>
            <div class="message"><%= message %></div>
            <% } %>
            <% if (error != null) { %>
            <div class="error"><%= error %></div>
            <% } %>

            <form method="post" action="<%=request.getContextPath()%>/profile" onsubmit="return validateProfile();">
                <div class="row">
                    <label for="email">Gmail</label>
                    <input id="email" type="email" value="<%= user.getEmail() %>" disabled/>
                </div>

                <div class="row">
                    <label for="role">Vai trò</label>
                    <input id="role" type="text" value="<%= roleName %>" disabled/>
                </div>

                <div class="row">
                    <label for="status">Trạng thái</label>
                    <input id="status" type="text" value="<%= user.getStatus() %>" disabled/>
                </div>

                <div class="row">
                    <label for="fullName">Họ và tên</label>
                    <input id="fullName" type="text" name="fullName" value="<%= fullName %>"/>
                </div>

                <div class="row">
                    <label for="phone">Số điện thoại</label>
                    <input id="phone" type="text" name="phone" value="<%= phone %>" placeholder="0123456789"/>
                </div>

                <button class="btn-primary" type="submit">Lưu thay đổi</button>
            </form>

            <div class="links">
                <a href="<%=request.getContextPath()%>/change-password">Đổi mật khẩu</a>
                <a href="<%=request.getContextPath()%>/index.jsp">Trang chủ</a>
                <a href="<%=request.getContextPath()%>/logout">Đăng xuất</a>
            </div>
        </div>
    </body>
</html>
