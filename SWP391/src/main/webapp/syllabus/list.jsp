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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/syllabus.css?v=2"/>
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
            <a class="btn-syl btn-primary-syl" href="<%=request.getContextPath()%>/syllabus-manage?action=create">
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
    <% } else if ("clone".equals(success)) { %>
    <div class="alert alert-success">Tạo phiên bản mới thành công! Vui lòng chỉnh sửa và nộp lại.</div>
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
                        <a class="btn-syl btn-outline-syl btn-sm" href="<%=request.getContextPath()%>/syllabus-manage?action=edit&id=<%= s.getSyllabusId() %>">
                            Sửa
                        </a>
                        <a class="btn-syl btn-danger-syl btn-sm" href="<%=request.getContextPath()%>/syllabus-manage?action=delete&id=<%= s.getSyllabusId() %>" onclick="return confirm('Bạn có chắc chắn muốn xóa Syllabus này không? Thao tác này không thể hoàn tác!');" style="margin-left: 5px;">
                            Xóa
                        </a>
                        <% } else if ("Rejected".equals(s.getStatus())) { %>
                        <button class="btn-syl btn-danger-syl btn-sm" onclick="showReasonModal('<%= s.getNote() != null ? s.getNote().replace("'", "\\'").replace("\n", "\\n").replace("\r", "") : "" %>')">
                            Xem lý do
                        </button>
                        <a class="btn-syl btn-outline-syl btn-sm" href="<%=request.getContextPath()%>/syllabus-manage?action=edit&id=<%= s.getSyllabusId() %>" style="margin-left: 5px;">
                            Sửa
                        </a>
                        <% } else if ("Approved".equals(s.getStatus())) { %>
                        <a class="btn-syl btn-outline-syl btn-sm" href="<%=request.getContextPath()%>/syllabus-manage?action=view&id=<%= s.getSyllabusId() %>" style="border-color:#1565c0; color:#1565c0;">
                            Xem
                        </a>
                        <a class="btn-syl btn-outline-syl btn-sm" href="<%=request.getContextPath()%>/syllabus-manage?action=clone_approved&id=<%= s.getSyllabusId() %>" style="margin-left: 5px;" onclick="return confirm('Hệ thống sẽ tạo ra một phiên bản nháp (Draft) mới từ phiên bản này để bạn chỉnh sửa. Bạn có muốn tiếp tục?');">
                            Sửa
                        </a>
                        <% } else { %>
                        <a class="btn-syl btn-outline-syl btn-sm" href="<%=request.getContextPath()%>/syllabus-manage?action=view&id=<%= s.getSyllabusId() %>" style="border-color:#1565c0; color:#1565c0;">
                            Xem
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

<!-- CSS for Modals -->
<style>
.syl-modal-overlay {
    display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
    background: rgba(0,0,0,0.5); z-index: 9999; justify-content: center; align-items: center;
}
.syl-modal {
    background: #fff; padding: 20px; border-radius: 8px; max-width: 500px; width: 90%;
    box-shadow: 0 4px 15px rgba(0,0,0,0.2); position: relative;
}
.syl-modal-lg {
    max-width: 800px;
}
.syl-modal-header {
    display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;
    border-bottom: 1px solid #eee; padding-bottom: 10px;
}
.syl-modal-title { font-size: 18px; font-weight: 600; color: #e65100; margin: 0; }
.syl-modal-close { background: none; border: none; font-size: 24px; cursor: pointer; color: #666; }
.syl-modal-body { font-size: 14px; color: #333; line-height: 1.5; margin-bottom: 20px; max-height: 60vh; overflow-y: auto;}
.syl-modal-footer { display: flex; justify-content: flex-end; gap: 10px; }
.form-group-modal { margin-bottom: 15px; }
.form-group-modal label { display: block; margin-bottom: 5px; font-weight: 500; }
.form-group-modal textarea { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;}
.history-table { width: 100%; border-collapse: collapse; margin-top: 10px; }
.history-table th, .history-table td { border: 1px solid #ddd; padding: 8px; text-align: left; }
.history-table th { background-color: #f8f9fa; }
</style>

<!-- Reason Modal -->
<div class="syl-modal-overlay" id="reasonModal">
    <div class="syl-modal">
        <div class="syl-modal-header">
            <h3 class="syl-modal-title">Lý do từ chối</h3>
            <button class="syl-modal-close" onclick="closeModal('reasonModal')">&times;</button>
        </div>
        <div class="syl-modal-body" id="reasonContent" style="white-space: pre-wrap;"></div>
        <div class="syl-modal-footer">
            <button class="btn-syl btn-outline-syl" onclick="closeModal('reasonModal')">Đóng</button>
        </div>
    </div>
</div>

<script>
function closeModal(id) {
    document.getElementById(id).style.display = 'none';
}
function showReasonModal(reason) {
    document.getElementById('reasonContent').textContent = reason || 'Không có lý do.';
    document.getElementById('reasonModal').style.display = 'flex';
}
</script>

</body>
</html>
