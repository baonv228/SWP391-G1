<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
    String emailValue = (String) request.getAttribute("emailValue");
    String fullNameValue = (String) request.getAttribute("fullNameValue");
    String phoneValue = (String) request.getAttribute("phoneValue");
    if (emailValue == null) {
        emailValue = "";
    }
    if (fullNameValue == null) {
        fullNameValue = "";
    }
    if (phoneValue == null) {
        phoneValue = "";
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Đăng ký</title>
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

            .error {
                margin: 14px 0 10px;
                padding: 10px 12px;
                border-radius: 10px;
                border: 1px solid rgba(220, 53, 69, 0.35);
                background: rgba(220, 53, 69, 0.08);
                color: var(--danger);
                font-size: 13px;
                text-align: center;
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

            .btn-primary:hover {
                background: var(--green-dark);
            }

            .hint {
                text-align: center;
                margin-top: 12px;
                font-size: 13px;
                color: var(--muted);
            }

            .hint a {
                color: #0d6efd;
                text-decoration: none;
                font-weight: 700;
            }
        </style>
        <script>
            function validateRegisterForm() {
                const fullName = document.getElementById("fullName").value.trim();
                const email = document.getElementById("email").value.trim();
                const pass = document.getElementById("password").value;
                const confirm = document.getElementById("confirm_password").value;

                if (!fullName || !email || !pass || !confirm) {
                    alert("Vui lòng nhập đầy đủ Họ tên, Gmail và mật khẩu.");
                    return false;
                }

                const gmailRegex = /^[A-Za-z0-9._%+-]+@gmail\.com$/;
                if (!gmailRegex.test(email)) {
                    alert("Email đăng ký phải là địa chỉ Gmail hợp lệ.");
                    return false;
                }

                if (pass.length < 6) {
                    alert("Mật khẩu phải từ 6 ký tự trở lên.");
                    return false;
                }

                if (pass !== confirm) {
                    alert("Xác nhận mật khẩu không khớp.");
                    return false;
                }

                return true;
            }

            function togglePass(id, btn) {
                const input = document.getElementById(id);
                if (!input) {
                    return;
                }
                input.type = input.type === "password" ? "text" : "password";
                btn.textContent = input.type === "password" ? "Hiện" : "Ẩn";
            }
        </script>
    </head>
    <body>
        <div class="card">
            <h2>Đăng ký tài khoản</h2>
            <div class="subtitle">Nhập Gmail và mật khẩu để tạo tài khoản.</div>

            <% if (error != null) { %>
            <div class="error"><%= error %></div>
            <% } %>

            <form method="post" action="<%=request.getContextPath()%>/register" onsubmit="return validateRegisterForm();">
                <input type="hidden" name="action" value="register"/>

                <div class="row">
                    <label for="fullName">Họ và tên</label>
                    <input id="fullName" type="text" name="fullName" value="<%= fullNameValue %>" placeholder="Nguyễn Văn A"/>
                </div>

                <div class="row">
                    <label for="email">Gmail</label>
                    <input id="email" type="email" name="email" value="<%= emailValue %>" placeholder="example@gmail.com"/>
                </div>

                <div class="row">
                    <label for="phone">Số điện thoại (tùy chọn)</label>
                    <input id="phone" type="text" name="phone" value="<%= phoneValue %>" placeholder="0123456789"/>
                </div>

                <div class="row">
                    <label for="password">Mật khẩu</label>
                    <div class="input-wrap">
                        <input id="password" type="password" name="password" placeholder="Tối thiểu 6 ký tự"/>
                        <button type="button" class="toggle-pass" onclick="togglePass('password', this)">Hiện</button>
                    </div>
                </div>

                <div class="row">
                    <label for="confirm_password">Xác nhận mật khẩu</label>
                    <div class="input-wrap">
                        <input id="confirm_password" type="password" name="confirm_password" placeholder="Nhập lại mật khẩu"/>
                        <button type="button" class="toggle-pass" onclick="togglePass('confirm_password', this)">Hiện</button>
                    </div>
                </div>

                <button class="btn-primary" type="submit">Tạo tài khoản</button>
            </form>

            <div class="hint">
                Bạn đã có tài khoản?
                <a href="<%=request.getContextPath()%>/login">Đăng nhập ngay</a>
            </div>
        </div>
    </body>
</html>
