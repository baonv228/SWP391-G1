<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String loginSuccess = request.getParameter("loginSuccess");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TPMS</title>

    <style>
        :root {
            --orange: #f37021;
            --orange-dark: #d95f12;
            --orange-soft: #fff1e7;
            --ink: #2b2b2b;
            --muted: #6b7280;
            --line: rgba(243, 112, 33, 0.16);
            --white: #ffffff;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: Arial, sans-serif;
            color: var(--ink);
            background:
                linear-gradient(135deg,
                        rgba(255,255,255,.96),
                        rgba(255,241,231,.98)),
                radial-gradient(circle at 10% 12%,
                        rgba(243,112,33,.12),
                        transparent 28%),
                radial-gradient(circle at 88% 82%,
                        rgba(243,112,33,.08),
                        transparent 32%);
        }

        .page {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 24px clamp(20px,6vw,76px);
        }

        .brand {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-size: 20px;
            font-weight: 800;
            color: var(--orange-dark);
        }

        .brand-mark {
            width: 14px;
            height: 14px;
            border-radius: 4px;
            background: var(--orange);
            box-shadow: 0 0 0 4px rgba(243,112,33,.14);
        }

        .nav-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .hero {
            flex: 1;
            display: grid;
            grid-template-columns: minmax(0,1.1fr) minmax(280px,.9fr);
            align-items: center;
            gap: clamp(28px,6vw,72px);
            padding: 20px clamp(20px,6vw,76px) 70px;
        }

        .eyebrow {
            color: var(--orange-dark);
            font-size: 13px;
            font-weight: 800;
            letter-spacing: .12em;
            text-transform: uppercase;
            margin-bottom: 14px;
        }

        h1 {
            margin: 0;
            max-width: 760px;
            font-size: clamp(42px,7vw,84px);
            line-height: .98;
            color: var(--ink);
        }

        .lead {
            max-width: 600px;
            margin-top: 22px;
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
            justify-content: center;
            align-items: center;
            min-width: 142px;
            min-height: 48px;
            padding: 13px 22px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 15px;
            font-weight: 700;
            transition: .15s;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        .btn-primary {
            background: var(--orange);
            color: white;
            box-shadow: 0 12px 24px rgba(243,112,33,.22);
        }

        .btn-primary:hover {
            background: var(--orange-dark);
        }

        .btn-outline {
            background: rgba(255,255,255,.8);
            color: var(--orange-dark);
            border: 1px solid rgba(243,112,33,.24);
        }

        .google-login {
            margin-top: 16px;
        }

        .btn-google {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            min-width: 260px;
            min-height: 48px;
            padding: 12px 20px;
            border-radius: 8px;
            background: #fff;
            color: #3c4043;
            border: 1px solid #dadce0;
            text-decoration: none;
            font-size: 15px;
            font-weight: 600;
            box-shadow: 0 1px 2px rgba(60,64,67,.08);
            transition: .15s;
        }

        .btn-google:hover {
            background: #f8f9fa;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(60,64,67,.12);
        }

        .btn-google svg {
            width: 20px;
            height: 20px;
            flex-shrink: 0;
        }

        .visual {
            min-height: 420px;
            border-radius: 8px;
            position: relative;
            overflow: hidden;
            background:
                linear-gradient(160deg,
                        rgba(243,112,33,.16),
                        rgba(255,255,255,.3)),
                repeating-linear-gradient(90deg,
                        rgba(243,112,33,.16) 0 2px,
                        transparent 2px 48px),
                repeating-linear-gradient(0deg,
                        rgba(243,112,33,.10) 0 2px,
                        transparent 2px 48px),
                #fff8f3;
            box-shadow:
                inset 0 0 0 1px rgba(243,112,33,.16),
                0 24px 70px rgba(43,43,43,.12);
        }

        .visual::before {
            content: "";
            position: absolute;
            inset: 36px;
            border: 2px solid rgba(243,112,33,.24);
            border-radius: 6px;
        }

        .visual::after {
            content: "TPMS";
            position: absolute;
            right: 30px;
            bottom: 26px;
            color: rgba(217,95,18,.18);
            font-size: 68px;
            font-weight: 800;
            pointer-events: none;
            z-index: 0;
        }

        .visual-content {
            position: absolute;
            inset: 0;
            z-index: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            gap: 14px;
            padding: 48px 28px;
        }

        .guest-title {
            margin: 0 0 8px;
            text-align: center;
            font-size: 18px;
            font-weight: 800;
            color: #1e3a5f;
        }

        .guest-btn {
            display: flex;
            justify-content: center;
            align-items: center;
            width: min(100%, 340px);
            min-height: 48px;
            padding: 12px 18px;
            border-radius: 8px;
            background: var(--orange);
            color: #fff;
            text-decoration: none;
            font-size: 14px;
            font-weight: 700;
            text-align: center;
            box-shadow: 0 10px 22px rgba(243,112,33,.22);
            transition: .15s;
        }

        .guest-btn:hover {
            background: var(--orange-dark);
            transform: translateY(-2px);
        }

        .toast {
            position: fixed;
            top: 18px;
            right: 18px;
            max-width: 360px;
            padding: 12px 14px;
            border-radius: 10px;
            background: #fff7f0;
            border: 1px solid rgba(243,112,33,.22);
            color: var(--orange-dark);
            box-shadow: 0 10px 28px rgba(0,0,0,.15);
            z-index: 10;
        }

        @media (max-width:820px) {

            .topbar {
                flex-direction: column;
                align-items: flex-start;
                gap: 18px;
            }

            .hero {
                grid-template-columns: 1fr;
                padding-top: 10px;
            }

            .visual {
                min-height: 320px;
            }

            .guest-title {
                font-size: 16px;
            }

            .guest-btn {
                font-size: 13px;
                min-height: 44px;
            }
        }
    </style>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/theme-orange.css" />
</head>

<body>

<% if ("1".equals(loginSuccess)) { %>
<div class="toast">
    Đăng nhập thành công. Chào mừng bạn.
</div>
<% } %>

<main class="page">

    <header class="topbar">
        <div class="brand">
            <span class="brand-mark"></span>
            TPMS
        </div>

    </header>

    <section class="hero">

        <div>
            <div class="eyebrow">
                Training Program Management System
            </div>

            <h1>
                Quản lý chương trình đào tạo rõ ràng hơn.
            </h1>

            <p class="lead">
                TPMS hỗ trợ quản lý môn học, đề cương, chương trình đào tạo
                và tài liệu học tập trên một hệ thống thống nhất.
            </p>

            <div class="cta-row">
                <a class="btn btn-primary"
                   href="<%=request.getContextPath()%>/register">
                    Đăng ký
                </a>

                <a class="btn btn-outline"
                   href="<%=request.getContextPath()%>/login">
                    Đăng nhập
                </a>
            </div>

            <div class="google-login">
                <a class="btn-google"
                   href="<%=request.getContextPath()%>/login/google">
                    <svg viewBox="0 0 24 24" aria-hidden="true">
                        <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                        <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                        <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                        <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                    </svg>
                    Đăng nhập bằng Google
                </a>
            </div>
        </div>

        <div class="visual">
            <div class="visual-content">
                <h2 class="guest-title">Guest's features </h2>

                <a class="guest-btn"
                   href="<%=request.getContextPath()%>/curriculum">
                    View Curriculum and Syllabus
                </a>

                <a class="guest-btn"
                   href="<%=request.getContextPath()%>/learning-path">
                    Show Learning Path of a Subject
                </a>

                <a class="guest-btn"
                   href="<%=request.getContextPath()%>/prerequisite">
                    A subject is the pre-requisite of
                </a>
            </div>
        </div>

    </section>

</main>

</body>
</html>
