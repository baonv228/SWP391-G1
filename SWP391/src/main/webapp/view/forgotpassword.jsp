<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
    String resetLink = (String) request.getAttribute("resetLink");
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
        <title>Quên mật khẩu</title>
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
            .message, .error, .link-box {
                margin: 14px 0 10px;
                padding: 10px 12px;
                border-radius: 10px;
                font-size: 13px;
                line-height: 1.5;
                word-break: break-word;
            }
            .message { border: 1px solid #b7f0c2; background: #ecfff1; color: #0b6b2f; }
            .error { border: 1px solid rgba(220, 53, 69, 0.35); background: rgba(220, 53, 69, 0.08); color: var(--danger); }
            .link-box { border: 1px dashed rgba(40, 167, 69, 0.35); background: #fbfff9; color: #0b6b2f; }
            form { margin-top: 14px; }
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
            input:focus { border-color: rgba(40, 167, 69, 0.9); box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.18); }
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
    </head>
    <body>
        <div class="card">
            <h2>Quên mật khẩu</h2>
            <div class="subtitle">Nhập Gmail để nhận liên kết đặt lại mật khẩu.</div>

            <% if (message != null) { %>
            <div class="message"><%= message %></div>
            <% } %>

            <% if (error != null) { %>
            <div class="error"><%= error %></div>
            <% } %>

            <% if (resetLink != null) { %>
            <div class="link-box">
                <strong>Liên kết đặt lại mật khẩu:</strong><br />
                <a href="<%= resetLink %>"><%= resetLink %></a>
            </div>
            <% } %>

            <form method="post" action="<%=request.getContextPath()%>/forgot-password">
                <div class="row">
                    <label for="email">Gmail</label>
                    <input id="email" type="email" name="email" value="<%= emailValue %>" placeholder="example@gmail.com" />
                </div>
                <button class="btn-primary" type="submit">Tạo liên kết</button>
            </form>

            <div class="hint">
                <a href="<%=request.getContextPath()%>/login">Quay lại đăng nhập</a>
            </div>
        </div>
    </body>
</html>
