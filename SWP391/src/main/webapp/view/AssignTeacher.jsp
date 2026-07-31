<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="model.User"%>
<%@page import="model.TrainingProgram"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    List<User> teachers = (List<User>) request.getAttribute("teachers");
    List<TrainingProgram> programs = (List<TrainingProgram>) request.getAttribute("programs");
    Map<Integer, List<TrainingProgram>> assignments =
            (Map<Integer, List<TrainingProgram>>) request.getAttribute("assignments");
    Map<Integer, List<Integer>> assignedIds =
            (Map<Integer, List<Integer>>) request.getAttribute("assignedIds");
    Integer selectedTeacherId = (Integer) request.getAttribute("selectedTeacherId");
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
    if (selectedTeacherId == null) selectedTeacherId = 0;
    if (teachers == null) teachers = java.util.Collections.emptyList();
    if (programs == null) programs = java.util.Collections.emptyList();
    if (assignments == null) assignments = java.util.Collections.emptyMap();
    if (assignedIds == null) assignedIds = java.util.Collections.emptyMap();
    List<Integer> selectedAssigned = assignedIds.getOrDefault(selectedTeacherId, java.util.Collections.emptyList());

    String selectedTeacherName = "";
    for (User t : teachers) {
        if (t.getUserId() == selectedTeacherId) {
            selectedTeacherName = t.getFullName() != null ? t.getFullName() : t.getEmail();
            break;
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Assign Teacher by Major</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/AssignTeacher.css"/>
</head>
<body class="at-body">
<main class="at-page">

    <nav class="at-breadcrumb" aria-label="Breadcrumb">
        <a href="<%=request.getContextPath()%>/home">Home</a>
        <span class="sep">&gt;</span>
        <span class="current">Assign Teacher by Major</span>
    </nav>

    <div class="at-title-row">
        <div class="at-title-icon" aria-hidden="true">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/>
                <circle cx="9" cy="7" r="4"/>
                <path d="M19 8v6"/><path d="M22 11h-6"/>
            </svg>
        </div>
        <h1>Assign <span class="accent">Teacher</span> by Major</h1>
    </div>

    <p class="at-hint">
        Chỉ <strong>Training Department</strong> được gán giáo viên theo ngành (SE, GD, IT, …).
        Giáo viên đã gán chỉ được <strong>Upload Materials</strong> trong ngành đó.
        Course List của teacher vẫn xem được tất cả ngành.
    </p>

    <% if (success != null && !success.isBlank()) { %>
        <div class="at-alert at-alert-ok"><%= success %></div>
    <% } %>
    <% if (error != null && !error.isBlank()) { %>
        <div class="at-alert at-alert-err"><%= error %></div>
    <% } %>

    <div class="at-layout">

        <%-- Left: Teacher list --%>
        <section class="at-panel">
            <div class="at-panel-head">
                <span class="ico" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                        <circle cx="9" cy="7" r="4"/>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                    </svg>
                </span>
                <h2>Danh sách Teacher</h2>
            </div>

            <div class="at-teacher-list">
                <% if (teachers.isEmpty()) { %>
                    <div class="at-empty">Chưa có tài khoản Teacher trong hệ thống.</div>
                <% } else {
                    for (User t : teachers) {
                        boolean active = t.getUserId() == selectedTeacherId;
                        List<TrainingProgram> assigned = assignments.getOrDefault(t.getUserId(), java.util.Collections.emptyList());
                        String name = t.getFullName() != null && !t.getFullName().isBlank() ? t.getFullName() : "(no name)";
                        String initial = name.substring(0, 1);
                %>
                    <a class="at-teacher-card <%= active ? "active" : "" %>"
                       href="<%=request.getContextPath()%>/assign-teacher?teacherId=<%= t.getUserId() %>">
                        <div class="at-avatar" aria-hidden="true">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                                <circle cx="12" cy="7" r="4"/>
                            </svg>
                        </div>
                        <div class="at-teacher-meta">
                            <p class="at-teacher-name"><%= name %></p>
                            <p class="at-teacher-email"><%= t.getEmail() %></p>
                            <div class="at-tags">
                                <% if (assigned.isEmpty()) { %>
                                    <span class="at-tag">Chưa gán ngành</span>
                                <% } else {
                                    for (TrainingProgram p : assigned) { %>
                                        <span class="at-tag"><%= p.getProgramCode() %></span>
                                <%  }
                                } %>
                            </div>
                        </div>
                    </a>
                <%  }
                } %>
            </div>
        </section>

        <%-- Right: Major assignment --%>
        <section class="at-panel">
            <div class="at-panel-head">
                <span class="ico" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M3 21h18"/>
                        <path d="M5 21V7l7-4 7 4v14"/>
                        <path d="M9 21v-6h6v6"/>
                    </svg>
                </span>
                <h2>Chọn ngành cho Teacher<%= selectedTeacherName.isBlank() ? "" : (" — " + selectedTeacherName) %></h2>
            </div>

            <% if (selectedTeacherId <= 0) { %>
                <div class="at-empty">Chọn một giáo viên bên trái để gán ngành.</div>
            <% } else { %>
                <form method="post" action="<%=request.getContextPath()%>/assign-teacher" id="assign-teacher-form">
                    <input type="hidden" name="teacherId" value="<%= selectedTeacherId %>"/>

                    <div class="at-program-list">
                        <% if (programs.isEmpty()) { %>
                            <div class="at-empty">Chưa có Training Program / ngành trong hệ thống.</div>
                        <% } else {
                            for (TrainingProgram p : programs) {
                                boolean checked = selectedAssigned.contains(p.getProgramId());
                                String major = p.getMajorName() != null ? p.getMajorName().trim() : "";
                        %>
                            <label class="at-program-row <%= checked ? "is-checked" : "" %>">
                                <input type="checkbox" name="programIds" value="<%= p.getProgramId() %>"
                                       <%= checked ? "checked" : "" %>
                                       onchange="this.closest('.at-program-row').classList.toggle('is-checked', this.checked)"/>
                                <span class="at-program-text">
                                    <span class="code"><%= p.getProgramCode() %></span>
                                    <span class="name"> — <%= p.getProgramName() %></span>
                                    <% if (!major.isBlank()) { %>
                                        <span class="major"> (<%= major %>)</span>
                                    <% } %>
                                </span>
                            </label>
                        <%  }
                        } %>
                    </div>

                    <div class="at-form-actions">
                        <button type="submit" class="at-save-btn">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/>
                                <polyline points="17 21 17 13 7 13 7 21"/>
                                <polyline points="7 3 7 8 15 8"/>
                            </svg>
                            Lưu gán ngành
                        </button>
                    </div>
                </form>
            <% } %>
        </section>
    </div>
</main>
</body>
</html>
