<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%
    User current = (User) session.getAttribute("user");
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
    String fullNameValue = current != null && current.getFullName() != null ? current.getFullName() : "";
    String emailValue = current != null && current.getEmail() != null ? current.getEmail() : "";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Hồ sơ</title>
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
            max-width: 520px;
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
        .meta {
            margin-top: 14px;
            padding: 12px;
            border-radius: 10px;
            background: #fffaf6;
            border: 1px solid var(--border);
            font-size: 13px;
            color: #374151;
            line-height: 1.6;
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
        .links {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            margin-top: 14px;
            flex-wrap: wrap;
            font-size: 13px;
        }
        .links a {
            color: var(--orange-dark);
            text-decoration: none;
            font-weight: 700;
        }
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/theme-orange.css" />
</head>
<body>
<div class="card">
    <h2>Hồ sơ cá nhân</h2>
    <div class="subtitle">Xem và cập nhật thông tin tài khoản.</div>

    <% if (message != null) { %>
    <div class="message"><%= message %></div>
    <% } %>

    <% if (error != null) { %>
    <div class="error"><%= error %></div>
    <% } %>

    <div class="meta">
        <div><strong>Email:</strong> <%= emailValue %></div>
        <div><strong>Vai trò:</strong> <%= current != null && current.getRole() != null ? current.getRole().getRoleName() : "" %></div>
    </div>

    <form method="post" action="<%=request.getContextPath()%>/profile" onsubmit="return validateProfile();">
        <div class="row">
            <label for="fullName">Họ tên</label>
            <input id="fullName" type="text" name="fullName" value="<%= fullNameValue %>" />
        </div>


        <button class="btn-primary" type="submit">Lưu thay đổi</button>
    </form>

    <div class="links">
        <a href="<%=request.getContextPath()%>/change-password">Đổi mật khẩu</a>
        <a href="<%=request.getContextPath()%>/logout">Đăng xuất</a>
    </div>
</div>
</body>
</html>
