<%@page import="model.User"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    User currentUser = (User) session.getAttribute("user");
    String roleName = (String) session.getAttribute("roleName");
    if (roleName == null && currentUser != null && currentUser.getRole() != null) {
        roleName = currentUser.getRole().getRoleName();
        session.setAttribute("roleName", roleName);
    }

    if (currentUser == null || roleName == null || !"Admin".equalsIgnoreCase(roleName.trim())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String displayName = currentUser.getFullName();
    if (displayName == null || displayName.isBlank()) {
        displayName = currentUser.getEmail();
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard — TPMS</title>
    <style>
        :root {
            --primary: #4f46e5;
            --primary-dark: #3730a3;
            --primary-soft: #e0e7ff;
            --ink: #0f172a;
            --muted: #475569;
            --line: #e2e8f0;
            --white: #ffffff;
            --bg: #f8fafc;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            min-height: 100vh;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            color: var(--ink);
            background-color: var(--bg);
            background-image: 
                radial-gradient(circle at 0% 0%, rgba(79, 70, 229, 0.05) 0%, transparent 35%),
                radial-gradient(circle at 100% 100%, rgba(79, 70, 229, 0.05) 0%, transparent 35%);
        }

        .page {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .topbar {
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 40px;
            border-bottom: 1px solid var(--line);
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(12px);
        }

        .brand {
            font-size: 20px;
            font-weight: 800;
            color: var(--primary);
            letter-spacing: 0.05em;
        }

        .top-actions {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .btn-outline {
            padding: 8px 18px;
            border-radius: 8px;
            border: 1px solid var(--line);
            background: var(--white);
            color: var(--muted);
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .btn-outline:hover {
            border-color: var(--primary);
            color: var(--primary);
        }

        .profile {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 6px 14px 6px 6px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 700;
            background: var(--white);
            border: 1px solid var(--line);
        }

        .avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: var(--primary-soft);
            color: var(--primary);
            font-weight: 800;
        }

        .content {
            flex: 1;
            max-width: 1200px;
            width: 100%;
            margin: 0 auto;
            padding: 48px 24px;
        }

        .welcome-banner {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
            padding: 40px;
            border-radius: 16px;
            margin-bottom: 40px;
            box-shadow: 0 10px 30px rgba(79, 70, 229, 0.15);
        }

        .welcome-banner h1 {
            font-size: 32px;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .welcome-banner p {
            font-size: 16px;
            opacity: 0.9;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
        }

        .card {
            background: var(--white);
            border: 1px solid var(--line);
            border-radius: 16px;
            padding: 32px 24px;
            text-decoration: none;
            color: inherit;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
            transition: all 0.2s ease;
        }

        .card:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            border-color: var(--primary);
        }

        .card-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--primary-soft);
            color: var(--primary);
            font-size: 24px;
            margin-bottom: 20px;
        }

        .card-title {
            font-size: 18px;
            font-weight: 700;
            color: var(--ink);
            margin-bottom: 8px;
        }

        .card-desc {
            font-size: 14px;
            color: var(--muted);
            line-height: 1.5;
        }

        .footer {
            padding: 24px;
            text-align: center;
            color: var(--muted);
            font-size: 13px;
            border-top: 1px solid var(--line);
        }

        @media (max-width: 768px) {
            .topbar {
                padding: 0 20px;
            }
            .content {
                padding: 24px 16px;
            }
            .welcome-banner {
                padding: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="page">
        <header class="topbar">
            <div class="brand">TPMS ADMIN</div>
            <div class="top-actions">
                <div class="profile">
                    <span class="avatar">AD</span>
                    <span>Admin</span>
                </div>
                <a class="btn-outline" href="<%=request.getContextPath()%>/logout">Đăng xuất</a>
            </div>
        </header>

        <main class="content">
            <div class="welcome-banner">
                <h1>Xin chào, <%= displayName %></h1>
                <p>Hệ thống Quản lý Đào tạo — Trang Quản trị hệ thống.</p>
            </div>

            <div class="grid">
                <a href="<%=request.getContextPath()%>/admin/users" class="card">
                    <div class="card-icon">👥</div>
                    <div class="card-title">Quản lý người dùng</div>
                    <div class="card-desc">Thêm mới, cập nhật thông tin và đặt lại mật khẩu cho giảng viên, sinh viên và nhân viên.</div>
                </a>

                <a href="<%=request.getContextPath()%>/curriculum?action=list" class="card">
                    <div class="card-icon">📚</div>
                    <div class="card-title">Xem chương trình học</div>
                    <div class="card-desc">Truy cập danh sách chương trình đào tạo hiện có trên toàn hệ thống.</div>
                </a>

                <a href="<%=request.getContextPath()%>/profile" class="card">
                    <div class="card-icon">👤</div>
                    <div class="card-title">Hồ sơ cá nhân</div>
                    <div class="card-desc">Cập nhật thông tin tài khoản cá nhân, đổi mật khẩu bảo mật.</div>
                </a>

                <a href="<%=request.getContextPath()%>/admin/roles" class="card">
                    <div class="card-icon">⚙️</div>
                    <div class="card-title">Quản lý vai trò</div>
                    <div class="card-desc">Xem danh sách các vai trò (roles) trong hệ thống cùng các mô tả chi tiết.</div>
                </a>
            </div>
        </main>

        <footer class="footer">
            © 2026 Training Program Management System. All rights reserved.
        </footer>
    </div>
</body>
</html>
