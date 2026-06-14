<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
    String token = (String) request.getAttribute("token");
    Boolean invalidToken = (Boolean) request.getAttribute("invalidToken");
    boolean invalid = invalidToken != null && invalidToken;
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
                max-width: 420px;
                background: #fff;
                border: 1px solid var(--border);
                border-radius: 14px;
                box-shadow: 0 14px 40px rgba(0, 0, 0, 0.12);
                padding: 22px;
            }
            h2 { margin: 0 0 4px; text-align: center; color: var(--green); font-size: 22px; font-weight: 800; }
            .subtitle { text-align: center; color: var(--muted); font-size: 13px; margin-bottom: 14px; }
            .error { margin: 10px 0; padding: 10px 12px; border-radius: 10px; font-size: 13px; text-align: center;
                border: 1px solid rgba(220, 53, 69, 0.35); background: rgba(220, 53, 69, 0.08); color: var(--danger); }
            .row { margin-bottom: 12px; }
            label { display: block; font-size: 13px; font-weight: 600; color: #374151; margin-bottom: 6px; }
            input {
                width: 100%; padding: 10px 12px; border-radius: 10px; border: 1px solid var(--border);
                font-size: 14px; outline: none; background: #fff; color: var(--text);
            }
            input:focus { border-color: rgba(40,167,69,0.9); box-shadow: 0 0 0 0.2rem rgba(40,167,69,0.18); }
            .btn-primary {
                width: 100%; border: none; cursor: pointer; border-radius: 10px;
                padding: 10px 12px; background: var(--green); color: #fff; font-size: 15px; font-weight: 700; margin-top: 6px;
            }
            .btn-primary:hover { background: var(--green-dark); }
            .links { text-align: center; margin-top: 14px; font-size: 13px; color: var(--muted); }
            .links a { color: #0d6efd; text-decoration: none; font-weight: 700; }
        </style>
        <script>
            function validateReset() {
                const newP = document.getElementById("newPassword").value;
                const confirmP = document.getElementById("confirmPassword").value;
                if (!newP || !confirmP) {
                    alert("Vui lòng nhập đầy đủ mật khẩu.");
                    return false;
                }
                if (newP.length < 6) {
                    alert("Mật khẩu mới phải từ 6 ký tự trở lên.");
                    return false;
                }
                if (newP !== confirmP) {
                    alert("Xác nhận mật khẩu không khớp.");
                    return false;
                }
                return true;
            }
        </script>
    </head>
    <body>
        <div class="card">
            <h2>Đặt lại mật khẩu</h2>
            <div class="subtitle">Nhập mật khẩu mới cho tài khoản của bạn.</div>

            <% if (error != null) { %>
            <div class="error"><%= error %></div>
            <% } %>

            <% if (invalid) { %>
            <div class="links">
                <a href="<%=request.getContextPath()%>/forgot-password">Yêu cầu liên kết mới</a>
            </div>
            <% } else { %>
            <form method="post" action="<%=request.getContextPath()%>/reset-password" onsubmit="return validateReset();">
                <input type="hidden" name="token" value="<%= token == null ? "" : token %>"/>
                <div class="row">
                    <label for="newPassword">Mật khẩu mới</label>
                    <input id="newPassword" type="password" name="newPassword" placeholder="Tối thiểu 6 ký tự"/>
                </div>
                <div class="row">
                    <label for="confirmPassword">Xác nhận mật khẩu mới</label>
                    <input id="confirmPassword" type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu mới"/>
                </div>
                <button class="btn-primary" type="submit">Đặt lại mật khẩu</button>
            </form>

            <div class="links">
                <a href="<%=request.getContextPath()%>/login">Quay lại đăng nhập</a>
            </div>
            <% } %>
        </div>
    </body>
</html>
