<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đổi mật khẩu</title>
    <style>
        :root {
            --orange: #f37021;
            --orange-dark: #d95f12;
            --text: #1f2937;
            --muted: #6b7280;
            --border: #eaded4;
            --danger: #dc3545;
        }
        * { box-sizing: border-box; }
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            font-family: "Segoe UI", Arial, sans-serif;
            background:
                linear-gradient(135deg, rgba(255, 255, 255, 0.96), rgba(255, 241, 231, 0.98)),
                radial-gradient(circle at 15% 20%, rgba(243, 112, 33, 0.1), transparent 26%);
        }
        .card {
            width: 100%;
            max-width: 420px;
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 14px;
            box-shadow: 0 14px 40px rgba(0, 0, 0, 0.12);
            padding: 22px;
        }
        h2 {
            margin: 0;
            text-align: center;
            color: var(--orange-dark);
            font-size: 22px;
            font-weight: 800;
        }
        .subtitle {
            text-align: center;
            margin-top: 6px;
            color: var(--muted);
            font-size: 13px;
        }
        .message, .error {
            margin: 14px 0 10px;
            padding: 10px 12px;
            border-radius: 10px;
            font-size: 13px;
            text-align: center;
            line-height: 1.5;
        }
        .message {
            border: 1px solid rgba(243, 112, 33, 0.22);
            background: #fff7f0;
            color: var(--orange-dark);
        }
        .error {
            border: 1px solid rgba(220, 53, 69, 0.35);
            background: rgba(220, 53, 69, 0.08);
            color: var(--danger);
        }
        form { margin-top: 14px; }
        .row { margin-bottom: 12px; }
        label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 6px;
        }
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
        input:focus {
            border-color: rgba(243, 112, 33, 0.9);
            box-shadow: 0 0 0 0.2rem rgba(243, 112, 33, 0.16);
        }
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
            background: var(--orange);
            color: #fff;
            font-size: 15px;
            font-weight: 700;
            margin-top: 6px;
        }
        .btn-primary:hover { background: var(--orange-dark); }
        .hint {
            text-align: center;
            margin-top: 12px;
            font-size: 13px;
            color: var(--muted);
        }
        .hint a {
            color: var(--orange-dark);
            text-decoration: none;
            font-weight: 700;
        }
    </style>
    <script>
        function validateChangePassword() {
            const oldPass = document.getElementById("oldPassword").value;
            const newPass = document.getElementById("newPassword").value;
            const confirmPass = document.getElementById("confirmPassword").value;

            if (!oldPass || !newPass || !confirmPass) {
                alert("Vui lòng nhập đầy đủ thông tin.");
                return false;
            }

            if (newPass.length < 6) {
                alert("Mật khẩu mới phải từ 6 ký tự trở lên.");
                return false;
            }

            if (newPass !== confirmPass) {
                alert("Xác nhận mật khẩu mới không khớp.");
                return false;
            }

            return true;
        }

        function togglePassword(id, button) {
            const input = document.getElementById(id);
            input.type = input.type === "password" ? "text" : "password";
            button.textContent = input.type === "password" ? "Hiện" : "Ẩn";
        }
    </script>
</head>
<body>
<div class="card">
    <h2>Đổi mật khẩu</h2>
    <div class="subtitle">Cập nhật mật khẩu để tăng bảo mật cho tài khoản.</div>

    <% if (message != null) { %>
    <div class="message"><%= message %></div>
    <% } %>

    <% if (error != null) { %>
    <div class="error"><%= error %></div>
    <% } %>

    <form method="post" action="<%=request.getContextPath()%>/change-password" onsubmit="return validateChangePassword();">
        <div class="row">
            <label for="oldPassword">Mật khẩu hiện tại</label>
            <div class="input-wrap">
                <input id="oldPassword" type="password" name="oldPassword" placeholder="Nhập mật khẩu hiện tại" />
                <button class="toggle-pass" type="button" onclick="togglePassword('oldPassword', this)">Hiện</button>
            </div>
        </div>

        <div class="row">
            <label for="newPassword">Mật khẩu mới</label>
            <div class="input-wrap">
                <input id="newPassword" type="password" name="newPassword" placeholder="Tối thiểu 6 ký tự" />
                <button class="toggle-pass" type="button" onclick="togglePassword('newPassword', this)">Hiện</button>
            </div>
        </div>

        <div class="row">
            <label for="confirmPassword">Xác nhận mật khẩu mới</label>
            <div class="input-wrap">
                <input id="confirmPassword" type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" />
                <button class="toggle-pass" type="button" onclick="togglePassword('confirmPassword', this)">Hiện</button>
            </div>
        </div>

        <button type="submit" class="btn-primary">Đổi mật khẩu</button>

        <div class="hint">
            <a href="<%=request.getContextPath()%>/profile">Quay lại hồ sơ</a>
        </div>
    </form>
</div>
</body>
</html>
