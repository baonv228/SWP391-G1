<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, model.Syllabus, model.User" %>
<%
    User user = (User) session.getAttribute("user");
    List<Syllabus> syllabuses = (List<Syllabus>) request.getAttribute("syllabuses");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Danh sách Syllabus — TPMS</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/syllabus.css"/>
</head>
<body class="syllabus-page">
<div class="syl-container">

    <!-- Header -->
    <div class="syl-header">
        <div>
            <h1>Quản lý Syllabus</h1>
        </div>
        <div style="display:flex; gap:10px; align-items:center;">
            <span style="color:var(--muted); font-size:14px;">
                Xin chào, <strong><%= user != null ? user.getFullName() : "" %></strong>
            </span>
            <a class="btn-syl btn-outline-syl btn-sm" href="<%=request.getContextPath()%>/home">
                ← Trang chủ
            </a>
            <a class="btn-syl btn-primary-syl" href="<%=request.getContextPath()%>/syllabus?action=create">
                + Tạo Syllabus mới
            </a>
        </div>
    </div>

    <!-- Success messages -->
    <% if ("1".equals(success) || "draft".equals(success)) { %>
    <div class="alert alert-success">Lưu Draft thành công!</div>
    <% } else if ("submit".equals(success)) { %>
    <div class="alert alert-success">Đã gửi Syllabus để phê duyệt thành công!</div>
    <% } else if ("update".equals(success)) { %>
    <div class="alert alert-success">Cập nhật Syllabus thành công!</div>
    <% } %>

    <!-- Table -->
    <div class="syl-card">
        <h2>Danh sách Syllabus đã tạo</h2>

        <% if (syllabuses == null || syllabuses.isEmpty()) { %>
        <div class="empty-state">
            <p>Bạn chưa tạo Syllabus nào.</p>
            <a class="btn-syl btn-outline-syl" href="<%=request.getContextPath()%>/syllabus-manage?action=create">
                Tạo Syllabus đầu tiên
            </a>
        </div>
        <% } else { %>
        <div style="overflow-x: auto;">
            <table class="syl-table">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Mã môn</th>
                    <th>Tên môn</th>
                    <th>Syllabus Title</th>
                    <th>Version</th>
                    <th>Trạng thái</th>
                    <th>Ngày tạo</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <% int idx = 1;
                    for (Syllabus s : syllabuses) {
                        String badgeClass = "badge-draft";
                        if ("Pending Approval".equals(s.getStatus())) badgeClass = "badge-pending";
                        else if ("Approved".equals(s.getStatus())) badgeClass = "badge-approved";
                        else if ("Rejected".equals(s.getStatus())) badgeClass = "badge-rejected";
                %>
                <tr>
                    <td><%= idx++ %></td>
                    <td><%= s.getSubjectCode() != null ? s.getSubjectCode() : "" %></td>
                    <td><%= s.getSubjectName() != null ? s.getSubjectName() : "" %></td>
                    <td><%= s.getSyllabusTitle() != null ? s.getSyllabusTitle() : "" %></td>
                    <td><%= s.getVersionNo() != null ? s.getVersionNo() : "" %></td>
                    <td><span class="badge <%= badgeClass %>"><%= s.getStatus() %></span></td>
                    <td><%= s.getCreatedAt() != null ? s.getCreatedAt().toString().substring(0, 16) : "" %></td>
                    <td>
                        <% if ("Draft".equals(s.getStatus())) { %>
                        <a class="btn-syl btn-outline-syl btn-sm" href="<%=request.getContextPath()%>/syllabus?action=edit&id=<%= s.getSyllabusId() %>">
                            ✏️ Sửa
                        </a>
                        <% } else { %>
                        <a class="btn-syl btn-outline-syl btn-sm" href="<%=request.getContextPath()%>/syllabus?action=view&id=<%= s.getSyllabusId() %>" style="border-color:#1565c0; color:#1565c0;">
                            👁️ Xem
                        </a>
                        <% } %>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>

</div>
</body>
</html>
