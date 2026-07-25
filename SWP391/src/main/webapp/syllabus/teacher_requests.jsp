<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.SyllabusRequestDTO" %>
<%
    List<SyllabusRequestDTO> requests = (List<SyllabusRequestDTO>) request.getAttribute("requests");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <title>Yêu cầu từ Giáo viên — TPMS</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/syllabus.css?v=2"/>
    <style>
        .badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-pending { background-color: #ffe0b2; color: #e65100; }
        .badge-approved { background-color: #c8e6c9; color: #2e7d32; }
        .badge-rejected { background-color: #ffcdd2; color: #c62828; }
        
        .request-note {
            max-width: 250px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
    </style>
</head>
<body class="syllabus-page">
<div class="syl-container">

    <!-- Header -->
    <div class="syl-header">
        <h1>Yêu cầu từ Giáo viên</h1>
        <div>
            <a class="btn-syl btn-outline-syl" href="<%=request.getContextPath()%>/home" style="margin-right: 10px;">
                &larr; Trang chủ
            </a>
        </div>
    </div>

    <!-- Alerts -->
    <% if ("1".equals(success)) { %>
    <div class="alert alert-success">Cập nhật yêu cầu thành công!</div>
    <% } else if ("1".equals(error)) { %>
    <div class="alert alert-danger" style="background:#ffcdd2; color:#c62828; padding:12px; border-radius:6px; margin-bottom:20px;">Lỗi khi cập nhật yêu cầu.</div>
    <% } %>

    <!-- Table -->
    <div class="syl-card">
        <h2>Danh sách Yêu cầu Pending</h2>

        <% if (requests == null || requests.isEmpty()) { %>
        <div class="empty-state">
            <p>Hiện không có yêu cầu mới nào từ Giáo viên.</p>
        </div>
        <% } else { %>
        <div style="overflow-x: auto;">
            <table class="syl-table">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Môn học</th>
                    <th>Syllabus</th>
                    <th>Người gửi</th>
                    <th>Loại Yêu cầu</th>
                    <th>Ghi chú</th>
                    <th>Ngày gửi</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <% int idx = 1;
                    for (SyllabusRequestDTO r : requests) {
                        String badgeClass = "badge-pending";
                %>
                <tr>
                    <td><%= idx++ %></td>
                    <td><%= r.getSubjectCode() %></td>
                    <td><%= r.getSyllabusTitle() %></td>
                    <td><%= r.getRequestedByName() %></td>
                    <td><span class="badge <%=badgeClass%>"><%= r.getRequestType() %></span></td>
                    <td class="request-note" title="<%= r.getReviewNote() != null ? r.getReviewNote().replace("\"", "&quot;") : "" %>">
                        <%= r.getReviewNote() != null ? r.getReviewNote() : "" %>
                    </td>
                    <td><%= r.getRequestedAt() != null ? r.getRequestedAt().toString().substring(0, 16) : "" %></td>
                    <td style="min-width: 140px;">
                        <form action="<%=request.getContextPath()%>/syllabus-manage" method="POST" style="display:inline;">
                            <input type="hidden" name="action" value="review_teacher_request">
                            <input type="hidden" name="requestId" value="<%= r.getRequestId() %>">
                            <input type="hidden" name="status" value="Approved">
                            <button type="submit" class="btn-syl btn-primary-syl btn-sm" onclick="return confirm('Bạn có chắc chắn chấp nhận yêu cầu này không?');">
                                Đồng ý
                            </button>
                        </form>
                        <button class="btn-syl btn-danger-syl btn-sm" style="margin-left:5px;" onclick="showRejectModal(<%= r.getRequestId() %>)">
                            Từ chối
                        </button>
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
.syl-modal-header {
    display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;
    border-bottom: 1px solid #eee; padding-bottom: 10px;
}
.syl-modal-title { font-size: 18px; font-weight: 600; color: #e65100; margin: 0; }
.syl-modal-close { background: none; border: none; font-size: 24px; cursor: pointer; color: #666; }
.syl-modal-body { font-size: 14px; color: #333; line-height: 1.5; margin-bottom: 20px; }
.syl-modal-footer { display: flex; justify-content: flex-end; gap: 10px; }
.form-group-modal { margin-bottom: 15px; }
.form-group-modal label { display: block; margin-bottom: 5px; font-weight: 500; }
.form-group-modal textarea { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;}
</style>

<!-- Reject Modal -->
<div class="syl-modal-overlay" id="rejectModal">
    <div class="syl-modal">
        <div class="syl-modal-header">
            <h3 class="syl-modal-title">Từ chối Yêu cầu</h3>
            <button class="syl-modal-close" onclick="closeModal('rejectModal')">&times;</button>
        </div>
        <form action="<%=request.getContextPath()%>/syllabus-manage" method="POST">
            <input type="hidden" name="action" value="review_teacher_request">
            <input type="hidden" name="requestId" id="rejectRequestId">
            <input type="hidden" name="status" value="Rejected">
            <div class="syl-modal-body">
                <div class="form-group-modal">
                    <label>Lý do từ chối (bắt buộc):</label>
                    <textarea name="reviewNote" rows="4" required placeholder="Nhập lý do từ chối..."></textarea>
                </div>
            </div>
            <div class="syl-modal-footer">
                <button type="button" class="btn-syl btn-outline-syl" onclick="closeModal('rejectModal')">Hủy</button>
                <button type="submit" class="btn-syl btn-danger-syl">Từ chối</button>
            </div>
        </form>
    </div>
</div>

<script>
function closeModal(id) {
    document.getElementById(id).style.display = 'none';
}
function showRejectModal(id) {
    document.getElementById('rejectRequestId').value = id;
    document.getElementById('rejectModal').style.display = 'flex';
}
</script>

</body>
</html>
