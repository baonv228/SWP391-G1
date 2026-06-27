<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="TPMS Learning Materials" scope="request"/>
<c:set var="pageDescription" value="TPMS Learning Materials - Student portal for Curriculum, Syllabus and Subject management." scope="request"/>
<jsp:include page="/view/layout/header.jsp"/>

<main class="container-fluid main-content">
    <div class="row justify-content-center">
        <div class="col-lg-8 col-md-10">
            <div class="features-card" id="features-card">
                <h2 class="features-title">Student's features</h2>
                <div class="features-list">
                    <a href="${pageContext.request.contextPath}/curriculum" class="feature-item" id="link-view-curriculum">
                        <span>View Curriculum</span>
                        <i class="bi bi-chevron-right"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/syllabus" class="feature-item" id="link-view-syllabus">
                        <span>View Syllabus</span>
                        <i class="bi bi-chevron-right"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/learning-path" class="feature-item" id="link-learning-path">
                        <span>Show Learning Path of a Subject</span>
                        <i class="bi bi-chevron-right"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/prerequisite" class="feature-item" id="link-prerequisite">
                        <span>A subject is the pre-requisite of</span>
                        <i class="bi bi-chevron-right"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/view/layout/footer.jsp"/>
