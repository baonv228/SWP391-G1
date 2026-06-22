<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
    String token = (String) request.getAttribute("token");
    Boolean invalidToken = (Boolean) request.getAttribute("invalidToken");
    if (token == null) {
        token = "";
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Đặt lại mật khẩu</title>
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
                max-width: 440px;
                background: #fff;
                border: 1px solid var(--border);
                border-radius: 14px;
                box-shadow: 0 14px 40px rgba(0, 0, 0, 0.12);
                padding: 22px;
            }
            h2 { margin: 0; text-align: center; color: var(--green); font-size: 22px; font-weight: 800; }
            .subtitle { text-align: center; margin-top: 6px; color: var(--muted); font-size: 13px; }
            .error {
                margin: 14px 0 10px;
                padding: 10px 12px;
                border-radius: 10px;
                border: 1px solid rgba(220, 53, 69, 0.35);
                background: rgba(220, 53, 69, 0.08);
                color: var(--danger);
                font-size: 13px;
                text-align: center;
                line-height: 1.5;
            }
            form { margin-top: 14px; }
            .row { margin-bottom: 12px; }
            label { display: block; font-size: 13px; font-weight: 600; color: #374151; margin-bottom: 6px; }
            .input-wrap { position: relative; }
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
            input:focus { border-color: rgba(40, 167, 69, 0.9); box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.18); }
            .toggle-pass {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                border: none;
                background: transparent;
                cursor: pointer;
                color: #6b7280;
                padding: 4px 6px;
                font-size: 13px;
            }
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
            .hint { text-align: center; margin-top: 12px; font-size: 13px; color: var(--muted); }
            .hint a { color: #0d6efd; text-decoration: none; font-weight: 700; }
        </style>
        <script>
            function validateReset() {
                const newPass = document.getElementById("newPassword").value;
                const confirmPass = document.getElementById("confirmPassword").value;

                if (!newPass || !confirmPass) {
                    alert("Vui lòng nhập đầy đủ mật khẩu mới.");
                    return false;
                }

                if (newPass.length < 6) {
                    alert("Mật khẩu mới phải từ 6 ký tự trở lên.");
                    return false;
                }

                if (newPass !== confirmPass) {
                    alert("Xác nhận mật khẩu không khớp.");
                    return false;
                }

                return true;
            }

            function togglePass(id, button) {
                const input = document.getElementById(id);
                input.type = input.type === "password" ? "text" : "password";
                button.textContent = input.type === "password" ? "Hiện" : "Ẩn";
            }
        </script>
    </head>
    <body>
        <div class="card">
            <h2>Đặt lại mật khẩu</h2>
            <div class="subtitle">Tạo mật khẩu mới cho tài khoản của bạn.</div>

            <% if (invalidToken != null && invalidToken) { %>
            <div class="error">Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.</div>
            <% } %>

            <% if (error != null) { %>
            <div class="error"><%= error %></div>
            <% } %>

            <form method="post" action="<%=request.getContextPath()%>/reset-password" onsubmit="return validateReset();">
                <input type="hidden" name="token" value="<%= token %>" />

                <div class="row">
                    <label for="newPassword">Mật khẩu mới</label>
                    <div class="input-wrap">
                        <input id="newPassword" type="password" name="newPassword" placeholder="Tối thiểu 6 ký tự" />
                        <button type="button" class="toggle-pass" onclick="togglePass('newPassword', this)">Hiện</button>
                    </div>
                </div>

                <div class="row">
                    <label for="confirmPassword">Xác nhận mật khẩu</label>
                    <div class="input-wrap">
                        <input id="confirmPassword" type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" />
                        <button type="button" class="toggle-pass" onclick="togglePass('confirmPassword', this)">Hiện</button>
                    </div>
                </div>

                <button class="btn-primary" type="submit">Đặt lại mật khẩu</button>
            </form>

            <div class="hint">
                <a href="<%=request.getContextPath()%>/forgot-password">Yêu cầu liên kết mới</a>
            </div>
        </div>
    </body>
</html>
