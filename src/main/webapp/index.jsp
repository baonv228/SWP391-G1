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
                min-height: 250px;
            }
        }
    </style>
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

        <nav class="nav-actions">
            <a class="btn btn-outline"
               href="<%=request.getContextPath()%>/login">
                Đăng nhập
            </a>

            <a class="btn btn-primary"
               href="<%=request.getContextPath()%>/register">
                Đăng ký
            </a>
        </nav>
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
        </div>

        <div class="visual" aria-hidden="true"></div>

    </section>

</main>

</body>
</html>