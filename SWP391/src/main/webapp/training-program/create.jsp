<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.TrainingProgram, model.User" %>
<%
    User user = (User) session.getAttribute("user");
    TrainingProgram program = (TrainingProgram) request.getAttribute("program");
    String error = (String) request.getAttribute("error");
    boolean canManage = user != null && user.getRole() != null
            && "Training Department".equalsIgnoreCase(user.getRole().getRoleName());
    if (!canManage) {
        response.sendRedirect(request.getContextPath() + "/training-program?action=list");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Create Training Program - TPMS</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/training.css"/>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/theme-orange.css" />
</head>
<body class="training-page">
<div class="train-container">
    <div class="train-header">
        <div>
            <h1>Create Training Program</h1>
            <div style="color: var(--muted); margin-top: 6px;">Them moi chuong trinh dao tao.</div>
        </div>
        <div>
            <a class="btn-train btn-outline-train" href="<%=request.getContextPath()%>/training-program?action=list">Back to list</a>
        </div>
    </div>

    <% if (error != null) { %>
    <div class="alert alert-error"><%= error %></div>
    <% } %>

    <div class="train-card">
        <form method="post" action="<%=request.getContextPath()%>/training-program">
            <input type="hidden" name="action" value="create"/>
            <div class="form-row">
                <div class="form-group">
                    <label>Program Code *</label>
                    <input class="form-control" type="text" name="programCode" value="<%= program != null && program.getProgramCode() != null ? program.getProgramCode() : "" %>"/>
                </div>
                <div class="form-group">
                    <label>Program Name *</label>
                    <input class="form-control" type="text" name="programName" value="<%= program != null && program.getProgramName() != null ? program.getProgramName() : "" %>"/>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Academic Year</label>
                    <input class="form-control" type="text" name="academicYear" value="<%= program != null && program.getAcademicYear() != null ? program.getAcademicYear() : "" %>"/>
                </div>
                <div class="form-group">
                    <label>Major Name</label>
                    <input class="form-control" type="text" name="majorName" value="<%= program != null && program.getMajorName() != null ? program.getMajorName() : "" %>"/>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>PNO</label>
                    <input class="form-control" type="text" name="pno" value="<%= program != null && program.getPno() != null ? program.getPno() : "" %>"/>
                </div>
                <div class="form-group">
                    <label>Status</label>
                    <select class="form-control" name="status">
                        <option value="Active" <%= program == null || program.getStatus() == null || "Active".equalsIgnoreCase(program.getStatus()) ? "selected" : "" %>>Active</option>
                        <option value="Inactive" <%= program != null && "Inactive".equalsIgnoreCase(program.getStatus()) ? "selected" : "" %>>Inactive</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label>Description</label>
                <textarea class="form-control" name="description"><%= program != null && program.getDescription() != null ? program.getDescription() : "" %></textarea>
            </div>
            <div style="display:flex; gap:12px; justify-content:flex-end;">
                <a class="btn-train btn-outline-train" href="<%=request.getContextPath()%>/training-program?action=list">Cancel</a>
                <button class="btn-train btn-primary-train" type="submit">Create</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
