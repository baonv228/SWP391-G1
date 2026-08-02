<%@page import="model.User"%>
<%@page import="java.util.Map"%>
<%@page import="java.time.LocalDate"%>
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

    String initials = "AD";
    if (displayName != null && !displayName.isBlank()) {
        String[] parts = displayName.trim().split("\\s+");
        if (parts.length >= 2) {
            initials = ("" + parts[0].charAt(0) + parts[parts.length - 1].charAt(0)).toUpperCase();
        } else {
            initials = displayName.substring(0, Math.min(2, displayName.length())).toUpperCase();
        }
    }

    @SuppressWarnings("unchecked")
    Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("dashboardStats");
    int totalUsers = stats != null && stats.get("Total Users") != null ? stats.get("Total Users") : 0;
    int totalPrograms = stats != null && stats.get("Total Programs") != null ? stats.get("Total Programs") : 0;
    int totalCourses = stats != null && stats.get("Total Subjects") != null ? stats.get("Total Subjects") : 0;
    int totalReports = stats != null && stats.get("Total Requests") != null ? stats.get("Total Requests") : 0;
    int pendingNoti = stats != null && stats.get("Pending Requests") != null ? stats.get("Pending Requests") : 0;

    LocalDate today = LocalDate.now();
    String[] viDays = {"Chủ Nhật", "Thứ Hai", "Thứ Ba", "Thứ Tư", "Thứ Năm", "Thứ Sáu", "Thứ Bảy"};
    String dayName = viDays[today.getDayOfWeek().getValue() % 7];
    String dateLabel = String.format("%s, %02d/%02d/%d",
            dayName, today.getDayOfMonth(), today.getMonthValue(), today.getYear());

    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Admin Dashboard — TPMS</title>
    <link rel="stylesheet" href="<%=ctx%>/css/admin-dashboard.css"/>
</head>
<body>
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

        <div class="quick-box">
            <div class="quick-label">QUICK ACTION</div>
            <a class="quick-link" href="#guide" onclick="alert('Hướng dẫn sử dụng sẽ được cập nhật.'); return false;">
                📖 Hướng dẫn sử dụng
            </a>
            <a class="quick-link" href="#support" onclick="alert('Liên hệ hỗ trợ: admin@tpms.local'); return false;">
                🛟 Hỗ trợ hệ thống
            </a>
        </div>
    </aside>

    <div class="main-wrap">
        <header class="top-header">
            <div class="date-chip" title="Ngày hiện tại trên máy chủ">
                <span class="date-ico">📅</span>
                <span id="adminDateLabel"><%= dateLabel %></span>
            </div>

            <div class="header-right">
                <button type="button" class="bell-btn" aria-label="Thông báo"
                        title="<%= pendingNoti %> yêu cầu đang chờ xử lý">
                    🔔
                    <% if (pendingNoti > 0) { %>
                    <span class="bell-badge"><%= pendingNoti > 99 ? "99+" : pendingNoti %></span>
                    <% } %>
                </button>

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
                </div>
            </div>
        </header>

        <main class="main-content">
            <section class="hero-banner">
                <div class="hero-text">
                    <h1>👋 Xin chào, <%= displayName %></h1>
                    <p>Hệ thống Quản lý Đào tạo — Trang Quản trị hệ thống.</p>

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
                        <div class="hero-stat">
                            <div class="stat-num"><%= totalReports %></div>
                            <div class="stat-label">Báo cáo</div>
                            <div class="stat-hint">Yêu cầu / Reports</div>
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
                </a>

                <a class="dash-card" href="<%=ctx%>/curriculum?action=list">
                    <div class="dash-ico">📘</div>
                    <h3>Xem chương trình học</h3>
                    <p>Truy cập danh sách chương trình đào tạo hiện có trên toàn hệ thống.</p>
                    <span class="dash-cta">Truy cập ngay <i>→</i></span>
                </a>

                <a class="dash-card" href="<%=ctx%>/profile">
                    <div class="dash-ico">👤</div>
                    <h3>Hồ sơ cá nhân</h3>
                    <p>Cập nhật thông tin tài khoản cá nhân, đổi mật khẩu bảo mật.</p>
                    <span class="dash-cta">Truy cập ngay <i>→</i></span>
                </a>

                <a class="dash-card" href="<%=ctx%>/admin/roles">
                    <div class="dash-ico">⚙️</div>
                    <h3>Quản lý vai trò</h3>
                    <p>Xem danh sách các vai trò (roles) trong hệ thống cùng các mô tả chi tiết.</p>
                    <span class="dash-cta">Truy cập ngay <i>→</i></span>
                </a>

                <a class="dash-card" href="<%=ctx%>/admin/reports">
                    <div class="dash-ico">📊</div>
                    <h3>System Reports</h3>
                    <p>Xem thống kê người dùng, curriculum, syllabus, course; lọc theo kỳ và xuất CSV / Excel / PDF.</p>
                    <span class="dash-cta">Truy cập ngay <i>→</i></span>
                </a>
            </section>
        </main>

        <footer class="admin-footer">
            <div class="footer-left">🛡️ Bảo mật • Ổn định • Hiệu quả</div>
            <div class="footer-center">© 2026 Training Program Management System. All rights reserved.</div>
            <div class="footer-right">Version 2.0.0</div>
        </footer>
    </div>
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

        var bell = document.querySelector(".bell-btn");
        if (bell) {
            bell.addEventListener("click", function () {
                var n = <%= pendingNoti %>;
                alert(n > 0
                    ? ("Có " + n + " yêu cầu phê duyệt đang Pending. Vào System Reports để xem.")
                    : "Không có thông báo mới.");
            });
        }

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
</body>
</html>
