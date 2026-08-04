<%@page import="model.User"%>
<%
    User headerCurrentUser = (User) session.getAttribute("user");
    String headerDisplayName = "User";
    String headerRoleName = (String) session.getAttribute("roleName");

    if (headerCurrentUser != null) {
        headerDisplayName = headerCurrentUser.getFullName();
        if (headerDisplayName == null || headerDisplayName.trim().isEmpty()) {
            headerDisplayName = headerCurrentUser.getEmail();
        }

        if ((headerRoleName == null || headerRoleName.trim().isEmpty()) && headerCurrentUser.getRole() != null) {
            headerRoleName = headerCurrentUser.getRole().getRoleName();
            session.setAttribute("roleName", headerRoleName);
        }
    }

    boolean headerIsTrainingDepartment = headerRoleName != null
            && "Training Department".equalsIgnoreCase(headerRoleName.trim());
    boolean headerIsSyllabusDesigner = headerRoleName != null
            && "Syllabus Designer".equalsIgnoreCase(headerRoleName.trim());
%>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/header-footer.css" />
<header class="topbar">
    <div class="header-left">
<%--        <details class="dashboard-menu">--%>
<%--            <summary class="menu-toggle" aria-label="Open dashboard menu" title="Menu">--%>
<%--                <span></span>--%>
<%--                <span></span>--%>
<%--                <span></span>--%>
<%--            </summary>--%>

<%--            <nav class="dashboard-panel" aria-label="Dashboard menu">--%>
<%--                <a href="<%=request.getContextPath()%>/home">Dashboard</a>--%>

<%--                <% if (headerIsTrainingDepartment) { %>--%>
<%--                    <a href="<%=request.getContextPath()%>/request-list">Request List</a>--%>
<%--                    <a href="<%=request.getContextPath()%>/course?action=list">Course List</a>--%>
<%--                    <a href="<%=request.getContextPath()%>/curriculum?action=list">Curriculum</a>--%>
<%--                    <a href="<%=request.getContextPath()%>/training-program?action=list">Department</a>--%>
<%--                    <a href="<%=request.getContextPath()%>/view-training-report">Training Report</a>--%>
<%--                    <a href="<%=request.getContextPath()%>/assign-teacher">Assign Teacher</a>--%>
<%--                <% } %>--%>

<%--                <% if (headerIsSyllabusDesigner) { %>--%>
<%--                    <a href="<%=request.getContextPath()%>/syllabus-manage?action=create">T&#7841;o Syllabus m&#7899;i</a>--%>
<%--                    <a href="<%=request.getContextPath()%>/syllabus-manage?action=list">Danh s&#225;ch Syllabus</a>--%>
<%--                    <a href="<%=request.getContextPath()%>/syllabus-manage?action=teacher_requests">Y&#234;u c&#7847;u t&#7915; Gi&#225;o vi&#234;n</a>--%>
<%--                <% } %>--%>
<%--            </nav>--%>
<%--        </details>--%>

        <a class="brand" href="<%=request.getContextPath()%>/home">Training Program Management System</a>
    </div>

    <div class="top-actions" aria-label="T&#224;i kho&#7843;n">
        <a class="profile" href="<%=request.getContextPath()%>/profile" title="<%= headerDisplayName %>">
            <span class="avatar">TD</span>
            <span>Xin ch&#224;o, <%= headerDisplayName %></span>
        </a>

        <a class="logout-button" href="<%=request.getContextPath()%>/logout">
            &#272;&#259;ng xu&#7845;t
        </a>
    </div>
</header>
