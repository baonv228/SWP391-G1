<%@page import="model.User"%>
<%
    User headerCurrentUser = (User) session.getAttribute("user");
    String headerDisplayName = "User";

    if (headerCurrentUser != null) {
        headerDisplayName = headerCurrentUser.getFullName();
        if (headerDisplayName == null || headerDisplayName.trim().isEmpty()) {
            headerDisplayName = headerCurrentUser.getEmail();
        }
    }
%>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/header-footer.css" />
<header class="topbar">
    <a class="brand" href="<%=request.getContextPath()%>/home">Training Program Management System</a>

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
