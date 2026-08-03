<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Syllabus Designer Dashboard — TPMS</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/syllabus.css?v=3"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"/>
</head>
<body class="syllabus-page" style="display: flex; flex-direction: column; min-height: 100vh;">

<jsp:include page="/view/header.jsp"/>

<div class="syl-container" style="flex: 1;">

    <!-- Welcome Banner -->
    <div style="background: linear-gradient(135deg, #f26d21, #c55416); color: #fff; padding: 40px; border-radius: 16px; margin-bottom: 32px; box-shadow: 0 8px 24px rgba(242,109,33,0.2); text-align: center;">
        <h2 style="color: #fff; font-size: 30px; margin-bottom: 10px; font-weight: 700;">
            <i class="bi bi-journal-richtext" style="margin-right: 8px;"></i>Syllabus Designer Dashboard
        </h2>
        <p style="font-size: 16px; opacity: 0.9; margin: 0;">
            Xin chào, <strong><%= user != null ? user.getFullName() : "Designer" %></strong>! 
            Hệ thống Quản lý Đề cương môn học. Vui lòng chọn một chức năng bên dưới để bắt đầu.
        </p>
    </div>

    <!-- Quick Stats -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; margin-bottom: 32px;">
        <div style="background: #fff; border-radius: 12px; padding: 24px; border-left: 4px solid #f26d21; box-shadow: 0 2px 12px rgba(0,0,0,0.06);">
            <div style="font-size: 14px; color: #888; margin-bottom: 4px;">Trạng thái hệ thống</div>
            <div style="font-size: 22px; font-weight: 700; color: #c55416;">Đang hoạt động</div>
            <div style="font-size: 12px; color: #aaa; margin-top: 4px;"><i class="bi bi-check-circle-fill" style="color: #2e7d32;"></i> Online</div>
        </div>
        <div style="background: #fff; border-radius: 12px; padding: 24px; border-left: 4px solid #2e7d32; box-shadow: 0 2px 12px rgba(0,0,0,0.06);">
            <div style="font-size: 14px; color: #888; margin-bottom: 4px;">Vai trò</div>
            <div style="font-size: 22px; font-weight: 700; color: #2e7d32;">Syllabus Designer</div>
            <div style="font-size: 12px; color: #aaa; margin-top: 4px;"><i class="bi bi-person-badge"></i> Thiết kế đề cương</div>
        </div>
        <div style="background: #fff; border-radius: 12px; padding: 24px; border-left: 4px solid #1565c0; box-shadow: 0 2px 12px rgba(0,0,0,0.06);">
            <div style="font-size: 14px; color: #888; margin-bottom: 4px;">Phiên làm việc</div>
            <div style="font-size: 22px; font-weight: 700; color: #1565c0;" id="currentTime">--:--</div>
            <div style="font-size: 12px; color: #aaa; margin-top: 4px;"><i class="bi bi-clock"></i> <span id="currentDate"></span></div>
        </div>
    </div>

    <!-- Actions Grid -->
    <h5 style="color: #4b3f35; font-weight: 700; margin-bottom: 20px;"><i class="bi bi-grid-3x3-gap-fill" style="margin-right: 8px;"></i>Chức năng chính</h5>
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 24px;">
        <a href="<%=request.getContextPath()%>/syllabus-manage?action=create" class="action-card">
            <div class="action-icon">📝</div>
            <div class="action-title">Tạo Syllabus mới</div>
            <div class="action-desc">Xây dựng đề cương môn học mới. Hỗ trợ nhập liệu thủ công và import từ file Excel.</div>
        </a>
        <a href="<%=request.getContextPath()%>/syllabus-manage?action=list" class="action-card">
            <div class="action-icon">🗂️</div>
            <div class="action-title">Danh sách Syllabus</div>
            <div class="action-desc">Quản lý, tìm kiếm, lọc và theo dõi trạng thái các đề cương đã tạo.</div>
        </a>
        <a href="<%=request.getContextPath()%>/syllabus-manage?action=teacher_requests" class="action-card">
            <div class="action-icon">📩</div>
            <div class="action-title">Yêu cầu từ Giáo viên</div>
            <div class="action-desc">Xem xét và phê duyệt các yêu cầu tạo mới hoặc chỉnh sửa Syllabus từ Giáo viên.</div>
        </a>
    </div>

</div>

<jsp:include page="/view/footer.jsp"/>

<style>
    .action-card {
        background: var(--white);
        border-radius: 12px;
        padding: 32px 24px;
        text-align: center;
        border: 1px solid rgba(242, 109, 33, 0.15);
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
        box-shadow: 0 8px 24px rgba(242, 109, 33, 0.15);
        border-color: var(--primary);
    }
    .action-icon { font-size: 48px; margin-bottom: 16px; color: var(--primary); }
    .action-title { font-size: 20px; font-weight: 700; color: var(--primary-dark); margin-bottom: 8px; }
    .action-desc { font-size: 14px; color: var(--muted); line-height: 1.5; }
</style>

<script>
    function updateClock() {
        var now = new Date();
        document.getElementById('currentTime').textContent = 
            now.getHours().toString().padStart(2,'0') + ':' + now.getMinutes().toString().padStart(2,'0') + ':' + now.getSeconds().toString().padStart(2,'0');
        document.getElementById('currentDate').textContent = 
            now.getDate().toString().padStart(2,'0') + '/' + (now.getMonth()+1).toString().padStart(2,'0') + '/' + now.getFullYear();
    }
    updateClock();
    setInterval(updateClock, 1000);
</script>

</body>
</html>
