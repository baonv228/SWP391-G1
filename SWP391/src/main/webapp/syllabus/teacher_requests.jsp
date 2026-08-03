<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.SyllabusRequestDTO" %>
<%
    List<SyllabusRequestDTO> requests = (List<SyllabusRequestDTO>) request.getAttribute("requests");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    String statusFilter = (String) request.getAttribute("statusFilter");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer totalCount = (Integer) request.getAttribute("totalCount");
    if (currentPage == null) currentPage = 1;
    if (totalPages == null) totalPages = 1;
    if (totalCount == null) totalCount = 0;
    if (statusFilter == null) statusFilter = "all";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Yêu cầu từ Giáo viên — TPMS</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/syllabus.css?v=3"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
</head>
<body class="syllabus-page" style="display: flex; flex-direction: column; min-height: 100vh;">

<jsp:include page="/view/header.jsp"/>

<div class="syl-container" style="flex: 1;">

    <!-- Page Header -->
    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; flex-wrap: wrap; gap: 12px;">
        <div>
            <h2 style="font-size: 26px; color: #c55416; margin: 0; font-weight: 700;">
                <i class="bi bi-envelope-paper me-2"></i>Yêu cầu từ Giáo viên
            </h2>
            <p style="color: #888; margin: 4px 0 0 0; font-size: 14px;">Tổng cộng <strong><%= totalCount %></strong> yêu cầu</p>
        </div>
        <div style="display:flex; gap:10px; align-items:center;">
            <a class="btn btn-outline-secondary btn-sm" href="<%=request.getContextPath()%>/home">
                <i class="bi bi-arrow-left me-1"></i>Trang chủ
            </a>
            <a class="btn btn-outline-secondary btn-sm" href="<%=request.getContextPath()%>/syllabus-manage?action=list">
                <i class="bi bi-journal-richtext me-1"></i>Danh sách Syllabus
            </a>
        </div>
    </div>

    <!-- Alerts -->
    <% if ("1".equals(success)) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i>Cập nhật yêu cầu thành công!
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } else if ("1".equals(error)) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-x-circle-fill me-2"></i>Lỗi khi cập nhật yêu cầu.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <!-- Filter Bar -->
    <div style="background: #fff; border-radius: 12px; padding: 20px; margin-bottom: 24px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); border: 1px solid #e8e8e8;">
        <form action="<%=request.getContextPath()%>/syllabus-manage" method="GET">
            <input type="hidden" name="action" value="teacher_requests"/>
            <div class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label class="form-label fw-semibold" style="font-size: 13px; color: #666;">
                        <i class="bi bi-funnel me-1"></i>Lọc theo trạng thái
                    </label>
                    <select class="form-select" name="statusFilter" style="border-radius: 8px;">
                        <option value="all" <%= "all".equals(statusFilter) ? "selected" : "" %>>Tất cả</option>
                        <option value="Pending" <%= "Pending".equals(statusFilter) ? "selected" : "" %>>Pending (Chờ xử lý)</option>
                        <option value="Approved" <%= "Approved".equals(statusFilter) ? "selected" : "" %>>Approved (Đã duyệt)</option>
                        <option value="Rejected" <%= "Rejected".equals(statusFilter) ? "selected" : "" %>>Rejected (Đã từ chối)</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn w-100" style="background: #f26d21; color: #fff; font-weight: 600; border-radius: 8px;">
                        <i class="bi bi-search me-1"></i>Lọc
                    </button>
                </div>
                <% if (!"all".equals(statusFilter)) { %>
                <div class="col-md-6 d-flex align-items-center" style="font-size: 13px; color: #888;">
                    <i class="bi bi-filter-circle me-1"></i>Đang lọc: 
                    <span class="badge bg-warning text-dark ms-1"><%= statusFilter %></span>
                    <a href="<%=request.getContextPath()%>/syllabus-manage?action=teacher_requests" style="color: #c62828; text-decoration: none; font-weight: 600; margin-left: 8px;">
                        <i class="bi bi-x-circle me-1"></i>Xóa bộ lọc
                    </a>
                </div>
                <% } %>
            </div>
        </form>
    </div>

    <!-- Table -->
    <div style="background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); border: 1px solid #e8e8e8;">
        <% if (requests == null || requests.isEmpty()) { %>
        <div style="text-align: center; padding: 60px 20px; color: #888;">
            <i class="bi bi-envelope-x" style="font-size: 48px; color: #ccc;"></i>
            <p style="margin-top: 16px; font-size: 16px;">Không có yêu cầu nào phù hợp.</p>
        </div>
        <% } else { %>
        <div style="overflow-x: auto;">
            <table class="table table-hover align-middle" style="margin-bottom: 0;">
                <thead>
                <tr style="background: linear-gradient(135deg, #f26d21, #c55416); color: #fff;">
                    <th style="border: none; padding: 12px 16px;">#</th>
                    <th style="border: none; padding: 12px 16px;">Môn học</th>
                    <th style="border: none; padding: 12px 16px;">Syllabus</th>
                    <th style="border: none; padding: 12px 16px;">Người gửi</th>
                    <th style="border: none; padding: 12px 16px;">Loại Yêu cầu</th>
                    <th style="border: none; padding: 12px 16px;">Trạng thái</th>
                    <th style="border: none; padding: 12px 16px;">Ghi chú</th>
                    <th style="border: none; padding: 12px 16px;">Ngày gửi</th>
                    <th style="border: none; padding: 12px 16px;">Hành động</th>
                </tr>
                </thead>
                <tbody>
                <% int idx = (currentPage - 1) * 10 + 1;
                    for (SyllabusRequestDTO r : requests) {
                        String typeBadge = "bg-secondary";
                        if ("New".equals(r.getRequestType())) typeBadge = "bg-success";
                        else if ("Modify".equals(r.getRequestType())) typeBadge = "bg-warning text-dark";
                        else if ("Deactivate".equals(r.getRequestType())) typeBadge = "bg-danger";

                        String statusBadge = "bg-secondary";
                        if ("Pending".equals(r.getStatus())) statusBadge = "bg-warning text-dark";
                        else if ("Approved".equals(r.getStatus())) statusBadge = "bg-success";
                        else if ("Rejected".equals(r.getStatus())) statusBadge = "bg-danger";
                %>
                <tr>
                    <td><%= idx++ %></td>
                    <td><strong><%= r.getSubjectCode() %></strong></td>
                    <td><%= r.getSyllabusTitle() %></td>
                    <td><i class="bi bi-person me-1"></i><%= r.getRequestedByName() %></td>
                    <td><span class="badge <%= typeBadge %>"><%= r.getRequestType() %></span></td>
                    <td><span class="badge <%= statusBadge %>"><%= r.getStatus() %></span></td>
                    <td style="max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" 
                        title="<%= r.getReviewNote() != null ? r.getReviewNote().replace("\"", "&quot;") : "" %>">
                        <%= r.getReviewNote() != null ? r.getReviewNote() : "" %>
                    </td>
                    <td style="font-size: 13px; color: #666;"><%= r.getRequestedAt() != null ? r.getRequestedAt().toString().substring(0, 16) : "" %></td>
                    <td style="min-width: 160px;">
                        <% if ("Pending".equals(r.getStatus())) { %>
                        <form action="<%=request.getContextPath()%>/syllabus-manage" method="POST" style="display:inline;">
                            <input type="hidden" name="action" value="review_teacher_request">
                            <input type="hidden" name="requestId" value="<%= r.getRequestId() %>">
                            <input type="hidden" name="status" value="Approved">
                            <button type="submit" class="btn btn-success btn-sm" onclick="return confirm('Bạn có chắc chắn chấp nhận yêu cầu này không?');">
                                <i class="bi bi-check-lg me-1"></i>Đồng ý
                            </button>
                        </form>
                        <button class="btn btn-outline-danger btn-sm" onclick="showRejectModal(<%= r.getRequestId() %>)">
                            <i class="bi bi-x-lg me-1"></i>Từ chối
                        </button>
                        <% } else { %>
                        <span class="text-muted" style="font-size: 13px;">Đã xử lý</span>
                        <% } %>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <% if (totalPages > 1) { %>
        <nav style="margin-top: 20px;">
            <ul class="pagination justify-content-center mb-0">
                <li class="page-item <%= currentPage <= 1 ? "disabled" : "" %>">
                    <a class="page-link" href="<%=request.getContextPath()%>/syllabus-manage?action=teacher_requests&page=<%= currentPage - 1 %>&statusFilter=<%= statusFilter %>">
                        <i class="bi bi-chevron-left"></i> Trước
                    </a>
                </li>
                <% for (int p = 1; p <= totalPages; p++) { %>
                <li class="page-item <%= p == currentPage ? "active" : "" %>">
                    <a class="page-link" href="<%=request.getContextPath()%>/syllabus-manage?action=teacher_requests&page=<%= p %>&statusFilter=<%= statusFilter %>"><%= p %></a>
                </li>
                <% } %>
                <li class="page-item <%= currentPage >= totalPages ? "disabled" : "" %>">
                    <a class="page-link" href="<%=request.getContextPath()%>/syllabus-manage?action=teacher_requests&page=<%= currentPage + 1 %>&statusFilter=<%= statusFilter %>">
                        Sau <i class="bi bi-chevron-right"></i>
                    </a>
                </li>
            </ul>
            <div class="text-center mt-2" style="font-size: 13px; color: #888;">
                Trang <%= currentPage %> / <%= totalPages %> — Hiển thị <%= requests.size() %> / <%= totalCount %> kết quả
            </div>
        </nav>
        <% } %>

        <% } %>
    </div>

</div>
</div>

<!-- Reject Modal (Bootstrap 5) -->
<div class="modal fade" id="rejectModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header" style="background: linear-gradient(135deg, #c62828, #e53935); color: #fff;">
                <h5 class="modal-title"><i class="bi bi-x-circle me-2"></i>Từ chối Yêu cầu</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%=request.getContextPath()%>/syllabus-manage" method="POST">
                <input type="hidden" name="action" value="review_teacher_request">
                <input type="hidden" name="requestId" id="rejectRequestId">
                <input type="hidden" name="status" value="Rejected">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Lý do từ chối <span class="text-danger">*</span></label>
                        <textarea name="reviewNote" class="form-control" rows="4" required placeholder="Nhập lý do từ chối..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-danger"><i class="bi bi-x-circle me-1"></i>Từ chối</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function showRejectModal(id) {
    document.getElementById('rejectRequestId').value = id;
    var modal = new bootstrap.Modal(document.getElementById('rejectModal'));
    modal.show();
}
</script>

<jsp:include page="/view/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
