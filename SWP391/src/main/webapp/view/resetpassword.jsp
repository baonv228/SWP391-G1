<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
    String email = (String) request.getAttribute("email");
    Boolean invalidToken = (Boolean) request.getAttribute("invalidToken");
    if (email == null) {
        email = "";
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
            --orange: #f37021;
            --orange-dark: #d95f12;
            --text: #1f2937;
            --muted: #6b7280;
            --border: #eaded4;
            --danger: #dc3545;
        }

        * { box-sizing: border-box; }

        body {
            font-family: "Segoe UI", Arial, sans-serif;
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            background:
                linear-gradient(135deg, rgba(255, 255, 255, 0.96), rgba(255, 241, 231, 0.98)),
                radial-gradient(circle at 15% 20%, rgba(243, 112, 33, 0.1), transparent 26%);
        }

        .card {
            width: 100%;
            max-width: 460px;
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
            display: flex;
            justify-content: space-between;
            gap: 12px;
            margin-top: 12px;
            font-size: 13px;
            color: var(--muted);
            flex-wrap: wrap;
        }

        .hint a {
            color: var(--orange-dark);
            text-decoration: none;
            font-weight: 700;
        }
    </style>
    <script>
        function validateReset() {
            const otp = document.getElementById("otp").value.trim();
            const newPass = document.getElementById("newPassword").value;
            const confirmPass = document.getElementById("confirmPassword").value;

            if (!otp) {
                alert("Vui lòng nhập mã OTP xác thực.");
                return false;
            }

            if (otp.length !== 6 || isNaN(otp)) {
                alert("Mã OTP phải là số gồm 6 chữ số.");
                return false;
            }

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

    <% if (email != null && !email.isEmpty()) { %>
    <div style="text-align: center; margin-top: 6px; font-weight: 600; color: var(--text);">
        Tài khoản: <%= email %>
    </div>
    <% } %>

    <% if (message != null) { %>
    <div style="border: 1px solid rgba(243, 112, 33, 0.22); background: #fff7f0; color: var(--orange-dark); padding: 10px 12px; border-radius: 10px; font-size: 13px; line-height: 1.5; margin: 14px 0 10px; text-align: center;"><%= message %></div>
    <% } %>

    <% if (invalidToken != null && invalidToken) { %>
    <div class="error"><%= error != null ? error : "Phiên đặt lại mật khẩu không hợp lệ hoặc đã hết hạn." %></div>
    <% } %>

    <% if (error != null && (invalidToken == null || !invalidToken)) { %>
    <div class="error"><%= error %></div>
    <% } %>

    <form method="post" action="<%=request.getContextPath()%>/reset-password" onsubmit="return validateReset();">
        <div class="row">
            <label for="otp">Mã xác thực OTP (6 chữ số)</label>
            <input id="otp" type="text" name="otp" placeholder="Nhập 6 chữ số" maxlength="6" required autocomplete="off" />
        </div>

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
        <a href="<%=request.getContextPath()%>/forgot-password">Yêu cầu mã OTP mới</a>
        <a href="<%=request.getContextPath()%>/login">Quay lại đăng nhập</a>
    </div>
</div>
</body>
</html>
