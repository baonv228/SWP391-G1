<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
    String success = request.getParameter("success");
    String emailValue = (String) request.getAttribute("emailValue");
    if (emailValue == null) {
        emailValue = "";
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Đăng nhập</title>
        <style>
            :root {
                --green: #28a745;
                --green-dark: #218838;
                --text: #1f2a37;
                --muted: #6b7280;
                --border: #e5e7eb;
                --danger: #dc3545;
            }

            * {
                box-sizing: border-box;
            }

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
                color: var(--green);
                font-size: 22px;
                font-weight: 800;
            }

            .subtitle {
                text-align: center;
                margin-top: 6px;
                color: var(--muted);
                font-size: 13px;
            }

            .message,
            .error {
                margin: 14px 0 10px;
                padding: 10px 12px;
                border-radius: 10px;
                font-size: 13px;
                text-align: center;
            }

            .message {
                border: 1px solid #b7f0c2;
                background: #ecfff1;
                color: #0b6b2f;
            }

            .error {
                border: 1px solid rgba(220, 53, 69, 0.35);
                background: rgba(220, 53, 69, 0.08);
                color: var(--danger);
            }

            form {
                margin-top: 14px;
            }

            .row {
                margin-bottom: 12px;
            }

            label {
                display: block;
                font-size: 13px;
                font-weight: 600;
                color: #374151;
                margin-bottom: 6px;
            }

            .input-wrap {
                position: relative;
            }

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
                border-color: rgba(40, 167, 69, 0.9);
                box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.18);
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

            .btn-login {
                width: 100%;
                border: none;
                cursor: pointer;
                border-radius: 10px;
                padding: 10px 12px;
                background: var(--green);
                color: #fff;
                font-size: 15px;
                font-weight: 700;
            }

            .btn-login:hover {
                background: var(--green-dark);
            }

            .register-now {
                text-align: center;
                margin-top: 12px;
                font-size: 13px;
                color: var(--muted);
            }

            .register-now a {
                color: #0d6efd;
                text-decoration: none;
                font-weight: 700;
            }
        </style>
        <script>
            function validateLoginForm() {
                const email = document.getElementById("email").value.trim();
                const pass = document.getElementById("password").value;

                if (!email || !pass) {
                    alert("Vui lòng nhập đầy đủ Gmail và mật khẩu.");
                    return false;
                }

                const gmailRegex = /^[A-Za-z0-9._%+-]+@gmail\.com$/;
                if (!gmailRegex.test(email)) {
                    alert("Email đăng nhập phải là địa chỉ Gmail hợp lệ.");
                    return false;
                }

                if (pass.length < 6) {
                    alert("Mật khẩu phải từ 6 ký tự trở lên.");
                    return false;
                }

                return true;
            }

            function togglePassword() {
                const input = document.getElementById("password");
                const btn = document.querySelector(".toggle-pass");
                input.type = input.type === "password" ? "text" : "password";
                btn.textContent = input.type === "password" ? "Hiện" : "Ẩn";
            }
        </script>
    </head>
    <body>
        <div class="card">
            <h2>Đăng nhập</h2>
            <div class="subtitle">Nhập Gmail và mật khẩu để tiếp tục.</div>

            <% if ("1".equals(success)) { %>
            <div class="message">Đăng ký thành công. Vui lòng đăng nhập.</div>
            <% } %>

            <% if (error != null) { %>
            <div class="error"><%= error %></div>
            <% } %>

            <form method="post" action="<%=request.getContextPath()%>/login" onsubmit="return validateLoginForm();">
                <input type="hidden" name="action" value="login"/>

                <div class="row">
                    <label for="email">Gmail</label>
                    <input id="email" type="email" name="email" value="<%= emailValue %>" placeholder="example@gmail.com"/>
                </div>

                <div class="row">
                    <label for="password">Mật khẩu</label>
                    <div class="input-wrap">
                        <input id="password" type="password" name="password" placeholder="Nhập mật khẩu"/>
                        <button class="toggle-pass" type="button" onclick="togglePassword()">Hiện</button>
                    </div>
                </div>

                <button type="submit" class="btn-login">Đăng nhập</button>

                <div class="register-now">
                    Bạn chưa có tài khoản?
                    <a href="<%=request.getContextPath()%>/register">Đăng ký ngay</a>
                </div>
            </form>
        </div>
    </body>
</html>
