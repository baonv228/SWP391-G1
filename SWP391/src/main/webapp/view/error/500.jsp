<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:set var="pageTitle" value="500 - Internal Server Error" scope="request" />
        <jsp:include page="/view/layout/header.jsp" />
        <main class="container-fluid main-content">
            <div class="error-page text-center" id="error-500-page">
                <div class="error-icon">500</div>
                <h2 class="error-title">Internal Server Error</h2>
                <p class="error-message text-muted">An unexpected error occurred. Please try again later.</p>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-search mt-3" id="error-500-home-btn">
                    <i class="bi bi-house-fill me-1"></i>Return to Home
                </a>
            </div>
        </main>
        <jsp:include page="/view/layout/footer.jsp" />