<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Database Error - FPT University" scope="request"/>
<jsp:include page="/view/layout/header.jsp"/>
<main class="container-fluid main-content">
    <div class="error-page text-center" id="db-error-page">
        <div class="error-icon" style="font-size:3rem;color:#dc3545;">
            <i class="bi bi-database-x"></i>
        </div>
        <h2 class="error-title">Database Connection Error</h2>
        <p class="error-message text-muted">
            We are unable to connect to the database at this time.
            Please check your connection and try again.
        </p>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger d-inline-block mt-2" id="db-error-detail">
                ${errorMessage}
            </div>
        </c:if>
        <br/>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-search mt-3" id="db-error-home-btn">
            <i class="bi bi-house-fill me-1"></i>Return to Home
        </a>
    </div>
</main>
<jsp:include page="/view/layout/footer.jsp"/>
