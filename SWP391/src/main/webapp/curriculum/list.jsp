<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, model.Curriculum, model.User" %>
<%
    User user = (User) session.getAttribute("user");
    List<Curriculum> curriculums = (List<Curriculum>) request.getAttribute("curriculums");
    String success = request.getParameter("success");
    boolean canManage = user != null && user.getRole() != null
            && "Training Department".equalsIgnoreCase(user.getRole().getRoleName());
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Curriculum - TPMS</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/training.css"/>
</head>
<body class="training-page">
<div class="train-container">
    <div class="train-header">
        <div>
            <h1>Curriculum</h1>
            <div style="color: var(--muted); margin-top: 6px;">Danh sach curriculum theo training program.</div>
        </div>
        <div>
            <a class="btn-train btn-outline-train" href="<%=request.getContextPath()%>/home">Dashboard</a>
            <% if (canManage) { %>
            <a class="btn-train btn-primary-train" href="<%=request.getContextPath()%>/curriculum?action=create">+ New Curriculum</a>
            <% } %>
        </div>
    </div>

    <% if ("1".equals(success)) { %>
    <div class="alert alert-success">Curriculum da duoc tao thanh cong.</div>
    <% } %>

    <div class="train-card">
        <h2>Curriculum List</h2>
        <% if (curriculums == null || curriculums.isEmpty()) { %>
        <div class="empty-state">
            <p>Chua co curriculum nao.</p>
            <% if (canManage) { %>
            <a class="btn-train btn-primary-train" href="<%=request.getContextPath()%>/curriculum?action=create">Create first curriculum</a>
            <% } %>
        </div>
        <% } else { %>
        <div style="overflow-x: auto;">
            <table class="train-table">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Program</th>
                    <th>Curriculum Name</th>
                    <th>Subjects</th>
                    <th>Status</th>
                    <th>Created By</th>
                </tr>
                </thead>
                <tbody>
                <%
                    int idx = 1;
                    for (Curriculum c : curriculums) {
                        String badgeClass = "badge-active";
                        if (c.getStatus() != null && !"Active".equalsIgnoreCase(c.getStatus())) {
                            badgeClass = "badge-inactive";
                        }
                %>
                <tr>
                    <td><%= idx++ %></td>
                    <td><%= (c.getProgramCode() != null ? c.getProgramCode() : "") %><% if (c.getProgramName() != null) { %> - <%= c.getProgramName() %><% } %></td>
                    <td><%= c.getCurriculumName() != null ? c.getCurriculumName() : "" %></td>
                    <td><%= c.getSubjectCount() %></td>
                    <td><span class="badge <%= badgeClass %>"><%= c.getStatus() != null ? c.getStatus() : "" %></span></td>
                    <td><%= c.getCreatedByName() != null ? c.getCreatedByName() : "" %></td>
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
