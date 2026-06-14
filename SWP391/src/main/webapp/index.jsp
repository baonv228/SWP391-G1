<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%
    String loginSuccess = request.getParameter("loginSuccess");
    User currentUser = (User) session.getAttribute("user");
    String displayName = "";
    if (currentUser != null) {
        displayName = currentUser.getFullName() != null && !currentUser.getFullName().isBlank()
                ? currentUser.getFullName() : currentUser.getEmail();
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>TPMS</title>
        <style>
            :root {
                --leaf: #2f7d32;
                --leaf-dark: #1f5d25;
                --soil: #4b3f35;
                --cream: #f7f3e8;
                --mint: #dff0df;
                --white: #ffffff;
                --muted: #5f6f63;
            }

            * {
                box-sizing: border-box;
            }

            body {
                margin: 0;
                min-height: 100vh;
                font-family: Georgia, "Times New Roman", serif;
                color: var(--soil);
                background:
                    linear-gradient(120deg, rgba(247, 243, 232, 0.94), rgba(223, 240, 223, 0.92)),
                    radial-gradient(circle at 12% 15%, rgba(47, 125, 50, 0.16), transparent 30%),
                    radial-gradient(circle at 85% 80%, rgba(75, 63, 53, 0.14), transparent 32%);
            }

            .page {
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            .topbar {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 24px clamp(20px, 6vw, 76px);
            }

            .brand {
                font-size: 20px;
                font-weight: 700;
                letter-spacing: 0.04em;
                color: var(--leaf-dark);
            }

            .nav-actions {
                display: flex;
                gap: 12px;
            }

            .hero {
                flex: 1;
                display: grid;
                grid-template-columns: minmax(0, 1.1fr) minmax(280px, 0.9fr);
                align-items: center;
                gap: clamp(28px, 6vw, 72px);
                padding: 20px clamp(20px, 6vw, 76px) 70px;
            }

            .eyebrow {
                color: var(--leaf);
                font-family: Arial, sans-serif;
                font-size: 13px;
                font-weight: 700;
                letter-spacing: 0.12em;
                text-transform: uppercase;
                margin-bottom: 14px;
            }

            h1 {
                margin: 0;
                max-width: 760px;
                font-size: clamp(42px, 7vw, 84px);
                line-height: 0.98;
                letter-spacing: 0;
                color: var(--soil);
            }

            .lead {
                max-width: 600px;
                margin: 22px 0 0;
                font-family: Arial, sans-serif;
                font-size: 18px;
                line-height: 1.7;
                color: var(--muted);
            }

            .cta-row {
                display: flex;
                flex-wrap: wrap;
                gap: 14px;
                margin-top: 34px;
            }

            .btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-width: 142px;
                min-height: 48px;
                padding: 13px 22px;
                border-radius: 8px;
                font-family: Arial, sans-serif;
                font-size: 15px;
                font-weight: 700;
                text-decoration: none;
                transition: transform 0.15s ease, box-shadow 0.15s ease, background 0.15s ease;
            }

            .btn:hover {
                transform: translateY(-2px);
            }

            .btn-primary {
                background: var(--leaf);
                color: var(--white);
                box-shadow: 0 12px 24px rgba(47, 125, 50, 0.24);
            }

            .btn-primary:hover {
                background: var(--leaf-dark);
            }

            .btn-outline {
                background: rgba(255, 255, 255, 0.65);
                color: var(--leaf-dark);
                border: 1px solid rgba(47, 125, 50, 0.28);
            }

            .visual {
                min-height: 420px;
                border-radius: 8px;
                position: relative;
                overflow: hidden;
                background:
                    linear-gradient(160deg, rgba(47, 125, 50, 0.14), rgba(255, 255, 255, 0.25)),
                    repeating-linear-gradient(90deg, rgba(47, 125, 50, 0.18) 0 2px, transparent 2px 48px),
                    repeating-linear-gradient(0deg, rgba(75, 63, 53, 0.14) 0 2px, transparent 2px 48px),
                    #eef7ea;
                box-shadow: inset 0 0 0 1px rgba(47, 125, 50, 0.18), 0 24px 70px rgba(75, 63, 53, 0.18);
            }

            .visual::before {
                content: "";
                position: absolute;
                inset: 36px;
                border: 2px solid rgba(47, 125, 50, 0.28);
                border-radius: 6px;
            }

            .visual::after {
                content: "TPMS";
                position: absolute;
                right: 30px;
                bottom: 26px;
                color: rgba(31, 93, 37, 0.22);
                font-size: 68px;
                font-weight: 800;
                font-family: Arial, sans-serif;
            }

            .toast {
                position: fixed;
                top: 18px;
                right: 18px;
                max-width: 360px;
                padding: 12px 14px;
                border-radius: 10px;
                box-shadow: 0 10px 28px rgba(0, 0, 0, 0.15);
                background: #ecfff1;
                border: 1px solid #b7f0c2;
                color: #0b6b2f;
                font-family: Arial, sans-serif;
                z-index: 10;
            }

            @media (max-width: 820px) {
                .topbar {
                    gap: 18px;
                    align-items: flex-start;
                    flex-direction: column;
                }

                .hero {
                    grid-template-columns: 1fr;
                    padding-top: 10px;
                }

                .visual {
                    min-height: 250px;
                }
            }
        </style>
    </head>
    <body>
        <% if ("1".equals(loginSuccess)) { %>
        <div class="toast">Đăng nhập thành công. Chào mừng bạn.</div>
        <% } %>

        <main class="page">
            <header class="topbar">
                <div class="brand">TPMS</div>
                <nav class="nav-actions" aria-label="Tài khoản">
                    <% if (currentUser != null) { %>
                    <a class="btn btn-outline" href="<%=request.getContextPath()%>/profile">Xin chào, <%= displayName %></a>
                    <a class="btn btn-primary" href="<%=request.getContextPath()%>/logout">Đăng xuất</a>
                    <% } else { %>
                    <a class="btn btn-outline" href="<%=request.getContextPath()%>/login">Đăng nhập</a>
                    <a class="btn btn-primary" href="<%=request.getContextPath()%>/register">Đăng ký</a>
                    <% } %>
                </nav>
            </header>

            <section class="hero">
                <div>
                    <div class="eyebrow">Training Program Management System</div>
                    <h1>Quản lý chương trình đào tạo rõ ràng hơn.</h1>
                    <p class="lead">
                        TPMS hỗ trợ quản lý môn học, đề cương, chương trình đào tạo và tài liệu học tập trên một hệ thống thống nhất.
                    </p>
                    <div class="cta-row">
                        <% if (currentUser != null) { %>
                        <a class="btn btn-primary" href="<%=request.getContextPath()%>/profile">Hồ sơ của tôi</a>
                        <a class="btn btn-outline" href="<%=request.getContextPath()%>/logout">Đăng xuất</a>
                        <% } else { %>
                        <a class="btn btn-primary" href="<%=request.getContextPath()%>/register">Đăng ký</a>
                        <a class="btn btn-outline" href="<%=request.getContextPath()%>/login">Đăng nhập</a>
                        <% } %>
                    </div>
                </div>

                <div class="visual" aria-hidden="true"></div>
            </section>
        </main>
    </body>
</html>
