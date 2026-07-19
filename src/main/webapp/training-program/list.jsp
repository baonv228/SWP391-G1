<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, model.TrainingProgram, model.User" %>
<%
    User user = (User) session.getAttribute("user");
    List<TrainingProgram> programs = (List<TrainingProgram>) request.getAttribute("programs");
    String success = request.getParameter("success");
    String updated = request.getParameter("updated");
    boolean canManage = user != null && user.getRole() != null
            && "Training Department".equalsIgnoreCase(user.getRole().getRoleName());
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Training Program - TPMS</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/training.css"/>
</head>
<body class="training-page">
<div class="train-container">
    <div class="train-header">
        <div>
            <h1>Training Program</h1>
            <div style="color: var(--muted); margin-top: 6px;">Danh sach chuong trinh dao tao trong he thong.</div>
        </div>
        <div>
            <a class="btn-train btn-outline-train" href="<%=request.getContextPath()%>/home">Dashboard</a>
            <% if (canManage) { %>
            <a class="btn-train btn-primary-train" href="<%=request.getContextPath()%>/training-program?action=create">+ New Program</a>
            <% } %>
        </div>
    </div>

    <% if ("1".equals(success)) { %>
    <div class="alert alert-success">Training Program da duoc tao thanh cong.</div>
    <% } %>
    <% if ("1".equals(updated)) { %>
    <div class="alert alert-success">Training Program da duoc cap nhat.</div>
    <% } %>

    <div class="train-card">
        <h2>Program List</h2>
        <% if (programs == null || programs.isEmpty()) { %>
        <div class="empty-state">
            <p>Chua co Training Program nao.</p>
            <% if (canManage) { %>
            <a class="btn-train btn-primary-train" href="<%=request.getContextPath()%>/training-program?action=create">Create first program</a>
            <% } %>
        </div>
        <% } else { %>
        <div style="overflow-x: auto;">
            <table class="train-table">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Code</th>
                    <th>Name</th>
                    <th>Academic Year</th>
                    <th>Major</th>
                    <th>PNO</th>
                    <th>Status</th>
                    <th>Created By</th>
                    <% if (canManage) { %><th>Actions</th><% } %>
                </tr>
                </thead>
                <tbody>
                <%
                    int idx = 1;
                    for (TrainingProgram p : programs) {
                        String badgeClass = "badge-active";
                        if (p.getStatus() != null && !"Active".equalsIgnoreCase(p.getStatus())) {
                            badgeClass = "badge-inactive";
                        }
                %>
                <tr>
                    <td><%= idx++ %></td>
                    <td><%= p.getProgramCode() != null ? p.getProgramCode() : "" %></td>
                    <td><%= p.getProgramName() != null ? p.getProgramName() : "" %></td>
                    <td><%= p.getAcademicYear() != null ? p.getAcademicYear() : "" %></td>
                    <td><%= p.getMajorName() != null ? p.getMajorName() : "" %></td>
                    <td><%= p.getPno() != null ? p.getPno() : "" %></td>
                    <td><span class="badge <%= badgeClass %>"><%= p.getStatus() != null ? p.getStatus() : "" %></span></td>
                    <td><%= p.getCreatedByName() != null ? p.getCreatedByName() : "" %></td>
                    <% if (canManage) { %>
                    <td>
                        <a class="btn-train btn-outline-train btn-sm" href="<%=request.getContextPath()%>/training-program?action=edit&id=<%= p.getProgramId() %>">Edit</a>
                    <a class="btn-train btn-outline-train btn-sm" href="<%=request.getContextPath()%>/curriculum-manage?action=create&programId=<%= p.getProgramId() %>">Create Curriculum</a>
                    </td>
                    <% } %>
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
