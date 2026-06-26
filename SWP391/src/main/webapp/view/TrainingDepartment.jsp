<%@page import="model.User"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    User currentUser = (User) session.getAttribute("user");
    String roleName = (String) session.getAttribute("roleName");
    if (roleName == null && currentUser != null && currentUser.getRole() != null) {
        roleName = currentUser.getRole().getRoleName();
        session.setAttribute("roleName", roleName);
    }

    if (currentUser == null || roleName == null || 
        (!"Training Department".equalsIgnoreCase(roleName.trim()) && !"Admin".equalsIgnoreCase(roleName.trim()))) {
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
        <title>Training Department Home</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/TraningDepartment.css" />
    </head>
    <body>
        <main class="page">
            <header class="topbar">
                <div class="brand">Training Program Management System</div>
                <div class="top-actions" aria-label="Tài khoản">
                    <button class="icon-button" type="button" aria-label="Thông báo">
                        <svg viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M18 8a6 6 0 0 0-12 0c0 7-3 7-3 9h18c0-2-3-2-3-9"></path>
                            <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                        </svg>
                    </button>
                    <div class="profile" title="<%= displayName %>">
                        <span class="avatar">TD</span>
                        <span>Xin chào, <%= displayName %></span>
                    </div>
                    <a href="<%=request.getContextPath()%>/logout" class="icon-button" style="text-decoration: none; border-radius: 999px; width: auto; padding: 0 16px; font-size: 13px; font-weight: 700; color: #dc3545; border-color: rgba(220, 53, 69, 0.35); display: inline-flex; align-items: center; justify-content: center;" title="Đăng xuất">
                        Đăng xuất
                    </a>
                </div>
            </header>

            <section class="content">
                <div class="welcome">
                    <h1>Welcome, Training Department</h1>
                    <p>Here is the overview of syllabus requests and training programs.</p>
                </div>

                <nav class="module-grid" aria-label="Training Department dashboard">
                    <a class="module-card" href="#">
                        <span class="module-icon">
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M9 5h6"></path>
                                <path d="M9 12h6"></path>
                                <path d="M9 16h4"></path>
                                <path d="M8 3h8l1 2h3v16H4V5h3z"></path>
                            </svg>
                        </span>
                        <span class="module-title">Request List</span>
                    </a>
                    <a class="module-card" href="#">
                        <span class="module-icon">
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                <path d="M4 4.5A2.5 2.5 0 0 1 6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5z"></path>
                            </svg>
                        </span>
                        <span class="module-title">Course List</span>
                    </a>
                    <a class="module-card" href="<%=request.getContextPath()%>/curriculum?action=list">
                        <span class="module-icon">
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                <path d="M14 2v6h6"></path>
                                <path d="M8 13h8"></path>
                                <path d="M8 17h5"></path>
                            </svg>
                        </span>
                        <span class="module-title">Curriculum</span>
                    </a>
                    <a class="module-card" href="<%=request.getContextPath()%>/training-program?action=list">
                        <span class="module-icon">
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <path d="m22 10-10-5-10 5 10 5z"></path>
                                <path d="M6 12v5c3 2 9 2 12 0v-5"></path>
                                <path d="M22 10v6"></path>
                            </svg>
                        </span>
                        <span class="module-title">Training Program</span>
                    </a>
                    <a class="module-card" href="<%=request.getContextPath()%>/report">
                        <span class="module-icon">
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M4 20h16"></path>
                                <path d="M7 16V9"></path>
                                <path d="M12 16V5"></path>
                                <path d="M17 16v-3"></path>
                            </svg>
                        </span>
                        <span class="module-title">Training Report</span>
                    </a>
                </nav>
            </section>

            <footer class="footer">© 2026 Training Program Management System. All rights reserved.</footer>
        </main>
    </body>
</html>
