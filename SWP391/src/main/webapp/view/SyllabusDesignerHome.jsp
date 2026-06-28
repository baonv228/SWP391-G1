<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Syllabus Designer Home — TPMS</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/syllabus.css"/>
    <style>
        .home-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 24px;
            margin-top: 32px;
        }

        .action-card {
            background: var(--white);
            border-radius: 12px;
            padding: 32px 24px;
            text-align: center;
            border: 1px solid rgba(47, 125, 50, 0.15);
            box-shadow: 0 4px 16px rgba(75, 63, 53, 0.05);
            transition: all 0.3s ease;
            text-decoration: none;
            color: inherit;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 220px;
        }

        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 24px rgba(47, 125, 50, 0.15);
            border-color: var(--leaf);
        }

        .action-icon {
            font-size: 48px;
            margin-bottom: 16px;
            color: var(--leaf);
        }

        .action-title {
            font-size: 20px;
            font-weight: 700;
            color: var(--leaf-dark);
            margin-bottom: 8px;
        }

        .action-desc {
            font-size: 14px;
            color: var(--muted);
            line-height: 1.5;
        }
        
        .welcome-banner {
            background: var(--leaf);
            color: var(--white);
            padding: 40px;
            border-radius: 12px;
            margin-bottom: 32px;
            box-shadow: 0 8px 24px rgba(47, 125, 50, 0.2);
            text-align: center;
        }
        
        .welcome-banner h1 {
            color: var(--white);
            font-size: 32px;
            margin-bottom: 10px;
        }
        
        .welcome-banner p {
            font-size: 16px;
            opacity: 0.9;
        }
    </style>
</head>
<body class="syllabus-page">
<div class="syl-container">

    <!-- Header / Navbar -->
    <div class="syl-header" style="border-bottom: 1px solid var(--border); padding-bottom: 16px; margin-bottom: 32px;">
        <div style="font-size: 24px; font-weight: 800; color: var(--leaf-dark); letter-spacing: 0.05em;">TPMS</div>
        <div>
            <span style="margin-right:16px; color:var(--muted); font-size:15px; font-weight: 500;">
                Xin chào, <%= user != null ? user.getFullName() : "Designer" %>
            </span>
            <a class="btn-syl btn-outline-syl" href="<%=request.getContextPath()%>/logout" style="border-color: #d4d8d4; color: var(--muted);">
                Đăng xuất
            </a>
        </div>
    </div>

    <!-- Welcome Banner -->
    <div class="welcome-banner">
        <h1>Syllabus Designer Dashboard</h1>
        <p>Hệ thống Quản lý Đề cương môn học. Vui lòng chọn một chức năng bên dưới để bắt đầu.</p>
    </div>

    <!-- Actions Grid -->
    <div class="home-grid">
        <a href="<%=request.getContextPath()%>/syllabus?action=create" class="action-card">
            <div class="action-icon">📝</div>
            <div class="action-title">Tạo Syllabus mới</div>
            <div class="action-desc">Xây dựng đề cương môn học mới dựa trên các môn học đang chờ xử lý.</div>
        </a>

        <a href="<%=request.getContextPath()%>/syllabus?action=list" class="action-card">
            <div class="action-icon">🗂️</div>
            <div class="action-title">Danh sách Syllabus</div>
            <div class="action-desc">Quản lý, xem lại và theo dõi trạng thái các đề cương mà bạn đã tạo.</div>
        </a>
        
        <a href="#" class="action-card" style="opacity: 0.6; cursor: not-allowed;" onclick="event.preventDefault(); alert('Chức năng đang phát triển!');">
            <div class="action-icon">📊</div>
            <div class="action-title">Báo cáo & Thống kê</div>
            <div class="action-desc">Tính năng đang trong quá trình phát triển, sẽ sớm ra mắt.</div>
        </a>
    </div>

</div>
</body>
</html>
