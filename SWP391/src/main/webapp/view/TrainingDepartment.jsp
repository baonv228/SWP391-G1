<%@page import="model.User"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    User currentUser = (User) session.getAttribute("user");
    String roleName = (String) session.getAttribute("roleName");
    if (roleName == null && currentUser != null && currentUser.getRole() != null) {
        roleName = currentUser.getRole().getRoleName();
        session.setAttribute("roleName", roleName);
    }

    if (currentUser == null || roleName == null || !"Training Department".equalsIgnoreCase(roleName.trim())) {
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
        <style>
            :root {
                --orange: #f59e3d;
                --orange-dark: #c76b12;
                --orange-soft: #fff1df;
                --cream: #fffaf3;
                --ink: #2b2118;
                --muted: #7b6a5c;
                --line: #f1d2ad;
                --white: #ffffff;
            }

            * {
                box-sizing: border-box;
            }

            body {
                margin: 0;
                min-height: 100vh;
                font-family: "Segoe UI", Tahoma, sans-serif;
                color: var(--ink);
                background:
                    linear-gradient(135deg, rgba(255, 250, 243, 0.96), rgba(255, 241, 223, 0.94)),
                    repeating-linear-gradient(90deg, rgba(245, 158, 61, 0.06) 0 1px, transparent 1px 42px),
                    repeating-linear-gradient(0deg, rgba(199, 107, 18, 0.05) 0 1px, transparent 1px 42px);
            }

            .page {
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            .topbar {
                height: 68px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 18px;
                padding: 0 clamp(18px, 5vw, 64px);
                border-bottom: 1px solid var(--line);
                background: rgba(255, 255, 255, 0.82);
                backdrop-filter: blur(12px);
            }

            .brand {
                font-size: 18px;
                font-weight: 800;
                color: var(--orange-dark);
            }

            .top-actions {
                display: flex;
                align-items: center;
                gap: 14px;
            }

            .icon-button,
            .profile {
                min-height: 42px;
                border: 1px solid var(--line);
                background: var(--white);
                color: var(--ink);
                box-shadow: 0 10px 28px rgba(199, 107, 18, 0.08);
            }

            .icon-button {
                width: 42px;
                border-radius: 50%;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }

            .profile {
                display: inline-flex;
                align-items: center;
                gap: 10px;
                padding: 7px 12px 7px 7px;
                border-radius: 999px;
                font-size: 13px;
                font-weight: 700;
            }

            .avatar {
                width: 30px;
                height: 30px;
                border-radius: 50%;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                background: var(--orange-soft);
                color: var(--orange-dark);
                font-weight: 900;
            }

            .content {
                flex: 1;
                width: min(1120px, calc(100% - 32px));
                margin: 0 auto;
                padding: clamp(28px, 6vw, 58px) 0 24px;
            }

            .welcome {
                margin-bottom: clamp(42px, 8vw, 86px);
            }

            .welcome h1 {
                margin: 0;
                font-size: clamp(28px, 4vw, 46px);
                line-height: 1.08;
                letter-spacing: 0;
            }

            .welcome p {
                max-width: 680px;
                margin: 12px 0 0;
                color: var(--muted);
                font-size: 16px;
                line-height: 1.7;
            }

            .module-grid {
                display: grid;
                grid-template-columns: repeat(6, 1fr);
                gap: 28px;
                align-items: stretch;
            }

            .module-card {
                grid-column: span 2;
                min-height: 156px;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                gap: 14px;
                padding: 24px;
                border: 1px solid var(--line);
                border-radius: 8px;
                background: rgba(255, 255, 255, 0.78);
                color: var(--ink);
                text-decoration: none;
                box-shadow: 0 18px 48px rgba(199, 107, 18, 0.1);
                transition: transform 0.16s ease, border-color 0.16s ease, box-shadow 0.16s ease;
            }

            .module-card:hover {
                transform: translateY(-4px);
                border-color: rgba(245, 158, 61, 0.8);
                box-shadow: 0 24px 58px rgba(199, 107, 18, 0.18);
            }

            .module-card:nth-child(4) {
                grid-column: 2 / span 2;
            }

            .module-card:nth-child(5) {
                grid-column: 4 / span 2;
            }

            .module-icon {
                width: 52px;
                height: 52px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                border-radius: 14px;
                color: var(--orange-dark);
                background: var(--orange-soft);
            }

            .module-title {
                font-size: 17px;
                font-weight: 800;
                text-align: center;
            }

            .footer {
                padding: 18px 16px 24px;
                text-align: center;
                color: var(--muted);
                font-size: 12px;
            }

            svg {
                width: 26px;
                height: 26px;
                stroke: currentColor;
                stroke-width: 1.8;
                fill: none;
                stroke-linecap: round;
                stroke-linejoin: round;
            }

            @media (max-width: 820px) {
                .topbar {
                    height: auto;
                    align-items: flex-start;
                    flex-direction: column;
                    padding-top: 16px;
                    padding-bottom: 16px;
                }

                .top-actions {
                    width: 100%;
                    justify-content: space-between;
                }

                .module-grid {
                    grid-template-columns: 1fr;
                    gap: 18px;
                }

                .module-card,
                .module-card:nth-child(4),
                .module-card:nth-child(5) {
                    grid-column: auto;
                }
            }
        </style>
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
                        <span>Training Department</span>
                    </div>
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
                    <a class="module-card" href="#">
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
                    <a class="module-card" href="#">
                        <span class="module-icon">
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <path d="m22 10-10-5-10 5 10 5z"></path>
                                <path d="M6 12v5c3 2 9 2 12 0v-5"></path>
                                <path d="M22 10v6"></path>
                            </svg>
                        </span>
                        <span class="module-title">Training Program</span>
                    </a>
                    <a class="module-card" href="#">
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
