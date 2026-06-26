<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="404 - Page Not Found" scope="request"/>
<jsp:include page="/views/layout/header.jsp"/>
<main class="container-fluid main-content">
    <div class="error-page text-center" id="error-404-page">
        <div class="error-icon">404</div>
        <h2 class="error-title">Page Not Found</h2>
        <p class="error-message text-muted">The page you are looking for does not exist or has been removed.</p>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-search mt-3" id="error-404-home-btn">
            <i class="bi bi-house-fill me-1"></i>Return to Home
        </a>
    </div>
</main>
<jsp:include page="/views/layout/footer.jsp"/>
