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
<<<<<<< Updated upstream
    <div class="page">
        <header class="topbar">
            <div class="brand">TPMS ADMIN</div>
            <div class="top-actions">
                <div class="profile">
                    <span class="avatar">AD</span>
                    <span>Admin</span>
=======
<div class="admin-shell">
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="logo-mark" aria-hidden="true">
                <svg viewBox="0 0 40 40" width="36" height="36">
                    <polygon points="20,2 36,11 36,29 20,38 4,29 4,11" fill="#ff7a00"/>
                    <polygon points="20,8 31,14 31,26 20,32 9,26 9,14" fill="#fff" opacity=".9"/>
                    <polygon points="20,14 26,17.5 26,24.5 20,28 14,24.5 14,17.5" fill="#ff7a00"/>
                </svg>
            </div>
            <div>
                <div class="brand-title">TPMS</div>
                <div class="brand-sub">Training Program Management System</div>
            </div>
        </div>

        <nav class="side-nav" aria-label="Menu Admin">
            <a class="nav-item active" href="<%=ctx%>/home">
                <span class="nav-ico">🏠</span> Trang chủ
            </a>
            <a class="nav-item" href="<%=ctx%>/admin/users">
                <span class="nav-ico">👥</span> Quản lý người dùng
            </a>
            <a class="nav-item" href="<%=ctx%>/curriculum?action=list">
                <span class="nav-ico">📘</span> Xem chương trình học
            </a>
            <a class="nav-item" href="<%=ctx%>/profile">
                <span class="nav-ico">👤</span> Hồ sơ cá nhân
            </a>
            <a class="nav-item" href="<%=ctx%>/admin/roles">
                <span class="nav-ico">⚙️</span> Quản lý vai trò
            </a>
            <a class="nav-item" href="<%=ctx%>/admin/reports">
                <span class="nav-ico">📊</span> System Reports
            </a>
        </nav>
    </aside>

    <div class="main-wrap">
        <header class="top-header">
            <div class="date-chip" title="Ngày hiện tại trên máy chủ">
                <span class="date-ico">📅</span>
                <span id="adminDateLabel"><%= dateLabel %></span>
            </div>

            <div class="header-right">
                <div class="user-menu" id="adminUserMenu">
                    <button type="button" class="user-menu-toggle" id="adminUserMenuBtn"
                            aria-haspopup="true" aria-expanded="false" aria-controls="adminUserDropdown">
                        <div class="avatar"><%= initials %></div>
                        <div class="user-meta">
                            <div class="user-name"><%= displayName %></div>
                            <div class="user-role">Administrator</div>
                        </div>
                        <span class="user-caret" aria-hidden="true">▾</span>
                    </button>
                    <div class="user-dropdown" id="adminUserDropdown" hidden>
                        <a class="user-dropdown-item" href="<%=ctx%>/profile">
                            <span class="item-ico">👤</span>
                            Chỉnh sửa hồ sơ cá nhân
                        </a>
                        <a class="user-dropdown-item danger" href="<%=ctx%>/logout">
                            <span class="item-ico">⎋</span>
                            Đăng xuất
                        </a>
                    </div>
>>>>>>> Stashed changes
                </div>
                <a class="btn-outline" href="<%=request.getContextPath()%>/logout">Đăng xuất</a>
            </div>
        </header>

        <main class="content">
            <div class="welcome-banner">
                <h1>Xin chào, <%= displayName %></h1>
                <p>Hệ thống Quản lý Đào tạo — Trang Quản trị hệ thống.</p>
            </div>

<<<<<<< Updated upstream
            <div class="grid">
                <a href="<%=request.getContextPath()%>/admin/users" class="card">
                    <div class="card-icon">👥</div>
                    <div class="card-title">Quản lý người dùng</div>
                    <div class="card-desc">Thêm mới, cập nhật thông tin và đặt lại mật khẩu cho giảng viên, sinh viên và nhân viên.</div>
=======
                    <div class="hero-stats">
                        <div class="hero-stat">
                            <div class="stat-num"><%= totalUsers %></div>
                            <div class="stat-label">Người dùng</div>
                            <div class="stat-hint">Tài khoản Active</div>
                        </div>
                        <div class="hero-stat">
                            <div class="stat-num"><%= totalPrograms %></div>
                            <div class="stat-label">Chương trình đào tạo</div>
                            <div class="stat-hint">Đang quản lý</div>
                        </div>
                        <div class="hero-stat">
                            <div class="stat-num"><%= totalCourses %></div>
                            <div class="stat-label">Khóa học</div>
                            <div class="stat-hint">Subject / Course</div>
                        </div>
                    </div>
                </div>
                <div class="hero-art" aria-hidden="true">
                    <div class="monitor">
                        <div class="monitor-screen">
                            <div class="chart-bars">
                                <span style="height:45%"></span>
                                <span style="height:70%"></span>
                                <span style="height:55%"></span>
                                <span style="height:85%"></span>
                                <span style="height:60%"></span>
                            </div>
                        </div>
                        <div class="monitor-stand"></div>
                    </div>
                </div>
            </section>

            <section class="cards-grid" aria-label="Lối tắt quản trị">
                <a class="dash-card" href="<%=ctx%>/admin/users">
                    <div class="dash-ico">👥</div>
                    <h3>Quản lý người dùng</h3>
                    <p>Thêm mới, cập nhật thông tin và đặt lại mật khẩu cho giảng viên, sinh viên và nhân viên.</p>
                    <span class="dash-cta">Truy cập ngay <i>→</i></span>
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======
</div>

<script>
    (function () {
        // Đồng bộ nhãn lịch với đồng hồ máy khách (ngày thực tế khi xem trang)
        var viDays = ["Chủ Nhật", "Thứ Hai", "Thứ Ba", "Thứ Tư", "Thứ Năm", "Thứ Sáu", "Thứ Bảy"];
        function refreshDate() {
            var now = new Date();
            var label = viDays[now.getDay()] + ", "
                + String(now.getDate()).padStart(2, "0") + "/"
                + String(now.getMonth() + 1).padStart(2, "0") + "/"
                + now.getFullYear();
            var el = document.getElementById("adminDateLabel");
            if (el) el.textContent = label;
        }
        refreshDate();
        setInterval(refreshDate, 60 * 1000);

        var menu = document.getElementById("adminUserMenu");
        var btn = document.getElementById("adminUserMenuBtn");
        var dropdown = document.getElementById("adminUserDropdown");
        if (menu && btn && dropdown) {
            function closeMenu() {
                dropdown.hidden = true;
                menu.classList.remove("open");
                btn.setAttribute("aria-expanded", "false");
            }
            function toggleMenu() {
                var open = dropdown.hidden;
                dropdown.hidden = !open;
                menu.classList.toggle("open", open);
                btn.setAttribute("aria-expanded", open ? "true" : "false");
            }
            btn.addEventListener("click", function (e) {
                e.stopPropagation();
                toggleMenu();
            });
            document.addEventListener("click", function (e) {
                if (!menu.contains(e.target)) closeMenu();
            });
            document.addEventListener("keydown", function (e) {
                if (e.key === "Escape") closeMenu();
            });
        }
    })();
</script>
>>>>>>> Stashed changes
</body>
</html>
