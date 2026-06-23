<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
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

        .message, .error, .link-box {
            margin: 14px 0 10px;
            padding: 10px 12px;
            border-radius: 10px;
            font-size: 13px;
            line-height: 1.5;
            word-break: break-word;
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

        .link-box {
            border: 1px dashed rgba(243, 112, 33, 0.3);
            background: #fffaf6;
            color: var(--orange-dark);
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
</head>
<body>
<div class="card">
    <h2>Quên mật khẩu</h2>
    <div class="subtitle">Nhập Email để nhận mã xác thực đặt lại mật khẩu.</div>

    <% if (message != null) { %>
    <div class="message"><%= message %></div>
    <% } %>

    <% if (error != null) { %>
    <div class="error"><%= error %></div>
    <% } %>



    <form method="post" action="<%=request.getContextPath()%>/forgot-password">
        <div class="row">
            <label for="email">Email</label>
            <input id="email" type="email" name="email" value="<%= emailValue %>" placeholder="example@email.com" />
        </div>
        <button class="btn-primary" type="submit">Gửi mã xác thực</button>
    </form>

    <div class="hint">
        <a href="<%=request.getContextPath()%>/login">Quay lại đăng nhập</a>
        <a href="<%=request.getContextPath()%>/register">Tạo tài khoản mới</a>
    </div>
</div>
</body>
</html>
