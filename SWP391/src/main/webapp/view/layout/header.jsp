<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>${not empty pageTitle ? pageTitle : 'TPMS Learning Materials'}</title>
    <meta name="description" content="${not empty pageDescription ? pageDescription : 'TPMS Learning Materials - Curriculum, Syllabus and Subject management system.'}"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head>
<body>

<header class="fpt-header">
    <div class="header-left">
        <a href="${pageContext.request.contextPath}/home" class="btn-home" id="btn-home">
            <i class="bi bi-house-fill"></i> Home
        </a>
    </div>
    <div class="header-center">
        <h1 class="header-title">Training Program Management System</h1>
    </div>
    <div class="header-right">
        <select class="form-select lang-select" id="lang-select" aria-label="Language selection" onchange="changeLanguage(this.value)">
            <option value="en" selected>English</option>
            <option value="vi">Vietnamese</option>
        </select>
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/profile" class="text-white fw-bold me-3 text-decoration-none" style="font-size: 0.9rem;" id="header-user-greeting" title="Xem hồ sơ & Sơ đồ cây đào tạo">
                    <i class="bi bi-person-circle"></i> Xin chào, ${not empty sessionScope.user.fullName ? sessionScope.user.fullName : sessionScope.user.email}
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-danger fw-bold px-3 py-1" style="font-size: 0.8rem; border-radius: 6px;" id="btn-logout">
                    Đăng xuất
                </a>
            </c:when>
            <c:otherwise>
                <div class="user-avatar" id="user-avatar" title="User Profile">G</div>
            </c:otherwise>
        </c:choose>
    </div>
</header>
