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

            /* ===== Quick Login ===== */
            .quick-login {
                margin: 14px 0 4px;
            }

            .quick-login-label {
                font-size: 11px;
                font-weight: 700;
                letter-spacing: 0.06em;
                text-transform: uppercase;
                color: var(--muted);
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .quick-login-label::before,
            .quick-login-label::after {
                content: '';
                flex: 1;
                height: 1px;
                background: var(--border);
            }

            .quick-cards {
                display: flex;
                gap: 8px;
            }

            .quick-card {
                flex: 1;
                border: 1.5px solid var(--border);
                border-radius: 10px;
                padding: 9px 8px;
                cursor: pointer;
                background: #f9fafb;
                transition: border-color 0.18s, background 0.18s, transform 0.15s, box-shadow 0.18s;
                text-align: center;
                user-select: none;
                position: relative;
                overflow: hidden;
            }

            .quick-card::after {
                content: 'Click để điền';
                position: absolute;
                inset: 0;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 10px;
                font-weight: 700;
                color: #fff;
                background: rgba(40,167,69,0.82);
                border-radius: 8px;
                opacity: 0;
                transition: opacity 0.18s;
            }

            .quick-card:hover::after {
                opacity: 1;
            }

            .quick-card:hover {
                border-color: var(--green);
                background: #f0fff4;
                transform: translateY(-2px);
                box-shadow: 0 4px 14px rgba(40,167,69,0.18);
            }

            .quick-card:active {
                transform: scale(0.96);
            }

            .quick-card .qc-icon {
                font-size: 20px;
                margin-bottom: 4px;
                display: block;
            }

            .quick-card .qc-role {
                font-size: 11px;
                font-weight: 800;
                color: var(--text);
                letter-spacing: 0.04em;
            }

            .quick-card .qc-email {
                font-size: 9.5px;
                color: var(--muted);
                margin-top: 2px;
                word-break: break-all;
                line-height: 1.3;
            }

            .quick-card .qc-pass {
                font-size: 9px;
                color: #9ca3af;
                margin-top: 1px;
            }

            .quick-card.filled {
                border-color: var(--green);
                background: #ecfff1;
                animation: fillPulse 0.4s ease;
            }

            @keyframes fillPulse {
                0%   { box-shadow: 0 0 0 0 rgba(40,167,69,0.45); }
                60%  { box-shadow: 0 0 0 8px rgba(40,167,69,0); }
                100% { box-shadow: 0 0 0 0 rgba(40,167,69,0); }
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

            function fillCredentials(email, password, cardEl) {
                document.getElementById('email').value = email;
                document.getElementById('password').value = password;
                /* Highlight the selected card */
                document.querySelectorAll('.quick-card').forEach(c => c.classList.remove('filled'));
                cardEl.classList.add('filled');
                /* Show password briefly */
                const passInput = document.getElementById('password');
                const toggleBtn = document.querySelector('.toggle-pass');
                passInput.type = 'text';
                toggleBtn.textContent = 'Ẩn';
                setTimeout(() => {
                    passInput.type = 'password';
                    toggleBtn.textContent = 'Hiện';
                }, 1200);
            }
        </script>
    </head>
    <body>
        <div class="card">
            <h2>Đăng nhập</h2>
            <div class="subtitle">Nhập Gmail và mật khẩu để tiếp tục.</div>

            <!-- ===== Quick Login Panel ===== -->
            <div class="quick-login">
                <div class="quick-login-label">Đăng nhập nhanh theo vai trò</div>
                <div class="quick-cards">
                    <!-- Admin -->
                    <div class="quick-card" id="qc-admin"
                         onclick="fillCredentials('admin.tpms@gmail.com','123456',this)"
                         title="Admin — admin.tpms@gmail.com / 123456">
                        <span class="qc-icon">🛡️</span>
                        <div class="qc-role">Admin</div>
                        <div class="qc-email">admin.tpms<br>@gmail.com</div>
                        <div class="qc-pass">123456</div>
                    </div>
                    <!-- Teacher -->
                    <div class="quick-card" id="qc-teacher"
                         onclick="fillCredentials('teacher.tpms@gmail.com','123456',this)"
                         title="Teacher — teacher.tpms@gmail.com / 123456">
                        <span class="qc-icon">👨‍🏫</span>
                        <div class="qc-role">Teacher</div>
                        <div class="qc-email">teacher.tpms<br>@gmail.com</div>
                        <div class="qc-pass">123456</div>
                    </div>
                    <!-- Student -->
                    <div class="quick-card" id="qc-student"
                         onclick="fillCredentials('student.tpms@gmail.com','123456',this)"
                         title="Student — student.tpms@gmail.com / 123456">
                        <span class="qc-icon">🎓</span>
                        <div class="qc-role">Student</div>
                        <div class="qc-email">student.tpms<br>@gmail.com</div>
                        <div class="qc-pass">123456</div>
                    </div>
                </div>
            </div>

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
