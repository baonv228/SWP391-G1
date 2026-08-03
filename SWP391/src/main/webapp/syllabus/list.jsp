<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.util.List, model.Syllabus, model.User" %>
<%
    User user = (User) session.getAttribute("user");
    List<Syllabus> syllabuses = (List<Syllabus>) request.getAttribute("syllabuses");
    String success = request.getParameter("success");
    String keyword = (String) request.getAttribute("keyword");
    String statusFilter = (String) request.getAttribute("statusFilter");
    String sortBy = (String) request.getAttribute("sortBy");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer totalCount = (Integer) request.getAttribute("totalCount");
    if (currentPage == null) currentPage = 1;
    if (totalPages == null) totalPages = 1;
    if (totalCount == null) totalCount = 0;
    if (keyword == null) keyword = "";
    if (statusFilter == null) statusFilter = "all";
    if (sortBy == null) sortBy = "newest";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Danh sách Syllabus — TPMS</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/syllabus.css?v=3"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
</head>
<body class="syllabus-page" style="display: flex; flex-direction: column; min-height: 100vh;">

<jsp:include page="/view/header.jsp"/>

<div class="syl-container" style="flex: 1;">
<div style="max-width: 1300px; margin: 0 auto;">

    <!-- Page Header -->
    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; flex-wrap: wrap; gap: 12px;">
        <div>
            <h2 style="font-size: 26px; color: #c55416; margin: 0; font-weight: 700;">
                <i class="bi bi-journal-richtext me-2"></i>Quản lý Syllabus
            </h2>
            <p style="color: #888; margin: 4px 0 0 0; font-size: 14px;">Tổng cộng <strong><%= totalCount %></strong> syllabus</p>
        </div>
        <div style="display:flex; gap:10px; align-items:center;">
            <a class="btn btn-outline-secondary btn-sm" href="<%=request.getContextPath()%>/home">
                <i class="bi bi-arrow-left me-1"></i>Trang chủ
            </a>
            <a class="btn btn-sm" style="background: #f26d21; color: #fff; font-weight: 600;" href="<%=request.getContextPath()%>/syllabus-manage?action=create">
                <i class="bi bi-plus-lg me-1"></i>Tạo Syllabus mới
            </a>
        </div>
    </div>

    <!-- Success messages -->
    <% if ("1".equals(success) || "draft".equals(success)) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i>Lưu Draft thành công!
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } else if ("submit".equals(success)) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i>Đã gửi Syllabus để phê duyệt thành công!
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } else if ("update".equals(success)) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i>Cập nhật Syllabus thành công!
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } else if ("clone".equals(success)) { %>
    <div class="alert alert-info alert-dismissible fade show" role="alert">
        <i class="bi bi-info-circle-fill me-2"></i>Tạo phiên bản mới thành công! Vui lòng chỉnh sửa và nộp lại.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <!-- Search / Filter / Sort Bar -->
    <div style="background: #fff; border-radius: 12px; padding: 20px; margin-bottom: 24px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); border: 1px solid #e8e8e8;">
        <form action="<%=request.getContextPath()%>/syllabus-manage" method="GET" id="filterForm">
            <input type="hidden" name="action" value="list"/>
            <div class="row g-3 align-items-end">
                <!-- Search -->
                <div class="col-md-4">
                    <label class="form-label fw-semibold" style="font-size: 13px; color: #666;">
                        <i class="bi bi-search me-1"></i>Tìm kiếm
                    </label>
                    <input type="text" class="form-control" name="keyword" value="<%= keyword %>"
                           placeholder="Tìm theo mã môn, tên môn hoặc tiêu đề..." style="border-radius: 8px;"/>
                </div>
                <!-- Status Filter -->
                <div class="col-md-3">
                    <label class="form-label fw-semibold" style="font-size: 13px; color: #666;">
                        <i class="bi bi-funnel me-1"></i>Trạng thái
                    </label>
                    <select class="form-select" name="status" style="border-radius: 8px;">
                        <option value="all" <%= "all".equals(statusFilter) ? "selected" : "" %>>Tất cả</option>
                        <option value="Draft" <%= "Draft".equals(statusFilter) ? "selected" : "" %>>Draft</option>
                        <option value="Pending Approval" <%= "Pending Approval".equals(statusFilter) ? "selected" : "" %>>Pending Approval</option>
                        <option value="Approved" <%= "Approved".equals(statusFilter) ? "selected" : "" %>>Approved</option>
                        <option value="Rejected" <%= "Rejected".equals(statusFilter) ? "selected" : "" %>>Rejected</option>
                    </select>
                </div>
                <!-- Sort -->
                <div class="col-md-3">
                    <label class="form-label fw-semibold" style="font-size: 13px; color: #666;">
                        <i class="bi bi-sort-down me-1"></i>Sắp xếp
                    </label>
                    <select class="form-select" name="sort" style="border-radius: 8px;">
                        <option value="newest" <%= "newest".equals(sortBy) ? "selected" : "" %>>Mới nhất</option>
                        <option value="oldest" <%= "oldest".equals(sortBy) ? "selected" : "" %>>Cũ nhất</option>
                        <option value="name_asc" <%= "name_asc".equals(sortBy) ? "selected" : "" %>>Tên A → Z</option>
                        <option value="name_desc" <%= "name_desc".equals(sortBy) ? "selected" : "" %>>Tên Z → A</option>
                    </select>
                </div>
                <!-- Buttons -->
                <div class="col-md-2">
                    <button type="submit" class="btn w-100" style="background: #f26d21; color: #fff; font-weight: 600; border-radius: 8px;">
                        <i class="bi bi-search me-1"></i>Lọc
                    </button>
                </div>
            </div>
        </form>
        <% if (!keyword.isEmpty() || !"all".equals(statusFilter)) { %>
        <div style="margin-top: 12px; font-size: 13px; color: #888;">
            <i class="bi bi-filter-circle me-1"></i>Đang lọc:
            <% if (!keyword.isEmpty()) { %>
                <span class="badge bg-secondary me-1">Keyword: <%= keyword %></span>
            <% } %>
            <% if (!"all".equals(statusFilter)) { %>
                <span class="badge bg-warning text-dark me-1">Status: <%= statusFilter %></span>
            <% } %>
            <a href="<%=request.getContextPath()%>/syllabus-manage?action=list" style="color: #c62828; text-decoration: none; font-weight: 600;">
                <i class="bi bi-x-circle me-1"></i>Xóa bộ lọc
            </a>
        </div>
        <% } %>
    </div>

    <!-- Table -->
    <div style="background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); border: 1px solid #e8e8e8;">
        <% if (syllabuses == null || syllabuses.isEmpty()) { %>
        <div style="text-align: center; padding: 60px 20px; color: #888;">
            <i class="bi bi-journal-x" style="font-size: 48px; color: #ccc;"></i>
            <p style="margin-top: 16px; font-size: 16px;">Không tìm thấy Syllabus nào phù hợp.</p>
            <a class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/syllabus-manage?action=create">
                <i class="bi bi-plus-lg me-1"></i>Tạo Syllabus đầu tiên
            </a>
        </div>
        <% } else { %>
        <div style="overflow-x: auto;">
            <table class="table table-hover align-middle" style="margin-bottom: 0;">
                <thead>
                <tr style="background: linear-gradient(135deg, #f26d21, #c55416); color: #fff;">
                    <th style="border: none; padding: 12px 16px;">#</th>
                    <th style="border: none; padding: 12px 16px;">Mã môn</th>
                    <th style="border: none; padding: 12px 16px;">Tên môn</th>
                    <th style="border: none; padding: 12px 16px;">Syllabus Title</th>
                    <th style="border: none; padding: 12px 16px;">Version</th>
                    <th style="border: none; padding: 12px 16px;">Trạng thái</th>
                    <th style="border: none; padding: 12px 16px;">Ngày tạo</th>
                    <th style="border: none; padding: 12px 16px;">Hành động</th>
                </tr>
                </thead>
                <tbody>
                <% int idx = (currentPage - 1) * 10 + 1;
                    for (Syllabus s : syllabuses) {
                        String badgeClass = "bg-secondary";
                        if ("Pending Approval".equals(s.getStatus())) badgeClass = "bg-warning text-dark";
                        else if ("Approved".equals(s.getStatus())) badgeClass = "bg-success";
                        else if ("Rejected".equals(s.getStatus())) badgeClass = "bg-danger";
                        else if ("Draft".equals(s.getStatus())) badgeClass = "bg-info text-dark";
                %>
                <tr>
                    <td><%= idx++ %></td>
                    <td><strong><%= s.getSubjectCode() != null ? s.getSubjectCode() : "" %></strong></td>
                    <td><%= s.getSubjectName() != null ? s.getSubjectName() : "" %></td>
                    <td><%= s.getSyllabusTitle() != null ? s.getSyllabusTitle() : "" %></td>
                    <td><span class="badge bg-light text-dark border"><%= s.getVersionNo() != null ? s.getVersionNo() : "" %></span></td>
                    <td><span class="badge <%= badgeClass %>"><%= s.getStatus() %></span></td>
                    <td style="font-size: 13px; color: #666;"><%= s.getCreatedAt() != null ? s.getCreatedAt().toString().substring(0, 16) : "" %></td>
                    <td style="min-width: 160px;">
                        <% if ("Draft".equals(s.getStatus())) { %>
                        <a class="btn btn-outline-primary btn-sm" href="<%=request.getContextPath()%>/syllabus-manage?action=edit&id=<%= s.getSyllabusId() %>">
                            <i class="bi bi-pencil-square me-1"></i>Sửa
                        </a>
                        <a class="btn btn-outline-danger btn-sm" href="<%=request.getContextPath()%>/syllabus-manage?action=delete&id=<%= s.getSyllabusId() %>" 
                           onclick="return confirm('Bạn có chắc chắn muốn xóa Syllabus này không? Thao tác này không thể hoàn tác!');">
                            <i class="bi bi-trash me-1"></i>Xóa
                        </a>
                        <% } else if ("Rejected".equals(s.getStatus())) { %>
                        <button class="btn btn-outline-danger btn-sm" onclick="showReasonModal('<%= s.getNote() != null ? s.getNote().replace("'", "\\'").replace("\n", "\\n").replace("\r", "") : "" %>')">
                            <i class="bi bi-exclamation-triangle me-1"></i>Xem lý do
                        </button>
                        <a class="btn btn-outline-primary btn-sm" href="<%=request.getContextPath()%>/syllabus-manage?action=edit&id=<%= s.getSyllabusId() %>">
                            <i class="bi bi-pencil-square me-1"></i>Sửa
                        </a>
                        <% } else if ("Approved".equals(s.getStatus())) { %>
                        <a class="btn btn-outline-primary btn-sm" href="<%=request.getContextPath()%>/syllabus-manage?action=view&id=<%= s.getSyllabusId() %>">
                            <i class="bi bi-eye me-1"></i>Xem
                        </a>
                        <a class="btn btn-outline-warning btn-sm" href="<%=request.getContextPath()%>/syllabus-manage?action=clone_approved&id=<%= s.getSyllabusId() %>" 
                           onclick="return confirm('Hệ thống sẽ tạo ra một phiên bản nháp (Draft) mới từ phiên bản này để bạn chỉnh sửa. Bạn có muốn tiếp tục?');">
                            <i class="bi bi-copy me-1"></i>Tạo bản sửa
                        </a>
                        <% } else { %>
                        <a class="btn btn-outline-primary btn-sm" href="<%=request.getContextPath()%>/syllabus-manage?action=view&id=<%= s.getSyllabusId() %>">
                            <i class="bi bi-eye me-1"></i>Xem
                        </a>
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
                    <a class="page-link" href="<%=request.getContextPath()%>/syllabus-manage?action=list&page=<%= currentPage - 1 %>&keyword=<%= java.net.URLEncoder.encode(keyword, "UTF-8") %>&status=<%= statusFilter %>&sort=<%= sortBy %>">
                        <i class="bi bi-chevron-left"></i> Trước
                    </a>
                </li>
                <% 
                    int startPage = Math.max(1, currentPage - 2);
                    int endPage = Math.min(totalPages, currentPage + 2);
                    if (startPage > 1) { 
                %>
                    <li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/syllabus-manage?action=list&page=1&keyword=<%= java.net.URLEncoder.encode(keyword, "UTF-8") %>&status=<%= statusFilter %>&sort=<%= sortBy %>">1</a></li>
                    <% if (startPage > 2) { %><li class="page-item disabled"><span class="page-link">...</span></li><% } %>
                <% } %>
                <% for (int p = startPage; p <= endPage; p++) { %>
                <li class="page-item <%= p == currentPage ? "active" : "" %>">
                    <a class="page-link" href="<%=request.getContextPath()%>/syllabus-manage?action=list&page=<%= p %>&keyword=<%= java.net.URLEncoder.encode(keyword, "UTF-8") %>&status=<%= statusFilter %>&sort=<%= sortBy %>"><%= p %></a>
                </li>
                <% } %>
                <% if (endPage < totalPages) { %>
                    <% if (endPage < totalPages - 1) { %><li class="page-item disabled"><span class="page-link">...</span></li><% } %>
                    <li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/syllabus-manage?action=list&page=<%= totalPages %>&keyword=<%= java.net.URLEncoder.encode(keyword, "UTF-8") %>&status=<%= statusFilter %>&sort=<%= sortBy %>"><%= totalPages %></a></li>
                <% } %>
                <li class="page-item <%= currentPage >= totalPages ? "disabled" : "" %>">
                    <a class="page-link" href="<%=request.getContextPath()%>/syllabus-manage?action=list&page=<%= currentPage + 1 %>&keyword=<%= java.net.URLEncoder.encode(keyword, "UTF-8") %>&status=<%= statusFilter %>&sort=<%= sortBy %>">
                        Sau <i class="bi bi-chevron-right"></i>
                    </a>
                </li>
            </ul>
            <div class="text-center mt-2" style="font-size: 13px; color: #888;">
                Trang <%= currentPage %> / <%= totalPages %> — Hiển thị <%= syllabuses.size() %> / <%= totalCount %> kết quả
            </div>
        </nav>
        <% } %>

        <% } %>
    </div>

</div>
</div>

<!-- Reason Modal -->
<div class="modal fade" id="reasonModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header" style="background: linear-gradient(135deg, #c62828, #e53935); color: #fff;">
                <h5 class="modal-title"><i class="bi bi-exclamation-triangle me-2"></i>Lý do từ chối</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="reasonContent" style="white-space: pre-wrap; min-height: 80px;"></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script>
function showReasonModal(reason) {
    document.getElementById('reasonContent').textContent = reason || 'Không có lý do.';
    var modal = new bootstrap.Modal(document.getElementById('reasonModal'));
    modal.show();
}
</script>

<jsp:include page="/view/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
