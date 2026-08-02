<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, model.TrainingProgram, model.Subject, model.Curriculum, model.User" %>
<%
    User user = (User) session.getAttribute("user");
    Curriculum curriculum = (Curriculum) request.getAttribute("curriculum");
    List<TrainingProgram> programs = (List<TrainingProgram>) request.getAttribute("programs");
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    String error = (String) request.getAttribute("error");
    String requestedProgramId = request.getParameter("programId");
    boolean canManage = user != null && user.getRole() != null
            && "Training Department".equalsIgnoreCase(user.getRole().getRoleName());
    if (!canManage) {
        response.sendRedirect(request.getContextPath() + "/curriculum-manage?action=list");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Create Curriculum - TPMS</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/training.css"/>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/theme-orange.css" />
</head>
<body class="training-page">
<div class="train-container">
    <div class="train-header">
        <div>
            <h1>Create Curriculum</h1>
            <div style="color: var(--muted); margin-top: 6px;">Tao curriculum cho training program da co.</div>
        </div>
        <div>
            <a class="btn-train btn-outline-train" href="<%=request.getContextPath()%>/curriculum-manage?action=list">Back to list</a>
        </div>
    </div>

    <% if (error != null) { %>
    <div class="alert alert-error"><%= error %></div>
    <% } %>

    <div class="train-card">
        <form method="post" action="<%=request.getContextPath()%>/curriculum-manage">
            <input type="hidden" name="action" value="create"/>
            <div class="form-row">
                <div class="form-group">
                    <label>Training Program *</label>
                    <select class="form-control" name="programId">
                        <option value="">-- Select program --</option>
                        <%
                            if (programs != null) {
                                for (TrainingProgram p : programs) {
                                    String selected = "";
                                    if (curriculum != null && curriculum.getProgramId() == p.getProgramId()) {
                                        selected = "selected";
                                    } else if (requestedProgramId != null && requestedProgramId.equals(String.valueOf(p.getProgramId()))) {
                                        selected = "selected";
                                    }
                        %>
                        <option value="<%= p.getProgramId() %>" <%= selected %>><%= p.getProgramCode() %> - <%= p.getProgramName() %></option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Status</label>
                    <select class="form-control" name="status">
                        <option value="Active">Active</option>
                        <option value="Inactive">Inactive</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label>Curriculum Name *</label>
                <input class="form-control" type="text" name="curriculumName" value="<%= curriculum != null && curriculum.getCurriculumName() != null ? curriculum.getCurriculumName() : "" %>"/>
            </div>
            <div class="form-group">
                <label>Description</label>
                <textarea class="form-control" name="description"><%= curriculum != null && curriculum.getDescription() != null ? curriculum.getDescription() : "" %></textarea>
            </div>

            <div class="grid-two">
                <div>
                    <h2 style="margin-top:0;">Subject selection</h2>
                    <div style="color: var(--muted); margin-bottom: 12px;">Chon cac mon hoc dua vao curriculum.</div>
                    <div class="checklist">
                        <%
                            if (subjects != null && !subjects.isEmpty()) {
                                for (Subject s : subjects) {
                        %>
                        <label class="subject-item">
                            <input type="checkbox" name="subjectIds" value="<%= s.getSubjectId() %>"/>
                            <div>
                                <div><strong><%= s.getSubjectCode() %></strong> - <%= s.getSubjectName() %></div>
                                <div class="subject-meta">Credits: <%= s.getCredits() %> | Status: <%= s.getStatus() %></div>
                            </div>
                        </label>
                        <%
                                }
                            } else {
                        %>
                        <div class="empty-state" style="padding: 20px;">Khong co mon hoc de chon.</div>
                        <%
                            }
                        %>
                    </div>
                </div>
                <div>
                    <h2 style="margin-top:0;">Notes</h2>
                    <div class="train-card" style="margin-bottom:0; padding:18px;">
                        <p style="margin-top:0; line-height:1.6; color: var(--muted);">
                            Curriculum nay se luu metadata chinh va mapping subject vao Curriculum_Subject theo thu tu chon.
                        </p>
                        <p style="line-height:1.6; color: var(--muted); margin-bottom:0;">
                            Neu can canh chinh semester hay subject group, co the mo rong form sau.
                        </p>
                    </div>
                </div>
            </div>

            <div style="display:flex; gap:12px; justify-content:flex-end; margin-top:20px;">
                <a class="btn-train btn-outline-train" href="<%=request.getContextPath()%>/curriculum-manage?action=list">Cancel</a>
                <button class="btn-train btn-primary-train" type="submit">Create</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
